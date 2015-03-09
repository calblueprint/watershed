package com.blueprint.watershed.FieldReports;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
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
import com.blueprint.watershed.Views.CoverPhotoPagerView;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;


public class FieldReportFragment extends Fragment implements AbsListView.OnItemClickListener {

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

    public void configureViewWithFieldReport(View view, FieldReport fieldReport) {
        ((CoverPhotoPagerView)view.findViewById(R.id.cover_photo_pager_view)).configureWithPhotos(fieldReport.getPhotos());
        ((TextView)view.findViewById(R.id.field_report_health_rating)).setText(String.format("Rating: %s", fieldReport.getHealthRating()));
        ((TextView)view.findViewById(R.id.field_report_description)).setText(fieldReport.getDescription());
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_field_report, container, false);
        configureViewWithFieldReport(view, mFieldReport);

        return view;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.empty, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public void onResume() {
        super.onResume();
        getFieldReportRequest(mFieldReport);
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
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