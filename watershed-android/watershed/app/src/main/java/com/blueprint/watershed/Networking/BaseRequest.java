package com.blueprint.watershed.Networking;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.NetworkResponse;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.blueprint.watershed.APIObject;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Utilities.APIError;
import com.blueprint.watershed.Utilities.Utility;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.apache.http.HttpStatus;
import org.json.JSONObject;

import java.util.HashMap;
/**
 * Created by maxwolffe on 11/2/14.
 * Base Requests for make api calls.
 */
public abstract class BaseRequest extends JsonObjectRequest {
    private SharedPreferences preferences;
    private Response.Listener listener;
    private Response.Listener errorListener;

//    private static final String baseURL = "http://155.41.97.153:3000/api/v1/";
//    private static final String baseURL = "https://intense-reaches-1457.herokuapp.com/api/v1/";
    private static final String baseURL = "https://floating-bayou-8262.herokuapp.com/api/v1/";

    public BaseRequest(int method, String url, JSONObject jsonRequest,
                       final Response.Listener listener, final Response.Listener<APIError> errorListener,
                       final Activity activity) {
        super(method, url, jsonRequest, listener, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError volleyError) {
                Log.e("Request Error", "Custom ErrorListener detected");
                NetworkResponse networkResponse = volleyError.networkResponse;
                APIError apiError = new APIError();
                if (networkResponse == null) {
                    if (!Utility.isConnectedToInternet(activity)) {
                        Toast.makeText(activity, "You're not connected to the internet!", Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(activity, "Server error - please try again!", Toast.LENGTH_SHORT).show();
                    }
                } else {
                    if (networkResponse.statusCode == HttpStatus.SC_FORBIDDEN) {
                        Toast.makeText(activity, "You must sign in!", Toast.LENGTH_SHORT).show();
                        MainActivity.logoutCurrentUser(activity);
                    } else {
                        try {
                            String errorJson = new String(networkResponse.data);
                            JSONObject errorJsonObject = new JSONObject(errorJson);
                            errorJson = errorJsonObject.getString("error");
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            apiError = mapper.readValue(errorJson, new TypeReference<APIError>() {
                            });
                        } catch (Exception e) {
                            Log.e("Json exception base", e.toString());
                        }
                        Toast.makeText(activity, apiError.getMessage(), Toast.LENGTH_SHORT).show();
                    }

                }
                errorListener.onResponse(apiError);
            }});

        this.listener = listener;
        this.errorListener = errorListener;
        this.preferences = activity.getSharedPreferences("LOGIN_PREFERENCES", 0);
    }

    public BaseRequest(int method, String url, JSONObject jsonRequest,
                       final Response.Listener listener, final Activity activity) {
        this(method, url, jsonRequest, listener, new Response.Listener<APIError>() {
            @Override
            public void onResponse(APIError apiError) {
                Log.e("Error Response", "onResponse not overridden");
            }
        }, activity);
    }

    public static String makeURL(String endpoint) {
        return baseURL + endpoint;
    }

    public static String makeObjectURL(String endpoint, APIObject object) {
        return String.format("%s/%s", makeURL(endpoint), object.getId().toString());
    }

    public static String makeUserResourceURL(int id, String endpoint){
        return String.format("%s/%s/%s", makeURL("users"), String.valueOf(id), endpoint);
    }

    public static NetworkManager getNetworkManager(Context context) {
        return NetworkManager.getInstance(context);
    }

    @Override
    public HashMap<String, String> getHeaders() {
        HashMap<String, String> headers = new HashMap<String, String>();
        headers.put("X-AUTH-TOKEN", preferences.getString("authentication_token", "none"));
        headers.put("X-AUTH-EMAIL", preferences.getString("email", "none"));
        return headers;
    }
}
