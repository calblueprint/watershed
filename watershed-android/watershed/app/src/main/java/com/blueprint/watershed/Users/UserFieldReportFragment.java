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
                                     {
    private NetworkManager mNetworkManager;
    private MainActivity mParentActivity;
    private HeaderGridView mFieldReportGridView;
    private FieldReportListAdapter mFieldReportAdapter;
    private User mUser;
    private ArrayList<FieldReport> mFieldReports;


    public static UserFieldReportFragment newInstance(User user) {
        UserFieldReportFragment miniSiteFragment = new UserFieldReportFragment();
        miniSiteFragment.configureWithUser(user);
        return miniSiteFragment;
    }

    public UserFieldReportFragment() {
    }

    public void configureWithUser(User user) {
        mUser = user;
    }

    public void configureViewWithUser(View view, User user) {
        int reportNum;
        if (user.getFieldReportsCount() != null){
            reportNum = user.getFieldReportsCount();
        }
        else{
            reportNum = 0;
        }
        ((TextView)view.findViewById(R.id.user_name)).setText(mUser.getName() + "\'s Reports");
        ((TextView)view.findViewById(R.id.user_objects)).setText(String.valueOf(reportNum) + " Reports");
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
        mParentActivity = (MainActivity) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_user_field_report, container, false);

        // Create FieldReportGridView
        mFieldReportGridView = (HeaderGridView) view.findViewById(R.id.field_reports_grid);

        // Add mini site header information to the top
        ViewGroup header = (ViewGroup)inflater.inflate(R.layout.user_header_view, mFieldReportGridView, false);
        mFieldReportGridView.addHeaderView(header, null, false);
        mFieldReportGridView.setEmptyView(view.findViewById(R.id.no_reports_layout));

        // Configure the header
        configureViewWithUser(header, mUser);

        // Set the adapter to fill the list of field reports
        mFieldReportAdapter = new FieldReportListAdapter(mParentActivity, getActivity(), R.layout.field_report_list_row, getFieldReports());
        mFieldReportGridView.setAdapter(mFieldReportAdapter);

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
        getFieldReportRequest(mUser.getId());
    }

    // Networking
    public void getFieldReportRequest(int id) {


        UserFieldReportRequest fieldReportRequest = new UserFieldReportRequest(mParentActivity,
                new HashMap<String, JSONObject>(),
                new Response.Listener<ArrayList<FieldReport>>() {
                @Override
                public void onResponse(ArrayList<FieldReport> fieldReports) {
                    setFieldReports(fieldReports);
                    mFieldReportAdapter.notifyDataSetChanged();
                }},
                id);

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
