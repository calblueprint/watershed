package com.blueprint.watershed.Tasks.TaskList;

import android.util.Log;

import com.blueprint.watershed.Tasks.Task;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class UserTaskListFragment extends TaskListAbstractFragment {

    public static UserTaskListFragment newInstance() {
        Log.e("New Instance Created", "User");
        return new UserTaskListFragment();
    }

    public void refreshTaskList(List<Task> tasks) {
        tasks = getUserTasks(tasks);
        if (tasks.size() > 0) {
            showList();
            setUserTasks(tasks);
            for (int i = 0; i < mTaskAdapter.getGroupCount(); i++) mListView.expandGroup(i);
        } else {
            hideList();
        }
    }

    private void setUserTasks(List<Task> tasks) {
        HashMap<String, List<Task>> taskList = new HashMap<String, List<Task>>();
        List<String> headers = new ArrayList<String>();
        tasks = getUserTasks(tasks);
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

    private ArrayList<Task> getUserTasks(List<Task> tasks) {
        ArrayList<Task> userTasks = new ArrayList<Task>();
        for (Task task : tasks) {
            Integer id = task.getAssigneeId();
            if (id != null && id == mParentActivity.getUserId()) userTasks.add(task);
        }
        return userTasks;
    }
}
