package com.blueprint.watershed.Networking.Sessions;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.NetworkError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.blueprint.watershed.Authentication.Session;
import com.blueprint.watershed.FieldReports.FieldReport;
import com.blueprint.watershed.Networking.BaseRequest;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by Mark Miyashita on 12/2/14.
 */
public class LoginRequest extends BaseRequest {

    public LoginRequest(final Activity activity, HashMap<String, String> params, final Response.Listener<Session> listener, final Response.ErrorListener errorListener) {
        super(Request.Method.POST, makeURL("users/sign_in"), loginRequestParams(activity, params),
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


    protected static JSONObject loginRequestParams(final Activity activity, final HashMap<String, String> userParams) {
        JSONObject userJson = new JSONObject(userParams);
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        params.put("user", userJson);
        return new JSONObject(params);
    }

}