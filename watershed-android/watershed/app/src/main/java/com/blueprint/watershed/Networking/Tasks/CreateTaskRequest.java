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

import java.util.HashMap;

/**
 * Created by Max Wolffe on 12/8/14.
 */
public class CreateTaskRequest extends BaseRequest {

    Task mTask;
    Activity mActivity;

    public CreateTaskRequest(final Activity activity, final Task task, HashMap<String, JSONObject> params, final Response.Listener<Task> listener) {
        super(Request.Method.POST, makeURL("tasks"), taskParams(activity, task),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String fieldReportJson = jsonObject.get("field_report").toString();
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            Task fieldReport = mapper.readValue(fieldReportJson, new TypeReference<Task>() {
                            });
                            listener.onResponse(task);
                        } catch (Exception e) {
                            Log.e("Json exception", e.toString());
                        }
                    }
                }, activity);
        mActivity = activity;
        mTask = task;
    }

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
