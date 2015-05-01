package com.blueprint.watershed.Tasks;

import android.content.DialogInterface;
import android.content.res.Resources;
import android.graphics.Color;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.RelativeLayout;
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
    private TextView mMiniSiteName;
    private TextView mDetailTitle;
    private TextView mDescription;
    private TextView mAssigner;
    private TextView mAssignee;
    private TextView mDueDate;
    private TextView mLocation;
    private RelativeLayout mBackgroundColor;

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
        mParentActivity.setToolbarElevation(0);
    }

    private void initializeViews(View view) {
        setButtonListeners(view);

        refreshCompletion();

        mDetailTitle = (TextView) view.findViewById(R.id.task_title);
        mDescription = (TextView) view.findViewById(R.id.task_description);
        mDueDate = (TextView) view.findViewById(R.id.task_due_date);
        mAssigner = (TextView) view.findViewById(R.id.task_assigner);
        mAssignee = (TextView) view.findViewById(R.id.task_assignee);
        mLocation = (TextView) view.findViewById(R.id.task_location);
        mMiniSiteName = (TextView) view.findViewById(R.id.task_site_name);
        mBackgroundColor = (RelativeLayout) view.findViewById(R.id.task_title_container);

        mDetailTitle.setText(mTask.getTitle());

        SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy", Locale.US);
        if (mTask.getDueDate() != null) mDueDate.setText(sdf.format(mTask.getDueDate()));

        String assigner;
        if (mTask.getAssigner() == null) assigner = "None";
        else assigner = mTask.getAssigner().getName();
        mAssigner.setText("Assigned by: " + assigner);

        String assignee;
        if (mTask.getAssignee() == null) assignee = "None";
        else assignee = mTask.getAssignee().getName();
        mAssignee.setText("Assigned to: " + assignee);

        String location;
        if (mTask.getMiniSite() == null) location = "MiniSite " + String.valueOf(mTask.getMiniSiteId());
        else location = mTask.getMiniSite().getLocationOneLine();
        mLocation.setText(location);

        String description;
        if (mTask.getDescription() == null) description = "No Description";
        else description = mTask.getDescription();
        mDescription.setText(description);

        String site;
        if (mTask.getMiniSite() == null) site = "No Minisite";
        else site = mTask.getMiniSite().getName();
        mMiniSiteName.setText(site);

        if (mTask.getColor() != null) {
            mParentActivity.setToolBarColor(Color.parseColor(mTask.getColor()),
                                            Utility.getSecondaryColor(mParentActivity, mTask.getColor()));

            mBackgroundColor.setBackgroundColor(Color.parseColor(mTask.getColor()));
            mCompleteButton.setBackgroundColor(Color.parseColor(mTask.getColor()));
        }
    }

    private void setButtonListeners(View view){
        View editTaskButton = view.findViewById(R.id.edit_task_button);
        editTaskButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mParentActivity.replaceFragment(EditTaskFragment.newInstance(mTask));
            }
        });
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
                bottomButton();
                break;
            default:
                break;
        }
    }

    @Override
    public void submitListener() {}


    public void bottomButton() {
        if (mTask.getFieldReport() == null) {
            mParentActivity.setFieldReportTask(mTask);
            mParentActivity.replaceFragment(AddFieldReportFragment.newInstance(mTask, mTask.getMiniSite()));
        } else {
            mParentActivity.replaceFragment(FieldReportFragment.newInstance(mTask.getFieldReport()));
        }
    }

    public void refreshCompletion() {
        String submit;
        int color;
        if (mTask.getAssignee() == null) {
            submit = "CLAIM TASK";
            color = Color.parseColor(mTask.getColor());
        } else if (mTask.getFieldReport() != null) {
            submit = "VIEW FIELD REPORT";
            color = Color.parseColor(mTask.getColor());
        } else {
            submit = "COMPLETE";
            color = Utility.getSecondaryColor(mParentActivity, mTask.getColor());
        }
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

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        Resources resources = mParentActivity.getResources();
        mParentActivity.setToolBarColor(resources.getColor(R.color.ws_blue), resources.getColor(R.color.ws_title_bar));
    }
}
