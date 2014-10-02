package com.blueprint.watershed;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.content.SharedPreferences;
import android.graphics.Typeface;
import com.blueprint.watershed.R;

public class MainActivity extends ActionBarActivity {

    // Constants
    public  static final String PREFERENCES = "LOGIN_PREFERENCES";
    private static final String TAG         = "MainActivity";

    // Authenticating against our own server
    public String authToken;
    public String authEmail;

    // For storing our credentials once we have successfully authenticated
    SharedPreferences preferences;

    // Fragments
    public Fragment currentFragment;

    // View Elements
    public CharSequence mTitle;

    // UI Elements
    public Typeface watershedFont;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        initializeFragments();

        setContentView(R.layout.activity_main);

        initializeNavigation();

        SharedPreferences prefs = getSharedPreferences(PREFERENCES, 0);
        authToken = prefs.getString("auth_token", "none");
        authEmail = prefs.getString("auth_email", "none");

        mTitle = getTitle();
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

    public void replaceFragment(Fragment newFragment) {
        FragmentManager fragmentManager = getSupportFragmentManager();
        android.support.v4.app.FragmentTransaction ft = fragmentManager.beginTransaction();
        if(!newFragment.isAdded()){
            ft.add(R.id.container, newFragment);
        }
        ft.hide(currentFragment);
        ft.show(newFragment);
        ft.commit();
    }

    private void initializeFragments() {
        // Initialize each of the fragments and set the current fragment
    }

    private void initializeNavigation() {
        // Initialize the left drawer

        String titles[] = { "Tasks", "Sites", "Activity Log", "Profile", "About", "Logout" };
    }
}
