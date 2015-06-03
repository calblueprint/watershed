package com.blueprint.watershed.Activities;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.FieldReports.FieldReportFragment;
import com.blueprint.watershed.MiniSites.MiniSiteAbstractFragment;
import com.blueprint.watershed.MiniSites.MiniSiteFragment;
import com.blueprint.watershed.Navigation.MenuRow;
import com.blueprint.watershed.Navigation.NavigationRowAdapter;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Users.HomeRequest;
import com.blueprint.watershed.Networking.Users.UpdateUserRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Sites.SiteFragment;
import com.blueprint.watershed.Sites.SiteList.SiteListAbstractFragment;
import com.blueprint.watershed.Sites.SiteViewPagerFragment;
import com.blueprint.watershed.Tasks.CreateTaskFragment;
import com.blueprint.watershed.Tasks.EditTaskFragment;
import com.blueprint.watershed.Tasks.Task;
import com.blueprint.watershed.Tasks.TaskDetailFragment;
import com.blueprint.watershed.Tasks.TaskList.UserTaskListFragment;
import com.blueprint.watershed.Tasks.TaskViewPagerFragment;
import com.blueprint.watershed.Users.AboutFragment;
import com.blueprint.watershed.Users.ManageViewPagerFragment;
import com.blueprint.watershed.Users.User;
import com.blueprint.watershed.Users.UserFieldReportFragment;
import com.blueprint.watershed.Users.UserFragment;
import com.blueprint.watershed.Users.UserMiniSiteFragment;
import com.blueprint.watershed.Users.UserTaskFragment;
import com.blueprint.watershed.Utilities.Utility;
import com.facebook.Session;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.google.android.gms.location.places.Places;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapsInitializer;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

