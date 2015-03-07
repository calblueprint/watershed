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
import android.widget.AbsListView;
import android.widget.ExpandableListView;
import android.widget.RelativeLayout;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Tasks.TaskListRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class TaskFragment extends ListFragment {

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
    private RelativeLayout mNoTasks;
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
        mTaskListHeaders = new ArrayList<String>();

        Bundle args = getArguments();
        TASK_TYPE = args.getInt(OPTION);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View finalView = inflater.inflate(R.layout.fragment_task_list, container, false);
        initializeViews(finalView);
        hideList();
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
        mSwipeLayout = (SwipeRefreshLayout) view.findViewById(R.id.tasks_swipe_container);
        mSwipeLayout.setColorSchemeResources(R.color.ws_blue, R.color.facebook_blue, R.color.facebook_dark_blue, R.color.dark_gray);
        mSwipeLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                mSwipeLayout.setRefreshing(true);
                getTasksRequest();
            }
        });

        mListView = (ExpandableListView) view.findViewById(android.R.id.list);
        mListView.setOnChildClickListener(new ExpandableListView.OnChildClickListener() {
            @Override
            public boolean onChildClick(ExpandableListView expandableListView, View view, int groupPosition, int childPosition, long l) {
                Log.i("asdf", "clicked");
                Task taskClicked;
                if (TASK_TYPE == USER) taskClicked = mUserTaskList.get(mTaskListHeaders.get(groupPosition)).get(childPosition);
                else taskClicked = mAllTaskList.get(mTaskListHeaders.get(groupPosition)).get(childPosition);

                TaskDetailFragment detailFragment = TaskDetailFragment.newInstance(taskClicked);
                mParentActivity.replaceFragment(detailFragment);
                return false;
            }
        });
        mListView.setOnScrollListener(new AbsListView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView view, int scrollState) {

            }

            @Override
            public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
                int topRowVerticalPosition = (mListView == null || mListView.getChildCount() == 0) ?
                        0 : mListView.getChildAt(0).getTop();
                mSwipeLayout.setEnabled((topRowVerticalPosition >= 0));
            }
        });
        mNoTasks = (RelativeLayout) view.findViewById(R.id.no_tasks_layout);
        mAllTaskAdapter = new TaskAdapter(mParentActivity, mTaskListHeaders, mAllTaskList);
        mUserTaskAdapter = new TaskAdapter(mParentActivity, mTaskListHeaders, mUserTaskList);

        if (TASK_TYPE == USER) mListView.setAdapter(mUserTaskAdapter);
        else mListView.setAdapter(mAllTaskAdapter);
//        mListView.setEmptyView(mNoTasks);
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
        Log.i("watasdfasdf", String.valueOf(TASK_TYPE));
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        TaskListRequest taskListRequest = new TaskListRequest(getActivity(), params, new Response.Listener<ArrayList<Task>>() {
            @Override
            public void onResponse(ArrayList<Task> tasks) {
                if (TASK_TYPE == USER) {
                    tasks = getUserTasks(tasks);
                    if (tasks.size() > 0) {
                        showList();
                        setUserTasks(tasks);
                        mUserTaskAdapter.notifyDataSetChanged();
                    } else {
                        hideList();
                    }
                } else {
                    if (tasks.size() > 0) {
                        showList();
                        setAllTasks(tasks);
                        mAllTaskAdapter.notifyDataSetChanged();
                    } else {
                        hideList();
                    }
                }
                mListView.expandGroup(0, true);
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
        mTaskListHeaders.clear();
        List<Task> allFinishedTasks = new ArrayList<Task>();
        List<Task> allUncompleteTasks = new ArrayList<Task>();
        for (Task task : tasks){
            if (task.getComplete()) allFinishedTasks.add(task);
            else allUncompleteTasks.add(task);
        }
        if (allUncompleteTasks.size() > 0) {
            mTaskListHeaders.add(INCOMPLETE);
            mAllTaskList.put(INCOMPLETE, allUncompleteTasks);
        }
        if (allFinishedTasks.size() > 0) {
            mTaskListHeaders.add(COMPLETE);
            mAllTaskList.put(COMPLETE, allFinishedTasks);
        }
    }

    private void setUserTasks(ArrayList<Task> tasks) {
        mUserTaskList.clear();
        mTaskListHeaders.clear();
        tasks = getUserTasks(tasks);
        List<Task> userFinishedTasks = new ArrayList<Task>();
        List<Task> userUncompleteTasks = new ArrayList<Task>();
        for (Task task : tasks){
            if (task.getComplete()) userFinishedTasks.add(task);
            else userUncompleteTasks.add(task);
        }
        if (userUncompleteTasks.size() > 0) {
            mTaskListHeaders.add(INCOMPLETE);
            mUserTaskList.put(INCOMPLETE, userUncompleteTasks);
        }
        if (userFinishedTasks.size() > 0) {
            mTaskListHeaders.add(COMPLETE);
            mUserTaskList.put(COMPLETE, userFinishedTasks);
        }
    }

    private ArrayList<Task> getUserTasks(ArrayList<Task> tasks) {
        ArrayList<Task> userTasks = new ArrayList<Task>();
        for (Task task : tasks) {
            if (task.getAssigneeId() == mParentActivity.getUserId()) userTasks.add(task);
        }
        return userTasks;
    }

    /**
     * Interface for the fragment to communicate with the activity
     * Implemented in MainActivity.
     */
    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

    public void showList() {
        mNoTasks.setVisibility(View.GONE);
        mListView.setVisibility(View.VISIBLE);
    }

    public void hideList() {
        mNoTasks.setVisibility(View.VISIBLE);
        mListView.setVisibility(View.GONE);
    }

}
