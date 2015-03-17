package com.blueprint.watershed.Users;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.support.v4.app.Fragment;
import android.support.v4.app.ListFragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Tasks.TaskListRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.SiteListAdapter;
import com.blueprint.watershed.Tasks.BasicTaskAdapter;
import com.blueprint.watershed.Tasks.Task;
import com.blueprint.watershed.Tasks.TaskAdapter;
import com.blueprint.watershed.Tasks.TaskFragment;
import com.blueprint.watershed.Views.HeaderGridView;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;


public class UserTaskFragment extends Fragment {

    MainActivity mParentActivity;
    NetworkManager mNetworkManager;
    private LinearLayoutManager mLayoutManager;

    private ArrayList<Task> mUserTaskList;
    private BasicTaskAdapter mUserTaskAdapter;

    private HeaderGridView mTaskGridView;

    private User mUser;


    private ListView mListView;
    private SwipeRefreshLayout mSwipeLayout;

    public static UserTaskFragment newInstance(User user) {
        UserTaskFragment fragment = new UserTaskFragment();
        fragment.configureWithUser(user);
        return fragment;
    }


    public UserTaskFragment(){}

    public void configureWithUser(User user) {
        mUser = user;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
        mParentActivity = (MainActivity) getActivity();
        mUserTaskList = new ArrayList<Task>();
    }

    public void configureViewWithUser(View view, User user) {
        int taskNumber;
        if (user.getTasksCount() != null){
            taskNumber = user.getTasksCount();
        }
        else{
            taskNumber = 0;
        }
        ((TextView)view.findViewById(R.id.user_name)).setText(mUser.getName() + "\'s Tasks");

        ((TextView)view.findViewById(R.id.user_objects)).setText(String.valueOf(taskNumber) + " Tasks");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_user_task, container, false);

        // Create MiniSite Grid View
        mTaskGridView = (HeaderGridView) view.findViewById(R.id.mini_sites_grid);

        // Add user header information to the top
        ViewGroup header = (ViewGroup)inflater.inflate(R.layout.user_header_view, mTaskGridView, false);
        mTaskGridView.addHeaderView(header, null, false);
        mTaskGridView.setEmptyView(view.findViewById(R.id.no_tasks_layout));

        // Configure the header
        configureViewWithUser(header, mUser);

        // Set the adapter to fill the list of tasks
        mUserTaskAdapter = new BasicTaskAdapter(mParentActivity, R.layout.task_list_row, getTasks());
        mTaskGridView.setAdapter(mUserTaskAdapter);

        return view;
    }


    @Override
    public void onResume() {
        super.onResume();
        //mSwipeLayout.setRefreshing(true);
        getTasksRequest();
    }


    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.empty, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    private void setTasks(ArrayList<Task> tasks, int id){
        mUserTaskList.clear();
        for (Task task : tasks){
            if (task.getAssigneeId() != null) {
                if (task.getAssigneeId() == id) mUserTaskList.add(task);
            }
        }
    }

    private ArrayList<Task> getTasks(){
        return mUserTaskList;
    }

    protected void getTasksRequest() {
        TaskListRequest taskListRequest = new TaskListRequest(mParentActivity,
                new HashMap<String, JSONObject>(),
                new Response.Listener<ArrayList<Task>>() {
            @Override
            public void onResponse(ArrayList<Task> tasks) {
                setTasks(tasks, mUser.getId());
                mUserTaskAdapter.notifyDataSetChanged();
            }
        }, mSwipeLayout);
        mNetworkManager.getRequestQueue().add(taskListRequest);
    }


}
