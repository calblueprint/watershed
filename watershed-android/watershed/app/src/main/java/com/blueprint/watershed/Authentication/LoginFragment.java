package com.blueprint.watershed.Authentication;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.Button;

import com.blueprint.watershed.Activities.LandingPageActivity;
import com.blueprint.watershed.R;

import java.util.HashMap;


public class LoginFragment extends Fragment implements View.OnClickListener {

    private LandingPageActivity parentActivity;
    private View rootView;

    // UI Elements
    private EditText mEmailField;
    private EditText mPasswordField;
    private Button mLoginButton;
    private SharedPreferences preferences;

    public static LoginFragment newInstance() {
        return new LoginFragment();
    }

    public LoginFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        parentActivity = (LandingPageActivity) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_login, container, false);

        // Configure view
        setEmailField((EditText) rootView.findViewById(R.id.email_field));
        setPasswordField((EditText) rootView.findViewById(R.id.password_field));
        setLoginButton((Button) rootView.findViewById(R.id.login_button));

        // Set OnClickListeners
        getLoginButton().setOnClickListener(this);

        return rootView;
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }

    // View.OnClickListener
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.login_button:
                didTapLoginButton(view);
                break;
        }
    }

    // UI Actions
    public void didTapLoginButton(View view) {
        
        final String emailString = getEmailField().getText().toString();
        final String passwordString = getPasswordField().getText().toString();

        HashMap<String, String> user_params = new HashMap<String, String>();
        user_params.put("email", emailString);
        user_params.put("password", passwordString);
        HashMap<String, HashMap<String, String>> params = new HashMap<String, HashMap<String,String>>();
        params.put("user",user_params);

        parentActivity.login(params);
    }



    // Getters
    public EditText getEmailField() { return mEmailField; }
    public EditText getPasswordField() { return mPasswordField; }
    public Button getLoginButton() { return mLoginButton; }


    // Setters
    public void setEmailField(EditText emailField) { mEmailField = emailField; }
    public void setPasswordField(EditText passwordField) { mPasswordField = passwordField; }
    public void setLoginButton(Button loginButton) { mLoginButton = loginButton; }
}