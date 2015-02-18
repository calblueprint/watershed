package com.blueprint.watershed.Tasks;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Tasks.TaskListRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

public class TaskFragment extends ListFragment {

    private static final String OPTION = "option";

    private OnFragmentInteractionListener mListener;
    private MainActivity mParentActivity;
    private NetworkManager mNetworkManager;

    private ArrayList<Task> mAllTaskList;
    private ArrayList<Task> mUserTaskList;
    private TaskAdapter mAllTaskAdapter;
    private TaskAdapter mUserTaskAdapter;
    

    private ListView mListView;
    private Button mNoTasksRefresh;
    private SwipeRefreshLayout mSwipeLayout;

    public static TaskFragment newInstance(int option) {
        TaskFragment fragment = new TaskFragment();
        Bundle args = new Bundle();
        args.putInt(OPTION, option);
        fragment.setArguments(args);
        return fragment;
    }

    public TaskFragment(){
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //setHasOptionsMenu(true);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
        mParentActivity = (MainActivity) getActivity();
        mAllTaskList = new ArrayList<Task>();
        mUserTaskList = new ArrayList<Task>();
        getTasksRequest();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View finalView = inflater.inflate(R.layout.fragment_task_list, container, false);
        initializeViews(finalView);
        return finalView;
    }

    private void initializeViews(View view) {
        mListView = (ListView) view.findViewById(android.R.id.list);
        mAllTaskAdapter = new TaskAdapter(mParentActivity,R.layout.task_list_row, mAllTaskList);
        mUserTaskAdapter = new TaskAdapter(mParentActivity,R.layout.task_list_row, mUserTaskList);

        if (getArguments() != null) {
            int option = getArguments().getInt(OPTION);
            if (option == 1) {
                mListView.setAdapter(mUserTaskAdapter);
            } else {
                mListView.setAdapter(mAllTaskAdapter);
            }
        } else {
            mListView.setAdapter(mAllTaskAdapter);
        }

        mListView.setEmptyView(view.findViewById(R.id.no_tasks_layout));

        mNoTasksRefresh = (Button) view.findViewById(R.id.no_tasks_refresh);
        mNoTasksRefresh.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mParentActivity.getSpinner().setVisibility(View.VISIBLE);
                getTasksRequest();
            }
        });

        mSwipeLayout = (SwipeRefreshLayout) view.findViewById(R.id.tasks_swipe_container);
        mSwipeLayout.setColorSchemeResources(R.color.ws_blue, R.color.facebook_blue, R.color.facebook_dark_blue, R.color.dark_gray);
        mSwipeLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                getTasksRequest();
            }
        });
    }

    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        if (getArguments() != null) {
            int option = getArguments().getInt(OPTION);
            Task taskClicked;
            if (option == 1) {
                 taskClicked = mUserTaskList.get(position);
            } else {
                taskClicked = mAllTaskList.get(position);
            }
            TaskDetailFragment detailFragment = TaskDetailFragment.newInstance(taskClicked);
            mParentActivity.replaceFragment(detailFragment);
        } else {
            Log.i("Error", "OnListItemClick is broken!");
        }
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
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.create_task_menu, menu);
    }


    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    private void getTasksRequest(){
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        TaskListRequest taskListRequest = new TaskListRequest(getActivity(), params, new Response.Listener<ArrayList<Task>>() {
            @Override
            public void onResponse(ArrayList<Task> tasks) {
                setTasks(tasks);
                mParentActivity.getSpinner().setVisibility(View.GONE);
                mTaskAdapter.notifyDataSetChanged();
                if (mSwipeLayout != null) mSwipeLayout.setRefreshing(false);
            }
        });

        mNetworkManager.getRequestQueue().add(taskListRequest);
    }
    
    private void setTasks(ArrayList<Task> tasks){
        mAllTaskList.clear();
        mUserTaskList.clear();
        int id = mParentActivity.getUser().getId();
        for (Task task : tasks){
            mAllTaskList.add(task);
            if (task.getAssigneeId() == id) mUserTaskList.add(task);
        }
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

}