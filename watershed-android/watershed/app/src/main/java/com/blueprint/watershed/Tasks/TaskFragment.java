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

    private OnFragmentInteractionListener mListener;
    private ListView mListView1;
    private ArrayList<Task> mTaskList;
    private MainActivity mParentActivity;
    private TaskAdapter mTaskAdapter;
    private NetworkManager mNetworkManager;

    private Button mNoTasksRefresh;
    private SwipeRefreshLayout mSwipeLayout;

    public static TaskFragment newInstance(int option) {
        TaskFragment fragment = new TaskFragment();
        Bundle args = new Bundle();
        args.putInt("option", option);
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
        mTaskList = new ArrayList<Task>();
        if (getArguments() != null) {
            int option = getArguments().getInt("option");
            Log.i("option", String.valueOf(option));
            getTasksRequest();
            switch (option) {
                case 0: //populates with tasks that you are assigned
                    break;
                case 1: //populates with all tasks
                    break;
            }
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View finalView = inflater.inflate(R.layout.fragment_task_list, container, false);
        initializeViews(finalView);
        return finalView;
    }

    private void initializeViews(View view) {
        mListView1 = (ListView) view.findViewById(android.R.id.list);
        mTaskAdapter = new TaskAdapter(mParentActivity,R.layout.task_list_row, mTaskList);
        mListView1.setAdapter(mTaskAdapter);
        mListView1.setEmptyView(view.findViewById(R.id.no_tasks_layout));

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
    public void onListItemClick(ListView l, View v, int position, long id){
        Task taskClicked = this.mTaskList.get(position);
        TaskDetailFragment detailFragment = TaskDetailFragment.newInstance(taskClicked);
        mParentActivity.replaceFragment(detailFragment);
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
        mTaskList.clear();
        for (Task task : tasks){
            mTaskList.add(task);
        }
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

}