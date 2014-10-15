package com.blueprint.watershed;

import android.app.Activity;
import android.app.Notification;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.os.Handler;

import android.widget.ImageView;
import android.widget.EditText;
import android.widget.Button;
import android.widget.LinearLayout;

import java.util.Arrays;
import java.util.List;

import android.content.SharedPreferences;


public class LandingPageActivity extends Activity {

    // Constants
    public  static final String PREFERENCES = "LOGIN_PREFERENCES";
    private static final String TAG         = "LandingPageActivity";

    // UI Elements
    private ImageView mLandingPageImage;
    private Button mLoginButton;
    private Button mFacebookButton;
    private Button mSignUpButton;
    private requestHandler mloginRequestHandler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_landing_page);
        mloginRequestHandler = RequestHandler.getInstance(this.getApplicationContext());

        initializeViews();

        SharedPreferences preferences = getSharedPreferences(PREFERENCES, 0);

        // NOTE(mark): Change to !hasAuthCredentials if you want the main activity to show.
        if (hasAuthCredentials(preferences)) {
            final Intent intent = new Intent(this, MainActivity.class);
            intent.putExtra("auth_token", preferences.getString("auth_token", null));
            this.finish();
            startActivity(intent);
        }
    }

    public void initializeViews() {
        //setLandingPageImage((ImageView)findViewById(R.id.landing_page_image));

        setLoginButton((Button)findViewById(R.id.login_load_fragment_button));
        setFacebookButton((Button)findViewById(R.id.facebook_button));
        setSignUpButton((Button)findViewById(R.id.sign_up_load_fragment_button));
    }

    public boolean hasAuthCredentials(SharedPreferences preferences) {
        return !preferences.getString("auth_token", "none").equals("none") &&
               !preferences.getString("auth_email", "none").equals("none");
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

    // Getters
    public ImageView getLandingPageImage() { return mLandingPageImage; }
    public Button getLoginButton() { return mLoginButton; }
    public Button getFacebookButton() { return mFacebookButton; }
    public Button getSignUpButton() { return mSignUpButton; }

    // Setters
    public void setLandingPageImage(ImageView imageView) { mLandingPageImage = imageView; }
    public void setLoginButton(Button loginButton) { mLoginButton = loginButton; }
    public void setFacebookButton(Button facebookButton) { mFacebookButton = facebookButton; }
    public void setSignUpButton(Button signUpButton) { mSignUpButton = signUpButton; }
}
