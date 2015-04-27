package com.blueprint.watershed.Networking.Tasks;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Tasks.Task;
import com.blueprint.watershed.Tasks.TaskList.TaskListAbstractFragment;
import com.blueprint.watershed.Utilities.APIError;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by Mark Miyashita on 11/16/14.
 */
public class TaskListRequest extends BaseRequest {

    public TaskListRequest(final Activity activity, HashMap<String, JSONObject> params,
                           final Response.Listener<ArrayList<Task>> listener, final TaskListAbstractFragment fragment) {
        super(Request.Method.GET, makeURL("tasks"), new JSONObject(params),
            new Response.Listener<JSONObject>() {
                @Override
                public void onResponse(JSONObject jsonObject) {
                    ArrayList<Task> tasks = new ArrayList<Task>();
                    try {
                        String tasksJson = jsonObject.get("tasks").toString();
                        ObjectMapper mapper = getNetworkManager(activity).getObjectMapper();
                        tasks = mapper.readValue(tasksJson, new TypeReference<ArrayList<Task>>() {});
                    } catch (Exception e) {
                        fragment.setSwipeFalse();
                        Log.e("Json exception", e.toString());
                    }
                    listener.onResponse(tasks);
                }
            }, new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError apiError) {
                        fragment.setSwipeFalse();
                    }
            }, activity);
    }
}
