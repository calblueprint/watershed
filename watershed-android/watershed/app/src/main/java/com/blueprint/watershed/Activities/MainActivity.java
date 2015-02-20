package com.blueprint.watershed.Activities;

import android.app.ActionBar;
import android.app.ActionBar.Tab;
import android.app.Activity;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.graphics.Typeface;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.ActionBarDrawerToggle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.view.ViewPager;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.ProgressBar;

import com.android.volley.Response;
import com.blueprint.watershed.AboutFragment;
import com.blueprint.watershed.FieldReports.AddFieldReportFragment;
import com.blueprint.watershed.FieldReports.FieldReportFragment;
import com.blueprint.watershed.MiniSites.MiniSiteFragment;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Users.HomeRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.SiteFragment;
import com.blueprint.watershed.Sites.SiteListFragment;
import com.blueprint.watershed.Tasks.Task;
import com.blueprint.watershed.Tasks.TaskAbstractFragment;
import com.blueprint.watershed.Tasks.TaskAdapter;
import com.blueprint.watershed.Tasks.TaskDetailFragment;
import com.blueprint.watershed.Tasks.TaskFragment;
import com.blueprint.watershed.Users.User;
import com.blueprint.watershed.Users.UserFragment;
import com.blueprint.watershed.Utilities.TabsPagerAdapter;
import com.facebook.Session;

import org.json.JSONObject;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

