package com.blueprint.watershed.Networking.Users;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Tasks.Task;
import com.blueprint.watershed.Users.User;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by Max Wolffe on 12/3/14.
 */
public class UserRequest extends BaseRequest {

    public UserRequest(final Activity activity, User user, HashMap<String, JSONObject> params, final Response.Listener<User> listener) {
        super(Request.Method.GET, makeURL("users"), new JSONObject(params),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String userJson = jsonObject.get("user").toString();
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            User user = mapper.readValue(userJson, new TypeReference<User>() {
                            });
                            listener.onResponse(user);
                        } catch (Exception e) {
                            Log.e("Json exception", e.toString());
                        }
                    }
                }, activity);
    }
}