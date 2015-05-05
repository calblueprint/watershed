package com.blueprint.watershed.Authentication;

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RelativeLayout;

import com.blueprint.watershed.Activities.LandingPageActivity;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Utilities.Utility;

import java.util.HashMap;


public class LoginFragment extends Fragment implements View.OnClickListener {

    private LandingPageActivity mParentActivity;

    private RelativeLayout mLayout;
    private EditText mEmailField;
    private EditText mPasswordField;
    private Button mLoginButton;

    public static LoginFragment newInstance() {
        return new LoginFragment();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mParentActivity = (LandingPageActivity) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_login, container, false);
        setViews(view);
        return view;
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.login_button:
                didTapLoginButton(view);
                break;
        }
    }

    private void setViews(View view) {
        Utility.setKeyboardListener(mParentActivity, view);
        mEmailField = (EditText) view.findViewById(R.id.email_field);
        mPasswordField = (EditText) view.findViewById(R.id.password_field);
        mLoginButton = (Button) view.findViewById(R.id.login_button);
        mLayout = (RelativeLayout) view.findViewById(R.id.login_container);
        mLoginButton.setOnClickListener(this);
    }

    // UI Actions
    public void didTapLoginButton(View view) {
        Utility.hideKeyboard(mParentActivity, mLayout);
        final String emailString = mEmailField.getText().toString();
        final String passwordString = mPasswordField.getText().toString();

        HashMap<String, String> user_params = new HashMap<String, String>();
        user_params.put("email", emailString);
        user_params.put("password", passwordString);
        mParentActivity.findViewById(R.id.viewBlocker).setVisibility(View.VISIBLE);
        mParentActivity.loginRequest(user_params);
    }

}