package com.blueprint.watershed.Networking.Sessions;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Authentication.Session;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Utilities.APIError;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by Mark Miyashita on 12/2/14.
 */
public class SignUpRequest extends BaseRequest {

    public SignUpRequest(final Activity activity, HashMap<String, Object> params, final Response.Listener<Session> listener, final Response.Listener<APIError> errorListener) {
        super(Request.Method.POST, makeURL("users"), signUpRequestParams(activity, params),
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
                }, errorListener, activity);
    }

    protected static JSONObject signUpRequestParams(final Activity activity, final HashMap<String, Object> userParams) {
        JSONObject userJson = new JSONObject(userParams);
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        params.put("user", userJson);
        return new JSONObject(params);
    }

}