package com.blueprint.watershed;

import android.app.Activity;
import android.app.Notification;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.*;
import android.view.View;

import android.content.SharedPreferences;


public class LandingPageActivity extends Activity {

    // Constants
    public  static final String PREFERENCES = "LOGIN_PREFERENCES";
    private static final String TAG         = "LandingPageActivity";

    // Fragments
    public Fragment currentFragment;

    // UI Elements
    private ImageView mLogoImageView;
    private EditText mEmailField;
    private EditText mPasswordField;
    private Button mLoginButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_landing_page);

        setLogoImageView((ImageView)findViewById(R.id.logo_image_view));
        setEmailField((EditText)findViewById(R.id.username_field));
        setPasswordField((EditText)findViewById(R.id.password_field));
        setLoginButton((Button)findViewById(R.id.login_button));

        mEmailField.setVisibility(View.INVISIBLE);
        mPasswordField.setVisibility(View.INVISIBLE);

        SharedPreferences preferences = getSharedPreferences(PREFERENCES, 0);

        // NOTE(mark): Change to !hasAuthCredentials if you want the main activity to show.
        if (hasAuthCredentials(preferences)) {
            final Intent intent = new Intent(this, MainActivity.class);
            intent.putExtra("auth_token", preferences.getString("auth_token", null));
            this.finish();
            startActivity(intent);
        }
    }

    public boolean hasAuthCredentials(SharedPreferences preferences) {
        return !preferences.getString("auth_token", "none").equals("none") &&
               !preferences.getString("auth_email", "none").equals("none");
    }

    public void didTapSignInButton(View view) {
        mLogoImageView.setVisibility(View.INVISIBLE);
        mLoginButton.setVisibility(View.INVISIBLE);
        mEmailField.setVisibility(View.VISIBLE);
        mPasswordField.setVisibility(View.VISIBLE);
    }

    // Getters

    // Setters
    public void setLogoImageView(ImageView imageView) { mLogoImageView = imageView; }
    public void setEmailField(EditText emailField) { mEmailField = emailField; }
    public void setPasswordField(EditText passwordField) { mPasswordField = passwordField; }
    public void setLoginButton(Button loginButton) { mLoginButton = loginButton; }
}
