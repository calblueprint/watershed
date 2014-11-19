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
import com.blueprint.watershed.FieldReports.FieldReport;
import com.blueprint.watershed.FieldReports.FieldReportFragment;
import com.blueprint.watershed.FieldReports.FieldReportListAdapter;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.MiniSites.MiniSiteListAdapter;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.SiteListRequest;
import com.blueprint.watershed.Networking.SiteRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.Site;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;


public class MiniSiteFragment extends Fragment
                              implements AbsListView.OnItemClickListener {

    private OnFragmentInteractionListener mListener;
    private NetworkManager mNetworkManager;
    private MainActivity mMainActivity;
    private ListView mFieldReportListView;
    private FieldReportListAdapter mFieldReportAdapter;
    private MiniSite mMiniSite;
    private ArrayList<FieldReport> mFieldReports;


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
        ((TextView)view.findViewById(R.id.primary_label)).setText("");
        ((TextView)view.findViewById(R.id.secondary_label)).setText("");
        ((TextView)view.findViewById(R.id.mini_site_name)).setText(miniSite.getName());
        ((TextView)view.findViewById(R.id.mini_site_description)).setText(miniSite.getDescription());
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_mini_site, container, false);
        configureViewWithMiniSite(view, mMiniSite);

        mFieldReportListView = (ListView) view.findViewById(R.id.field_reports_table);
        mFieldReportAdapter = new MiniSiteListAdapter(getActivity(), R.layout.field_report_list_row, getFieldReports());
        mFieldReportListView.setAdapter(mFieldReportAdapter);

        mFieldReportListView.setOnItemClickListener(this);
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

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        if (null != mListener) {
            // Load Field Report
            FieldReport fieldReport = getFieldReport(position);
            FieldReportFragment fieldReportFragment = new FieldReportFragment();
            fieldReportFragment.configureWithFieldReport(fieldReport);
            mMainActivity.replaceFragment(fieldReportFragment);
        }
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

    // Networking

    // Objects
    public void setMiniSite(MiniSite miniSite) {
        mMiniSite = miniSite;
        setFieldReports(miniSite.getFieldReports());
    }

    public MiniSite getFieldReport(int position) { return mFieldReports.get(position); }

    public ArrayList<FieldReport> getFieldReports() {
        if (mFieldReports == null) {
            mFieldReports = new ArrayList<MiniSite>();
        }
        return mFieldReports;
    }

    public void setFieldReports(ArrayList<FieldReport> fieldReports) {
        mFieldReports.clear();
        for (FieldReport fieldReport : fieldReports) {
            mFieldReports.add(fieldReport);
        }
    }
}