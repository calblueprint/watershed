package com.blueprint.watershed.Activities;

import android.app.ActionBar;
import android.app.FragmentTransaction;
import android.content.res.Configuration;
import android.net.Uri;
import android.os.Bundle;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.support.v4.app.ActionBarDrawerToggle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.content.SharedPreferences;
import android.graphics.Typeface;

import com.blueprint.watershed.MiniSites.MiniSiteFragment;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Utilities.ResideMenu;
import com.blueprint.watershed.Utilities.ResideMenuItem;
import com.blueprint.watershed.Sites.SiteFragment;
import com.blueprint.watershed.Sites.SiteListFragment;
import com.blueprint.watershed.Utilities.TabsPagerAdapter;
import com.blueprint.watershed.Tasks.TaskAdapter;
import com.blueprint.watershed.Tasks.TaskDetailFragment;
import com.blueprint.watershed.Tasks.TaskFragment;

import android.view.View;
import android.content.Context;
import android.content.Intent;
import android.app.ActionBar.Tab;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import java.util.ArrayList;

public class MainActivity extends ActionBarActivity
                          implements ActionBar.TabListener,
                                     View.OnClickListener,
                                     TaskFragment.OnFragmentInteractionListener,
                                     TaskDetailFragment.OnFragmentInteractionListener,
                                     SiteListFragment.OnFragmentInteractionListener,
                                     SiteFragment.OnFragmentInteractionListener,
                                     MiniSiteFragment.OnFragmentInteractionListener {

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
    private TaskFragment mtaskFragment;
    private SiteListFragment siteListFragment;
    private FragmentManager fragmentManager;

    // Navigation Drawer
    private DrawerLayout mDrawerLayout;
    private ListView mDrawerList;
    private ActionBarDrawerToggle mDrawerToggle;
    private ArrayList<String> menuItems;

    // View Elements
    public CharSequence mTitle;

    // UI Elements
    public Typeface watershedFont;

    // Adapters
    public TaskAdapter arrayAdapter;

    // Action Bar Elements
    private ActionBar actionBar;
    private ViewPager viewPager;
    private TabsPagerAdapter mAdapter;
    private View mContainer;

    // Networking
    private NetworkManager mNetworkManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        actionBar = getActionBar();
        setTitle("Tasks");
        mAdapter = new TabsPagerAdapter(getSupportFragmentManager());
        viewPager = (ViewPager) findViewById(R.id.pager);
        mContainer = findViewById(R.id.container);
        initializeFragments();
        initializeTabs(0);

        initializeNavigationDrawer();

        SharedPreferences prefs = getSharedPreferences(PREFERENCES, 0);
        authToken = prefs.getString("auth_token", "none");
        authEmail = prefs.getString("auth_email", "none");
        mTitle = "Tasks";

        setNetworkManager(NetworkManager.getInstance(this.getApplicationContext()));
    }

    public void initializeTabs(int option){
        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
        ActionBar.TabListener tabListener = new ActionBar.TabListener() {
            public void onTabSelected(ActionBar.Tab tab, FragmentTransaction ft) {
                viewPager.setCurrentItem(tab.getPosition());
            }
            public void onTabUnselected(ActionBar.Tab tab, FragmentTransaction ft) {
                // hide the given tab
            }
            public void onTabReselected(ActionBar.Tab tab, FragmentTransaction ft) {
                // probably ignore this event
            }
        };

        viewPager.setAdapter(mAdapter);
        actionBar.setHomeButtonEnabled(false);
        actionBar.setDisplayHomeAsUpEnabled(true);

        if (option == 0) {
            actionBar.addTab(
                    actionBar.newTab()
                            .setText("Your Tasks")
                            .setTabListener(tabListener));
            actionBar.addTab(
                    actionBar.newTab()
                            .setText("All Tasks")
                            .setTabListener(tabListener));
        }

        viewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {

            @Override
            public void onPageSelected(int position) {
                // on changing the page
                // make respected tab selected
                actionBar.setSelectedNavigationItem(position);
            }

            @Override
            public void onPageScrolled(int arg0, float arg1, int arg2) {
            }

            @Override
            public void onPageScrollStateChanged(int arg0) {
            }
        });
    }

    public void updateTitle(Fragment f){
        if (f instanceof TaskFragment){
            setTitle("Tasks");
            displayTaskView(true);
            return;
        }
        else if (f instanceof SiteListFragment) {
            setTitle("Sites");
        }
        displayTaskView(false);

    }

    public void displayTaskView(boolean toggle){
        if (toggle){
            actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
            viewPager.setVisibility(View.VISIBLE);
            mContainer.setVisibility(View.INVISIBLE);
        }
        else {
            actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_STANDARD);
            viewPager.setVisibility(View.INVISIBLE);
            mContainer.setVisibility(View.VISIBLE);
        }
    }

    public void replaceFragment(Fragment newFragment) {
        android.support.v4.app.FragmentTransaction ft = fragmentManager.beginTransaction();
        if(!newFragment.isAdded()){
            ft.replace(R.id.container, newFragment);
            updateTitle(newFragment);
            ft.addToBackStack(null);
            ft.commit();
        }
    }

    private void initializeFragments() {
        mtaskFragment = TaskFragment.newInstance(0);
        fragmentManager = getSupportFragmentManager();
        fragmentManager.addOnBackStackChangedListener(
                new FragmentManager.OnBackStackChangedListener() {
                    @Override
                    public void onBackStackChanged() {
                        Fragment f = getSupportFragmentManager().findFragmentById(R.id.container);
                        if (f != null){
                            updateTitle(f);
                        }
                    }
                });
        updateTitle(mtaskFragment);
        android.support.v4.app.FragmentTransaction ft = fragmentManager.beginTransaction();
        ft.add(R.id.container, mtaskFragment);
        //ft.show(mtaskFragment);
        ft.commit();
    }

    public void onFragmentInteraction(String id){
        // Deals with fragment interactions
    }

    public void onFragmentInteraction(Uri uri){
        // Deals with fragment interactions
    }

    @Override
    public void onTabReselected(Tab tab, FragmentTransaction ft) {
    }

    @Override
    public void onTabSelected(Tab tab, FragmentTransaction ft) {
        // on tab selected
        // show respected fragment view
        viewPager.setCurrentItem(tab.getPosition());
    }

    @Override
    public void onTabUnselected(ActionBar.Tab tab, FragmentTransaction ft) {
    }

    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            // Respond to the action bar's Up/Home button
            case android.R.id.home:
                //TODO
                //resideMenu.openMenu(ResideMenu.DIRECTION_LEFT);
        }
        if (mDrawerToggle.onOptionsItemSelected(item)) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    private void initializeNavigationDrawer() {
        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        mDrawerList = (ListView) findViewById(R.id.left_drawer);
        String titles[] = { "Tasks", "Sites", "Activity Log", "Profile", "About", "Logout" };

        menuItems = new ArrayList<String>();
        for (String title : titles) {
            menuItems.add(title);
        }

        mDrawerList.setAdapter(new ArrayAdapter<String>(this,
                R.layout.residemenu_item, R.id.tv_title, titles));

        //int icon[] = { R.drawable.watershed_logo, R.drawable.watershed_logo, R.drawable.watershed_logo, R.drawable.watershed_logo, R.drawable.watershed_logo, R.drawable.watershed_logo };

        mDrawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout,
                R.drawable.ic_drawer, R.string.draw_open_close , R.string.draw_open_close) {

            /** Called when a drawer has settled in a completely closed state. */
            public void onDrawerClosed(View view) {
                super.onDrawerClosed(view);
                getActionBar().setTitle(mTitle);
                invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()
            }

            /** Called when a drawer has settled in a completely open state. */
            public void onDrawerOpened(View drawerView) {
                super.onDrawerOpened(drawerView);
                getActionBar().setTitle("Menu");
                invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()
            }
        };
        mDrawerLayout.setDrawerListener(mDrawerToggle);

        getActionBar().setDisplayHomeAsUpEnabled(true);
        getActionBar().setHomeButtonEnabled(true);
    }

    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        // Sync the toggle state after onRestoreInstanceState has occurred.
        mDrawerToggle.syncState();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        mDrawerToggle.onConfigurationChanged(newConfig);
    }

    // View on click listener
    @Override
    public void onClick(View view) {
        int position = menuItems.indexOf(view);
        switch (position) {
            case 0:
                TaskFragment taskFragment = TaskFragment.newInstance(0);
                replaceFragment(taskFragment);
                break;
            case 1:
                //displayTaskView(false);
                siteListFragment = new SiteListFragment();
                replaceFragment(siteListFragment);
                break;
            case 2:
                //replaceFragment();
                break;
            case 3:
                //replaceFragment();
                break;
            case 4:
                //replaceFragment();
                break;
            case 5:
                SharedPreferences prefs = getSharedPreferences(LandingPageActivity.PREFERENCES, 0);
                SharedPreferences.Editor editor = prefs.edit();
                editor.clear();
                editor.commit();
                Intent intent = new Intent(this, LandingPageActivity.class);
                this.finish();
                startActivity(intent);
                break;
        }
        //resideMenu.closeMenu();
    }

    // System level attributes
    private static int getAppVersion(Context context) {
        try {
            PackageInfo packageInfo = context.getPackageManager()
                    .getPackageInfo(context.getPackageName(), 0);
            return packageInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            // should never happen
            throw new RuntimeException("Could not get package name: " + e);
        }
    }

    // Networking
    public NetworkManager getNetworkManager() { return mNetworkManager; }
    public void setNetworkManager(NetworkManager networkManager) { mNetworkManager = networkManager; }



}
