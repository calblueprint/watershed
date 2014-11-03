package com.blueprint.watershed;

import android.app.Activity;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.Button;
import android.content.Intent;
import android.widget.Toast;

import com.android.volley.NetworkError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;


public class LoginFragment extends Fragment implements View.OnClickListener {

    private LandingPageActivity parentActivity;
    private View rootView;

    // UI Elements
    private EditText mEmailField;
    private EditText mPasswordField;
    private Button mLoginButton;

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
        final Intent intent = new Intent(parentActivity, MainActivity.class);

        final String emailString = getEmailField().getText().toString();
        final String passwordString = getPasswordField().getText().toString();

        HashMap<String, String> user_params = new HashMap<String, String>();
        user_params.put("email", emailString);
        user_params.put("password", passwordString);
        HashMap<String, HashMap<String, String>> params = new HashMap<String, HashMap<String,String>>();
        params.put("user",user_params);

        parentActivity.Login(params);

        if (parentActivity.getRequestHandler().has_Credentials()){
            parentActivity.finish();
            startActivity(intent);
        }

        Log.e("No go", "joe");
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