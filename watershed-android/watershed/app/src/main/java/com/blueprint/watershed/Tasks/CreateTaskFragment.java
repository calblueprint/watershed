package com.blueprint.watershed.Tasks;

import android.app.Activity;
import android.graphics.drawable.TransitionDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Tasks.CreateTaskRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.HashMap;


public class CreateTaskFragment extends Fragment implements View.OnClickListener {

    private static final int FADE_TIMER = 500;

    private EditText mTitleField;
    private EditText mDescriptionField;
    private EditText mAssigneeField;
    private EditText mDueDateField;
    private EditText mMiniSiteId;
    private MainActivity mParentActivity;
    private NetworkManager mNetworkManager;
    private OnFragmentInteractionListener mListener;

    public static CreateTaskFragment newInstance() {
        return new CreateTaskFragment();
    }

    public CreateTaskFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        mParentActivity = (MainActivity) getActivity();
        return inflater.inflate(R.layout.fragment_create_task, container, false);
    }
    
    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        setButtonListeners();
        setFocusListeners();
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

    private void setButtonListeners(){
        mTitleField = (EditText) mParentActivity.findViewById(R.id.create_task_title);
        mDescriptionField = (EditText) mParentActivity.findViewById(R.id.create_task_description);
        mAssigneeField = (EditText) mParentActivity.findViewById(R.id.create_task_assignee);
        mDueDateField = (EditText) mParentActivity.findViewById(R.id.create_task_due_date);
        mMiniSiteId = (EditText) mParentActivity.findViewById(R.id.create_task_site);
        Button submitButton = (Button) mParentActivity.findViewById(R.id.create_task_submit);
        submitButton.setOnClickListener(this);
    }

    private void setFocusListeners() {
        View.OnFocusChangeListener listener = new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View view, boolean b) {
                TransitionDrawable drawable = (TransitionDrawable) view.getBackground();
                if (b) drawable.startTransition(FADE_TIMER);
                else drawable.reverseTransition(0);
            }
        };

        mTitleField.setOnFocusChangeListener(listener);
        mDescriptionField.setOnFocusChangeListener(listener);
        mAssigneeField.setOnFocusChangeListener(listener);
        mDueDateField.setOnFocusChangeListener(listener);
        mMiniSiteId.setOnFocusChangeListener(listener);
    }

    public void onClick(View view) {
        switch (view.getId()){
            case (R.id.create_task_submit):
                createTask();
        }
    }

    public void createTaskRequest(Task task){
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        CreateTaskRequest createFieldReportRequest = new CreateTaskRequest(getActivity(), task, params, new Response.Listener<Task>() {
            @Override
            public void onResponse(Task task) {
                Log.e("successful task", "creation");
            }
        });

        mNetworkManager.getRequestQueue().add(createFieldReportRequest);
    }


    private void createTask() {
        Task submitTask = new Task();

        submitTask.setTitle(mTitleField.getText().toString());
        submitTask.setDescription(mDescriptionField.getText().toString());
        submitTask.setAssignerId(mParentActivity.getUser().getId());
        submitTask.setMiniSiteId(Integer.parseInt(mMiniSiteId.getText().toString()));
        submitTask.setComplete(false);

        createTaskRequest(submitTask);

        TaskFragment taskFragment = TaskFragment.newInstance(0);
        mParentActivity.replaceFragment(taskFragment);
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

}
