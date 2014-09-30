package com.blueprint.watershed;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.content.SharedPreferences;

import android.view.View;

import com.android.volley.*;
import com.android.volley.toolbox.*;
import android.widget.Toast;


public class LoginActivity extends Activity {

    // Constants
    public  static final String PREFERENCES = "LOGIN_PREFERENCES";
    private static final String TAG         = "LoginActivity";

    // TODO(mark): This should be in a global constants file
    private static final String url = "http://localhost:3000/api/v1";
    private static final String login_path = "/sign_in";


    // Networking
    private RequestQueue requestQueue;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        requestQueue = Volley.newRequestQueue(this);

        SharedPreferences preferences = getSharedPreferences(PREFERENCES, 0);

        if (!preferences.getString("auth_token", "none").equals("none") && !preferences.getString("auth_email", "none").equals("none")) {
            final Intent intent = new Intent(this, MainActivity.class);
            intent.putExtra("auth_token", preferences.getString("auth_token", null));
            this.finish();
            startActivity(intent);
        }
    }

    public void attemptLogin(View view) {

    }
}
