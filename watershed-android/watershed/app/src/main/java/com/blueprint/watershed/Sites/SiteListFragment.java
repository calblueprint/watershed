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
    private NetworkManager mNetworkManager;
    private LinearLayoutManager mLayoutManager;
    
    // Views
    private RecyclerView mSiteListView;
    private SwipeRefreshLayout mSwipeLayout;
    
    private SiteListAdapter mAdapter;
    private ArrayList<Site> mSites;

    public static SiteListFragment newInstance() { return new SiteListFragment(); }


    public SiteListFragment() { mSites = new ArrayList<Site>(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        Log.i("asdf", "ONCREATE");
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_site_list, container, false);
        initializeViews(view);
        mSwipeLayout.setRefreshing(true);
        getSitesRequest();
        return view;
    }
    
    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
    }
    
    private void initializeViews(View view) {
        mLayoutManager = new LinearLayoutManager(mParentActivity);
        mSiteListView = (RecyclerView) view.findViewById(R.id.list);
        mSiteListView.setLayoutManager(mLayoutManager);
//        mSiteListView.setEmptyView(mParentActivity.findViewById(R.id.site_layout));
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
                if (getSites().size() == 0) hideList();
                else mAdapter.notifyDataSetChanged();
                new CountDownTimer(1000, 1000) {
                    @Override
                    public void onTick(long timeLeft) {}
                    @Override
                    public void onFinish() { mSwipeLayout.setRefreshing(false); }
                }.start();
            }

        });
        mNetworkManager.getRequestQueue().add(siteListRequest);
    }

    // Getters
    public ArrayList<Site> getSites() { return mSites; }

    // Setters
    public void setSites(ArrayList<Site> sites) {
        mSites.clear();
        for (Site site : sites) {
            mSites.add(site);
        }
    }

    private void hideList() {

    }
}
