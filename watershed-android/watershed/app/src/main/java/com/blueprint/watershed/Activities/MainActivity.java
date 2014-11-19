package com.blueprint.watershed.Activities;

import android.app.ActionBar;
import android.app.FragmentTransaction;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v7.app.ActionBarActivity;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.MenuItem;
import android.content.SharedPreferences;
import android.graphics.Typeface;

import com.blueprint.watershed.FieldReports.FieldReportFragment;
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
import android.widget.ImageView;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

public class MainActivity extends ActionBarActivity
                          implements ActionBar.TabListener,
                                     View.OnClickListener,
                                     TaskFragment.OnFragmentInteractionListener,
                                     TaskDetailFragment.OnFragmentInteractionListener,
                                     SiteListFragment.OnFragmentInteractionListener,
                                     SiteFragment.OnFragmentInteractionListener,
                                     MiniSiteFragment.OnFragmentInteractionListener,
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
    public Fragment currentFragment;
    private TaskFragment mtaskFragment;
    private SiteListFragment siteListFragment;
    private FragmentManager fragmentManager;

    // Navigation Drawer
    private ResideMenu resideMenu;
    private ArrayList<ResideMenuItem> menuItems;

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

    // Camera Stuff
    private static final int CAMERA_REQUEST = 1888;

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
        ft.commit();
    }

    public void onFragmentInteraction(String id){
        // Deals with fragment interactions
    }

    public void onFragmentInteraction(Uri uri){
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
                resideMenu.openMenu(ResideMenu.DIRECTION_LEFT);
        }
        return super.onOptionsItemSelected(item);
    }

    private void initializeNavigationDrawer() {
        resideMenu = new ResideMenu(this);
        resideMenu.attachToActivity(this);
        resideMenu.setShadowVisible(false);
        resideMenu.setDirectionDisable(ResideMenu.DIRECTION_RIGHT);
        resideMenu.setDirectionDisable(ResideMenu.DIRECTION_LEFT);
        resideMenu.setBackground(R.drawable.golden_gate_bridge);
        String titles[] = { "Tasks", "Sites", "Activity Log", "Profile", "About", "Logout" };
        int icon[] = { R.drawable.watershed_logo, R.drawable.watershed_logo, R.drawable.watershed_logo, R.drawable.watershed_logo, R.drawable.watershed_logo, R.drawable.watershed_logo };
        menuItems = new ArrayList<ResideMenuItem>();
        for (int i = 0; i < titles.length; i++) {
            ResideMenuItem item = new ResideMenuItem(this, icon[i], titles[i]);
            item.setOnClickListener(this);
            resideMenu.addMenuItem(item, ResideMenu.DIRECTION_LEFT);
            menuItems.add(item);
        }
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
        resideMenu.closeMenu();
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


    // Button Events

    public void FieldReportButtonPressed(View view){
        FieldReportFragment fieldFragment = FieldReportFragment.newInstance();
        replaceFragment(fieldFragment);
    }

    public void HandleTakePhotoButton(View view){
         Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
         if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
             File photoFile = null;
             try {
                 photoFile = createImageFile();
             } catch (IOException ex) {
                Log.e("Field Report Photo", "Error");
             }
             if (photoFile != null) {
                 //takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT,
                         //Uri.fromFile(photoFile));
                 startActivityForResult(takePictureIntent, 1888);
             }
        }
    }


    // Image Handling

    String mCurrentPhotoPath;

    private File createImageFile() throws IOException {
        // Create an image file name
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String imageFileName = "JPEG_" + timeStamp + "_";
        File storageDir = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_PICTURES);
        File image = File.createTempFile(
                imageFileName,  /* prefix */
                ".jpg",         /* suffix */
                storageDir      /* directory */
        );

        // Save a file: path for use with ACTION_VIEW intents
        mCurrentPhotoPath = "file:" + image.getAbsolutePath();
        return image;
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        ImageView fieldReportImageView = (ImageView)findViewById(R.id.field_report_image);
        if (requestCode == CAMERA_REQUEST && resultCode == RESULT_OK) {
            Log.e("Great Success!", "BLUEPRINT");
            Bitmap photo = (Bitmap) data.getExtras().get("data");
            fieldReportImageView.setImageBitmap(photo);
        }
    }
}
