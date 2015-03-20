package com.blueprint.watershed.Tasks;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
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

import java.text.SimpleDateFormat;


public class TaskDetailFragment extends Fragment implements View.OnClickListener {

    private MainActivity mParentActivity;
    private Task mTask;
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
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.edit_menu, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity.getApplicationContext());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        return inflater.inflate(R.layout.fragment_task, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initializeViews();
    }

    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setMenuAction(false);
    }

    private void initializeViews() {
        mFieldReportButton = (Button) mParentActivity.findViewById(R.id.field_report_button);
        mFieldReportButton.setOnClickListener(this);
        mCompleteButton = (Button) mParentActivity.findViewById(R.id.complete_button);
        mCompleteButton.setOnClickListener(this);

        String submit = mTask.getFieldReport() == null ? "ADD FIELD REPORT" : "VIEW FIELD REPORT";
        mFieldReportButton.setText(submit);

        String complete = mTask.getComplete() ? "UNDO COMPLETION" : "COMPLETE";
        mCompleteButton.setText(complete);

        mDetailTitle = (TextView) mParentActivity.findViewById(R.id.task_title);
        mDescription = (TextView) mParentActivity.findViewById(R.id.task_description);
        mDueDate = (TextView) mParentActivity.findViewById(R.id.task_due_date);
        mAssigner = (TextView) mParentActivity.findViewById(R.id.task_assigner);
        mLocation = (TextView) mParentActivity.findViewById(R.id.task_location);

        mDetailTitle.setText(mTask.getTitle());
        mDescription.setText(mTask.getDescription());
        mDueDate.setText(new SimpleDateFormat("MM/dd/yyyy").format(mTask.getDueDate()));

        String assigner;
        if (mTask.getAssigner() == null) assigner = "None";
        else assigner = mTask.getAssigner().getName();
        mAssigner.setText(assigner);

        String location;
        if (mTask.getMiniSite() == null) location = "MiniSite " + String.valueOf(mTask.getMiniSiteId());
        else location = mTask.getMiniSite().getLocation();
        mLocation.setText(location);
    }

    //TODO Move this method to TaskFragment once the duplicate menu items bug is fixed.
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle item selection
        switch (item.getItemId()) {
            case R.id.edit:
                EditTaskFragment newTask = EditTaskFragment.newInstance(mTask);
                mParentActivity.replaceFragment(newTask);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    // Button Events

    public void onClick(View view){
        switch(view.getId()){
            case (R.id.field_report_button):
                fieldReportButtonPressed();
                break;
            default:
                break;
        }
    }

    public void fieldReportButtonPressed() {
        if (mTask.getFieldReport() == null) {
            mParentActivity.setFieldReportTask(mTask);
            mParentActivity.replaceFragment(AddFieldReportFragment.newInstance(mTask, mTask.getMiniSite()));
        } else {
            mParentActivity.replaceFragment(FieldReportFragment.newInstance(mTask.getFieldReport()));
        }
    }
}
