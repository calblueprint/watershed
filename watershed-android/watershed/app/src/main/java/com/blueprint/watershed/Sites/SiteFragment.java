package com.blueprint.watershed.Sites;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.support.v4.app.Fragment;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.MiniSites.MiniSiteFragment;
import com.blueprint.watershed.MiniSites.MiniSiteListAdapter;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Sites.SiteRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;


public class SiteFragment extends Fragment
                          implements AbsListView.OnItemClickListener {

    private OnFragmentInteractionListener mListener;
    private NetworkManager mNetworkManager;
    private MainActivity mMainActivity;
    private ListView mMiniSiteListView;
    private MiniSiteListAdapter mMiniSiteAdapter;
    private Site mSite;
    private ArrayList<MiniSite> mMiniSites;


    public static SiteFragment newInstance(Site site) {
        SiteFragment siteFragment = new SiteFragment();
        siteFragment.configureWithSite(site);
        return siteFragment;
    }

    public SiteFragment() {
    }

    public void configureWithSite(Site site) {
        mSite = site;
    }

    public void configureViewWithSite(View view, Site site) {
        ((TextView)view.findViewById(R.id.primary_label)).setText("");
        ((TextView)view.findViewById(R.id.secondary_label)).setText("");
        ((TextView)view.findViewById(R.id.site_name)).setText(site.getName());
        ((TextView)view.findViewById(R.id.site_description)).setText(site.getDescription());
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_site, container, false);
        configureViewWithSite(view, mSite);

        mMiniSiteListView = (ListView) view.findViewById(R.id.mini_sites_table);
        mMiniSiteAdapter = new MiniSiteListAdapter(getActivity(), R.layout.mini_site_list_row, getMiniSites());
        mMiniSiteListView.setAdapter(mMiniSiteAdapter);

        mMiniSiteListView.setOnItemClickListener(this);
        return view;
    }

    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
            mMainActivity = (MainActivity)activity;
            mListener = (OnFragmentInteractionListener) activity;
        } catch (ClassCastException e) {
            throw new ClassCastException(activity.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        getSiteRequest(mSite);
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        if (mListener != null) {
            // Load MiniSite
            MiniSite miniSite = getMiniSite(position);
            MiniSiteFragment miniSiteFragment = new MiniSiteFragment();
            miniSiteFragment.configureWithMiniSite(miniSite);

            mMainActivity.replaceFragment(miniSiteFragment);
        }
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

    // Networking
    public void getSiteRequest(Site site) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        SiteRequest siteRequest = new SiteRequest(getActivity(), site, params, new Response.Listener<Site>() {
            @Override
            public void onResponse(Site site) {
                setSite(site);
                mMiniSiteAdapter.notifyDataSetChanged();
            }
        });

        mNetworkManager.getRequestQueue().add(siteRequest);
    }

    public void setSite(Site site) {
        mSite = site;
        setMiniSites(site.getMiniSites());
    }

    public MiniSite getMiniSite(int position) { return mMiniSites.get(position); }

    public ArrayList<MiniSite> getMiniSites() {
        if (mMiniSites == null) {
            mMiniSites = new ArrayList<MiniSite>();
        }
        return mMiniSites;
    }

    public void setMiniSites(ArrayList<MiniSite> miniSites) {
        mMiniSites.clear();
        for (MiniSite miniSite : miniSites) {
            mMiniSites.add(miniSite);
        }
    }
}