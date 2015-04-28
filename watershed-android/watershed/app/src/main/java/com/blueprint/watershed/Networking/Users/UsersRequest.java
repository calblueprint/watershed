package com.blueprint.watershed.Networking.Users;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Users.User;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by charlesx on 3/8/15.
 * Gets all users
 */
public class UsersRequest extends BaseRequest {

    public UsersRequest(final Activity activity, final Response.Listener<ArrayList<User>> listener) {
        super(Method.GET, makeURL("users"), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String usersJson = jsonObject.get("users").toString();
                            ObjectMapper mapper = getNetworkManager(activity).getObjectMapper();
                            ArrayList<User> users = mapper.readValue(usersJson, new TypeReference<ArrayList<User>>() {});
                            listener.onResponse(users);
                        } catch (Exception e) {
                            Log.e("Json exception", e.toString());
                        }
                    }
                }, activity);
    }

}
