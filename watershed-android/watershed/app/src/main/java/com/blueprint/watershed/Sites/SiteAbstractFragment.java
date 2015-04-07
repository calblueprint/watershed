package com.blueprint.watershed.Sites;

import android.app.Activity;
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
import com.blueprint.watershed.Networking.Sites.EditSiteRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by maxwolffe on 4/5/15.
 */
public abstract class SiteAbstractFragment extends Fragment{

    protected static final String EDIT = "edit";
    protected static final String CREATE = "create";
    protected static final String COMPLETE = "complete";

    protected NetworkManager mNetworkManager;
    protected MainActivity mMainActivity;
    protected EditText mTitleField;
    protected EditText mDescriptionField;
    protected EditText mCityField;
    protected EditText mAddressField;
    protected EditText mZipField;
    protected EditText mStateField;
    protected Button mSubmitButton;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment CreateSiteFragment.
     */


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

    protected void setButtonListeners(View view){
        mSubmitButton = (Button)view.findViewById(R.id.create_site_submit);
        mTitleField = (EditText)view.findViewById(R.id.create_site_title);
        mDescriptionField = (EditText)view.findViewById(R.id.create_site_description);
        mAddressField = (EditText)view.findViewById(R.id.create_site_address);
        mCityField = (EditText)view.findViewById(R.id.create_site_city);
        mZipField = (EditText)view.findViewById(R.id.create_site_zip);
        mStateField = (EditText)view.findViewById(R.id.create_site_state);
        mSubmitButton.setOnClickListener(validateAndSubmit());
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }

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

                if (has_errors) {
                    return;
                }

                submitListener();

                SiteListFragment returnFragment = SiteListFragment.newInstance();
                mMainActivity.replaceFragment(returnFragment);
            }
        };
    }

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

    private void setEmpty(String field, EditText editText) { editText.setError(field + " can't be blank!"); }

    public void createSiteRequest(String type, Site site){
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        if (type.equals(CREATE)) {
            CreateSiteRequest createSiteRequest = new CreateSiteRequest(mMainActivity, site, params, new Response.Listener<Site>() {
                @Override
                public void onResponse(Site site) {
                    Log.e("successful site", "creation");
                }
            });
            mNetworkManager.getRequestQueue().add(createSiteRequest);
            SiteListFragment returnFragment = SiteListFragment.newInstance();
            mMainActivity.replaceFragment(returnFragment);
        }
        else {
            EditSiteRequest editSiteRequest = new EditSiteRequest(mMainActivity, site, params, new Response.Listener<Site>() {
                @Override
                public void onResponse(Site site) {
                    Log.e("successful site", "edit");
                }
            });
            mNetworkManager.getRequestQueue().add(editSiteRequest);
            mMainActivity.getSupportFragmentManager().popBackStack();
        }
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

    public abstract void submitListener();

}
