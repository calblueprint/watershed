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
import android.os.Handler;
import java.util.*;

import android.content.SharedPreferences;


public class LandingPageActivity extends Activity {

    // Constants
    public  static final String PREFERENCES = "LOGIN_PREFERENCES";
    private static final String TAG         = "LandingPageActivity";

    // View Constants
    private static final int TEXTFIELD_ANIMATION_Y_OFFSET = -300;

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
        setEmailField((EditText)findViewById(R.id.email_field));
        setPasswordField((EditText)findViewById(R.id.password_field));
        setLoginButton((Button)findViewById(R.id.login_button));

        toggleVisibilityOfElements(Arrays.asList((View)getEmailField(), (View)getPasswordField()));

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

    // UI Actions
    public void didTapSignInButton(View view) {
        toggleVisibilityOfElements(Arrays.asList(
                (View)getLogoImageView(),
                (View)getLoginButton(),
                (View)getEmailField(),
                (View)getPasswordField()
        ));

        new Handler().postDelayed(new Runnable() {
            // Animate the textfields after a 0.5 second delay.
            @Override
            public void run() {
                mEmailField.animate().translationY(TEXTFIELD_ANIMATION_Y_OFFSET);
                mPasswordField.animate().translationY(TEXTFIELD_ANIMATION_Y_OFFSET);
            }
        }, 500);
    }

    // View Animations
    public void toggleVisibilityOfElements(List<View> views) {
        for (View view : views) {
            // Android is dumb because it doesn't have a toggle visibility method.
            if (view.getVisibility() == View.VISIBLE) {
                view.setVisibility(View.INVISIBLE);
            } else {
                view.setVisibility(View.VISIBLE);
            }
        }
    }


    // Getters
    public ImageView getLogoImageView() { return mLogoImageView; }
    public EditText getEmailField() { return mEmailField; }
    public EditText getPasswordField() { return mPasswordField; }
    public Button getLoginButton() { return mLoginButton; }

    // Setters
    public void setLogoImageView(ImageView imageView) { mLogoImageView = imageView; }
    public void setEmailField(EditText emailField) { mEmailField = emailField; }
    public void setPasswordField(EditText passwordField) { mPasswordField = passwordField; }
    public void setLoginButton(Button loginButton) { mLoginButton = loginButton; }
}
