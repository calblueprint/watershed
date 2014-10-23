package com.blueprint.watershed;

import android.app.ActionBar;
import android.app.Activity;
import android.app.FragmentTransaction;
import android.net.Uri;
import android.os.Bundle;
import android.os.Build;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v7.app.ActionBarActivity;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.content.SharedPreferences;
import android.graphics.Typeface;
import com.blueprint.watershed.R;
import android.view.View;
import android.content.Context;
import android.content.Intent;
import android.widget.TextView;
import android.app.ActionBar.Tab;

import java.util.ArrayList;

public class MainActivity extends ActionBarActivity
                          implements ActionBar.TabListener,
                                     View.OnClickListener,
                                     TaskFragment.OnFragmentInteractionListener,
                                     SiteListFragment.OnFragmentInteractionListener {

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

    // Navigation Drawer
    private ResideMenu resideMenu;
    private ArrayList<ResideMenuItem> menuItems;

    // View Elements
    public CharSequence mTitle;

    // UI Elements
    public Typeface watershedFont;

    //Adapters
    public TaskAdapter arrayAdapter;

    private ActionBar actionBar;
    private ViewPager viewPager;
    private TabsPagerAdapter mAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        actionBar = getActionBar();
        if (actionBar == null){
            Log.e("NO ACTIONBAR ", "FIGHT ME");
        }
        mAdapter = new TabsPagerAdapter(getSupportFragmentManager());
        viewPager = (ViewPager) findViewById(R.id.pager);
        initializeFragments();
        initializeTabs();

        //initializeNavigationDrawer();

        SharedPreferences prefs = getSharedPreferences(PREFERENCES, 0);
        authToken = prefs.getString("auth_token", "none");
        authEmail = prefs.getString("auth_email", "none");

        mTitle = "Tasks";
    }

    public void initializeTabs(){
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

        actionBar.addTab(
                actionBar.newTab()
                        .setText("Your Tasks")
                        .setTabListener(tabListener));
        actionBar.addTab(
                actionBar.newTab()
                        .setText("All Tasks")
                        .setTabListener(tabListener));

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

    public void replaceFragment(Fragment newFragment) {
        FragmentManager fragmentManager = getSupportFragmentManager();
        android.support.v4.app.FragmentTransaction ft = fragmentManager.beginTransaction();
        if(!newFragment.isAdded()){
            ft.replace(R.id.container, newFragment);
            ft.commit();
        }
    }

    private void initializeFragments() {
        mtaskFragment = TaskFragment.newInstance(0);
        FragmentManager fragmentManager = getSupportFragmentManager();
        android.support.v4.app.FragmentTransaction ft = fragmentManager.beginTransaction();
        ft.add(R.id.container, mtaskFragment);
        ft.show(mtaskFragment);
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


//    private void initializeNavigationDrawer() {
//        resideMenu = new ResideMenu(this);
//        resideMenu.attachToActivity(this);
//        resideMenu.setShadowVisible(false);
//        resideMenu.setDirectionDisable(ResideMenu.DIRECTION_RIGHT);
//        resideMenu.setBackground(R.drawable.golden_gate_bridge);
//
//        String titles[] = { "Tasks", "Sites", "Activity Log", "Profile", "About", "Logout" };
//        int icon[] = { R.drawable.watershed_logo, R.drawable.watershed_logo, R.drawable.watershed_logo, R.drawable.watershed_logo, R.drawable.watershed_logo, R.drawable.watershed_logo };
//        menuItems = new ArrayList<ResideMenuItem>();
//        for (int i = 0; i < titles.length; i++) {
//            ResideMenuItem item = new ResideMenuItem(this, icon[i], titles[i]);
//            item.setOnClickListener(this);
//            resideMenu.addMenuItem(item, ResideMenu.DIRECTION_LEFT);
//            menuItems.add(item);
//        }
//
//        findViewById(R.id.title_bar_left_menu).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                resideMenu.openMenu(ResideMenu.DIRECTION_LEFT);
//            }
//        });
//    }

    // View on click listener
    @Override
    public void onClick(View view) {
        int position = menuItems.indexOf(view);
        setActionBarTitle(position);
        switch (position) {
            case 0:
                TaskFragment taskFragment = new TaskFragment();
                replaceFragment(taskFragment);
                break;
            case 1:
                SiteListFragment siteListFragment = new SiteListFragment();
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
        resideMenu.closeMenu();
    }

    private void setActionBarTitle(int position){
        switch (position) {
            case 0:
                mTitle = "Tasks";
                break;
            case 1:
                mTitle = "Sites";
                break;
            case 2:
                mTitle = "Activity Log";
                break;
            case 3:
                mTitle = "Profile";
                break;
            case 4:
                mTitle = "About";
                break;
            case 5:
                mTitle = "Logout";
                break;
        }
        TextView titleView = (TextView) findViewById(R.id.title);
        titleView.setTypeface(watershedFont);
        titleView.setText(mTitle);
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
}
