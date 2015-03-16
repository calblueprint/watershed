package com.blueprint.watershed.Users;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.MiniSites.MiniSiteListAdapter;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Users.UserMiniSitesRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Sites.SiteListAdapter;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;


public class UserMiniSiteFragment extends Fragment {
    MainActivity mParentActivity;
    NetworkManager mNetworkManager;

    private ArrayList<MiniSite> mUserMiniSiteList;
    private MiniSiteListAdapter mMiniSiteAdapter;

    private static String ID = "id";
    private int mId;


    private ListView mListView;

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
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
        mParentActivity = (MainActivity) getActivity();
        mUserMiniSiteList = new ArrayList<MiniSite>();
        Bundle args = getArguments();
        if (args != null) mId = args.getInt(ID);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View finalView = inflater.inflate(R.layout.fragment_user_site, container, false);
        initializeViews(finalView);
        return finalView;
    }

    /**
     * Initializes all the views in the fragment.
     * This includes the adapters, buttons, listview, etc.
     * @param view
     */
    private void initializeViews(View view) {
        mListView = (ListView) view.findViewById(android.R.id.list);
        mMiniSiteAdapter = new MiniSiteListAdapter(mParentActivity,mParentActivity.getApplicationContext(),  R.layout.site_list_row, mUserMiniSiteList);

        mListView.setAdapter(mMiniSiteAdapter);
        mListView.setEmptyView(view.findViewById(R.id.no_site_layout));

    }


    @Override
    public void onResume() {
        getMiniSiteRequest();
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

    protected void getMiniSiteRequest() {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        UserMiniSitesRequest miniSitesRequest = new UserMiniSitesRequest(getActivity(), params, new Response.Listener<ArrayList<MiniSite>>() {
            @Override
            public void onResponse(ArrayList<MiniSite> miniSites) {
                setMiniSites(miniSites);
                mMiniSiteAdapter.notifyDataSetChanged();
            }
        }, mId);
        mNetworkManager.getRequestQueue().add(miniSitesRequest);
    }

}
