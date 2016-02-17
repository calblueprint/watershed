package com.blueprint.watershed.Tasks.TaskList;

import android.os.Bundle;
import android.os.CountDownTimer;
import android.support.v4.app.ListFragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ExpandableListView;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Tasks.TaskListRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Tasks.CreateTaskFragment;
import com.blueprint.watershed.Tasks.Task;
import com.blueprint.watershed.Views.Material.FloatingActionButton;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 4/16/15.
 */
public abstract class TaskListAbstractFragment extends ListFragment {

    protected static String INCOMPLETE = "Incomplete Tasks";
    protected static String COMPLETE = "Completed Tasks";
    protected static String TASK_LIST_TAG = "TaskListTag";

    protected MainActivity mParentActivity;
    protected NetworkManager mNetworkManager;

    protected HashMap<String, List<Task>> mTaskList;
    protected List<String> mTaskListHeaders;
    protected TaskAdapter mTaskAdapter;

    protected FloatingActionButton mCreateTask;
    protected ExpandableListView mListView;
    protected SwipeRefreshLayout mNoTasks;
    protected SwipeRefreshLayout mSwipeLayout;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
        EventBus.getDefault().register(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View finalView = inflater.inflate(R.layout.fragment_task_list, container, false);
        initializeViews(finalView);
        refreshList();
        return finalView;
    }

    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setMenuAction(true);
        mParentActivity.setToolbarElevation(0);
    }

    @Override
    public void onPause() {
        super.onPause();
        RequestQueue requestQueue = mNetworkManager.getRequestQueue();
        if (requestQueue != null) {
            requestQueue.cancelAll(TASK_LIST_TAG);
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
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

        mListView.setChildDivider(mParentActivity.getResources().getDrawable(R.color.transparent));
        mListView.setDivider(mParentActivity.getResources().getDrawable(R.color.transparent));
        if (mTaskAdapter != null) mListView.setAdapter(mTaskAdapter);

        mNoTasks = (SwipeRefreshLayout) view.findViewById(R.id.no_tasks_layout);
        mNoTasks.setColorSchemeResources(R.color.ws_blue, R.color.facebook_blue, R.color.facebook_dark_blue, R.color.dark_gray);
        mNoTasks.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                mNoTasks.setRefreshing(true);
                getTasksRequest();
            }
        });

        if (mParentActivity.getUser().isManager()) {
            mCreateTask = (FloatingActionButton) view.findViewById(R.id.create_task_button);
            mCreateTask.setVisibility(View.VISIBLE);
            mCreateTask.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    CreateTaskFragment newTask = CreateTaskFragment.newInstance();
                    mParentActivity.replaceFragment(newTask);
                }
            });
        }
    }

    private void refreshList() {
        if (mTaskList == null) getTasksRequest();
        toggleList();
    }

    public void onEvent(TaskEvent event) {
        Task task = event.getTask();
        if (!rightTaskType(task)) return;
        switch (event.getType()) {
            case TASK_CREATED:
                addTaskToList(task);
                break;
            case TASK_EDITED:
                removeTaskFromList(task);
                addTaskToList(task);
                break;
            case TASK_DELETED:
                removeTaskFromList(task);
                break;
        }

        if (mTaskAdapter != null) mTaskAdapter.notifyDataSetChanged();
    }

    private void addTaskToList(Task task) {
        String type = task.getComplete() ? COMPLETE : INCOMPLETE;
        List<Task> taskList = getTaskList(type);
        taskList.add(0, task);
        mTaskList.put(type, taskList);
    }

    private void removeTaskFromList(Task task) {
        String type = task.getComplete() ? COMPLETE : INCOMPLETE;
        List<Task> taskList = getTaskList(type);
        for (Task taskObj : taskList) {
            if (taskObj.getId().equals(task.getId())) {
                taskList.remove(taskObj);
                break;
            }
        }
        mTaskList.put(type, taskList);
    }

    private List<Task> getTaskList(String type) {
        return mTaskList.containsKey(type) ?
                mTaskList.get(type) : new ArrayList<Task>();
    }

    public abstract boolean rightTaskType(Task task);

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.empty, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    /**
     * Gets all the tasks in the server and updates the ListView accordingly,
     * depending on what tab is being clicked on.
     */
    protected void getTasksRequest() {
        mSwipeLayout.setRefreshing(true);
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        TaskListRequest taskListRequest = new TaskListRequest(mParentActivity, params, new Response.Listener<ArrayList<Task>>() {
            @Override
            public void onResponse(ArrayList<Task> tasks) {
                refreshTaskList(tasks);
                setSwipeFalse();
            }
        }, this);
        taskListRequest.setTag(TASK_LIST_TAG);
        mNetworkManager.getRequestQueue().add(taskListRequest);
    }

    public abstract void refreshTaskList(List<Task> tasks);

    public void setSwipeFalse() {
        new CountDownTimer(1000, 1000) {
            public void onTick(long millisUntilFinished) {}
            public void onFinish() {
                if (mSwipeLayout != null) mSwipeLayout.setRefreshing(false);
                if (mNoTasks != null) mNoTasks.setRefreshing(false);
            }
        }.start();
    }

    public void toggleList() {
        if (mTaskList == null || mTaskList.size() == 0) {
            mNoTasks.setVisibility(View.VISIBLE);
            mSwipeLayout.setVisibility(View.GONE);
        } else {
            mNoTasks.setVisibility(View.GONE);
            mSwipeLayout.setVisibility(View.VISIBLE);
        }
    }

    public void setTasksAndHeaders(HashMap<String, List<Task>> tasks, List<String> headers) {
        if (mTaskList == null) mTaskList = new HashMap<>();
        mTaskList.clear();
        mTaskList.putAll(tasks);

        if (mTaskListHeaders == null) mTaskListHeaders = new ArrayList<>();
        mTaskListHeaders.clear();
        mTaskListHeaders.addAll(headers);

        if (mTaskAdapter == null) {
            mTaskAdapter = new TaskAdapter(mParentActivity, mTaskListHeaders, mTaskList);
            mListView.setAdapter(mTaskAdapter);
        }

        mTaskAdapter.notifyDataSetChanged();
    }
}
