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
import com.android.volley.toolbox.JsonObjectRequest;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Tasks.CreateTaskRequest;
import com.blueprint.watershed.Networking.Tasks.EditTaskRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by charlesx on 2/19/15.
 * Abstract fragment from
 */
public abstract class TaskAbstractFragment extends Fragment {

    private static final String CREATE = "create";
    private static final String EDIT = "edit";

    protected EditText mTitleField;
    protected EditText mDescriptionField;
    protected EditText mAssigneeField;
    protected EditText mDueDateField;
    protected EditText mMiniSiteId;
    protected MainActivity mParentActivity;
    protected NetworkManager mNetworkManager;
    protected OnFragmentInteractionListener mListener;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
        mParentActivity = (MainActivity) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        return inflater.inflate(R.layout.fragment_create_task, container, false);
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
     */
    public void setButtonListeners(){
        Button submitButton = (Button) mParentActivity.findViewById(R.id.create_task_submit);
        submitButton.setOnClickListener(submitListener());

        mTitleField = (EditText) mParentActivity.findViewById(R.id.create_task_title);
        mDescriptionField = (EditText) mParentActivity.findViewById(R.id.create_task_description);
        mAssigneeField = (EditText) mParentActivity.findViewById(R.id.create_task_assignee);
        mDueDateField = (EditText) mParentActivity.findViewById(R.id.create_task_due_date);
        mMiniSiteId = (EditText) mParentActivity.findViewById(R.id.create_task_site);
    }

    /**
     * Creates a request to create/edit a task.
     * Returns back to the task index fragment
     * @param task - Task object
     */
    public void createTaskRequest(Task task, final String type) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        JsonObjectRequest request;
        if (type.equals(CREATE)) {
            request = new CreateTaskRequest(mParentActivity, task, params, new Response.Listener<Task>() {
                @Override
                public void onResponse(Task task) {
                    TaskFragment taskFragment = TaskFragment.newInstance(0);
                    mParentActivity.replaceFragment(taskFragment);
                    Log.e("successful task", "creation");
                }
            });
        } else {
            request = new EditTaskRequest(mParentActivity, task, params, new Response.Listener<Task>() {
                @Override
                public void onResponse(Task task) {
                    Fragment fragment;
                    if (type.equals(EDIT)) fragment = TaskDetailFragment.newInstance(task);
                    else fragment = TaskFragment.newInstance(0);
                    mParentActivity.replaceFragment(fragment);
                    Log.i("successful task", "editing");
                }
            });
        }

        mNetworkManager.getRequestQueue().add(request);
    }

    /**
     * Creates a task object that is pass to createTaskRequest
     * @param type
     */
    public void createTask(String type, Task task) {
        if (type.equals(CREATE)) task = new Task();
        if (mTitleField.getText().toString() != null) task.setTitle(mTitleField.getText().toString());
        if (mDescriptionField.getText().toString() != null) task.setDescription(mDescriptionField.getText().toString());
        if (mParentActivity.getUser().getId() != null) task.setAssignerId(mParentActivity.getUser().getId());
        if (mMiniSiteId.getText().toString() != null) task.setMiniSiteId(Integer.parseInt(mMiniSiteId.getText().toString()));
        task.setComplete(false);

        createTaskRequest(task, type);
    }

    public abstract View.OnClickListener submitListener();

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }
}
