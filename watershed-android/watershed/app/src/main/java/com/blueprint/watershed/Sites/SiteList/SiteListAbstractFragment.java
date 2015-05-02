package com.blueprint.watershed.Sites.SiteList;

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

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Sites.SiteListRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.CreateSiteFragment;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Views.Material.FloatingActionButton;

import java.util.ArrayList;
import java.util.List;

public abstract class SiteListAbstractFragment extends Fragment {

    public static final String SITE_LIST_REQUEST = "SiteListTag";

    protected MainActivity mParentActivity;
    protected NetworkManager mNetworkManager;
    protected LinearLayoutManager mLayoutManager;
    
    // Views
    protected RecyclerView mSiteListView;
    protected SwipeRefreshLayout mSwipeLayout;
    protected SwipeRefreshLayout mNoSiteLayout;
    protected FloatingActionButton mCreateSiteButton;
    
    protected SiteListAdapter mAdapter;
    protected List<Site> mSites;

    protected boolean mInitializeSites = false;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
        mSites = new ArrayList<Site>();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_site_list, container, false);
        initializeViews(view);
        return view;
    }

    /**
     * Initializes all the views in the layout
     * @param view Root view of the fragment
     */
    protected void initializeViews(View view) {
        mNoSiteLayout = (SwipeRefreshLayout) view.findViewById(R.id.no_site_layout);
        mNoSiteLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                mNoSiteLayout.setRefreshing(true);
                getSitesRequest();
            }
        });

        mLayoutManager = new LinearLayoutManager(mParentActivity);
        mSiteListView = (RecyclerView) view.findViewById(R.id.list);
        mSiteListView.setLayoutManager(mLayoutManager);

        mSwipeLayout = (SwipeRefreshLayout) view.findViewById(R.id.site_swipe_container);
        mSwipeLayout.setColorSchemeResources(R.color.ws_blue, R.color.facebook_blue, R.color.facebook_dark_blue, R.color.dark_gray);
        mSwipeLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                mSwipeLayout.setRefreshing(true);
                getSitesRequest();
            }
        });

        mAdapter = new SiteListAdapter(mParentActivity, R.layout.site_list_row, mSites);
        mSiteListView.setAdapter(mAdapter);

        if (!mInitializeSites) {
            mNoSiteLayout.setRefreshing(true);
            getSitesRequest();
        }

        mCreateSiteButton = (FloatingActionButton) view.findViewById(R.id.create_site_button);
        mCreateSiteButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mParentActivity.replaceFragment(CreateSiteFragment.newInstance());
            }
        });

        // Make sure we update the list if we delete a site
        Site deletedSite = mParentActivity.getSite();
        if (deletedSite != null) {
            int position = getDeletedSite(deletedSite);
            mSites.remove(position);
            mAdapter.notifyItemRemoved(position);
//            mAdapter.notifyDataSetChanged();
            mParentActivity.setSite(null);
        }
    }

    /**
     * Updates the list when we delete a site
     * @param site Site that was deleted
     * @return Position of that site
     */
    protected int getDeletedSite(Site site) {
        for (int i = 0; i < mSites.size(); i++) {
            if (mSites.get(i).getId() == site.getId()) return i;
        }
        return -1;
    }

    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setMenuAction(true);
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
        inflater.inflate(R.menu.empty, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    /**
     * Request to get all the sites, updates and shows them according,
     * or displays a text view telling the user that there are no sites.
     */
    public abstract void getSitesRequest();

    /**
     * Fake a minimum animation time for the spinner to "load"
     */
    public void setSwipeFalse() {
        new CountDownTimer(1000, 1000) {
            public void onTick(long millisUntilFinished) {}
            public void onFinish() {
                if (mSwipeLayout != null) mSwipeLayout.setRefreshing(false);
                if (mNoSiteLayout != null) mNoSiteLayout.setRefreshing(false);
            }
        }.start();
    }

    /**
     * Set the sites given.
     * @param sites ArrayList of sites
     */
    public void setSites(ArrayList<Site> sites) {
        mSites.clear();
        mSites.addAll(sites);
    }

    /**
     * Shows the list of sites, hides the empty textview
     */
    protected void showList() {
        mNoSiteLayout.setVisibility(View.GONE);
        mSiteListView.setVisibility(View.VISIBLE);
    }

    /**
     * Hides the list of sites, shows the empty textview
     */
    protected void hideList() {
        mNoSiteLayout.setVisibility(View.VISIBLE);
        mSiteListView.setVisibility(View.GONE);
    }
}
