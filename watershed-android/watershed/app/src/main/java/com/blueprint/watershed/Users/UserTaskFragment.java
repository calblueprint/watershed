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

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Tasks.TaskListRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.SiteListAdapter;
import com.blueprint.watershed.Tasks.Task;
import com.blueprint.watershed.Tasks.TaskAdapter;
import com.blueprint.watershed.Tasks.TaskFragment;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;


public class UserTaskFragment extends ListFragment {

    MainActivity mParentActivity;
    NetworkManager mNetworkManager;
    private LinearLayoutManager mLayoutManager;

    private ArrayList<Task> mUserTaskList;
    private TaskAdapter mUserTaskAdapter;

    private static String ID = "id";
    private int mId;


    private ListView mListView;
    private SwipeRefreshLayout mSwipeLayout;

    public static UserTaskFragment newInstance(int id) {
        UserTaskFragment fragment = new UserTaskFragment();
        Bundle args = new Bundle();
        args.putInt(ID, id);
        fragment.setArguments(args);
        return fragment;
    }

    public UserTaskFragment(){}

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
        mParentActivity = (MainActivity) getActivity();
        mUserTaskList = new ArrayList<Task>();
        Bundle args = getArguments();
        if (args != null) mId = args.getInt(ID);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View finalView = inflater.inflate(R.layout.fragment_user_task, container, false);
        initializeViews(finalView);
        return finalView;
    }

    /**
     * Initializes all the views in the fragment.
     * This includes the adapters, buttons, listview, etc.
     * @param view
     */
    private void initializeViews(View view) {
        mListView = (ListView) view.findViewById(android.R.id.list);
        mUserTaskAdapter = new TaskAdapter(mParentActivity,R.layout.task_list_row, mUserTaskList);

        mListView.setAdapter(mUserTaskAdapter);
        mListView.setEmptyView(view.findViewById(R.id.no_tasks_layout));

        mSwipeLayout = (SwipeRefreshLayout) view.findViewById(R.id.tasks_swipe_container);
        mSwipeLayout.setColorSchemeResources(R.color.ws_blue, R.color.facebook_blue, R.color.facebook_dark_blue, R.color.dark_gray);
        mSwipeLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                mSwipeLayout.setRefreshing(true);
                getTasksRequest();
            }
        });
    }


    @Override
    public void onResume() {
        super.onResume();
        mSwipeLayout.setRefreshing(true);
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
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        TaskListRequest taskListRequest = new TaskListRequest(getActivity(), params, new Response.Listener<ArrayList<Task>>() {
            @Override
            public void onResponse(ArrayList<Task> tasks) {
                setTasks(tasks, mId);
                mUserTaskAdapter.notifyDataSetChanged();
                new CountDownTimer(1000, 1000) {
                    @Override
                    public void onTick(long timeLeft) {
                    }

                    @Override
                    public void onFinish() {
                        mSwipeLayout.setRefreshing(false);
                    }
                }.start();
            }
        });
        mNetworkManager.getRequestQueue().add(taskListRequest);
    }


}
