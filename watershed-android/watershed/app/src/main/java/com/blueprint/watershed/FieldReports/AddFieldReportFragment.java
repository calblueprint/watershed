package com.blueprint.watershed.FieldReports;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.blueprint.watershed.R;

public class AddFieldReportFragment extends Fragment implements View.OnClickListener {

    private OnFragmentInteractionListener mListener;
    private View view;
    private Button mTakePhotoButton;
    private Button mSubmitFieldReportButton;


    public static AddFieldReportFragment newInstance() {
        AddFieldReportFragment addFieldReportFragment = new AddFieldReportFragment();
        return addFieldReportFragment;
    }

    public AddFieldReportFragment() {
        // Required empty public constructor
    }

    public void configureWithFieldReport(FieldReport fieldReport) {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.fragment_add_field_report, container, false);
        setTakePhotoButton((Button) view.findViewById(R.id.take_photo_button));
        setSubmitFieldReportButton((Button) view.findViewById(R.id.submit_field_report_button));


        // Set OnClickListeners
        getTakePhotoButton().setOnClickListener(this);
        getSubmitFieldReportButton().setOnClickListener(this);

        return view;
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
            mListener = (OnFragmentInteractionListener) activity;
        } catch (ClassCastException e) {
            throw new ClassCastException(activity.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    // View.OnClickListener
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.take_photo_button:
                // Take the photo

                break;
            case R.id.submit_field_report_button:
                // Send the request to make the field report
                // createFieldReport();
                break;
        }
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

    // Getters
    public Button getTakePhotoButton() { return mTakePhotoButton; }
    public Button getSubmitFieldReportButton() { return mSubmitFieldReportButton; }

    // Setters
    public void setTakePhotoButton(Button takePhotoButton) { mTakePhotoButton = takePhotoButton; }
    public void setSubmitFieldReportButton(Button submitFieldReportButton) { mSubmitFieldReportButton = submitFieldReportButton; }
}
