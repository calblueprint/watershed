package com.blueprint.watershed.Activities;

import android.app.Activity;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.android.volley.Response;
import com.blueprint.watershed.Authentication.LoginFragment;
import com.blueprint.watershed.Authentication.Session;
import com.blueprint.watershed.Authentication.SignUpFragment;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Sessions.FacebookLoginRequest;
import com.blueprint.watershed.Networking.Sessions.LoginRequest;
import com.blueprint.watershed.Networking.Sessions.SignUpRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Utilities.APIError;
import com.blueprint.watershed.Utilities.Utility;
import com.crashlytics.android.Crashlytics;
import com.facebook.AppEventsLogger;
import com.facebook.SessionState;
import com.facebook.UiLifecycleHelper;
import com.facebook.model.GraphUser;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.gcm.GoogleCloudMessaging;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Arrays;
import java.util.HashMap;

import io.fabric.sdk.android.Fabric;


public class LandingPageActivity extends Activity implements View.OnClickListener{

    // Constants
    public  static final String PREFERENCES                   = "LOGIN_PREFERENCES";
    private static final String TAG                           = "LandingPageActivity";
    private final static int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;

    // UI Elements
    private ImageView mLandingPageImage;
    private Button mLoginButton;
    private com.facebook.widget.LoginButton mFacebookButton;
    private Button mSignUpButton;
    private NetworkManager mLoginNetworkManager;
    private SharedPreferences mPreferences;
    private ObjectMapper mMapper;
    private View mViewBlocker;
    private LinearLayout mLayout;

    // Facebook Login
    private UiLifecycleHelper mUiHelper;

    // Notification Params
    private GoogleCloudMessaging mGcm;

