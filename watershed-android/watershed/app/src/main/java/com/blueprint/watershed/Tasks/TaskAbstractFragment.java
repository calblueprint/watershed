package com.blueprint.watershed.Tasks;

import android.app.Activity;
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

/**
 * Created by charlesx on 2/19/15.
 * Abstract fragment from
 */
public abstract class TaskAbstractFragment extends Fragment {

    protected EditText mTitleField;
    protected EditText mDescriptionField;
    protected EditText mAssigneeField;
    protected EditText mDueDateField;
    protected EditText mMiniSiteId;
    protected MainActivity mMainActivity;
    protected NetworkManager mNetworkManager;
    protected OnFragmentInteractionListener mListener;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
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
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    /**
     * Initializes all the views for the form.
     * @param view
     */
    private void setButtonListeners(View view){
        Button submitButton = (Button)view.findViewById(R.id.create_task_submit);
        mTitleField = (EditText)view.findViewById(R.id.create_task_title);
        mDescriptionField = (EditText)view.findViewById(R.id.create_task_description);
        mAssigneeField = (EditText)view.findViewById(R.id.create_task_assignee);
        mDueDateField = (EditText)view.findViewById(R.id.create_task_due_date);
        mMiniSiteId = (EditText)view.findViewById(R.id.create_task_site);
        submitButton.setOnClickListener(submitListener());
    }

    /**
     * Creates a request to create/edit a task.
     * Returns back to the task index fragment
     * @param task - Task object
     */
    public void createTaskRequest(Task task) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        CreateTaskRequest createFieldReportRequest = new CreateTaskRequest(getActivity(), task, params, new Response.Listener<Task>() {
            @Override
            public void onResponse(Task task) {
                TaskFragment taskFragment = TaskFragment.newInstance(0);
                mMainActivity.replaceFragment(taskFragment);
                Log.e("successful task", "creation");
            }
        });

        mNetworkManager.getRequestQueue().add(createFieldReportRequest);
    }

    /**
     * Creates a task object that is pass to createTaskRequest
     * @param type
     */
    public void createTask(String type) {
        Task submitTask = new Task();
        submitTask.setTitle(mTitleField.getText().toString());
        submitTask.setDescription(mDescriptionField.getText().toString());
        submitTask.setAssignerId(mMainActivity.getUser().getId());
        submitTask.setMiniSiteId(Integer.parseInt(mMiniSiteId.getText().toString()));
        submitTask.setComplete(false);

        createTaskRequest(submitTask);
    }

    public abstract View.OnClickListener submitListener();

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }
}
