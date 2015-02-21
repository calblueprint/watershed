package com.blueprint.watershed.Tasks;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.support.v4.app.Fragment;
import android.widget.Button;
import android.widget.EditText;


import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.FieldReports.CreateFieldReportRequest;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Tasks.CreateTaskRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.HashMap;


public class CreateTaskFragment extends Fragment implements View.OnClickListener {

    private EditText mTitleField;
    private EditText mDescriptionField;
    private EditText mAssigneeField;
    private EditText mDueDateField;
    private EditText mMiniSiteId;
    private MainActivity mMainActivity;
    private NetworkManager mNetworkManager;
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
        setHasOptionsMenu(true);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
        mMainActivity = (MainActivity) getActivity();
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
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.empty, menu);
        super.onCreateOptionsMenu(menu, inflater);
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

    public void createTaskRequest(Task task){
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        CreateTaskRequest createTaskRequest = new CreateTaskRequest(getActivity(), task, params, new Response.Listener<Task>() {
            @Override
            public void onResponse(Task task) {
                Log.e("successful task", "creation");
            }
        });

        mNetworkManager.getRequestQueue().add(createTaskRequest);
    }


    private void createTask() {
        Task submitTask = new Task();
        submitTask.setTitle(mTitleField.getText().toString());
        submitTask.setDescription(mDescriptionField.getText().toString());
        submitTask.setAssignerId(mMainActivity.getUser().getId());
        submitTask.setMiniSiteId(Integer.parseInt(mMiniSiteId.getText().toString()));
        submitTask.setComplete(false);

        createTaskRequest(submitTask);

        TaskFragment taskFragment = TaskFragment.newInstance(0);
        mMainActivity.replaceFragment(taskFragment);
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

}
