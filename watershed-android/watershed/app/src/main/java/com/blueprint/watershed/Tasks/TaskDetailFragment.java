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
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.R;

import java.text.SimpleDateFormat;


public class TaskDetailFragment extends Fragment implements View.OnClickListener {

    private MainActivity mParentActivity;
    private Task mTask;
    private NetworkManager mNetworkManager;

    private Button mFieldReportButton;
    private TextView mDetailTitle;
    private TextView mDescription;
    private TextView mAssigner;
    private TextView mDueDate;


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
        inflater.inflate(R.menu.edit_task_menu, menu);
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

        mDetailTitle = (TextView) mParentActivity.findViewById(R.id.task_title);
        mDescription = (TextView) mParentActivity.findViewById(R.id.task_description);
        mDueDate = (TextView) mParentActivity.findViewById(R.id.task_due_date);
        mAssigner = (TextView) mParentActivity.findViewById(R.id.task_assigner);

        mDetailTitle.setText(mTask.getTitle());
        mDescription.setText(mTask.getDescription());
        mDueDate.setText(new SimpleDateFormat("MM/dd/yyyy").format(mTask.getDueDate()));
    }

    //TODO Move this method to TaskFragment once the duplicate menu items bug is fixed.
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle item selection
        switch (item.getItemId()) {
            case R.id.edit_task:
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
                fieldReportButtonPressed(view);
                break;
            default:
                break;
        }
    }

    public void fieldReportButtonPressed(View view){
        AddFieldReportFragment fieldFragment = AddFieldReportFragment.newInstance();
        mParentActivity.setFieldReportTask(mTask);
        mParentActivity.replaceFragment(fieldFragment);
    }
}
