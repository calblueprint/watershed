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

import android.widget.Toast;

import com.android.volley.NetworkError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.blueprint.watershed.Authentication.LoginFragment;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.R;
import com.facebook.AppEventsLogger;
import com.facebook.Session;
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
    //private static final String LOGIN_URL = "http://10.0.0.18:3001/api/v1/users/sign_in";

    // UI Elements
    private ImageView mLandingPageImage;
    private Button mLoginButton;
    private com.facebook.widget.LoginButton mFacebookButton;
    private Button mSignUpButton;
    private NetworkManager mloginNetworkManager;
    private SharedPreferences preferences;
    private ObjectMapper mMapper;

    private Session.StatusCallback callback = new Session.StatusCallback() {
        @Override
        public void call(Session session, SessionState state, Exception exception) {
            onSessionStateChange(session, state, exception);
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_landing_page);
        mloginNetworkManager = NetworkManager.getInstance(this.getApplicationContext());

        initializeViews();

        preferences = getSharedPreferences(PREFERENCES, 0);

        // NOTE(mark): Change to !hasAuthCredentials if you want the main activity to show.
        if (hasAuthCredentials(preferences)) {
            final Intent intent = new Intent(this, MainActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
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

        Session session = Session.getActiveSession();
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

    private void onSessionStateChange(final Session session, SessionState state, Exception exception) {
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
                        makeFacebookRequest(email, accessToken, id, name);
                    }
                }
            });

            Log.e("Facebook", "Logged in...");
        } else if (state.isClosed()) {
            Log.e("Facebook", "Logged out...");
        }
    }

    public void didTapSignUpLoadFragmentButton(View view) {
    }

    public void makeFacebookRequest(String email, String accessToken, String id, String name){
        final Intent intent = new Intent(this, MainActivity.class);

        HashMap<String, String> params = new HashMap<String, String>();
        params.put("email", email);
        params.put("facebook_auth_token", accessToken);
        params.put("facebook_id", id);
        params.put("name", name);

        JSONObject requestUser = new JSONObject(params);
        HashMap<String, JSONObject> realParams = new HashMap<String, JSONObject>();
        realParams.put("user", requestUser);

        JsonObjectRequest request = new JsonObjectRequest(Request.Method.POST, FACEBOOK_URL, new JSONObject(realParams), new Response.Listener<JSONObject>() {

            @Override
            public void onResponse(JSONObject jsonObject) {
                SharedPreferences.Editor editor = preferences.edit();

                try {
                    //TODO do something with the user object.
                    String token = jsonObject.getString("authentication_token");
                    String email = jsonObject.getString("email");

                    editor.putString("authentication_token", token);
                    editor.putString("email", email);
                    editor.commit();

                    LandingPageActivity.this.finish();
                    startActivity(intent);
                }
                catch (JSONException e) {
                    Log.e("Json exception", "in login fragment");
                }
            }
        },
        new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError volleyError) {
                String message;
                if (volleyError instanceof NetworkError) {
                    message = "Network Error. Please try again later.";
                }
                else {
                    try {
                        JSONObject response = new JSONObject(new String(volleyError.networkResponse.data));
                        message = (String) response.get("message");
                    } catch (Exception e) {
                        message = "Unknown Error";
                        e.printStackTrace();
                    }
                }
                Context context = getApplicationContext();
                int duration = Toast.LENGTH_SHORT;

                Toast toast = Toast.makeText(context, message, duration);
                toast.show();
            }
        });

        mloginNetworkManager.getRequestQueue().add(request);
    }

    public void login(HashMap<String, HashMap<String, String>> params) {
        final Intent intent = new Intent(this, MainActivity.class);

        JSONObject requestUser = new JSONObject(params.get("user"));
        HashMap<String, JSONObject> realParams = new HashMap<String, JSONObject>();
        realParams.put("user", requestUser);

        JsonObjectRequest request = new JsonObjectRequest(Request.Method.POST, LOGIN_URL, new JSONObject(realParams),
                new Response.Listener<JSONObject>() {
                    @Override
                    // presumably will receive a hash that has the auth info and user object
                    public void onResponse(JSONObject jsonObject) {
                        SharedPreferences.Editor editor = preferences.edit();

                        try {
                            String token = jsonObject.getString("authentication_token");
                            String email = jsonObject.getString("email");

                            editor.putString("authentication_token", token);
                            editor.putString("email", email);
                            editor.commit();

                            LandingPageActivity.this.finish();
                            startActivity(intent);
                        }
                        catch (JSONException e) {
                            Log.e("Json exception", "in login fragment");
                        }
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError volleyError) {
                        String message;
                        if (volleyError instanceof NetworkError) {
                            message = "Network Error. Please try again later.";
                        }
                        else {
                            try {
                                JSONObject response = new JSONObject(new String(volleyError.networkResponse.data));
                                message = (String) response.get("message");
                            } catch (Exception e) {
                                message = "Unknown Error";
                                e.printStackTrace();
                            }
                        }
                        Context context = getApplicationContext();
                        int duration = Toast.LENGTH_SHORT;

                        Toast toast = Toast.makeText(context, message, duration);
                        toast.show();
                    }
                }
        );

        mloginNetworkManager.getRequestQueue().add(request);
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Object result = data.getExtras().get("com.facebook.LoginActivity:Result");
        Log.e("THIS RESULT", result.toString());

        Session.getActiveSession().onActivityResult(this, requestCode, resultCode, data);

        Session session = Session.getActiveSession();
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