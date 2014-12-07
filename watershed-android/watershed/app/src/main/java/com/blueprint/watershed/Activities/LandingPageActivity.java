package com.blueprint.watershed.Activities;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.util.Log;
import android.view.View;

import android.widget.ImageView;
import android.widget.Button;

import java.util.Arrays;
import java.util.HashMap;

import android.widget.LinearLayout;
import android.widget.Toast;

import com.android.volley.NetworkError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.blueprint.watershed.Authentication.LoginFragment;
import com.blueprint.watershed.Authentication.Session;
import com.blueprint.watershed.Authentication.SignUpFragment;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Sessions.FacebookLoginRequest;
import com.blueprint.watershed.Networking.Sessions.LoginRequest;
import com.blueprint.watershed.Networking.Sessions.SignUpRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Users.User;

import com.fasterxml.jackson.core.type.TypeReference;

import com.blueprint.watershed.Utilities.APIError;
import com.facebook.AppEventsLogger;
import com.facebook.SessionState;
import com.facebook.model.GraphUser;
import com.fasterxml.jackson.databind.ObjectMapper;


import org.json.JSONException;
import org.json.JSONObject;


public class LandingPageActivity extends Activity implements View.OnClickListener{

    // Constants
    public  static final String PREFERENCES = "LOGIN_PREFERENCES";
    private static final String TAG         = "LandingPageActivity";
    private static final String LOGIN_URL = "https://intense-reaches-1457.herokuapp.com/api/v1/users/sign_in";
    private static final String FACEBOOK_URL = "https://intense-reaches-1457.herokuapp.com/api/v1/users/sign_up/facebook";

    // UI Elements
    private ImageView mLandingPageImage;
    private Button mLoginButton;
    private com.facebook.widget.LoginButton mFacebookButton;
    private Button mSignUpButton;
    private NetworkManager mloginNetworkManager;
    private SharedPreferences preferences;
    private ObjectMapper mMapper;
    private View viewBlocker;

    //User
    private Integer mUserId;

    private com.facebook.Session.StatusCallback callback = new com.facebook.Session.StatusCallback() {
        @Override
        public void call(com.facebook.Session session, SessionState state, Exception exception) {
            onSessionStateChange(session, state, exception);
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_landing_page);
        mloginNetworkManager = NetworkManager.getInstance(this.getApplicationContext());
        viewBlocker = findViewById(R.id.viewBlocker);
        viewBlocker.setVisibility(View.GONE);
        initializeViews();

        preferences = getSharedPreferences(PREFERENCES, 0);

        // NOTE(mark): Change to !hasAuthCredentials if you want the main activity to show.
        if (hasAuthCredentials(preferences)) {
            // Ideally we could request the user object from the server again here and then pass them to the main activity.
            final Intent intent = new Intent(this, MainActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
            Bundle b = new Bundle();
            b.putInt("userId", 1); //Replace with an actual user Id soon
            intent.putExtras(b);
            // intent.putExtra("auth_token", preferences.getString("auth_token", null));
            this.finish();
            startActivity(intent);
            overridePendingTransition(0, 0);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();

        AppEventsLogger.activateApp(this);

        com.facebook.Session session = com.facebook.Session.getActiveSession();
        if (session != null &&
                (session.isOpened() || session.isClosed()) ) {
            onSessionStateChange(session, session.getState(), null);

        }
    }

    protected void onPause() {
        super.onPause();

        AppEventsLogger.deactivateApp(this);
    }

    public void initializeViews() {
        setLoginButton((Button)findViewById(R.id.login_load_fragment_button));
        setFacebookButton((com.facebook.widget.LoginButton)findViewById(R.id.authButton));
        setSignUpButton((Button)findViewById(R.id.sign_up_load_fragment_button));

        mLoginButton.setOnClickListener(this);
        mSignUpButton.setOnClickListener(this);

        mFacebookButton.setReadPermissions(Arrays.asList("email"));
    }

    public void onClick(View view){
        if (view == mFacebookButton){
            didTapFacebookButton(view);
        }
        else if (view == mLoginButton){
            didTapLoginLoadFragmentButton(view);
        }
        else{
            didTapSignUpLoadFragmentButton(view);
        }
    }

    public boolean hasAuthCredentials(SharedPreferences preferences) {
        return !preferences.getString("authentication_token", "none").equals("none") &&
               !preferences.getString("email", "none").equals("none");
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
            com.facebook.Request.executeMeRequestAsync(session, new com.facebook.Request.GraphUserCallback() {

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

                        HashMap<String, String> params = new HashMap<String, String>();
                        params.put("email", email);
                        params.put("facebook_auth_token", accessToken);
                        params.put("facebook_id", id);
                        params.put("name", name);

                        facebookRequest(params);
                    }
                }
            });

            Log.e("Facebook", "Logged in...");
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
        final Intent intent = new Intent(this, MainActivity.class);

        FacebookLoginRequest facebookLoginRequest = new FacebookLoginRequest(this, params, new Response.Listener<Session>() {
            @Override
            public void onResponse(Session session) {
                storeSessionAndStartMainActivity(intent, session);
            }
        });

        mloginNetworkManager.getRequestQueue().add(facebookLoginRequest);
    }

    public void loginRequest(HashMap<String, String> params) {
        final Intent intent = new Intent(this, MainActivity.class);

        LoginRequest loginRequest = new LoginRequest(this, params, new Response.Listener<Session>() {
            @Override
            public void onResponse(Session session) {
                storeSessionAndStartMainActivity(intent, session);
            }
        }, new Response.Listener<APIError>() {
            @Override
            public void onResponse(APIError apiError) {
                viewBlocker.setVisibility(View.GONE);
                Log.e("Error response", "In the landing page activity for the login request");
            }
        });

        mloginNetworkManager.getRequestQueue().add(loginRequest);
    }


    public void signUpRequest(HashMap<String, String> params) {
        final Intent intent = new Intent(this, MainActivity.class);

        SignUpRequest signUpRequest = new SignUpRequest(this, params, new Response.Listener<Session>() {
            @Override
            public void onResponse(Session session) {
                storeSessionAndStartMainActivity(intent, session);
            }
        });

        mloginNetworkManager.getRequestQueue().add(signUpRequest);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        com.facebook.Session.getActiveSession().onActivityResult(this, requestCode, resultCode, data);

        com.facebook.Session session = com.facebook.Session.getActiveSession();
    }

    public void storeSessionAndStartMainActivity(Intent intent, Session session) {
        SharedPreferences.Editor editor = preferences.edit();
        editor.putString("authentication_token", session.getAuthenticationToken());
        editor.putString("email", session.getEmail());
        editor.putInt("userId", session.getUser().getId());
        editor.commit();

        Bundle bundle = new Bundle();
        bundle.putInt("userId", session.getUser().getId());
        intent.putExtras(bundle);

        LandingPageActivity.this.finish();
        startActivity(intent);
    }

    // Getters
    public ImageView getLandingPageImage() { return mLandingPageImage; }
    public Button getLoginButton() { return mLoginButton; }
    public Button getFacebookButton() { return mFacebookButton; }
    public Button getSignUpButton() { return mSignUpButton; }
    public NetworkManager getRequestHandler(){return mloginNetworkManager;}

    // Setters
    public void setLandingPageImage(ImageView imageView) { mLandingPageImage = imageView; }
    public void setLoginButton(Button loginButton) { mLoginButton = loginButton; }
    public void setFacebookButton(com.facebook.widget.LoginButton facebookButton) { mFacebookButton = facebookButton; }
    public void setSignUpButton(Button signUpButton) { mSignUpButton = signUpButton; }
}