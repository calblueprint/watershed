package com.blueprint.watershed.Networking.Tasks;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Tasks.Task;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.HashMap;

/**
 * Created by charlesx on 2/19/15.
 * Request to edit a task
 */
public class EditTaskRequest extends BaseRequest {

    public EditTaskRequest(final Activity activity, Task task, HashMap<String, JSONObject> params, final Response.Listener<Task> listener) {
        super(Method.PUT, makeURL("tasks/" + task.getId()), taskParams(activity, task),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String taskJson = jsonObject.get("task").toString();
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            Task task = mapper.readValue(taskJson, new TypeReference<Task>() {});
                            listener.onResponse(task);
                        } catch (Exception e) {
                            Log.e("Edit Task Request Json exception", e.toString());
                        }
                    }
                }, activity);
    }

    protected static JSONObject taskParams(final Activity activity, final Task task) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        ObjectMapper mapper = getNetworkManager(activity).getObjectMapper();

        try {
            JSONObject taskJson = new JSONObject(mapper.writeValueAsString(task));
            taskJson.put("due_date", new SimpleDateFormat("yyyy/MM/dd").format(task.getDueDate()));
            params.put("task", taskJson);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new JSONObject(params);
    }
}
