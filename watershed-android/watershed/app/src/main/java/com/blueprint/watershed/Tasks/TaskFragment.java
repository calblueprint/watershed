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
import android.widget.ExpandableListView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Tasks.TaskListRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

public class TaskFragment extends ListFragment implements ExpandableListView.OnChildClickListener {

    private static final String OPTION = "option";

    private static String INCOMPLETE = "Incomplete Tasks";
    private static String COMPLETE = "Completed Tasks";

    private static int TASK_TYPE;

    private static final int USER = 0;
    private static final int ALL = 1;


    private OnFragmentInteractionListener mListener;
    private MainActivity mParentActivity;
    private NetworkManager mNetworkManager;

    private HashMap<String, List<Task>> mAllTaskList;
    private HashMap<String, List<Task>> mUserTaskList;
    private List<String> mTaskListHeaders;
    private TaskAdapter mAllTaskAdapter;
    private TaskAdapter mUserTaskAdapter;
    

    private ExpandableListView mListView;
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
        mAllTaskList = new HashMap<String, List<Task>>();
        mUserTaskList = new HashMap<String, List<Task>>();
        String [] headers = { INCOMPLETE, COMPLETE };
        mTaskListHeaders = Arrays.asList(headers);
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
     * @param view - Parent view
     */
    private void initializeViews(View view) {
        mListView = (ExpandableListView) view.findViewById(android.R.id.list);
        mAllTaskAdapter = new TaskAdapter(mParentActivity, mTaskListHeaders, mAllTaskList);
        mUserTaskAdapter = new TaskAdapter(mParentActivity, mTaskListHeaders, mUserTaskList);

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
     * Gets the clicked position
     * @param parent - Listview
     * @param v - View that was clicked
     * @param groupPosition - Group that was clicked
     * @param childPosition - Child that was clicked
     * @param id - id of the view
     * @return boolean of result
     */
    @Override
    public boolean onChildClick(ExpandableListView parent, View v,
                             int groupPosition, int childPosition, long id) {
        Task taskClicked;
        if (TASK_TYPE == USER) taskClicked = mUserTaskList.get(mTaskListHeaders.get(groupPosition)).get(childPosition);
        else taskClicked = mAllTaskList.get(mTaskListHeaders.get(groupPosition)).get(childPosition);

        TaskDetailFragment detailFragment = TaskDetailFragment.newInstance(taskClicked);
        mParentActivity.replaceFragment(detailFragment);
        return true;
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
                if (tasks.size() > 0) {
                    if (TASK_TYPE == USER) {
                        setUserTasks(tasks);
                        mUserTaskAdapter.notifyDataSetChanged();
                    } else {
                        setAllTasks(tasks);
                        mAllTaskAdapter.notifyDataSetChanged();
                    }
                }
                mParentActivity.getSpinner().setVisibility(View.GONE);
                if (mSwipeLayout != null) mSwipeLayout.setRefreshing(false);
            }
        });
        mNetworkManager.getRequestQueue().add(taskListRequest);
    }


    /**
     * Sets the tasks for all tasks list and user tasks lists
     * @param tasks - ArrayList of all tasks from server
     */
    private void setAllTasks(ArrayList<Task> tasks){
        mAllTaskList.clear();
        List<Task> allFinishedTasks = new ArrayList<Task>();
        List<Task> allUncompleteTasks = new ArrayList<Task>();
        for (Task task : tasks){
            if (task.getComplete()) allFinishedTasks.add(task);
            else allUncompleteTasks.add(task);
        }
        mAllTaskList.put(INCOMPLETE, allUncompleteTasks);
        mAllTaskList.put(COMPLETE, allFinishedTasks);
    }

    private void setUserTasks(ArrayList<Task> tasks) {
        mUserTaskList.clear();
        List<Task> userFinishedTasks = new ArrayList<Task>();
        List<Task> userUncompleteTasks = new ArrayList<Task>();
        int id = mParentActivity.getUserId();
        for (Task task : tasks){
            if (task.getAssigneeId() == id) {
                if (task.getComplete()) userFinishedTasks.add(task);
                else userUncompleteTasks.add(task);
            }
        }
        mUserTaskList.put(INCOMPLETE, userUncompleteTasks);
        mUserTaskList.put(COMPLETE, userFinishedTasks);
    }

    /**
     * Interface for the fragment to communicate with the activity
     * Implemented in MainActivity.
     */
    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

}
