package com.blueprint.watershed.Networking.Tasks;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Tasks.Task;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

/**
 * Created by charlesx on 5/1/15.
 *
 */
public class ClaimTaskRequest extends BaseRequest {
    public ClaimTaskRequest(final Activity activity, Task task, final Response.Listener<Task> response) {
        super(Method.POST, makeURL("tasks/" + task.getId() + "/claim"), null, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject o) {
                try {
                    String taskJson = o.getString("task");
                    ObjectMapper mapper = getNetworkManager(activity).getObjectMapper();
                    Task task = mapper.readValue(taskJson, new TypeReference<Task>(){});
                    response.onResponse(task);
                } catch (Exception e) {
                    Log.i("CLAIM TASK ERROR", e.toString());
                }
            }
        }, activity);
    }
}
