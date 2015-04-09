package com.blueprint.watershed.Tasks;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.FieldReports.AddFieldReportFragment;
import com.blueprint.watershed.FieldReports.FieldReportFragment;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Utilities.Utility;

import java.text.SimpleDateFormat;
import java.util.Locale;


public class TaskDetailFragment extends TaskAbstractFragment
                                implements View.OnClickListener{

    private MainActivity mParentActivity;
    private NetworkManager mNetworkManager;

    private Button mFieldReportButton;
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

        View completeButton = view.findViewById(R.id.complete_button);

        mFieldReportButton = (Button) view.findViewById(R.id.field_report_button);
        mFieldReportButton.setOnClickListener(this);
        mCompleteButton = (Button) completeButton;
        mCompleteButton.setOnClickListener(this);

        String submit = mTask.getFieldReport() == null ? "ADD FIELD REPORT" : "VIEW FIELD REPORT";
        mFieldReportButton.setText(submit);
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

    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle item selection
        switch (item.getItemId()) {
            case R.id.edit:
                EditTaskFragment newTask = EditTaskFragment.newInstance(mTask);
                mParentActivity.replaceFragment(newTask);
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    // Button Events

    @Override
    public void onClick(View view) {
        switch(view.getId()){
            case (R.id.field_report_button):
                fieldReportButtonPressed();
                break;
            case (R.id.complete_button):
                if (!mTask.getComplete()) completeTask();
                else unCompleteTask();
                break;
            default:
                break;
        }
    }

    @Override
    public void submitListener() {}

    public void completeTask() {
        Utility.hideKeyboard(mParentActivity, mLayout);
        createTask(COMPLETE, mTask);
    }

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
        String complete = mTask.getComplete() ? "UNDO COMPLETION" : "COMPLETE";
        mCompleteButton.setText(complete);
        if (mTask.getComplete()) mCompleteButton.setBackgroundColor(getResources().getColor(R.color.ws_green));
        else mCompleteButton.setBackgroundColor(getResources().getColor(R.color.ws_blue));
    }
}
