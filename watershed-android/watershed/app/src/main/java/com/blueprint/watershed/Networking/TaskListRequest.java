package com.blueprint.watershed.Networking;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Tasks.Task;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by Mark Miyashita on 11/16/14.
 */
public class TaskListRequest extends BaseRequest {

    public TaskListRequest(final Activity activity, HashMap<String, JSONObject> params, final Response.Listener<ArrayList<Task>> listener) {
        super(Request.Method.GET, makeURL("tasks"), new JSONObject(params),
            new Response.Listener<JSONObject>() {
                @Override
                public void onResponse(JSONObject jsonObject) {
                    try {
                        String sitesJson = jsonObject.get("tasks").toString();
                        ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                        ArrayList<Task> tasks = mapper.readValue(sitesJson, new TypeReference<ArrayList<Task>>() {
                        });
                        listener.onResponse(tasks);
                    } catch (Exception e) {
                        Log.e("Json exception", e.toString());
                    }
                }
            }, activity);
    }
}
