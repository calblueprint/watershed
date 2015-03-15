package com.blueprint.watershed.Sites;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.MiniSites.MiniSiteFragment;
import com.blueprint.watershed.MiniSites.MiniSiteListAdapter;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Sites.SiteRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Views.CoverPhotoPagerView;
import com.blueprint.watershed.Views.HeaderGridView;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;


public class SiteFragment extends Fragment
                          implements AbsListView.OnItemClickListener {

    private NetworkManager mNetworkManager;
    private MainActivity mParentActivity;
    private HeaderGridView mMiniSiteGridView;
    private MiniSiteListAdapter mMiniSiteAdapter;
    private Site mSite;
    private ArrayList<MiniSite> mMiniSites;


    public static SiteFragment newInstance(Site site) {
        SiteFragment siteFragment = new SiteFragment();
        siteFragment.configureWithSite(site);
        return siteFragment;
    }

    public SiteFragment() {}

    public void configureWithSite(Site site) { mSite = site; }

    public void configureViewWithSite(View view, Site site) {
        ((CoverPhotoPagerView) view.findViewById(R.id.cover_photo_pager_view)).configureWithPhotos(site.getPhotos());
        ((TextView) view.findViewById(R.id.site_name)).setText(site.getName());
        ((TextView) view.findViewById(R.id.site_description)).setText(site.getDescription());
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        // Add site header information to the top
        return inflater.inflate(R.layout.fragment_site, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initializeViews();
    }

    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setMenuAction(false);
        getSiteRequest(mSite);
    }

    private void initializeViews() {
        // Create MiniSite grid
        mMiniSiteGridView = (HeaderGridView) mParentActivity.findViewById(R.id.mini_sites_grid);
        ViewGroup header = (ViewGroup) mParentActivity.getLayoutInflater().inflate(R.layout.site_header_view, mMiniSiteGridView, false);
        mMiniSiteGridView.addHeaderView(header, null, false);
        configureViewWithSite(header, mSite);

        // Set the adapter to fill the list of mini sites
        mMiniSiteAdapter = new MiniSiteListAdapter(mParentActivity, getActivity(), R.layout.mini_site_list_row, getMiniSites());
        mMiniSiteGridView.setAdapter(mMiniSiteAdapter);
        mMiniSiteGridView.setOnItemClickListener(this);
    }


    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        MiniSite miniSite = getMiniSite(position);
        MiniSiteFragment miniSiteFragment = new MiniSiteFragment();
        miniSiteFragment.configureWithMiniSite(miniSite);
        mParentActivity.replaceFragment(miniSiteFragment);
    }


    // Networking
    private void getSiteRequest(Site site) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        SiteRequest siteRequest = new SiteRequest(getActivity(), site, params, new Response.Listener<Site>() {
            @Override
            public void onResponse(Site site) {
                setSite(site);
                mParentActivity.getSpinner().setVisibility(View.GONE);
                mMiniSiteAdapter.notifyDataSetChanged();
            }
        });

        mNetworkManager.getRequestQueue().add(siteRequest);
    }

    private void setSite(Site site) {
        mSite = site;
        setMiniSites(site.getMiniSites());
    }

    private MiniSite getMiniSite(int position) { return mMiniSites.get(position); }

    private ArrayList<MiniSite> getMiniSites() {
        if (mMiniSites == null) {
            mMiniSites = new ArrayList<MiniSite>();
        }
        return mMiniSites;
    }

    private void setMiniSites(ArrayList<MiniSite> miniSites) {
        mMiniSites.clear();
        for (MiniSite miniSite : miniSites) {
            mMiniSites.add(miniSite);
        }
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.empty, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }
}