package com.blueprint.watershed.FieldReports;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
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
import com.blueprint.watershed.FieldReports.AddFieldReportFragment;
import com.blueprint.watershed.FieldReports.FieldReportListAdapter;
import com.blueprint.watershed.Networking.FieldReports.FieldReportRequest;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;


public class FieldReportFragment extends Fragment
        implements AbsListView.OnItemClickListener {

    private OnFragmentInteractionListener mListener;
    private NetworkManager mNetworkManager;
    private MainActivity mMainActivity;
    private FieldReport mFieldReport;


    public static FieldReportFragment newInstance(FieldReport fieldReport) {
        FieldReportFragment fieldReportFragment = new FieldReportFragment();
        fieldReportFragment.configureWithFieldReport(fieldReport);
        return fieldReportFragment;
    }

    public FieldReportFragment() {
    }

    public void configureWithFieldReport(FieldReport fieldReport) {
        mFieldReport = fieldReport;
    }

    public void configureViewWithfieldReport(View view, FieldReport fieldReport) {
        ((TextView)view.findViewById(R.id.primary_label)).setText("");
        ((TextView)view.findViewById(R.id.secondary_label)).setText("");
        ((TextView)view.findViewById(R.id.mini_site_name)).setText(fieldReport.getName());
        ((TextView)view.findViewById(R.id.mini_site_description)).setText(fieldReport.getDescription());
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
        configureViewWithfieldReport(view, mFieldReport);

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
        getFieldReportRequest(mFieldReport);
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        if (null != mListener) {

        }
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

    // Networking
    public void getFieldReportRequest(FieldReport fieldReport) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        FieldReportRequest fieldReportRequest = new FieldReportRequest(getActivity(), fieldReport, params, new Response.Listener<FieldReport>() {
            @Override
            public void onResponse(FieldReport fieldReport) {
                setFieldReport(fieldReport);
            }
        });

        mNetworkManager.getRequestQueue().add(fieldReportRequest);
    }

    // Objects
    public void setFieldReport(FieldReport fieldReport) {
        mFieldReport = fieldReport;
    }
}