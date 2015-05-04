package com.blueprint.watershed.Tasks;

import android.os.Bundle;

import java.text.SimpleDateFormat;

/**
 * Created by charlesx on 2/19/15.
 * Fragment to edit tasks
 */
public class EditTaskFragment extends TaskAbstractFragment {

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
        if (mTask.getAssignee() != null) {
            mUser = mTask.getAssignee();
            mAssigneeField.setText(String.valueOf(mTask.getAssignee().getName()));
        }

        if (mTask.getDueDate() != null) {
            mDate = mTask.getDueDate();
            mDueDateField.setText(new SimpleDateFormat("MMMM dd, yyyy").format(mDate));
        }

        if (mTask.getMiniSiteId() != null) {
            mMiniSite = mTask.getMiniSite();
            mMiniSiteId.setText(String.valueOf(mTask.getMiniSite().getName()));
        }
    }

    @Override
    public void submitListener() { createTask(EDIT, mTask); }

    public void refreshCompletion() {}
}
