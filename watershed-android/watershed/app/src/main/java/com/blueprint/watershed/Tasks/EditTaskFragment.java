package com.blueprint.watershed.Tasks;

import android.os.Bundle;

import com.blueprint.watershed.Utilities.Utility;

/**
 * Created by charlesx on 2/19/15.
 * Fragment to edit tasks
 */
public class EditTaskFragment extends TaskAbstractFragment {

    private Task mTask;

    /**
     * Creates a fragment and sets the task for the fragment.
     * @param task - Task you want to edit.
     * @return - an EditTaskFragment instance.
     */
    public static EditTaskFragment newInstance(Task task) {
        EditTaskFragment fragment =  new EditTaskFragment();
        fragment.setTask(task);
        return fragment;
    }

    private void setTask(Task task) { mTask = task; }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        setButtonListeners();
        setTextViews();
    }

    /**
     * Presets the task with task information
     */
    private void setTextViews() {
        if (mTask.getTitle() != null) mTitleField.setText(mTask.getTitle());
        if (mTask.getDescription() != null) mDescriptionField.setText(mTask.getDescription());
        if (mTask.getAssigneeId() != null) mAssigneeField.setText(String.valueOf(mTask.getAssigneeId()));
        if (mTask.getDueDate() != null) mDueDateField.setText(String.valueOf(mTask.getDueDate().toString()));
        if (mTask.getMiniSiteId() != null) mMiniSiteId.setText(String.valueOf(mTask.getMiniSiteId()));
    }

    @Override
    public void submitListener() {
        Utility.hideKeyboard(mParentActivity, mLayout);
        createTask(EDIT, mTask);
    }
}
