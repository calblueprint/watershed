package com.blueprint.watershed.Users;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.FieldReports.AddFieldReportFragment;
import com.blueprint.watershed.FieldReports.FieldReport;
import com.blueprint.watershed.FieldReports.FieldReportListAdapter;
import com.blueprint.watershed.Networking.FieldReports.FieldReportRequest;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Users.UserFieldReportRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Views.CoverPhotoPagerView;
import com.blueprint.watershed.Views.HeaderGridView;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

public class UserFieldReportFragment extends Fragment
                                     implements AbsListView.OnItemClickListener{
    private NetworkManager mNetworkManager;
    private MainActivity mMainActivity;
    private HeaderGridView mFieldReportGirdView;
    private FieldReportListAdapter mFieldReportAdapter;
    private int mId;
    private ArrayList<FieldReport> mFieldReports;


    public static UserFieldReportFragment newInstance(int Id) {
        UserFieldReportFragment miniSiteFragment = new UserFieldReportFragment();
        miniSiteFragment.configureWithId(Id);
        return miniSiteFragment;
    }

    public UserFieldReportFragment() {
    }

    public void configureWithId(int Id) {
        mId = Id;
    }

    public void configureViewWithUser(View view, int Id) {
        ((TextView)view.findViewById(R.id.user_name)).setText(String.valueOf(mId));
        ((TextView)view.findViewById(R.id.user_objects)).setText("7");//mFieldReports.size());
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
        mMainActivity = (MainActivity) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_user_field_report, container, false);

        // Create FieldReportGridView
        mFieldReportGirdView = (HeaderGridView) view.findViewById(R.id.field_reports_grid);

        // Add mini site header information to the top
        ViewGroup header = (ViewGroup)inflater.inflate(R.layout.user_header_view, mFieldReportGirdView, false);
        mFieldReportGirdView.addHeaderView(header, null, false);

        // Configure the header
        configureViewWithUser(header, mId);

        // Set the adapter to fill the list of field reports
        mFieldReportAdapter = new FieldReportListAdapter(mMainActivity, getActivity(), R.layout.field_report_list_row, getFieldReports());
        mFieldReportGirdView.setAdapter(mFieldReportAdapter);

        mFieldReportGirdView.setOnItemClickListener(this);
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
        getFieldReportRequest(mId);
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        // Load Field Report
        FieldReport fieldReport = getFieldReport(position);
        AddFieldReportFragment addFieldReportFragment = new AddFieldReportFragment();
        addFieldReportFragment.configureWithFieldReport(fieldReport);
        mMainActivity.replaceFragment(addFieldReportFragment);
    }

    // Networking
    public void getFieldReportRequest(int id) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        UserFieldReportRequest fieldReportRequest = new UserFieldReportRequest(getActivity(), params, new Response.Listener<ArrayList<FieldReport>>() {
            @Override
            public void onResponse(ArrayList<FieldReport> fieldReports) {
                Log.e("Field Response", "Sucess");
                setFieldReports(fieldReports);
                mFieldReportAdapter.notifyDataSetChanged();
            }
        }, id);

        mNetworkManager.getRequestQueue().add(fieldReportRequest);
    }

    // Objects

    public FieldReport getFieldReport(int position) { return mFieldReports.get(position); }

    public ArrayList<FieldReport> getFieldReports() {
        if (mFieldReports == null) {
            mFieldReports = new ArrayList<FieldReport>();
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
