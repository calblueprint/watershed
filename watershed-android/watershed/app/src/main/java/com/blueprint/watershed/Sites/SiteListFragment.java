package com.blueprint.watershed.Sites;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.LandingPageActivity;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Sites.SiteListRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

public class SiteListFragment extends Fragment implements AbsListView.OnItemClickListener {

    private OnFragmentInteractionListener mListener;

    private ListView mSiteListView;
    private SiteListAdapter mAdapter;
    private SharedPreferences preferences;
    private NetworkManager mNetworkManager;
    private MainActivity mMainActivity;
    private ArrayList<Site> mSites;


    public static SiteListFragment newInstance() {
        return new SiteListFragment();
    }

    public SiteListFragment() {
        mSites = new ArrayList<Site>();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        preferences = getActivity().getSharedPreferences(LandingPageActivity.PREFERENCES, 0);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_site_list, container, false);

        mSiteListView = (ListView) view.findViewById(android.R.id.list);

        mAdapter = new SiteListAdapter(getActivity(), R.layout.site_list_row, getSites());
        mSiteListView.setAdapter(mAdapter);

        mSiteListView.setOnItemClickListener(this);
        return view;
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
            mMainActivity = (MainActivity)activity;
            mListener = (OnFragmentInteractionListener) activity;
        } catch (ClassCastException e) {
            throw new ClassCastException(activity.toString()
                + " must implement OnFragmentInteractionListener");
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        getSitesRequest();
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        Log.e("item clicked", "yeS");
        if (null != mListener) {
            // Load site
            Site site = getSite(position);
            SiteFragment siteFragment = new SiteFragment();
            siteFragment.configureWithSite(site);

            mMainActivity.replaceFragment(siteFragment);
        }
    }

    public void getSitesRequest() {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        SiteListRequest siteListRequest = new SiteListRequest(getActivity(), params, new Response.Listener<ArrayList<Site>>() {
            @Override
            public void onResponse(ArrayList<Site> sites) {
                setSites(sites);
                mMainActivity.getSpinner().setVisibility(View.GONE);
                mAdapter.notifyDataSetChanged();
            }
        });

        mNetworkManager.getRequestQueue().add(siteListRequest);
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(String id);
    }

    // Getters
    public ArrayList<Site> getSites() { return mSites; }
    public Site getSite(int position) { return mSites.get(position); }

    // Setters
    public void setSites(ArrayList<Site> sites) {
        mSites.clear();
        for (Site site : sites) {
            mSites.add(site);
        }
    }
}
