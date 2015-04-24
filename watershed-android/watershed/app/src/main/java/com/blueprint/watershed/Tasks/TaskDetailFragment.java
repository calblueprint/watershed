package com.blueprint.watershed.Tasks;

import android.content.DialogInterface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.FieldReports.AddFieldReportFragment;
import com.blueprint.watershed.FieldReports.FieldReportFragment;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Tasks.DeleteTaskRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Utilities.Utility;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Locale;


public class TaskDetailFragment extends TaskAbstractFragment
                                implements View.OnClickListener {

    private static final String OPTION = "option";
    private static final int ALL = 1;

    private MainActivity mParentActivity;
    private NetworkManager mNetworkManager;

    private Button mCompleteButton;
    private TextView mDetailTitle;
    private TextView mDescription;
    private TextView mAssigner;
    private TextView mDueDate;
    private TextView mLocation;


    public static TaskDetailFragment newInstance(Task task) {
        TaskDetailFragment taskFragment = new TaskDetailFragment();
        taskFragment.configureWithTask(task);
        return taskFragment;
    }

    public void configureWithTask(Task task) {
        mTask = task;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_task, container, false);
        initializeViews(view);
        return view;
    }

    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setMenuAction(false);
    }

    private void initializeViews(View view) {
        setButtonListeners(view);

        refreshCompletion();

        mDetailTitle = (TextView) view.findViewById(R.id.task_title);
        mDescription = (TextView) view.findViewById(R.id.task_description);
        mDueDate = (TextView) view.findViewById(R.id.task_due_date);
        mAssigner = (TextView) view.findViewById(R.id.task_assigner);
        mLocation = (TextView) view.findViewById(R.id.task_location);

        mDetailTitle.setText(mTask.getTitle());
        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy", Locale.US);
        if (mTask.getDueDate() != null) mDueDate.setText(sdf.format(mTask.getDueDate()));

        String assigner;
        if (mTask.getAssigner() == null) assigner = "None";
        else assigner = mTask.getAssigner().getName();
        mAssigner.setText(assigner);

        String location;
        if (mTask.getMiniSite() == null) location = "MiniSite " + String.valueOf(mTask.getMiniSiteId());
        else location = mTask.getMiniSite().getLocation();
        mLocation.setText(location);

        String description;
        if (mTask.getDescription() == null) description = "No Description";
        else description = mTask.getDescription();
        mDescription.setText(description);
    }

    private void setButtonListeners(View view){
        View editTaskButton = view.findViewById(R.id.edit_task_button);
        editTaskButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mParentActivity.replaceFragment(EditTaskFragment.newInstance(mTask));
            }
        });
//        mFieldReportButton = (Button) view.findViewById(R.id.field_report_button);
//        mFieldReportButton.setOnClickListener(this);
        mCompleteButton = (Button) view.findViewById(R.id.complete_button);
        mCompleteButton.setOnClickListener(this);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.delete_menu, menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.delete:
                deleteTask();
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onClick(View view) {
        switch(view.getId()){
            case (R.id.complete_button):
                fieldReportButtonPressed();
                break;
            default:
                break;
        }
    }

    @Override
    public void submitListener() {}

    public void unCompleteTask() {
        Utility.hideKeyboard(mParentActivity, mLayout);
        createTask(UNCOMPLETE, mTask);

    }

    public void fieldReportButtonPressed() {
        if (mTask.getFieldReport() == null) {
            mParentActivity.setFieldReportTask(mTask);
            mParentActivity.replaceFragment(AddFieldReportFragment.newInstance(mTask, mTask.getMiniSite()));
        } else {
            mParentActivity.replaceFragment(FieldReportFragment.newInstance(mTask.getFieldReport()));
        }
    }

    public void refreshCompletion() {
        String submit = mTask.getFieldReport() == null ? "COMPLETE" : "VIEW FIELD REPORT";
        int color = mTask.getFieldReport() == null ? R.color.ws_blue : R.color.facebook_blue;
        mCompleteButton.setText(submit);
        mCompleteButton.setBackgroundColor(mParentActivity.getResources().getColor(color));
    }

    private void deleteTask() {
        Utility.showAndBuildDialog(mParentActivity, R.string.task_delete_title,
                R.string.task_delete_msg, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        makeDeleteRequest();
                    }
                }, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                }
        );
    }

    private void makeDeleteRequest() {
        DeleteTaskRequest request = new DeleteTaskRequest(mParentActivity, mTask, new Response.Listener<ArrayList<Task>>() {
            @Override
            public void onResponse(ArrayList<Task> tasks) {
                mParentActivity.getSupportFragmentManager().popBackStack();
            }
        });
        mNetworkManager.getRequestQueue().add(request);
    }
}
