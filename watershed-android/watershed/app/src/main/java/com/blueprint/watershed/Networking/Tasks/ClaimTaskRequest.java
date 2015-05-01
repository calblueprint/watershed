package com.blueprint.watershed.Networking.Tasks;

import android.app.Activity;

import com.android.volley.Response;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Tasks.Task;

import org.json.JSONObject;

/**
 * Created by charlesx on 5/1/15.
 *
 */
public class ClaimTaskRequest extends BaseRequest {
    public ClaimTaskRequest(Activity activity, Task task, final Response.Listener<JSONObject> response) {
        super(Method.POST, makeURL("tasks/" + task.getId() + "/claim"), null, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject o) {
                response.onResponse(o);
            }
        }, activity);
    }
}
