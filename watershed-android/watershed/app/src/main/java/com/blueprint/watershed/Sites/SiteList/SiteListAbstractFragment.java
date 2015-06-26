package com.blueprint.watershed.Sites.SiteList;

import android.os.Bundle;
import android.os.CountDownTimer;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;

import com.android.volley.RequestQueue;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.CreateSiteFragment;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Views.Material.FloatingActionButton;

import java.util.ArrayList;
import java.util.List;

import de.greenrobot.event.EventBus;

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

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
        EventBus.getDefault().register(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_site_list, container, false);
        initializeViews(view);
        refreshList();
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

        if (mParentActivity.getUser().isManager()) {
            mCreateSiteButton = (FloatingActionButton) view.findViewById(R.id.create_site_button);
            mCreateSiteButton.setVisibility(View.VISIBLE);
            mCreateSiteButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    mParentActivity.replaceFragment(CreateSiteFragment.newInstance());
                }
            });
        }
    }

    private void refreshList() {
        if (mSites == null) {
            mNoSiteLayout.setRefreshing(true);
            getSitesRequest();
        }
    }

    public void onEvent(SiteEvent event) {
        Site site = event.getSite();
        if (!rightSiteType(site)) return;

        switch (event.getType()) {
            case SITE_CREATED:
                addSiteToList(site);
                break;
            case SITE_EDITED:
                removeSiteFromList(site);
                addSiteToList(site);
                break;
            case SITE_DESTROYED:
                removeSiteFromList(site);
                break;
        }

        if (mAdapter != null) mAdapter.notifyDataSetChanged();
    }

    private void addSiteToList(Site site) { mSites.add(0, site); }

    private void removeSiteFromList(Site site) {
        for (Site siteObj : mSites) {
            if (siteObj.getId().equals(site.getId())) {
                mSites.remove(siteObj);
            }
        }
    }


    public abstract boolean rightSiteType(Site site);


    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setMenuAction(true);
    }

    @Override
    public void onPause() {
        super.onPause();
        RequestQueue requestQueue = mNetworkManager.getRequestQueue();
        if (requestQueue != null) { requestQueue.cancelAll(SITE_LIST_REQUEST); }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().register(this);
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
        if (mSites == null) mSites = new ArrayList<>();
        mSites.clear();
        mSites.addAll(sites);

        if (mAdapter == null) {
            mAdapter = new SiteListAdapter(mParentActivity, R.layout.site_list_row, mSites);
            mSiteListView.setAdapter(mAdapter);
        }

        mAdapter.notifyDataSetChanged();
    }

    protected void toggleList() {
        if (mSites == null || mSites.size() == 0) {
            mNoSiteLayout.setVisibility(View.VISIBLE);
            mSiteListView.setVisibility(View.GONE);
        } else {
            mNoSiteLayout.setVisibility(View.GONE);
            mSiteListView.setVisibility(View.VISIBLE);
        }
    }
}
