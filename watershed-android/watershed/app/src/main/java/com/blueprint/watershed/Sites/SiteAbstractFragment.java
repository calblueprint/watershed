package com.blueprint.watershed.Sites;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Sites.CreateSiteRequest;
import com.blueprint.watershed.Networking.Sites.EditSiteRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by maxwolffe on 4/5/15.
 */
public abstract class  SiteAbstractFragment extends Fragment{

    protected static final String EDIT = "edit";
    protected static final String CREATE = "create";
    protected static final String COMPLETE = "complete";

    protected NetworkManager mNetworkManager;
    protected MainActivity mParentActivity;
    protected EditText mTitleField;
    protected EditText mDescriptionField;
    protected EditText mCityField;
    protected EditText mAddressField;
    protected EditText mZipField;
    protected EditText mStateField;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of either Create or Edit SiteFragment.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_create_site, container, false);
        setButtonListeners(view);
        return view;
    }

    /**
     * Inflates a menu into the action bar.
     * Called by Activity if setHasOptionsMenu(true) set in OnCreate
     * @param menu - options menu
     * @param inflater - view inflater.
     */
    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.save_menu, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.save:
                validateAndSubmit();
            default:
                return super.onOptionsItemSelected(item);
        }
    }
    
    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setMenuAction(false);
    }

    protected void setButtonListeners(View view){
        mTitleField = (EditText)view.findViewById(R.id.create_site_title);
        mDescriptionField = (EditText)view.findViewById(R.id.create_site_description);
        mAddressField = (EditText)view.findViewById(R.id.create_site_address);
        mCityField = (EditText)view.findViewById(R.id.create_site_city);
        mZipField = (EditText)view.findViewById(R.id.create_site_zip);
        mStateField = (EditText)view.findViewById(R.id.create_site_state);
    }

    /**
     *  Validates Site data, and calls the submit listener implemented by subclasses.
     * @return  an OnClickListener to validate Site data.
     */
    protected View.OnClickListener validateAndSubmit(){
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                boolean has_errors = false;

                if (mTitleField.getText().toString().length() == 0) {
                    has_errors = true;
                    setEmpty("Title", mTitleField);
                }

                if (mDescriptionField.getText().toString().length() == 0) {
                    has_errors = true;
                    setEmpty("Description", mDescriptionField);
                }

                if (mAddressField.getText().toString().length() == 0) {
                    has_errors = true;
                    setEmpty("Address", mAddressField);
                }

                if (mCityField.getText().toString().length() == 0) {
                    has_errors = true;
                    setEmpty("City", mCityField);
                }

                if (mStateField.getText().toString().length() == 0) {
                    has_errors = true;
                    setEmpty("State", mStateField);
                }

                try {
                    Integer.valueOf(mZipField.getText().toString());
                } catch (Exception e) {
                    has_errors = true;
                    mZipField.setError("Please enter a valid ZIP code");
                }

                if (has_errors) return; 

                submitListener();

                SiteListFragment returnFragment = SiteListFragment.newInstance();
                mParentActivity.replaceFragment(returnFragment);
            }
        };
    }

    /**
     * Creates and sends a request for either editing or creating a new site.
     * sets default values for Lat, Long, TaskCount, and MiniSiteCount.
     * @param type CREATE or EDIT.
     * @param new_site The site to be editted, or null.
     */
    protected void createSite(String type, Site new_site) {
        if (type.equals(CREATE)){
            new_site = new Site();
            new_site.setLatitude("0");
            new_site.setLongitude("0");
            new_site.setTasksCount(0);
            new_site.setMiniSitesCount(0);
        }

        new_site.setName(mTitleField.getText().toString());
        new_site.setDescription(mDescriptionField.getText().toString());
        new_site.setStreet(mAddressField.getText().toString());
        new_site.setCity(mCityField.getText().toString());
        new_site.setState(mStateField.getText().toString());
        new_site.setZipCode(Integer.valueOf(mZipField.getText().toString()));

        createSiteRequest(type, new_site);
    }

    /**
     * Sets Empty Error messages.
     * @param field The field name (eg. City, Street...)
     * @param editText some EditText
     */
    private void setEmpty(String field, EditText editText) { editText.setError(field + " can't be blank!"); }

    public void createSiteRequest(String type, Site site){
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        if (type.equals(CREATE)) {
            CreateSiteRequest createSiteRequest = new CreateSiteRequest(mParentActivity, site, params, new Response.Listener<Site>() {
                @Override
                public void onResponse(Site site) {
                    Log.e("successful site", "creation");
                }
            });
            mNetworkManager.getRequestQueue().add(createSiteRequest);
        }
        else {
            EditSiteRequest editSiteRequest = new EditSiteRequest(mParentActivity, site, params, new Response.Listener<Site>() {
                @Override
                public void onResponse(Site site) {
                    Log.e("successful site", "edit");
                }
            });
            mNetworkManager.getRequestQueue().add(editSiteRequest);
        }
        mParentActivity.getSupportFragmentManager().popBackStack();

    }

    public abstract void submitListener();
}
