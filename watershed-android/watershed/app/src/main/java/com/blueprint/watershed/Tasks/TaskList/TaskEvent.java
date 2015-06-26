package com.blueprint.watershed.Tasks.TaskList;

import com.blueprint.watershed.Tasks.Task;

/**
 * Created by charlesx on 6/18/15.
 */

public class TaskEvent {

    private Task task;
    private TaskEnum type;

    public TaskEvent(Task task, TaskEnum type) {
        this.task = task;
        this.type = type;
    }

    public Task getTask() {
        return task;
    }

    public TaskEnum getType() {
        return type;
    }
}
