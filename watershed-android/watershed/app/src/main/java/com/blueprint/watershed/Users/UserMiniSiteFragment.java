package com.blueprint.watershed.Users;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ListView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.MiniSites.BasicMiniSiteListAdapter;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.MiniSites.MiniSiteFragment;
import com.blueprint.watershed.MiniSites.MiniSiteListAdapter;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Users.UserMiniSitesRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Sites.SiteListAdapter;
import com.blueprint.watershed.Views.HeaderGridView;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;


public class UserMiniSiteFragment extends Fragment implements AbsListView.OnItemClickListener{
    MainActivity mParentActivity;
    NetworkManager mNetworkManager;

    private ArrayList<MiniSite> mUserMiniSiteList;
    private BasicMiniSiteListAdapter mMiniSiteAdapter;

    private static String ID = "id";
    private int mId;

    private ListView mListView;
    private SwipeRefreshLayout mSwipeLayout;

    public static UserMiniSiteFragment newInstance(int id) {
        UserMiniSiteFragment fragment = new UserMiniSiteFragment();
        Bundle args = new Bundle();
        args.putInt(ID, id);
        fragment.setArguments(args);
        return fragment;
    }

    public UserMiniSiteFragment(){}

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
        mUserMiniSiteList = new ArrayList<MiniSite>();
        Bundle args = getArguments();
        if (args != null) mId = args.getInt(ID);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        return inflater.inflate(R.layout.fragment_about, container, false);
        //initializeViews(finalView);
        //return finalView;
    }

    private void initializeViews(View view) {
        mListView = (ListView) view.findViewById(android.R.id.list);
        mMiniSiteAdapter = new BasicMiniSiteListAdapter(mParentActivity,mParentActivity, R.layout.basic_mini_site_list_row, mUserMiniSiteList);

        mListView.setAdapter(mMiniSiteAdapter);
        mListView.setEmptyView(view.findViewById(R.id.no_site_layout));

        mSwipeLayout = (SwipeRefreshLayout) view.findViewById(R.id.site_swipe_container);
        mSwipeLayout.setColorSchemeResources(R.color.ws_blue, R.color.facebook_blue, R.color.facebook_dark_blue, R.color.dark_gray);
        mSwipeLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                mSwipeLayout.setRefreshing(true);
                //getMiniSiteRequest();
            }
        });
    }

    @Override
    public void onResume() {
        //getMiniSiteRequest();
    }


    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.empty, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    private void setMiniSites(ArrayList<MiniSite> miniSites){
        mUserMiniSiteList.clear();
        for (MiniSite miniSite : miniSites){
            mUserMiniSiteList.add(miniSite);
        }
    }

    private ArrayList<MiniSite> getMiniSites(){
        return mUserMiniSiteList;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        MiniSite miniSite = getMiniSite(position);
        MiniSiteFragment miniSiteFragment = new MiniSiteFragment();
        miniSiteFragment.configureWithMiniSite(miniSite);
        mParentActivity.replaceFragment(miniSiteFragment);
    }

    private MiniSite getMiniSite(int position) { return mUserMiniSiteList.get(position); }

    protected void getMiniSiteRequest() {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        UserMiniSitesRequest miniSitesRequest = new UserMiniSitesRequest(getActivity(), params, new Response.Listener<ArrayList<MiniSite>>() {
            @Override
            public void onResponse(ArrayList<MiniSite> miniSites) {
                Log.e("Good ", "MiniSite Request");
                setMiniSites(miniSites);
                mMiniSiteAdapter.notifyDataSetChanged();
            }
        }, mId);
        mNetworkManager.getRequestQueue().add(miniSitesRequest);
    }

}
