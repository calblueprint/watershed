package com.blueprint.watershed.Sites;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.GoogleApis.Places.PlacePredictionAdapter;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Sites.CreateSiteRequest;
import com.blueprint.watershed.Networking.Sites.EditSiteRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.SiteList.SiteEnum;
import com.blueprint.watershed.Sites.SiteList.SiteEvent;
import com.blueprint.watershed.Utilities.Utility;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.location.places.AutocompletePrediction;
import com.google.android.gms.location.places.AutocompletePredictionBuffer;
import com.google.android.gms.location.places.Places;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by maxwolffe on 4/5/15.
 */
public abstract class SiteAbstractFragment extends Fragment {

    protected static final String EDIT = "edit";
    protected static final String CREATE = "create";
    protected static final String COMPLETE = "complete";

    private int SW_LAT = 37;
    private int SW_LNG = -123;
    private int NE_LAT = 38;
    private int NE_LNG = -122;

    protected NetworkManager mNetworkManager;
    protected MainActivity mParentActivity;
    protected EditText mTitleField;
    protected EditText mDescriptionField;
    protected AutoCompleteTextView mAddressField;
    protected RelativeLayout mLayout;

    // Params for maps
    private ArrayAdapter<AutocompletePrediction> mPlacesAdapter;
    private List<AutocompletePrediction> mPredictions;

    protected Site mSite;

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
        mPredictions = new ArrayList<>();
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

    protected void setButtonListeners(View view) {
        mLayout = (RelativeLayout) view.findViewById(R.id.create_site_layout);
        mTitleField = (EditText) view.findViewById(R.id.create_site_title);
        mDescriptionField = (EditText) view.findViewById(R.id.create_site_description);

        mPlacesAdapter = new PlacePredictionAdapter(mParentActivity, mPredictions);
        mAddressField = (AutoCompleteTextView) view.findViewById(R.id.create_site_address);
        mAddressField.setAdapter(mPlacesAdapter);
        mAddressField.setThreshold(3);
        mAddressField.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() > 2) getPredictions(s.toString());
            }

            @Override
            public void afterTextChanged(Editable s) {}
        });

        mAddressField.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                AutocompletePrediction prediction = mPlacesAdapter.getItem(position);
                mAddressField.setText(prediction.getDescription());
            }
        });
    }

    private void getPredictions(String string) {
        PendingResult result =
                Places.GeoDataApi.getAutocompletePredictions(mParentActivity.getGoogleApiClient(), string,
                        new LatLngBounds(new LatLng(SW_LAT, SW_LNG), new LatLng(NE_LAT, NE_LNG)), null);
        result.setResultCallback(new ResultCallback<AutocompletePredictionBuffer>() {
            @Override
            public void onResult(AutocompletePredictionBuffer buffer) {
                List<AutocompletePrediction> places = new ArrayList<AutocompletePrediction>();
                for (AutocompletePrediction prediction : buffer) {
                    AutocompletePrediction frozenPrediction = prediction.freeze();
                    places.add(frozenPrediction);
                }
                buffer.release();
                setPlaces(places);
            }
        });
    }

    private void setPlaces(List<AutocompletePrediction> places) {
        mPredictions.clear();
        mPredictions.addAll(places);
        mPlacesAdapter.notifyDataSetChanged();
    }

    /**
     *  Validates Site data, and calls the submit listener implemented by subclasses.
     * @return  an OnClickListener to validate Site data.
     */
    protected void validateAndSubmit() {
        Utility.hideKeyboard(mParentActivity, mLayout);
        List<String> errorStrings = new ArrayList<String>();
        if (mTitleField.getText().toString().length() == 0) {
            errorStrings.add("Title");
        }

        if (mDescriptionField.getText().toString().length() == 0) {
            errorStrings.add("Description");
        }

        if (mAddressField.getText().toString().length() == 0) {
            errorStrings.add("Address");
        }

        if (errorStrings.size() > 0) {
            Utility.setEmpty(mParentActivity, errorStrings);
        } else {
            submitListener();
        }
    }

    /**
     * Creates and sends a request for either editing or creating a new site.
     * sets default values for Lat, Long, TaskCount, and MiniSiteCount.
     * @param type CREATE or EDIT.
     * @param new_site The site to be editted, or null.
     */
    protected void createSite(String type, Site new_site) {
        if (type.equals(CREATE)) {
            new_site = new Site();
            new_site.setLatitude(0f);
            new_site.setLongitude(0f);
            new_site.setTasksCount(0);
            new_site.setMiniSitesCount(0);
        }

        new_site.setName(mTitleField.getText().toString());
        new_site.setDescription(mDescriptionField.getText().toString());
        new_site.setStreet(mAddressField.getText().toString());
        LatLng latLng = Utility.getLatLng(mParentActivity, mAddressField.getText().toString());
        if (latLng != null) {
            new_site.setLatitude((float) latLng.latitude);
            new_site.setLongitude((float) latLng.longitude);
        }

        createSiteRequest(type, new_site);
    }

    public void createSiteRequest(String type, Site site){
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        if (type.equals(CREATE)) {
            CreateSiteRequest createSiteRequest = new CreateSiteRequest(mParentActivity, site, params, new Response.Listener<Site>() {
                @Override
                public void onResponse(Site site) {
                    mSite = site;
                    Toast.makeText(mParentActivity, R.string.create_site, Toast.LENGTH_SHORT).show();
                    mParentActivity.post(new SiteEvent(site, SiteEnum.SITE_CREATED));
                    mParentActivity.getSupportFragmentManager().popBackStack();
                    mParentActivity.replaceFragment(SiteFragment.newInstance(site));
                }
            });
            mParentActivity.addRequest(createSiteRequest);
        }
        else {
            EditSiteRequest editSiteRequest = new EditSiteRequest(mParentActivity, site, params, new Response.Listener<Site>() {
                @Override
                public void onResponse(Site site) {
                    mSite = site;
                    Toast.makeText(mParentActivity, R.string.edit_site, Toast.LENGTH_SHORT).show();
                    mParentActivity.post(new SiteEvent(site, SiteEnum.SITE_EDITED));
                    mParentActivity.getSupportFragmentManager().popBackStack();

                }
            });
            mParentActivity.addRequest(editSiteRequest);
        }
    }

    public abstract void submitListener();
}