    // Called when session changes
    private com.facebook.Session.StatusCallback callback = new com.facebook.Session.StatusCallback() {
        @Override
        public void call(com.facebook.Session session, SessionState state, Exception exception) {
            onSessionStateChange(session, state, exception);
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Fabric.with(this, new Crashlytics());
        setContentView(R.layout.activity_landing_page);
        mLoginNetworkManager = NetworkManager.getInstance(this.getApplicationContext());
        mViewBlocker = findViewById(R.id.viewBlocker);
        mViewBlocker.setVisibility(View.GONE);
        mUiHelper = new UiLifecycleHelper(this, callback);
        mUiHelper.onCreate(savedInstanceState);
        initializeViews();

        mPreferences = getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE);

        if (checkPlayServices()) {
            mGcm = GoogleCloudMessaging.getInstance(this);
        } else {
            Log.i("Exception in services", "Please get a valid Play services APK");
        }

        // NOTE(mark): Change to !hasAuthCredentials if you want the main activity to show.
        if (hasAuthCredentials(mPreferences)) {
            // Ideally we could request the user object from the server again here and then pass them to the main activity.
            final Intent intent = new Intent(this, MainActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
            startActivity(intent);
            finish();
            overridePendingTransition(0, 0);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();

        AppEventsLogger.activateApp(this);
        com.facebook.Session session = com.facebook.Session.getActiveSession();
        if (session != null && (session.isOpened() || session.isClosed()) ) {
            onSessionStateChange(session, session.getState(), null);
        }
        mUiHelper.onResume();

        checkPlayServices();
    }

    @Override
    protected void onPause() {
        super.onPause();
        AppEventsLogger.deactivateApp(this);
        mUiHelper.onPause();
    }

    /**
     * Check the device to make sure it has the Google Play Services APK. If
     * it doesn't, display a dialog that allows users to download the APK from
     * the Google Play Store or enable it in the device's system settings.
     */
    private boolean checkPlayServices() {
        int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (GooglePlayServicesUtil.isUserRecoverableError(resultCode)) {
                GooglePlayServicesUtil.getErrorDialog(resultCode, this,
                        PLAY_SERVICES_RESOLUTION_REQUEST).show();
            } else {
                Log.i(TAG, "This device is not supported.");
                finish();
            }
            return false;
        }
        return true;
    }

    /**
     * Gets the current registration ID for application on GCM service.
     * <p>
     * If result is empty, the app needs to register.
     *
     * @return registration ID, or empty string if there is no existing
     *         registration ID.
     */
    private String getRegistrationId() {
        String registrationId = mPreferences.getString("registration_id", "");
        if (registrationId.isEmpty()) {
            Log.i(TAG, "Registration not found.");
            return "";
        }

        // Check if app was updated; if so, it must clear the registration ID
        // since the existing registration ID is not guaranteed to work with
        // the new app version.
        int registeredVersion = mPreferences.getInt("app_version", Integer.MIN_VALUE);
        int currentVersion = Utility.getAppVersion(this);
        if (registeredVersion != currentVersion) {
            Log.i(TAG, "App version changed.");
            mPreferences.edit().putInt("app_version", currentVersion).commit();
            return "";
        }
        return registrationId;
    }

    public void initializeViews() {
        setLoginButton((Button)findViewById(R.id.login_load_fragment_button));
        setFacebookButton((com.facebook.widget.LoginButton)findViewById(R.id.authButton));
        setSignUpButton((Button)findViewById(R.id.sign_up_load_fragment_button));

        mLoginButton.setOnClickListener(this);
        mSignUpButton.setOnClickListener(this);

        mFacebookButton.setReadPermissions(Arrays.asList("email"));

        mLayout = (LinearLayout) findViewById(R.id.container);
        Utility.setKeyboardListener(this, mLayout);
    }

    public void onClick(View view){
        if (view == mFacebookButton) didTapFacebookButton(view);
        else if (view == mLoginButton) didTapLoginLoadFragmentButton(view);
        else didTapSignUpLoadFragmentButton(view);
    }

    public boolean hasAuthCredentials(SharedPreferences mPreferences) {
        return !mPreferences.getString("authentication_token", "none").equals("none") &&
               !mPreferences.getString("email", "none").equals("none") &&
               !mPreferences.getString("user", "none").equals("none") &&
                mPreferences.getInt("userId", 0) != 0;
    }

    // UI Actions
    public void didTapLoginLoadFragmentButton(View view) {
        FragmentManager fragmentManager = getFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();

        LoginFragment fragment = new LoginFragment();
        fragmentTransaction.replace(R.id.container, fragment);
        fragmentTransaction.addToBackStack(null);
        fragmentTransaction.commit();
    }

    public void didTapFacebookButton(View view) {
        // Facebook authentication
    }

    // Facebook Stuff
    private void onSessionStateChange(final com.facebook.Session session, SessionState state, Exception exception) {
        if (state.isOpened()) {
            com.facebook.Request.newMeRequest(session, new com.facebook.Request.GraphUserCallback() {

                @Override
                public void onCompleted(GraphUser user, com.facebook.Response response) {
                    if (user != null) {
                        String accessToken = session.getAccessToken();
                        String name = user.getName();
                        String id = user.getId(); //This may not be the profile picture Id that you are expecting, but we can pass this in to the graph api to get the actual profile picture
                        String email = "";
                        try {
                            email = user.getInnerJSONObject().getString("email");
                        }
                        catch (JSONException e){
                            Log.e("JSONException", "Facebook Login");
                        }

                        String regid = "";
                        try {
                            regid = mGcm.register(SENDER_ID);
                        } catch (Exception e) {
                            Log.i("Exception", e.toString());
                        }
                        HashMap<String, String> params = new HashMap<String, String>();
                        params.put("email", email);
                        params.put("facebook_auth_token", accessToken);
                        params.put("facebook_id", id);
                        params.put("name", name);
                        params.put("device_type", "0");
                        params.put("registration_id", regid);
                        facebookRequest(params);
                    }
                }
            }).executeAsync();
        } else if (state.isClosed()) {
            Log.e("Facebook", "Logged out...");
        }
    }

    public void didTapSignUpLoadFragmentButton(View view) {
        FragmentManager fragmentManager = getFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();

        SignUpFragment fragment = new SignUpFragment();
        fragmentTransaction.replace(R.id.container, fragment);
        fragmentTransaction.addToBackStack(null);
        fragmentTransaction.commit();
    }

    public void facebookRequest(HashMap<String, String> params) {

        FacebookLoginRequest facebookLoginRequest = new FacebookLoginRequest(this, params, new Response.Listener<Session>() {
            @Override
            public void onResponse(Session session) {
                storeSessionAndStartMainActivity(session);
            }
        }, new Response.Listener<APIError>() {
            @Override
            public void onResponse(APIError apiError) {
                mViewBlocker.setVisibility(View.GONE);
            }
        });

        mLoginNetworkManager.getRequestQueue().add(facebookLoginRequest);
    }

    public void loginRequest(HashMap<String, String> params) {
        LoginRequest loginRequest = new LoginRequest(this, params, new Response.Listener<Session>() {
            @Override
            public void onResponse(Session session) {
                storeSessionAndStartMainActivity(session);
            }
        }, new Response.Listener<APIError>() {
            @Override
            public void onResponse(APIError apiError) {
                mViewBlocker.setVisibility(View.GONE);
            }
        });

        mLoginNetworkManager.getRequestQueue().add(loginRequest);
    }


    public void signUpRequest(HashMap<String, String> params) {

        SignUpRequest signUpRequest = new SignUpRequest(this, params, new Response.Listener<Session>() {
            @Override
            public void onResponse(Session session) {
                storeSessionAndStartMainActivity(session);
            }
        }, new Response.Listener<APIError>() {
            @Override
            public void onResponse(APIError apiError) {
                mViewBlocker.setVisibility(View.GONE);
            }
        });

        mLoginNetworkManager.getRequestQueue().add(signUpRequest);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        mUiHelper.onActivityResult(requestCode, resultCode, data);
    }

    public void storeSessionAndStartMainActivity(Session session) {
        final Intent intent = new Intent(this, MainActivity.class);
        ObjectMapper mapper = mLoginNetworkManager.getObjectMapper();
        JSONObject userJson = null;

        try {  userJson = new JSONObject(mapper.writeValueAsString(session.getUser())); }
        catch (Exception e) { Log.i("Exception", e.toString()); }

        SharedPreferences.Editor editor = mPreferences.edit();
        editor.putString("authentication_token", session.getAuthenticationToken());
        editor.putString("email", session.getEmail());
        if (userJson != null) editor.putString("user", userJson.toString());
        else {
            Toast.makeText(this, "Something went wrong - try again!", Toast.LENGTH_SHORT).show();
            return;
        }
        editor.putInt("userId", session.getUser().getId());
        editor.apply();
        startActivity(intent);
        finish();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        mUiHelper.onDestroy();
    }

    @Override
    public void onSaveInstanceState(Bundle savedInstanceState) {
        super.onSaveInstanceState(savedInstanceState);
        mUiHelper.onSaveInstanceState(savedInstanceState);
    }

    // Getters
    public ImageView getLandingPageImage() { return mLandingPageImage; }
    public Button getLoginButton() { return mLoginButton; }
    public Button getFacebookButton() { return mFacebookButton; }
    public Button getSignUpButton() { return mSignUpButton; }
    public NetworkManager getRequestHandler(){return mLoginNetworkManager;}
    public GoogleCloudMessaging getGcm() { return mGcm; }
    // Setters
    public void setLandingPageImage(ImageView imageView) { mLandingPageImage = imageView; }
    public void setLoginButton(Button loginButton) { mLoginButton = loginButton; }
    public void setFacebookButton(com.facebook.widget.LoginButton facebookButton) { mFacebookButton = facebookButton; }
    public void setSignUpButton(Button signUpButton) { mSignUpButton = signUpButton; }
    public void setGcm(GoogleCloudMessaging gcm) { mGcm = gcm; }
}