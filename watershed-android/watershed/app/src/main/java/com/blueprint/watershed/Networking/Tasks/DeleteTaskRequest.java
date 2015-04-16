package com.blueprint.watershed.Networking.Tasks;

import android.util.Log;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Tasks.Task;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by charlesx on 4/10/15.
 * Delete Task Request
 */
public class DeleteTaskRequest extends BaseRequest {
    public DeleteTaskRequest(final MainActivity activity, Task task, final Response.Listener<ArrayList<Task>> listener) {
        super(Method.DELETE, makeObjectURL("tasks", task), null, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {
                    String tasksJson = jsonObject.get("tasks").toString();
                    ObjectMapper mapper = getNetworkManager(activity).getObjectMapper();
                    ArrayList<Task> tasks = mapper.readValue(tasksJson, new TypeReference<ArrayList<Task>>() {});
                    listener.onResponse(tasks);
                } catch (Exception e) {
                    Log.e("exception delete task", e.toString());
                }
            }
        }, activity);
    }
}
