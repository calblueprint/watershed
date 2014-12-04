package com.blueprint.watershed.Networking.Sessions;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Authentication.Session;
import com.blueprint.watershed.Networking.BaseRequest;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by Mark Miyashita on 12/3/14.
 */
public class FacebookLoginRequest extends BaseRequest {

    public FacebookLoginRequest(final Activity activity, HashMap<String, String> params, final Response.Listener<Session> listener) {
        super(Request.Method.POST, makeURL("users/sign_up/facebook"), facebookLoginRequestParams(activity, params),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String sessionJson = jsonObject.get("session").toString();
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            Session session = mapper.readValue(sessionJson, new TypeReference<Session>() {
                            });
                            listener.onResponse(session);
                        } catch (Exception e) {
                            Log.e("Json exception", e.toString());
                        }
                    }
                }, activity);
    }

    protected static JSONObject facebookLoginRequestParams(final Activity activity, final HashMap<String, String> userParams) {
        HashMap<String, HashMap<String, String>> params = new HashMap<String, HashMap<String, String>>();
        params.put("user", userParams);
        return new JSONObject(params);
    }

}