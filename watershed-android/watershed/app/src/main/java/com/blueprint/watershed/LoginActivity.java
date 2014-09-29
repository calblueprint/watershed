package com.blueprint.watershed;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.content.SharedPreferences;

import com.android.volley.NetworkError;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.Request;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
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

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.login, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
