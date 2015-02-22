package com.blueprint.watershed.Tasks;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.support.v4.widget.SwipeRefreshLayout;
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

    private static int TASK_TYPE;

    private static final int USER = 0;
    private static final int ALL = 1;


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
        setHasOptionsMenu(true);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
        mParentActivity = (MainActivity) getActivity();
        mAllTaskList = new ArrayList<Task>();
        mUserTaskList = new ArrayList<Task>();
        Bundle args = getArguments();
        if (args != null) TASK_TYPE = args.getInt(OPTION);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View finalView = inflater.inflate(R.layout.fragment_task_list, container, false);
        initializeViews(finalView);
        mSwipeLayout.setRefreshing(true);
        getTasksRequest();
        return finalView;
    }

    /**
     * Initializes all the views in the fragment.
     * This includes the adapters, buttons, listview, etc.
     * @param view
     */
    private void initializeViews(View view) {
        mListView = (ListView) view.findViewById(android.R.id.list);
        mAllTaskAdapter = new TaskAdapter(mParentActivity,R.layout.task_list_row, mAllTaskList);
        mUserTaskAdapter = new TaskAdapter(mParentActivity,R.layout.task_list_row, mUserTaskList);

        if (TASK_TYPE == USER) mListView.setAdapter(mUserTaskAdapter);
        else mListView.setAdapter(mAllTaskAdapter);
        mListView.setEmptyView(view.findViewById(R.id.no_tasks_layout));

        mNoTasksRefresh = (Button) view.findViewById(R.id.no_tasks_refresh);
        mNoTasksRefresh.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mSwipeLayout.setRefreshing(true);
                getTasksRequest();
            }
        });

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

    /**
     * Starts a new fragment for the corresponding task view
     * @param l
     * @param v
     * @param position
     * @param id
     */
    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        Task taskClicked;
        if (TASK_TYPE == USER) taskClicked = mUserTaskList.get(position);
        else taskClicked = mAllTaskList.get(position);

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
        menu.clear();
        inflater.inflate(R.menu.create_task_menu, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    /**
     * Gets all the tasks in the server and updates the ListView accordingly,
     * depending on what tab is being clicked on.
     */
    private void getTasksRequest(){
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        TaskListRequest taskListRequest = new TaskListRequest(getActivity(), params, new Response.Listener<ArrayList<Task>>() {
            @Override
            public void onResponse(ArrayList<Task> tasks) {
                setTasks(tasks);
                mParentActivity.getSpinner().setVisibility(View.GONE);
                mAllTaskAdapter.notifyDataSetChanged();
                mUserTaskAdapter.notifyDataSetChanged();
                if (mSwipeLayout != null) mSwipeLayout.setRefreshing(false);
            }
        });
        mNetworkManager.getRequestQueue().add(taskListRequest);
    }


    /**
     * Sets the tasks for all tasks list and user tasks lists
     * @param tasks
     */
    private void setTasks(ArrayList<Task> tasks){
        mAllTaskList.clear();
        mUserTaskList.clear();
        int id = mParentActivity.getUserId();
        for (Task task : tasks){
            mAllTaskList.add(task);
            if (task.getAssigneeId() != null) {
                if (task.getAssigneeId() == id) mUserTaskList.add(task);
            }
        }
    }

    /**
     * Interface for the fragment to communicate with the activity
     * Implemented in MainActivity.
     */
    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

}
