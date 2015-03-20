package com.blueprint.watershed.Tasks;

import android.os.Bundle;


public class CreateTaskFragment extends TaskAbstractFragment {

    private static final String CREATE = "create";

    /**
     * @return Returns CreateTaskFragment instance.
     */
    public static CreateTaskFragment newInstance() { return new CreateTaskFragment(); }

    public CreateTaskFragment() {}

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        setButtonListeners();
    }

    /**
     * Returns a listener that is applied to the submit button.
     * @return a listener called when submit is clicked.
     */
    public void submitListener() { createTask(CREATE, null); }
}
