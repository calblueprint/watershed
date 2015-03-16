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
import android.widget.TextView;

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
    private HeaderGridView mMiniSiteGridView;
    private MiniSiteListAdapter mMiniSiteAdapter;

    private static String ID = "id";
    private int mId;


    public static UserMiniSiteFragment newInstance(int id) {
        UserMiniSiteFragment fragment = new UserMiniSiteFragment();
        fragment.configureWithId(id);
        return fragment;
    }

    public UserMiniSiteFragment(){}

    public void configureWithId(int Id) {
        mId = Id;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity.getApplicationContext());
    }

    public void configureViewWithUser(View view, int Id) {
        ((TextView)view.findViewById(R.id.user_name)).setText(String.valueOf(mId));
        ((TextView)view.findViewById(R.id.user_objects)).setText("7");//mFieldReports.size());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_user_site, container, false);

        // Create FieldReportGridView
        mMiniSiteGridView = (HeaderGridView) view.findViewById(R.id.mini_sites_grid);

        // Add mini site header information to the top
        ViewGroup header = (ViewGroup)inflater.inflate(R.layout.user_header_view, mMiniSiteGridView, false);
        mMiniSiteGridView.addHeaderView(header, null, false);

        // Configure the header
        configureViewWithUser(header, mId);

        // Set the adapter to fill the list of field reports
        mMiniSiteAdapter = new MiniSiteListAdapter(mParentActivity, getActivity(), R.layout.mini_site_list_row, getMiniSites());
        mMiniSiteGridView.setAdapter(mMiniSiteAdapter);

        mMiniSiteGridView.setOnItemClickListener(this);
        return view;
    }

    @Override
    public void onResume() {
        super.onResume();
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
        // Load MiniSite
        MiniSite miniSite = getMiniSite(position);
        MiniSiteFragment addFieldReportFragment = new MiniSiteFragment();
        addFieldReportFragment.configureWithMiniSite(miniSite);
        mParentActivity.replaceFragment(addFieldReportFragment);
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
