package com.blueprint.watershed.Tasks;

import android.view.View;


public class CreateTaskFragment extends TaskAbstractFragment {

    private static final String CREATE = "create";

    public static CreateTaskFragment newInstance() {
        return new CreateTaskFragment();
    }

    public CreateTaskFragment() {
        // Required empty public constructor
    }

    /**
     * Returns a listener that is applied to the submit button.
     * @return
     */
    public View.OnClickListener submitListener() {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) { createTask(CREATE); }
        };
    }
}
