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
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.ActionBarDrawerToggle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.view.ViewPager;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.util.LruCache;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.ProgressBar;

import com.android.volley.Response;
import com.blueprint.watershed.AboutFragment;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Users.HomeRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.CreateSiteFragment;
import com.blueprint.watershed.Sites.SiteFragment;
import com.blueprint.watershed.Sites.SiteListFragment;
import com.blueprint.watershed.Tasks.CreateTaskFragment;
import com.blueprint.watershed.Tasks.Task;
import com.blueprint.watershed.Tasks.TaskFragment;
import com.blueprint.watershed.Users.User;
import com.blueprint.watershed.Users.UserFragment;
import com.blueprint.watershed.Utilities.TabsPagerAdapter;
import com.blueprint.watershed.Utilities.Utility;
import com.facebook.Session;

import org.json.JSONObject;

import java.util.HashMap;

public class MainActivity extends ActionBarActivity
                          implements ActionBar.TabListener,
                                     View.OnClickListener,
                                     ListView.OnItemClickListener {


    // Constants
    private static final String PREFERENCES = "LOGIN_PREFERENCES";
    private static final String TAG         = "MainActivity";
    private static int CACHE_SIZE = 512;

    // Authenticating against our own server
    public String authToken;
    public String authEmail;

    // Fragments
    private FragmentManager mFragmentManager;

    // Navigation Drawer
    private DrawerLayout mDrawerLayout;
    private ListView mDrawerList;
    private ActionBarDrawerToggle mDrawerToggle;

    // View Elements
    public CharSequence mTitle;

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

    // Caching images
    private LruCache<Integer, Drawable> mSiteImages;
    private LruCache<Integer, Drawable> mMiniSiteImages;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mUserId = getIntent().getExtras().getInt("userId");

        setNetworkManager(NetworkManager.getInstance(this));
        makeHomeRequest();

        initializeCache();
        initializeViews();

        mProgress = (ProgressBar) this.findViewById(R.id.progressBar);
        initializeTabs(0);

        initializeNavigationDrawer();
        initializeFragments();

        SharedPreferences prefs = getSharedPreferences(PREFERENCES, 0);
        authToken = prefs.getString("auth_token", "none");
        authEmail = prefs.getString("auth_email", "none");
        mTitle = "Tasks";

    }

    private void initializeCache() {
        mSiteImages = new LruCache<Integer, Drawable>(CACHE_SIZE) {
            protected int sizeOf(String key, Bitmap value) {
                return value.getByteCount();
            }
        };

        mMiniSiteImages = new LruCache<Integer, Drawable>(CACHE_SIZE) {
            protected int sizeOf(String key, Bitmap value) {
                return value.getByteCount();
            }
        };
    }

    private void initializeViews() {
        actionBar = getActionBar();
        setTitle("Tasks");
        mAdapter = new TabsPagerAdapter(getSupportFragmentManager());
        viewPager = (ViewPager) findViewById(R.id.pager);
        mContainer = findViewById(R.id.container);
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
        android.support.v4.app.FragmentTransaction ft = mFragmentManager.beginTransaction();
        if(!newFragment.isAdded()){
            updateTitle(newFragment);
            ft.replace(R.id.container, newFragment).addToBackStack(null).commit();
        }
    }

    private void initializeFragments() {
        TaskFragment taskFragment = TaskFragment.newInstance(0);
        mFragmentManager = getSupportFragmentManager();
        mFragmentManager.addOnBackStackChangedListener(
                new FragmentManager.OnBackStackChangedListener() {
                    @Override
                    public void onBackStackChanged() {
                        Fragment f = getSupportFragmentManager().findFragmentById(R.id.container);
                        if (f != null){
                            updateTitle(f);
                        }
                    }
                });
        updateTitle(taskFragment);
        android.support.v4.app.FragmentTransaction ft = mFragmentManager.beginTransaction();
        ft.add(R.id.container, taskFragment);
        ft.commit();
    }

    @Override
    public void onTabReselected(Tab tab, FragmentTransaction ft) {}

    @Override
    public void onTabSelected(Tab tab, FragmentTransaction ft) {
        viewPager.setCurrentItem(tab.getPosition());
    }

    @Override
    public void onTabUnselected(ActionBar.Tab tab, FragmentTransaction ft) {}

    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                Utility.hideKeyboard(this, mContainer);
                Fragment f = getSupportFragmentManager().findFragmentById(R.id.container);
                if (!(f instanceof TaskFragment) && !(f instanceof SiteListFragment) &&!(f instanceof UserFragment) &&!(f instanceof AboutFragment)) {
                    getSupportFragmentManager().popBackStack();
                    return false;
                }
                break;
            case R.id.add_task:
                CreateTaskFragment newTask = CreateTaskFragment.newInstance();
                replaceFragment(newTask);
                return true;
            case R.id.add_site:
                CreateSiteFragment newSite = CreateSiteFragment.newInstance();
                replaceFragment(newSite);
                return true;
        }
        return mDrawerToggle.onOptionsItemSelected(item) || super.onOptionsItemSelected(item);
    }

    private void initializeNavigationDrawer() {
        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        mDrawerList = (ListView) findViewById(R.id.left_drawer);
        String titles[] = { "Tasks", "Sites", "Profile", "About", "Logout" };

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

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);
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
        switch (position) {
            case 0:
                replaceFragment(TaskFragment.newInstance(0));
                break;
            case 1:
                replaceFragment(SiteListFragment.newInstance());
                break;
            case 2:
                replaceFragment(UserFragment.newInstance(mUser));
                break;
            case 3:
                replaceFragment(AboutFragment.newInstance());
                break;
            case 4:
                logoutCurrentUser(this);
                break;
            default:
                break;
        }
        mDrawerLayout.closeDrawer(mDrawerList);
    }

    public static void logoutCurrentUser(Activity activity) {
        SharedPreferences prefs = activity.getSharedPreferences(LandingPageActivity.PREFERENCES, 0);
        SharedPreferences.Editor editor = prefs.edit();
        editor.clear();
        editor.apply();
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
            public void onResponse(User home) { setUser(home); }
        });
        mNetworkManager.getRequestQueue().add(homeRequest);
    }


    // Setter
    public void setUser(User user) { mUser = user; }
    public User getUser() { return mUser; }
    public int getUserId() { return mUserId; }
    public void setFieldReportTask(Task task) { mFieldReportTask = task; }
    public Task getFieldReportTask() { return mFieldReportTask; }

    public ProgressBar getSpinner() { return mProgress; }
}
