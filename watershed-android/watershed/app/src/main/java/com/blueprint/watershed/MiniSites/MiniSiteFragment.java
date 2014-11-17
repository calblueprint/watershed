package com.blueprint.watershed.MiniSites;

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
import com.blueprint.watershed.MiniSites.MiniSiteListAdapter;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.SiteListRequest;
import com.blueprint.watershed.Networking.SiteRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;


public class MiniSiteFragment extends Fragment {

    private OnFragmentInteractionListener mListener;
    private MiniSite mMiniSite;
    private NetworkManager mNetworkManager;
    private MainActivity mMainActivity;


    public static MiniSiteFragment newInstance(MiniSite miniSite) {
        MiniSiteFragment miniSiteFragment = new MiniSiteFragment();
        miniSiteFragment.configureWithMiniSite(miniSite);
        return miniSiteFragment;
    }

    public MiniSiteFragment() {
    }

    public void configureWithMiniSite(MiniSite miniSite) {
        mMiniSite = miniSite;
    }

    public void configureViewWithMiniSite(View view, MiniSite miniSite) {
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
        //configureViewWithSite(view, mSite);

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
        //getSiteRequest(mSite);
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

    // Networking

}