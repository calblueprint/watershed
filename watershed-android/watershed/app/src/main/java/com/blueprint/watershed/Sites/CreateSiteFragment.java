package com.blueprint.watershed.Sites;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.android.volley.Network;
import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Tasks.CreateTaskRequest;
import com.blueprint.watershed.R;
import android.support.v4.app.Fragment;
import android.widget.Button;
import android.widget.EditText;

import com.blueprint.watershed.Networking.Sites.CreateSiteRequest;
import com.blueprint.watershed.Tasks.Task;

import org.json.JSONObject;

import java.util.HashMap;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * to handle interaction events.
 * Use the {@link CreateSiteFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class CreateSiteFragment extends Fragment implements View.OnClickListener{


    private NetworkManager mNetworkManager;
    private MainActivity mMainActivity;
    private EditText mTitleField;
    private EditText mDescriptionField;
    private EditText mCityField;
    private EditText mAddressField;
    private EditText mZipField;
    private EditText mStateField;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment CreateSiteFragment.
     */
    public static CreateSiteFragment newInstance() {
        CreateSiteFragment fragment = new CreateSiteFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }

    public CreateSiteFragment() {
        // Required empty public constructor
    }

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

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }

    public void onClick(View view){
        switch (view.getId()){
            case (R.id.create_site_submit):
                createSite();
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

    public void createSiteRequest(Site site){
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        CreateSiteRequest createSiteRequest = new CreateSiteRequest(getActivity(), site, params, new Response.Listener<Site>() {
            @Override
            public void onResponse(Site site) {
                Log.e("successful site", "creation");
            }
        });

        mNetworkManager.getRequestQueue().add(createSiteRequest);
    }

    private void createSite(){
        Site new_site = new Site();
        new_site.setName(mTitleField.getText().toString());
        new_site.setStreet(mAddressField.getText().toString());
        new_site.setCity(mCityField.getText().toString());
        new_site.setZipCode(Integer.valueOf(mZipField.getText().toString()));
        new_site.setLatitude("0");
        new_site.setLongitude("0");
        new_site.setTasksCount(0);
        new_site.setMiniSitesCount(0);

        createSiteRequest(new_site);

        SiteListFragment returnFragment = SiteListFragment.newInstance();
        mMainActivity.replaceFragment(returnFragment);



    }
}
