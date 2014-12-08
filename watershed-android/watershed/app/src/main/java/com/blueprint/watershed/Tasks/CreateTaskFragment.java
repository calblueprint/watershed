package com.blueprint.watershed.Tasks;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.support.v4.app.Fragment;
import android.widget.Button;
import android.widget.EditText;


import com.blueprint.watershed.R;


public class CreateTaskFragment extends Fragment implements View.OnClickListener {

    private EditText mTitleField;
    private EditText mDescriptionField;
    private EditText mAssigneeField;
    private EditText mDueDateField;
    private EditText mMiniSiteId;
    private OnFragmentInteractionListener mListener;

    public static CreateTaskFragment newInstance() {
        CreateTaskFragment fragment = new CreateTaskFragment();
        return fragment;
    }
    public CreateTaskFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view =  inflater.inflate(R.layout.fragment_create_task, container, false);

        setButtonListeners(view);
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

    private void setButtonListeners(View view){
        Button submitButton = (Button)view.findViewById(R.id.create_task_submit);
        mTitleField = (EditText)view.findViewById(R.id.create_task_title);
        mDescriptionField = (EditText)view.findViewById(R.id.create_task_description);
        mAssigneeField = (EditText)view.findViewById(R.id.create_task_assignee);
        mDueDateField = (EditText)view.findViewById(R.id.create_task_due_date);
        mMiniSiteId = (EditText)view.findViewById(R.id.create_task_site);
        submitButton.setOnClickListener(this);
    }

    public void onClick(View view) {
        switch (view.getId()){
            case (R.id.create_task_submit):
                createTask();
        }
    }

    private void createTask() {
        Task submitTask = new Task();
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

}
