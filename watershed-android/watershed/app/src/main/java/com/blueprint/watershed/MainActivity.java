package com.blueprint.watershed;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.content.SharedPreferences;
import com.blueprint.watershed.R;

public class MainActivity extends Activity {

    public  static final String PREFERENCES = "LOGIN_PREFERENCES";
    private static final String TAG         = "MainActivity";

    // Authenticating against our own server
    public String authToken;
    public String authEmail;

    // For storing our credentials once we have successfully authenticated
    SharedPreferences preferences;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        initializeFragments();

        setContentView(R.layout.activity_main);

        initializeNavigation();


    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
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

    private void initializeFragments() {
        // Initialize each of the fragments and set the current fragment
    }

    private void initializeNavigation() {
        // Initialize the left drawer
    }
}
