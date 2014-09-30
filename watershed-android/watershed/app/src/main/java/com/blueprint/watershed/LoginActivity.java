package com.blueprint.watershed;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import android.view.View;

import com.android.volley.*;
import com.android.volley.toolbox.*;
import android.widget.Toast;


public class LoginActivity extends Activity {

    // Constants
    private static final String TAG = "LoginActivity";

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
    }

    public void attemptLogin(View view) {

    }
}
