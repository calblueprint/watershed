package com.blueprint.watershed.Networking;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkError;
import com.android.volley.NetworkResponse;
import com.android.volley.ParseError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.HttpHeaderParser;
import com.android.volley.toolbox.JsonObjectRequest;
import com.blueprint.watershed.APIObject;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by maxwolffe on 11/2/14.
 */
public abstract class BaseRequest extends JsonObjectRequest {
    private SharedPreferences preferences;
    private Response.Listener listener;
    private Response.ErrorListener errorListener;

    private static final String baseURL = "https://intense-reaches-1457.herokuapp.com/api/v1/";

    public BaseRequest(int method, String url, JSONObject jsonRequest,
                       final Response.Listener listener, final Response.ErrorListener errorListener,
                       final Activity activity) {
        super(method, url, jsonRequest, listener, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError volleyError) {
                Log.e("Request Error", volleyError.getMessage());
                Log.e("Request error data", new String(volleyError.networkResponse.data));
                errorListener.onErrorResponse(volleyError);

                String message = "An error has occurred.";
                Context context = activity.getApplicationContext();
                int duration = Toast.LENGTH_SHORT;

                Toast toast = Toast.makeText(context, message, duration);
                toast.show();
            }});

        this.listener = listener;
        this.errorListener = errorListener;
        this.preferences = activity.getSharedPreferences("LOGIN_PREFERENCES", 0);
    }

    public static String makeURL(String endpoint) {
        return baseURL + endpoint;
    }

    public static String makeObjectURL(String endpoint, APIObject object) {
        return String.format("%s/%s", makeURL(endpoint), object.getId().toString());
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
