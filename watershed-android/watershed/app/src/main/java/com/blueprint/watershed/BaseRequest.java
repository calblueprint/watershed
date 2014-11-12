package com.blueprint.watershed;

import android.app.Activity;
import android.content.SharedPreferences;
import android.util.Log;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkResponse;
import com.android.volley.ParseError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.toolbox.HttpHeaderParser;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by maxwolffe on 11/2/14.
 */
public abstract class BaseRequest extends Request{
    private RequestHandler singletonRequestHandler;
    private Activity mParentActivity;
    private Map<String,String> params;
    private SharedPreferences preferences;
    private Response.Listener listener;

    public BaseRequest(int method, String url, JSONObject jsonRequest,
                       Response.Listener listener, Response.ErrorListener errorListener, Activity activity){
        super(method, url, errorListener);
        this.listener = listener;
        this.mParentActivity = activity;
        this.preferences = activity.getSharedPreferences("LOGIN_PREFERENCES", 0);
    }   

    @Override
    public HashMap<String, String> getHeaders() {
        HashMap<String, String> params = new HashMap<String, String>();
        params.put("X-AUTH-TOKEN", preferences.getString("authentication_token", "none"));
        params.put("X-AUTH-EMAIL", preferences.getString("email", "none"));
        return params;
    }

    @Override
    protected void deliverResponse(Object response) {
        this.listener.onResponse(response);
    }

    @Override
    protected Response parseNetworkResponse(NetworkResponse response) {
        try {
            String json = new String(
                    response.data,
                    HttpHeaderParser.parseCharset(response.headers));
            return Response.success(
                    json,
                    HttpHeaderParser.parseCacheHeaders(response));
        } catch (UnsupportedEncodingException e) {
            return Response.error(new ParseError(e));
        }
    }
}
