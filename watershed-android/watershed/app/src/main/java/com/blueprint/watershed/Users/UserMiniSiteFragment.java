package com.blueprint.watershed.Users;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.MiniSites.MiniSiteListAdapter;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Users.UserMiniSitesRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Views.HeaderGridView;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;


public class UserMiniSiteFragment extends Fragment{
    MainActivity mParentActivity;
    NetworkManager mNetworkManager;

    private ArrayList<MiniSite> mUserMiniSiteList;
    private HeaderGridView mMiniSiteGridView;
    private MiniSiteListAdapter mMiniSiteAdapter;

    private User mUser;


    public static UserMiniSiteFragment newInstance(User user) {
        UserMiniSiteFragment fragment = new UserMiniSiteFragment();
        fragment.configureWithUser(user);
        return fragment;
    }

    public UserMiniSiteFragment(){}

    public void configureWithUser(User user) {
        mUser =  user;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity.getApplicationContext());
    }

    public void configureViewWithUser(View view, User user) {
        int siteNum;
        if (user.getTasksCount() != null){
            siteNum = user.getSitesCount();
        }
        else{
            siteNum = 0;
        }
        ((TextView)view.findViewById(R.id.user_name)).setText(mUser.getName() + "\'s Sites");
        ((TextView)view.findViewById(R.id.user_objects)).setText(String.valueOf(siteNum) + " Sites");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_user_site, container, false);

        // Create MiniSite Grid View
        mMiniSiteGridView = (HeaderGridView) view.findViewById(R.id.mini_sites_grid);

        // Add user header information to the top
        ViewGroup header = (ViewGroup)inflater.inflate(R.layout.user_header_view, mMiniSiteGridView, false);
        mMiniSiteGridView.addHeaderView(header, null, false);
        mMiniSiteGridView.setEmptyView(view.findViewById(R.id.no_site_layout));

        // Configure the header
        configureViewWithUser(header, mUser);

        // Set the adapter to fill the list of miniSites
        mMiniSiteAdapter = new MiniSiteListAdapter(mParentActivity, getMiniSites(), null);
        mMiniSiteGridView.setAdapter(mMiniSiteAdapter);

        return view;
    }

    @Override
    public void onResume() {
        super.onResume();
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
        if (mUserMiniSiteList == null) {
            mUserMiniSiteList = new ArrayList<MiniSite>();
        }
        return mUserMiniSiteList;
    }

    private MiniSite getMiniSite(int position) { return mUserMiniSiteList.get(position); }

    protected void getMiniSiteRequest() {
        UserMiniSitesRequest miniSitesRequest = new UserMiniSitesRequest(mParentActivity,
                new HashMap<String, JSONObject>(),
                new Response.Listener<ArrayList<MiniSite>>() {
            @Override
            public void onResponse(ArrayList<MiniSite> miniSites) {
                Log.e("Good ", "MiniSite Request");
                setMiniSites(miniSites);
                mMiniSiteAdapter.notifyDataSetChanged();
            }
        }, mUser.getId());
        mNetworkManager.getRequestQueue().add(miniSitesRequest);
    }

}
