package com.blueprint.watershed.Sites;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Sites.SiteListRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

public class SiteListFragment extends Fragment {

    private MainActivity mParentActivity;

    private ListView mSiteListView;
    private SiteListAdapter mAdapter;
    private NetworkManager mNetworkManager;


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
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_site_list, container, false);

        mSiteListView = (ListView) view.findViewById(android.R.id.list);

        mAdapter = new SiteListAdapter(mParentActivity, getActivity(), R.layout.site_list_row, getSites());
        mSiteListView.setAdapter(mAdapter);
        return view;
    }

    @Override
    public void onResume() {
        super.onResume();
        getSitesRequest();
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.empty, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    public void getSitesRequest() {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        SiteListRequest siteListRequest = new SiteListRequest(getActivity(), params, new Response.Listener<ArrayList<Site>>() {
            @Override
            public void onResponse(ArrayList<Site> sites) {
                setSites(sites);
                mAdapter.notifyDataSetChanged();
            }
        });

        mNetworkManager.getRequestQueue().add(siteListRequest);
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