public class MainActivity extends ActionBarActivity
                          implements View.OnClickListener,
                                     ListView.OnItemClickListener,
                                     OnMapReadyCallback {

    // Constants
    private static final String PREFERENCES = "LOGIN_PREFERENCES";
    private static final String TAG         = "MainActivity";
    private final String SENDER_ID          = "158271976435";

    // Authenticating against our own server
    public String mAuthToken;
    public String mAuthEmail;
    private String mRegistrationId;
    private int mAppVersion;

    // Navigation Drawer
    private DrawerLayout mDrawerLayout;
    private RelativeLayout mDrawer;
    private ListView mDrawerList;
    private ActionBarDrawerToggle mDrawerToggle;
    private NavigationRowAdapter mNavAdapter;

    // MenuItem
    private String mManagerTitles[] = { "Tasks", "Sites", "About", "Manage" };
    private String mMemberTitles[] = { "Tasks", "Sites", "About" };
    private int mManagerIcons[] = { R.drawable.tasks_dark, R.drawable.sites_dark, R.drawable.about_dark,
                             R.drawable.profile_dark };
    private int mMemberIcons[] = { R.drawable.tasks_dark, R.drawable.sites_dark, R.drawable.about_dark };
    private RelativeLayout mUserInfo;
    private TextView mUserName;

    // Action Bar Elements

    private View mContainer;
    private RelativeLayout mProgressContainer;
    private Toolbar mToolBar;

    // Networking
    private NetworkManager mNetworkManager;
    private SharedPreferences mPreferences;

    // User
    private User mUser;
    private Integer mUserId;

    // Temp Vars
    private Site mSite;
    private Site mMapSite;

    // Task for FieldReport
    private Task mFieldReportTask;

    // Google APIS
    private GoogleCloudMessaging mGoogleCloudMessaging;
    private GoogleApiClient mGoogleApiClient;

    // Params (so we don't have to set them later)
    private List<User> mUsers;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        setNetworkManager(NetworkManager.getInstance(this));

        mPreferences = getSharedPreferences(PREFERENCES, MODE_PRIVATE);
        mAuthToken = mPreferences.getString("auth_token", "none");
        mAuthEmail = mPreferences.getString("auth_email", "none");
        mRegistrationId = mPreferences.getString("registration_id", "none");
        mAppVersion = mPreferences.getInt("app_version", Integer.MIN_VALUE);
        mUserId = mPreferences.getInt("userId", 0);
        setUserObject();

        mGoogleApiClient = new GoogleApiClient
                .Builder(this)
                .addApi(Places.GEO_DATA_API)
                .addApi(Places.PLACE_DETECTION_API)
                .build();

        if (getRegistrationId().isEmpty())
            registerInBackground();
        MapsInitializer.initialize(this);

        initializeViews();
        initializeNavigationDrawer();

        setSupportActionBar(mToolBar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);

        initializeFragments();
    }

    @Override
    public void onStart() {
        super.onStart();
        mGoogleApiClient.connect();
    }

    @Override
    public void onResume() {
        super.onResume();
        updateToolbarElevation();
    }

    @Override
    public void onStop() {
        super.onStop();
        mGoogleApiClient.disconnect();
    }

    /**
     * Gets the current registration ID for application on GCM service.
     * If result is empty, the app needs to register.
     *
     * @return registration ID, or empty string if there is no existing
     *         registration ID.
     */
    private String getRegistrationId() {
        if (mRegistrationId.equals("none")) {
            Log.i(TAG, "Registration not found.");
            return "";
        }

        // Check if app was updated; if so, it must clear the registration ID
        // since the existing registration ID is not guaranteed to work with
        // the new app version.
        int currentVersion = Utility.getAppVersion(this);
        if (mAppVersion != currentVersion) {
            Log.i(TAG, "App version changed.");
            mPreferences.edit().putInt("app_version", currentVersion).apply();
            return "";
        }
        return mRegistrationId;
    }

    /**
     * Registers the application with GCM servers asynchronously.
     * <p>
     * Stores the registration ID and app versionCode in the application's
     * shared preferences.
     */
    private void registerInBackground() {
        new AsyncTask<String, String, String>() {
            @Override
            protected String doInBackground(String... params) {
                String msg = "";
                JSONObject user = new JSONObject();
                JSONObject objParams = new JSONObject();
                try {
                    if (mGoogleCloudMessaging == null) mGoogleCloudMessaging = GoogleCloudMessaging.getInstance(MainActivity.this);
                    objParams.put("registration_id", mGoogleCloudMessaging.register(SENDER_ID));
                    objParams.put("device_type", 0);
                    user.put("user", objParams);
                } catch (Exception ex) {
                    msg = "Error :" + ex.getMessage();
                }

                UpdateUserRequest request = new UpdateUserRequest(MainActivity.this, getUser(), user, new Response.Listener<User>() {
                    @Override
                    public void onResponse(User user) {
                        setUser(user);
                    }
                }, BaseRequest.makeUserResourceURL(getUserId(), "register"));
                mNetworkManager.getRequestQueue().add(request);

                return msg;
            }

            @Override
            protected void onPostExecute(String msg) { Log.i("ERROR", msg + "\n"); }
        }.execute(null, null, null);
    }

    @Override
    public void onMapReady(GoogleMap map) {
        if (getMapSite() == null) return;

        Site site = getMapSite();
        final float lat = site.getLatitude();
        final float lng = site.getLongitude();
        map.addMarker(new MarkerOptions().position(new LatLng(lat, lng)).title("Location"));
        map.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(lat, lng), 10f));
        map.setOnMapClickListener(new GoogleMap.OnMapClickListener() {
            @Override
            public void onMapClick(LatLng latLng) {
                Utility.showAndBuildDialog(
                        MainActivity.this, R.string.map_title, R.string.map_message, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                openMap(lat, lng);
                            }
                        }, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                            }
                        });
            }
        });
        map.getUiSettings().setScrollGesturesEnabled(false);
    }

    public void openMap(Float lat, Float lng) {
        String uri = String.format(Locale.ENGLISH, "geo:%f,%f?q=%f,%f", lat, lng, lat, lng);
        Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(uri));
        startActivity(intent);
    }

    private void setUserObject() {
        String userObject = mPreferences.getString("user", "none");
        if (!userObject.equals("none")) getUserFromPreferences(userObject);
        else makeHomeRequest();
    }

    private void getUserFromPreferences(String user) {
        try {
            JSONObject jsonObject = new JSONObject(user);
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
            setUser(objectMapper.readValue(jsonObject.toString(), User.class));
        } catch (Exception e) {
            Log.i("Exception", e.toString());
        }
    }

    public void makeHomeRequest(){
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        HomeRequest homeRequest = new HomeRequest(this, mUserId, params, new Response.Listener<User>() {
            @Override
            public void onResponse(User home) { setUser(home); }
        });
        mNetworkManager.getRequestQueue().add(homeRequest);
    }

    private void initializeViews() {
        mProgressContainer = (RelativeLayout) findViewById(R.id.progress_bar_container);
        mToolBar = (Toolbar) findViewById(R.id.toolbar);
        mContainer = findViewById(R.id.container);

        mUserName = (TextView) findViewById(R.id.nav_bar_user_name);
        mUserInfo = (RelativeLayout) findViewById(R.id.nav_bar_user_info);
        mUserInfo.setOnClickListener(this);

        setNavInfo();
    }

    @SuppressWarnings("deprecation")
    @TargetApi(21)
    public void setToolBarColor(int toolbar, int statusBar) {
        if (Utility.currentVersion() >= 21) getWindow().setStatusBarColor(statusBar);
        mToolBar.setBackgroundColor(toolbar);
        mToolBar.invalidate();
    }

    @SuppressWarnings("deprecation")
    @TargetApi(21)
    public void setToolBarDefault() {
        if (Utility.currentVersion() >= 21) getWindow().setStatusBarColor(getResources().getColor(R.color.ws_title_bar));
        mToolBar.setBackgroundColor(getResources().getColor(R.color.ws_blue));
        mToolBar.invalidate();
    }

    public void setNavInfo() {
        mUserName.setText(getUser().getName());
    }

    public void updateFragment(Fragment f) {
        if (f instanceof TaskViewPagerFragment ||
            f instanceof UserTaskFragment)                setTitle("Tasks");
        else if (f instanceof CreateTaskFragment)         setTitle("Add Task");
        else if (f instanceof EditTaskFragment)           setTitle("Edit Task");
        else if (f instanceof TaskDetailFragment)         setTitle("");
        else if (f instanceof SiteListAbstractFragment ||
                 f instanceof UserMiniSiteFragment ||
                 f instanceof SiteViewPagerFragment ||
                 f instanceof SiteFragment)               setTitle("Sites");
        else if (f instanceof AboutFragment)              setTitle("About");
        else if (f instanceof UserFieldReportFragment ||
                 f instanceof FieldReportFragment)        setTitle("Field Reports");
        else if (f instanceof UserFragment)               setTitle("Profile");
        else if (f instanceof MiniSiteAbstractFragment ||
                 f instanceof MiniSiteFragment)           setTitle("MiniSite");
        else if (f instanceof ManageViewPagerFragment)    setTitle("Manage");
    }

    public void replaceFragment(Fragment newFragment) {
        android.support.v4.app.FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        if(!newFragment.isAdded()){
            updateFragment(newFragment);

            setToolbarElevation(Utility.convertDptoPix(this, 4));
            ft.setCustomAnimations(R.anim.in, R.anim.out, R.anim.in, R.anim.out);
            ft.replace(R.id.container, newFragment)
              .addToBackStack(null)
              .commit();
        }
    }

    private void initializeFragments() {
        TaskViewPagerFragment taskFragment = TaskViewPagerFragment.newInstance();
        getSupportFragmentManager().addOnBackStackChangedListener(
                new FragmentManager.OnBackStackChangedListener() {
                    @Override
                    public void onBackStackChanged() {
                        Fragment f = getSupportFragmentManager().findFragmentById(R.id.container);
                        if (f != null) updateFragment(f);
                    }
                });
        updateFragment(taskFragment);
        android.support.v4.app.FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        ft.replace(R.id.container, taskFragment);
        ft.commit();
    }

    public void showProgress() {
        mProgressContainer.setVisibility(View.VISIBLE);
    }

    public void hideProgress() {
        mProgressContainer.setVisibility(View.GONE);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                Utility.hideKeyboard(this, mContainer);
                Fragment f = getSupportFragmentManager().findFragmentById(R.id.container);
                if (!(f instanceof UserTaskListFragment) && !(f instanceof SiteListAbstractFragment) &&!(f instanceof UserFragment) &&!(f instanceof AboutFragment)) {
                    getSupportFragmentManager().popBackStack();
                    return false;
                }
                break;
        }
        return mDrawerToggle.onOptionsItemSelected(item) || super.onOptionsItemSelected(item);
    }

    private void initializeNavigationDrawer() {
        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        mDrawerLayout.setStatusBarBackgroundColor(getResources().getColor(R.color.ws_blue));
        mDrawer = (RelativeLayout) findViewById(R.id.left_drawer);
        mDrawerList = (ListView) findViewById(R.id.left_drawer_list_view);

        List<MenuRow> menuItems = new ArrayList<>();
        String[] titles;
        int[] icons;
        if (getUser().isManager()) {
            titles = mManagerTitles;
            icons = mManagerIcons;
        } else {
            titles = mMemberTitles;
            icons = mMemberIcons;
        }
        for (int i = 0; i < titles.length; i ++)
            menuItems.add(new MenuRow(icons[i], titles[i], titles[i].equals("Tasks")));

        mNavAdapter = new NavigationRowAdapter(this, R.layout.menu_list_item, menuItems);
        mDrawerList.setOnItemClickListener(this);
        mDrawerList.setAdapter(mNavAdapter);

        setDrawerListener();
    }

    private void setDrawerListener() {
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
                replaceFragment(TaskViewPagerFragment.newInstance());
                mNavAdapter.setHighlighted("Tasks");
                break;
            case 1:
                replaceFragment(SiteViewPagerFragment.newInstance());
                mNavAdapter.setHighlighted("Sites");
                break;
            case 2:
                replaceFragment(AboutFragment.newInstance());
                mNavAdapter.setHighlighted("About");
                break;
            case 3:
                mNavAdapter.setHighlighted("Manage");
                replaceFragment(ManageViewPagerFragment.newInstance());
                break;
            default:
                logoutCurrentUser(this);
                break;
        }
        mDrawerList.setItemChecked(position, true);
        mDrawerList.setSelection(position);
        mDrawerLayout.invalidate();
        mDrawerLayout.closeDrawer(mDrawer);
    }

    public static void logoutCurrentUser(Activity activity) {
        SharedPreferences prefs = activity.getSharedPreferences(PREFERENCES, 0);
        SharedPreferences.Editor editor = prefs.edit();
        editor.clear();
        editor.apply();
        Intent intent = new Intent(activity, LandingPageActivity.class);

        if (Session.getActiveSession() != null)
            Session.getActiveSession().closeAndClearTokenInformation();

        activity.finish();
        activity.startActivity(intent);
    }

    @Override
    public void onClick(View view){
        switch (view.getId()) {
            case R.id.nav_bar_user_info:
                Fragment fragment = UserFragment.newInstance(getUser());
                replaceFragment(fragment);
                updateFragment(fragment);
                mDrawerLayout.closeDrawer(mDrawer);
                break;
        }
    }

    // Networking
    public NetworkManager getNetworkManager() { return mNetworkManager; }
    public void setNetworkManager(NetworkManager networkManager) { mNetworkManager = networkManager; }

    /*
        Getter and setter zones;
     */
    public void setUser(User user) {
        JSONObject userJson = null;
        ObjectMapper mapper = mNetworkManager.getObjectMapper();
        SharedPreferences.Editor editor = mPreferences.edit();

        try { userJson = new JSONObject(mapper.writeValueAsString(user)); }
        catch (Exception e) { Log.i("Exception", e.toString()); }

        editor.putString("email", user.getEmail());
        if (userJson != null) editor.putString("user", userJson.toString());
        editor.putString("registration_id", user.getRegistrationId());
        editor.putInt("app_version", Utility.getAppVersion(this));
        editor.apply();

        mUser = user;
        Log.e("User ID", String.valueOf(mUser.getId())); // TODO: DELETE THIS
    }

    public void setMenuAction(boolean setMenu) {
        if (setMenu) setMenu();
        else setBackArrow();
    }

    public void setBackArrow() {
        mToolBar.setNavigationIcon(getResources().getDrawable(R.drawable.abc_ic_ab_back_mtrl_am_alpha));
        mToolBar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mDrawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED);
                onBackPressed();
            }
        });
    }

    public void setMenu() {
        setDrawerListener();
        mDrawerToggle.syncState();
    }

    private void updateToolbarElevation() {
        setToolbarElevation(Utility.convertDptoPix(this, 4));
    }

    @SuppressWarnings("deprecation")
    @TargetApi(21)
    public void setToolbarElevation(float elevation) {
        if (Utility.currentVersion() >= 21) {
            mToolBar.setElevation(elevation);
            mToolBar.invalidate();
        }
    }

    @Override
    public void onBackPressed() {
        Fragment f = getSupportFragmentManager().findFragmentById(R.id.container);
        Utility.hideKeyboard(this, f.getView());
        if (mDrawerLayout.isDrawerOpen(mDrawer)) mDrawerLayout.closeDrawer(mDrawer);
        else super.onBackPressed();
    }

    public User getUser() { return mUser; }
    public void setUsers(List<User> users) { mUsers = users; }
    public List<User> getUsers() { return mUsers; }
    public int getUserId() { return mUserId; }
    public void setFieldReportTask(Task task) { mFieldReportTask = task; }
    public Task getFieldReportTask() { return mFieldReportTask; }
    public GoogleApiClient getGoogleApiClient() { return mGoogleApiClient; }
    public void setGoogleApiClient(GoogleApiClient client) { mGoogleApiClient = client; }

    /**
     * HELPERS FOR SITE FRAGMENT
     */

    public void setSite(Site site) { mSite = site; }
    public Site getSite() { return mSite; }
    public void setMapSite(Site site) { mMapSite = site; }
    public Site getMapSite() { return mMapSite; }
}
