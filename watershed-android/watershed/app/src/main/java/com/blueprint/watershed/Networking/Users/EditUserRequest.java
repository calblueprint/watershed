package com.blueprint.watershed.Networking.Users;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Users.User;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

/**
 * Created by charlesx on 2/21/15.
 */
public class EditUserRequest extends BaseRequest {

    public EditUserRequest(final Activity activity, User user, JSONObject params, final Response.Listener<User> listener) {
        super(Request.Method.PUT, makeObjectURL("users", user), params,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String userJson = jsonObject.get("user").toString();
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            User user = mapper.readValue(userJson, new TypeReference<User>() {});
                            listener.onResponse(user);
                        } catch (Exception e) {
                            Log.e("Json exception", e.toString());
                        }
                    }
                }, activity);
    }
}
