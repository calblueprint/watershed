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

    // View Constants
    private static final int TEXT_FIELD_ANIMATION_Y_OFFSET = 100;

    // Fragments
    public Fragment currentFragment;

    // UI Elements
    private ImageView mLogoImageView;
    private EditText mEmailField;
    private EditText mPasswordField;
    private Button mLoginButton;
    private Button mFacebookButton;
    private Button mSignUpButton;

    private Button mSendLoginRequestButton;
    private Button mSendSignUpRequestButton;

    // Layouts
    private LinearLayout mButtonsLayout;
    private LinearLayout mLoginWithEmailLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_landing_page);

        initializeViews();
        toggleVisibilityOfElements(Arrays.asList((View)getLoginWithEmailLayout()));

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
        setLogoImageView((ImageView)findViewById(R.id.logo_image_view));

        setEmailField((EditText)findViewById(R.id.email_field));
        setPasswordField((EditText)findViewById(R.id.password_field));

        setLoginButton((Button)findViewById(R.id.login_button));
        setFacebookButton((Button)findViewById(R.id.facebook_button));
        setSignUpButton((Button)findViewById(R.id.sign_up_button));

        setButtonsLayout((LinearLayout)findViewById(R.id.buttons));
        setLoginWithEmailLayout((LinearLayout)findViewById(R.id.login_with_email_layout));
    }

    public boolean hasAuthCredentials(SharedPreferences preferences) {
        return !preferences.getString("auth_token", "none").equals("none") &&
               !preferences.getString("auth_email", "none").equals("none");
    }

    // UI Actions
    public void didTapLoginButton(View view) {
        toggleVisibilityOfElements(Arrays.asList(
                (View)getLogoImageView(),
                (View)getButtonsLayout(),
                (View)getLoginWithEmailLayout()
        ));

        new Handler().postDelayed(new Runnable() {
            // Animate the text fields after a 0.5 second delay.
            @Override
            public void run() {
                getLoginWithEmailLayout().animate().translationY(TEXT_FIELD_ANIMATION_Y_OFFSET);
            }
        }, 500);
    }

    public void didTapFacebookButton(View view) {
        // Facebook authentication
    }

    public void didTapSignUpButton(View view) {
    }

    public void didTapSendLoginRequestButton(View view) {
    }

    public void didTapSendSignUpRequestButton(View view) {
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
    public Button getFacebookButton() { return mFacebookButton; }
    public Button getSignUpButton() { return mSignUpButton; }
    public LinearLayout getButtonsLayout() { return mButtonsLayout; }
    public LinearLayout getLoginWithEmailLayout() { return mLoginWithEmailLayout; }

    // Setters
    public void setLogoImageView(ImageView imageView) { mLogoImageView = imageView; }
    public void setEmailField(EditText emailField) { mEmailField = emailField; }
    public void setPasswordField(EditText passwordField) { mPasswordField = passwordField; }
    public void setLoginButton(Button loginButton) { mLoginButton = loginButton; }
    public void setFacebookButton(Button facebookButton) { mFacebookButton = facebookButton; }
    public void setSignUpButton(Button signUpButton) { mSignUpButton = signUpButton; }
    public void setButtonsLayout(LinearLayout buttonsLayout) { mButtonsLayout = buttonsLayout; }
    public void setLoginWithEmailLayout(LinearLayout loginWithEmailLayout) { mLoginWithEmailLayout = loginWithEmailLayout; }
}
