package com.blueprint.watershed.Networking.Users;

import android.app.Activity;

import com.android.volley.Response;
import com.blueprint.watershed.Users.User;

import org.json.JSONObject;

/**
 * Created by charlesx on 2/21/15.
 */
public class EditUserRequest extends UpdateUserRequest {
    public EditUserRequest(final Activity activity, User user, JSONObject params, final Response.Listener<User> listener) {
        super(activity, user, params, listener, makeObjectURL("users", user));
    }
}
