package com.blueprint.watershed.Sites;

import android.os.Bundle;
import android.os.CountDownTimer;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Sites.SiteListRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

public class SiteListFragment extends Fragment {

    public static final String SITE_LIST_REQUEST = "SiteListTag";

    private MainActivity mParentActivity;
    private NetworkManager mNetworkManager;
    private LinearLayoutManager mLayoutManager;
    
    // Views
    private RecyclerView mSiteListView;
    private SwipeRefreshLayout mSwipeLayout;
    private RelativeLayout mNoSiteLayout;
    
    private SiteListAdapter mAdapter;
    private SiteMapper mSites;

    public static SiteListFragment newInstance() { return new SiteListFragment(); }


    public SiteListFragment() { mSites = new SiteMapper(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_site_list, container, false);
        initializeViews(view);
        getSitesRequest();
        return view;
    }
    
    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
    }
    
    private void initializeViews(View view) {
        mNoSiteLayout = (RelativeLayout) view.findViewById(R.id.no_site_layout);
        mLayoutManager = new LinearLayoutManager(mParentActivity);
        mSiteListView = (RecyclerView) view.findViewById(R.id.list);
        mSiteListView.setLayoutManager(mLayoutManager);
        if (getSites().size() == 0) hideList();
        mAdapter = new SiteListAdapter(mParentActivity, R.layout.site_list_row, getSites());
        mSiteListView.setAdapter(mAdapter);

        mSwipeLayout = (SwipeRefreshLayout) view.findViewById(R.id.site_swipe_container);
        mSwipeLayout.setColorSchemeResources(R.color.ws_blue, R.color.facebook_blue, R.color.facebook_dark_blue, R.color.dark_gray);
        mSwipeLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                mSwipeLayout.setRefreshing(true);
                getSitesRequest();
            }
        });
    }

    @Override
    public void onResume() {
        super.onResume();
        mSwipeLayout.setRefreshing(true);
        getSitesRequest();
    }

    @Override
    public void onPause(){
        super.onPause();
        RequestQueue requestQueue = mNetworkManager.getRequestQueue();
        if (requestQueue != null) {
            requestQueue.cancelAll(SITE_LIST_REQUEST);
        }

    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.site_list_menu, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    public void getSitesRequest() {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        SiteListRequest siteListRequest = new SiteListRequest(getActivity(), params, new Response.Listener<ArrayList<Site>>() {
            @Override
            public void onResponse(ArrayList<Site> sites) {
                setSites(sites);
                Log.e("Site Response", "Returned");
                if (getSites().size() == 0) hideList();
                else {
                    showList();
                    mAdapter.notifyDataSetChanged();
                }
                new CountDownTimer(1000, 1000) {
                    @Override
                    public void onTick(long timeLeft) {}
                    @Override
                    public void onFinish() { mSwipeLayout.setRefreshing(false); }
                }.start();
            }

        });
        siteListRequest.setTag(SITE_LIST_REQUEST);
        mNetworkManager.getRequestQueue().add(siteListRequest);
    }

    // Getters
    public SiteMapper getSites() { return mSites; }

    // Setters
    public void setSites(ArrayList<Site> sites) {
        if (sites.size() != mSites.size()) {
            mSites.setSites(sites);
            mAdapter.notifyDataSetChanged();
        } else {
            for (int i = 0; i < sites.size(); i++) {
                Site site = sites.get(i);
                if (!site.equals(mSites.getSiteWithPosition(i))) {
                    mSites.addSite(site, i);
                    mAdapter.notifyItemChanged(i);
                }
            }
        }
    }

    private void showList() {
        mNoSiteLayout.setVisibility(View.GONE);
        mSiteListView.setVisibility(View.VISIBLE);
    }

    private void hideList() {
        mNoSiteLayout.setVisibility(View.VISIBLE);
        mSiteListView.setVisibility(View.GONE);
    }
}
