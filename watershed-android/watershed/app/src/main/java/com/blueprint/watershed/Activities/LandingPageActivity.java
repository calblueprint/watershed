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
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONException;
import org.json.JSONObject;


public class LandingPageActivity extends Activity {

    // Constants
    public  static final String PREFERENCES = "LOGIN_PREFERENCES";
    private static final String TAG         = "LandingPageActivity";
    private static final String LOGIN_URL = "https://intense-reaches-1457.herokuapp.com/api/v1/users/sign_in";

    // UI Elements
    private ImageView mLandingPageImage;
    private Button mLoginButton;
    private Button mFacebookButton;
    private Button mSignUpButton;
    private NetworkManager mloginNetworkManager;
    private SharedPreferences preferences;
    private ObjectMapper mMapper;

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

    public void initializeViews() {
        //setLandingPageImage((ImageView)findViewById(R.id.landing_page_image));

        setLoginButton((Button)findViewById(R.id.login_load_fragment_button));
        setFacebookButton((Button)findViewById(R.id.facebook_button));
        setSignUpButton((Button)findViewById(R.id.sign_up_load_fragment_button));
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

    public void didTapSignUpLoadFragmentButton(View view) {
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

                            /* This will be broken into a user object and auth info later.
                            JSONObject auth_info = jsonObject.getJSONObject("auth_info");
                            String token = auth_info.getString("token");
                            String email = auth_info.getString("email");
                            */
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

    // Getters
    public ImageView getLandingPageImage() { return mLandingPageImage; }
    public Button getLoginButton() { return mLoginButton; }
    public Button getFacebookButton() { return mFacebookButton; }
    public Button getSignUpButton() { return mSignUpButton; }
    public NetworkManager getRequestHandler(){return mloginNetworkManager;}

    // Setters
    public void setLandingPageImage(ImageView imageView) { mLandingPageImage = imageView; }
    public void setLoginButton(Button loginButton) { mLoginButton = loginButton; }
    public void setFacebookButton(Button facebookButton) { mFacebookButton = facebookButton; }
    public void setSignUpButton(Button signUpButton) { mSignUpButton = signUpButton; }
}