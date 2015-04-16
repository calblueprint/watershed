package com.blueprint.watershed.Networking.Users;

import android.app.Activity;

import com.android.volley.Response;
import com.blueprint.watershed.Users.User;

import org.json.JSONObject;

/**
 * Created by charlesx on 4/13/15.
 */
public class RegisterUserRequest extends UpdateUserRequest {
    public RegisterUserRequest(final Activity activity, User user, JSONObject params, final Response.Listener<User> listener) {
        super(activity, user, params, listener, makeUserResourceURL(user.getId(), "register"));
    }
}
