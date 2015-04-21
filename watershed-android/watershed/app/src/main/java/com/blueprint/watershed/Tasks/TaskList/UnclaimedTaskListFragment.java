package com.blueprint.watershed.Tasks.TaskList;

import com.android.volley.Response;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Networking.Users.UserMiniSitesRequest;
import com.blueprint.watershed.Tasks.Task;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class UnclaimedTaskListFragment extends TaskListAbstractFragment {

    private ArrayList<MiniSite> mUserMiniSiteList;

    public static UnclaimedTaskListFragment newInstance() {
        return new UnclaimedTaskListFragment();
    }

    public void refreshTaskList(List<Task> tasks) {
        getMiniSiteRequest();
        tasks = getUnclaimedTasks(tasks);
        if (tasks.size() > 0) {
            showList();
            setUnclaimedTasks(tasks);
            for (int i = 0; i < mTaskAdapter.getGroupCount(); i++) mListView.expandGroup(i);
        } else {
            hideList();
        }
    }

    private void setMiniSites(ArrayList<MiniSite> miniSites){
        mUserMiniSiteList.clear();
        for (MiniSite miniSite : miniSites){
            mUserMiniSiteList.add(miniSite);
        }
    }

    private void setUnclaimedTasks(List<Task> tasks) {
        HashMap<String, List<Task>> taskList = new HashMap<String, List<Task>>();
        List<String> headers = new ArrayList<String>();
        tasks = getUnclaimedTasks(tasks);
        List<Task> userFinishedTasks = new ArrayList<Task>();
        List<Task> userUncompleteTasks = new ArrayList<Task>();
        for (Task task : tasks){
            if (task.getComplete()) userFinishedTasks.add(task);
            else userUncompleteTasks.add(task);
        }
        if (userUncompleteTasks.size() > 0) {
            headers.add(INCOMPLETE);
            taskList.put(INCOMPLETE, userUncompleteTasks);
        }
        if (userFinishedTasks.size() > 0) {
            headers.add(COMPLETE);
            taskList.put(COMPLETE, userFinishedTasks);
        }
        setTasks(taskList);
        setHeaders(headers);
    }

    private ArrayList<Task> getUnclaimedTasks(List<Task> tasks) {
        ArrayList<Task> unclaimedTasks = new ArrayList<Task>();
        for (Task task : tasks) {
            Integer id = task.getMiniSiteId();
            if (id != null && mUserMiniSiteList.contains(id)) unclaimedTasks.add(task);
        }
        return unclaimedTasks;
    }

    protected void getMiniSiteRequest() {
        UserMiniSitesRequest miniSitesRequest = new UserMiniSitesRequest(mParentActivity,
                new HashMap<String, JSONObject>(),
                new Response.Listener<ArrayList<MiniSite>>() {
                    @Override
                    public void onResponse(ArrayList<MiniSite> miniSites) {
                        setMiniSites(miniSites);
                    }
                }, mParentActivity.getUserId());
        mNetworkManager.getRequestQueue().add(miniSitesRequest);
    }
}
