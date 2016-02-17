package com.blueprint.watershed.Tasks.TaskList;

import com.blueprint.watershed.Tasks.Task;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by charlesx on 4/16/15.
 */
public class AllTaskListFragment extends TaskListAbstractFragment {

    public static AllTaskListFragment newInstance() {
        return new AllTaskListFragment();
    }

    public void refreshTaskList(List<Task> tasks) {
        if (tasks.size() > 0) {
            setAllTasks(tasks);
            for (int i = 0; i < mTaskAdapter.getGroupCount(); i++) mListView.expandGroup(i);
        }
        toggleList();
    }

    /**
     * Sets the tasks for all tasks list and user tasks lists
     * @param tasks - ArrayList of all tasks from server
     */
    private void setAllTasks(List<Task> tasks) {
        HashMap<String, List<Task>> taskList = new HashMap<String, List<Task>>();
        List<String> headers = new ArrayList<String>();
        List<Task> allFinishedTasks = new ArrayList<Task>();
        List<Task> allUncompleteTasks = new ArrayList<Task>();
        for (Task task : tasks){
            if (task.getComplete()) allFinishedTasks.add(task);
            else allUncompleteTasks.add(task);
        }
        if (allUncompleteTasks.size() > 0) {
            headers.add(INCOMPLETE);
            taskList.put(INCOMPLETE, allUncompleteTasks);
        }
        if (allFinishedTasks.size() > 0) {
            headers.add(COMPLETE);
            taskList.put(COMPLETE, allFinishedTasks);
        }
        setTasksAndHeaders(taskList, headers);
    }

    public boolean rightTaskType(Task task) {
        return true;
    }
}
