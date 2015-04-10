package com.blueprint.watershed.Networking.Tasks;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Tasks.Task;

import org.json.JSONObject;

/**
 * Created by charlesx on 4/10/15.
 */
public class DeleteTaskRequest extends BaseRequest {
    public DeleteTaskRequest(MainActivity activity, Task task, final Response.Listener<JSONObject> listener) {
        super(Method.DELETE, makeObjectURL("tasks", task), null, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject o) {
                listener.onResponse(o);
            }
        }, activity);
    }
}
