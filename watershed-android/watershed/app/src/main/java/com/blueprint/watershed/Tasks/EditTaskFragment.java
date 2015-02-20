package com.blueprint.watershed.Tasks;

import android.view.View;

/**
 * Created by charlesx on 2/19/15.
 * Fragment to edit tasks
 */
public class EditTaskFragment extends TaskAbstractFragment {

    private static final String EDIT = "edit";

    public static EditTaskFragment newInstance() { return new EditTaskFragment(); }

    @Override
    public View.OnClickListener submitListener() {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) { createTask(EDIT); }
        };
    }
}