public class MainActivity extends ActionBarActivity
                          implements ActionBar.TabListener,
                                     View.OnClickListener,
                                     ListView.OnItemClickListener,
                                     TaskFragment.OnFragmentInteractionListener,
                                     TaskDetailFragment.OnFragmentInteractionListener,
                                     SiteFragment.OnFragmentInteractionListener,
                                     UserFragment.OnFragmentInteractionListener,
                                     AboutFragment.OnFragmentInteractionListener,
                                     SiteListFragment.OnFragmentInteractionListener,
                                     MiniSiteFragment.OnFragmentInteractionListener,
                                     AddFieldReportFragment.OnFragmentInteractionListener,
                                     TaskAbstractFragment.OnFragmentInteractionListener,
                                     FieldReportFragment.OnFragmentInteractionListener {

    // Constants
    public  static final String PREFERENCES = "LOGIN_PREFERENCES";
    private static final String TAG         = "MainActivity";

    // Authenticating against our own server
    public String authToken;
    public String authEmail;

    // For storing our credentials once we have successfully authenticated
    SharedPreferences preferences;

    // Fragments
    private TaskFragment mtaskFragment;
    private SiteListFragment siteListFragment;
    private FragmentManager fragmentManager;
    private UserFragment mUserFragment;
    private AboutFragment mAboutFragment;

    // Navigation Drawer
    private DrawerLayout mDrawerLayout;
    private ListView mDrawerList;
    private ActionBarDrawerToggle mDrawerToggle;
    private List<String> menuItems;

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
    private ProgressBar mProgress;


    // Networking
    private NetworkManager mNetworkManager;

    // User
    private User mUser;
    private Integer mUserId;

    //Task for FieldReport
    private Task mFieldReportTask;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Bundle b = getIntent().getExtras();
        mUserId = b.getInt("userId");

        actionBar = getActionBar();
        setTitle("Tasks");
        mAdapter = new TabsPagerAdapter(getSupportFragmentManager());
        viewPager = (ViewPager) findViewById(R.id.pager);
        mContainer = findViewById(R.id.container);

        setNetworkManager(NetworkManager.getInstance(this.getApplicationContext()));

        mProgress = (ProgressBar) this.findViewById(R.id.progressBar);
        initializeTabs(0);

        makeHomeRequest();
        initializeNavigationDrawer();
        initializeFragments();

        SharedPreferences prefs = getSharedPreferences(PREFERENCES, 0);
        authToken = prefs.getString("auth_token", "none");
        authEmail = prefs.getString("auth_email", "none");
        mTitle = "Tasks";

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

    public void updateTitle(Fragment f) {
        if (f instanceof TaskFragment){
            setTitle("Tasks");
            displayTaskView(true);
            return;
        }
        else if (f instanceof SiteListFragment || f instanceof SiteFragment) {
            setTitle("Sites");
        }
        else if (f instanceof AboutFragment) {
            setTitle("About");
        }
        else if (f instanceof UserFragment) {
            setTitle("Profile");
        }
        displayTaskView(false);

    }

    public void displayTaskView(boolean toggle) {
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
        ft.commit();
    }

    public void onFragmentInteraction(String id) {
        // Deals with fragment interactions
    }

    public void onFragmentInteraction(Uri uri) {
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
            case android.R.id.home:
                Fragment f = getSupportFragmentManager().findFragmentById(R.id.container);
                if (!(f instanceof TaskFragment) && !(f instanceof SiteListFragment) &&!(f instanceof UserFragment) &&!(f instanceof AboutFragment)) {
                    getSupportFragmentManager().popBackStack();
                    return false;
                }
        }
        if (mDrawerToggle.onOptionsItemSelected(item)) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    private void initializeNavigationDrawer() {
        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        mDrawerList = (ListView) findViewById(R.id.left_drawer);
        String titles[] = { "Tasks", "Sites", "Profile", "About", "Logout" };

        menuItems = Arrays.asList(titles);

        mDrawerList.setOnItemClickListener(this);

        mDrawerList.setAdapter(new ArrayAdapter<String>(this,
                R.layout.menu_list_item, R.id.menu_title, titles));

        mDrawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout,
                R.drawable.ic_drawer, R.string.draw_open_close , R.string.draw_open_close) {

            /** Called when a drawer has settled in a completely closed state. */
            public void onDrawerClosed(View view) {
                super.onDrawerClosed(view);
                invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()
            }

            /** Called when a drawer has settled in a completely open state. */
            public void onDrawerOpened(View drawerView) {
                super.onDrawerOpened(drawerView);
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

    // Nav Drawer on click listener

    public void onItemClick(AdapterView parent, View view, int position, long id) {
        onNavClick(position);
    }

    // View on click listener
    public void onNavClick(int position) {
        switch (position) {
            case 0:
                TaskFragment taskFragment = TaskFragment.newInstance(0);
                mProgress.setVisibility(View.VISIBLE);
                replaceFragment(taskFragment);
                break;
            case 1:
                siteListFragment = new SiteListFragment();
                mProgress.setVisibility(View.VISIBLE);
                replaceFragment(siteListFragment);
                break;
            case 2:
                mUserFragment = UserFragment.newInstance(mUser);
                replaceFragment(mUserFragment);
                break;
            case 3:
                mAboutFragment = new AboutFragment();
                replaceFragment(mAboutFragment);
                break;
            case 4:
                logoutCurrentUser(this);
                break;
        }
        mDrawerLayout.closeDrawer(mDrawerList);
    }

    public static void logoutCurrentUser(Activity activity) {
        SharedPreferences prefs = activity.getSharedPreferences(LandingPageActivity.PREFERENCES, 0);
        SharedPreferences.Editor editor = prefs.edit();
        editor.clear();
        editor.commit();
        Intent intent = new Intent(activity, LandingPageActivity.class);

        if (Session.getActiveSession() != null) {
            Session.getActiveSession().closeAndClearTokenInformation();
        }

        activity.finish();
        activity.startActivity(intent);
    }

    @Override
    public void onClick(View view){}

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

    public void makeHomeRequest(){
        // TODO: Change to an actual home request, and not just a user request.
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        HomeRequest homeRequest = new HomeRequest(this, mUserId, params, new Response.Listener<User>() {
            @Override
            public void onResponse(User home) {
                setUser(home);
                mUserFragment = UserFragment.newInstance(mUser);
            }
        });

        mNetworkManager.getRequestQueue().add(homeRequest);
    }


    // Setter
    public void setUser(User user){
        mUser = user;
    }
    public User getUser() { return mUser; }

    public void setFieldReportTask(Task task) { mFieldReportTask = task; }
    public Task getFieldReportTask() { return mFieldReportTask; }

    public ProgressBar getSpinner() { return mProgress; }
}
