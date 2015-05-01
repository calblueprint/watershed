package com.blueprint.watershed.FieldReports;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.FieldReports.FieldReportRequest;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.HashMap;


public class FieldReportFragment extends Fragment {

    private NetworkManager mNetworkManager;
    private FieldReport mFieldReport;
    private MainActivity mParentActivity;

    private ImageView mImage;
    private RatingBar mRating;
    private TextView mDescription;
    private TextView mRatingNumber;

    public static FieldReportFragment newInstance(FieldReport fieldReport) {
        FieldReportFragment fieldReportFragment = new FieldReportFragment();
        fieldReportFragment.setFieldReport(fieldReport);
        return fieldReportFragment;
    }

    public void setFieldReport(FieldReport fieldReport) {
        mFieldReport = fieldReport;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_field_report, container, false);
        initializeViews(view);
        setViews();
        getFieldReportRequest(mFieldReport);
        return view;
    }

    private void initializeViews(View view) {
        mImage = (ImageView) view.findViewById(R.id.cover_photo_pager_view);
        mRating = (RatingBar) view.findViewById(R.id.field_report_health_rating);
        mRatingNumber = (TextView) view.findViewById(R.id.field_report_rating_text);
        mDescription = (TextView) view.findViewById(R.id.field_report_description);
    }

    private void setViews() {
        mRating.setRating(mFieldReport.getHealthRating());
        mRatingNumber.setText(String.valueOf(mFieldReport.getHealthRating()));
        mDescription.setText(mFieldReport.getDescription());
        if (mFieldReport.getPhoto() != null) mFieldReport.getPhoto().getImageAndSetImageView(mParentActivity, mImage);
        mImage.invalidate();
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
        mParentActivity.setMenuAction(false);
    }

    // Networking
    public void getFieldReportRequest(FieldReport fieldReport) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        FieldReportRequest fieldReportRequest = new FieldReportRequest(mParentActivity, fieldReport, params, new Response.Listener<FieldReport>() {
            @Override
            public void onResponse(FieldReport fieldReport) {
                setFieldReport(fieldReport);
                setViews();
            }
        });

        mNetworkManager.getRequestQueue().add(fieldReportRequest);
    }
}