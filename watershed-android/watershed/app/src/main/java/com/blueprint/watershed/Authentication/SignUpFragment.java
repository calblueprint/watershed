package com.blueprint.watershed.Authentication;

import android.app.Activity;
import android.app.Fragment;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.text.method.PasswordTransformationMethod;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import com.blueprint.watershed.Activities.LandingPageActivity;
import com.blueprint.watershed.R;

import java.util.HashMap;


public class SignUpFragment extends Fragment implements View.OnClickListener {

    private final String SENDER_ID = "158271976435";
    private LandingPageActivity mParentActivity;
    private View rootView;

    // UI Elements
    private EditText mNameField;
    private EditText mEmailField;
    private EditText mPasswordField;
    private EditText mPasswordConfirmationField;
    private Button mSignUpButton;
    private SharedPreferences preferences;

    public static SignUpFragment newInstance() {
        return new SignUpFragment();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mParentActivity = (LandingPageActivity) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.fragment_sign_up, container, false);

        // Configure view
        setNameField((EditText) rootView.findViewById(R.id.name_field));
        setEmailField((EditText) rootView.findViewById(R.id.email_field));
        setPasswordField((EditText) rootView.findViewById(R.id.password_field));
        setPasswordConfirmationField((EditText) rootView.findViewById(R.id.password_confirmation_field));
        setSignUpButton((Button) rootView.findViewById(R.id.sign_up_button));

        getPasswordField().setTransformationMethod(new PasswordTransformationMethod());
        getPasswordConfirmationField().setTransformationMethod(new PasswordTransformationMethod());

        // Set OnClickListeners
        getSignUpButton().setOnClickListener(this);

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
            case R.id.sign_up_button:
                didTapSignUpButton(view);
                break;
        }
    }

    // UI Actions
    public void didTapSignUpButton(View view) {
        final String nameString = getNameField().getText().toString();
        final String emailString = getEmailField().getText().toString();
        final String passwordString = getPasswordField().getText().toString();
        final String passwordConfirmationString = getPasswordConfirmationField().getText().toString();

        HashMap<String, String> user_params = new HashMap<String, String>();
        user_params.put("name", nameString);
        user_params.put("email", emailString);
        user_params.put("password", passwordString);
        user_params.put("password_confirmation", passwordConfirmationString);
        user_params.put("device_type", "0");

        try {
            if (mParentActivity.getGcm() != null) {
                user_params.put("registration_id", mParentActivity.getGcm().register(SENDER_ID));
            }
        } catch (Exception e) {
            Log.i("Exception", e.toString());
        }

        mParentActivity.signUpRequest(user_params);
    }

    // Getters
    public EditText getNameField() { return mNameField; }
    public EditText getEmailField() { return mEmailField; }
    public EditText getPasswordField() { return mPasswordField; }
    public EditText getPasswordConfirmationField() { return mPasswordConfirmationField; }
    public Button getSignUpButton() { return mSignUpButton; }


    // Setters
    public void setNameField(EditText nameField) { mNameField = nameField; }
    public void setEmailField(EditText emailField) { mEmailField = emailField; }
    public void setPasswordField(EditText passwordField) { mPasswordField = passwordField; }
    public void setPasswordConfirmationField(EditText passwordConfirmationField) { mPasswordConfirmationField = passwordConfirmationField; }
    public void setSignUpButton(Button signUpButton) { mSignUpButton = signUpButton; }
}