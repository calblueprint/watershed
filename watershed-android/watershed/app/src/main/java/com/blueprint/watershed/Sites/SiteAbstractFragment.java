package com.blueprint.watershed.Sites;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Sites.CreateSiteRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by charlesx on 4/7/15.
 * Fragment that is inherited by create and edit site fragments.
 */
public abstract class SiteAbstractFragment extends Fragment implements View.OnClickListener {

    protected NetworkManager mNetworkManager;
    protected MainActivity mMainActivity;
    protected EditText mTitleField;
    protected EditText mDescriptionField;
    protected EditText mCityField;
    protected EditText mAddressField;
    protected EditText mZipField;
    protected EditText mStateField;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
        mMainActivity = (MainActivity) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
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
        inflater.inflate(R.menu.empty, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    public void onClick(View view){
        switch (view.getId()){
            case (R.id.create_site_submit):
                startSiteRequest();
//                createSite();
        }
    }

    private void setButtonListeners(View view){
        Button submitButton = (Button)view.findViewById(R.id.create_site_submit);
        mTitleField = (EditText)view.findViewById(R.id.create_site_title);
        mDescriptionField = (EditText)view.findViewById(R.id.create_site_description);
        mAddressField = (EditText)view.findViewById(R.id.create_site_address);
        mCityField = (EditText)view.findViewById(R.id.create_site_city);
        mZipField = (EditText)view.findViewById(R.id.create_site_zip);
        mStateField = (EditText)view.findViewById(R.id.create_site_state);
        submitButton.setOnClickListener(this);
    }

    private void validateSiteRequest(Site site, String string) {
        boolean has_errors = false;
        if (site == null) site = new Site();

        if (mTitleField.getText().toString().length() == 0) {
            has_errors = true;
            mTitleField.setError("Title can't be blank!");
        } else {
            site.setName(mTitleField.getText().toString());
        }

        if (mDescriptionField.getText().toString().length() == 0){
            has_errors = true;
            mDescriptionField.setError("Description can't be blank!");
        } else {
            site.setDescription(mDescriptionField.getText().toString());
        }

        if (mAddressField.getText().toString().length() == 0){
            has_errors = true;
            mAddressField.setError("Address can't be blank!");
        } else {
            site.setStreet(mAddressField.getText().toString());
        }

        if (mCityField.getText().toString().length() == 0){
            has_errors = true;
            mCityField.setError("City can't be blank!");
        } else {
            site.setCity(mCityField.getText().toString());
        }

        if (mStateField.getText().toString().length() == 0) {
            has_errors = true;
            mStateField.setError("State can't be blank!");
        } else {
            site.setState(mStateField.getText().toString());
        }

        try {
            site.setZipCode(Integer.valueOf(mZipField.getText().toString()));
        } catch (Exception e){
            has_errors = true;
            mZipField.setError("Please enter a valid ZIP code");
        }

        site.setLatitude("0");
        site.setLongitude("0");
        site.setTasksCount(0);
        site.setMiniSitesCount(0);

        if (has_errors) return;

        if (string.equals("CREATE")) createSiteRequest(site);
        else editSiteRequest(site);

        SiteListFragment returnFragment = SiteListFragment.newInstance();
        mMainActivity.replaceFragment(returnFragment);
    }

    public void createSiteRequest(Site site) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        CreateSiteRequest createSiteRequest = new CreateSiteRequest(getActivity(), site, params, new Response.Listener<Site>() {
            @Override
            public void onResponse(Site site) {
                Log.e("successful site", "creation");
            }
        });

        mNetworkManager.getRequestQueue().add(createSiteRequest);
    }

    public void editSiteRequest(Site site) {

    }

    public abstract void startSiteRequest();
}
