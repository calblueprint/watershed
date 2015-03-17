package com.blueprint.watershed.Activities;

import android.app.ActionBar;
import android.app.ActionBar.Tab;
import android.app.Activity;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.view.PagerTabStrip;
import android.support.v4.view.ViewPager;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;
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
import com.blueprint.watershed.Sites.SiteFragment;
import com.blueprint.watershed.Sites.SiteListFragment;
import com.blueprint.watershed.Tasks.Task;
import com.blueprint.watershed.Tasks.TaskFragment;
import com.blueprint.watershed.Users.User;
import com.blueprint.watershed.Users.UserFieldReportFragment;
import com.blueprint.watershed.Users.UserFragment;
import com.blueprint.watershed.Users.UserMiniSiteFragment;
import com.blueprint.watershed.Users.UserTaskFragment;
import com.blueprint.watershed.Utilities.TabsPagerAdapter;
import com.blueprint.watershed.Utilities.Utility;
import com.facebook.Session;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;

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
    private PagerTabStrip mPagerTabStrip;
    private ViewPager viewPager;
    private TabsPagerAdapter mAdapter;
    private View mContainer;
    private ProgressBar mProgress;
    private Toolbar mToolBar;

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

    // Params (so we don't have to set them later)
    private List<User> mUsers;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mUserId = getIntent().getExtras().getInt("userId");

        setNetworkManager(NetworkManager.getInstance(this));
        makeHomeRequest();

        initializeCache();
        initializeViews();
        initializeNavigationDrawer();

        setSupportActionBar(mToolBar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);

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
        setTitle("Tasks");
        mPagerTabStrip = (PagerTabStrip) findViewById(R.id.pager_title_strip);

        mProgress = (ProgressBar) findViewById(R.id.progressBar);
        mToolBar = (Toolbar) findViewById(R.id.toolbar);
        mAdapter = new TabsPagerAdapter(getSupportFragmentManager());
        viewPager = (ViewPager) findViewById(R.id.pager);
        mContainer = findViewById(R.id.container);
        viewPager.setAdapter(mAdapter);
    }

    public void updateTitle(Fragment f) {
        if (f instanceof TaskFragment) {
            setTitle("Tasks");
            displayTaskView(true);
            return;
        }
        else if (f instanceof UserTaskFragment){
            setTitle("Tasks");
        }
        else if (f instanceof SiteListFragment || f instanceof SiteFragment || f instanceof UserMiniSiteFragment) {
            setTitle("Sites");
        }
        else if (f instanceof AboutFragment) {
            setTitle("About");
        }
        else if (f instanceof UserFieldReportFragment){
            setTitle("Field Reports");
        }
        else if (f instanceof UserFragment) {
            setTitle("Profile");
        }
        displayTaskView(false);

    }

    public void displayTaskView(boolean toggle) {
        if (toggle){
            viewPager.setVisibility(View.VISIBLE);
            mContainer.setVisibility(View.INVISIBLE);
        }
        else {
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
            default:
                super.onOptionsItemSelected(item);

        }
        return mDrawerToggle.onOptionsItemSelected(item) || super.onOptionsItemSelected(item);
    }

    private void initializeNavigationDrawer() {
        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        mDrawerLayout.setStatusBarBackgroundColor(getResources().getColor(R.color.ws_blue));
        mDrawerList = (ListView) findViewById(R.id.left_drawer);
        String titles[] = { "Tasks", "Sites", "Profile", "About", "Logout" };

        mDrawerList.setOnItemClickListener(this);
        mDrawerList.setAdapter(new ArrayAdapter<>(this,
                R.layout.menu_list_item, R.id.menu_title, titles));

        mDrawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout,
                mToolBar, R.string.draw_open_close , R.string.draw_open_close) {

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


    /*
        Getter and setter zones;
     */
    public void setUser(User user) { mUser = user; }
    public User getUser() { return mUser; }
    public void setUsers(List<User> users) { mUsers = users; }
    public List<User> getUsers() { return mUsers; }
    public int getUserId() { return mUserId; }
    public void setFieldReportTask(Task task) { mFieldReportTask = task; }
    public Task getFieldReportTask() { return mFieldReportTask; }

    public ProgressBar getSpinner() { return mProgress; }

    public void setMenuAction(boolean setMenu) {
        if (setMenu) setMenu();
        else setBackArrow();
    }

    public void setBackArrow() {
        mToolBar.setNavigationIcon(getResources().getDrawable(R.drawable.abc_ic_ab_back_mtrl_am_alpha));
        mDrawerToggle.setToolbarNavigationClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getSupportFragmentManager().popBackStack();
                mDrawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED);
            }
        });

    }

    public void setMenu() {
        mDrawerLayout.setDrawerListener(mDrawerToggle);
        mDrawerToggle.syncState();
    }
}
