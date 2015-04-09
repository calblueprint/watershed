package com.blueprint.watershed.Networking.Tasks;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Tasks.Task;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.HashMap;

/**
 * Created by Max Wolffe on 12/8/14.
 */
public class CreateTaskRequest extends BaseRequest {

    Task mTask;
    Activity mActivity;

    /**
     * Sends a request to the server to create a new task.
     *
     * @param activity - typically MainActivity, an activity that has a network manager.
     * @param task - task to be created
     * @param params - params for a new task. JSON Object
     * @param listener - A response listener to be called once the response is returned.
     */
    public CreateTaskRequest(final Activity activity, final Task task, HashMap<String, JSONObject> params, final Response.Listener<Task> listener) {
        super(Request.Method.POST, makeURL("tasks"), taskParams(activity, task),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String taskJson = jsonObject.get("task").toString();
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            Task task = mapper.readValue(taskJson, new TypeReference<Task>() {});
                            listener.onResponse(task);
                        } catch (Exception e) {
                            Log.e("Create Task Json exception", e.toString());
                        }
                    }
                }, activity);
        mActivity = activity;
        mTask = task;
    }

    /**
     * Generates a JSON object of the created task to be sent to the server.
     * @param activity
     * @param task - task object to be created.
     * @return Task Json object with task parameters
     */
    protected static JSONObject taskParams(final Activity activity, final Task task) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();

        try {
            JSONObject taskJson = new JSONObject(mapper.writeValueAsString(task));
            params.put("task", taskJson);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new JSONObject(params);
    }
}
