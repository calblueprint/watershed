package com.blueprint.watershed;

import android.util.Log;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkResponse;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.toolbox.HttpHeaderParser;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by maxwolffe on 11/2/14.
 */
public abstract class BaseRequest extends Request{
    private RequestHandler singletonRequestHandler;
    private Map<String,String> params;

    public BaseRequest(int method, String url, JSONObject jsonRequest,
                       Response.Listener<JSONArray> listener, Response.ErrorListener errorListener){
        super(method, url, jsonRequest, listener, errorListener);
    }   

    @Override
    public Map<String, String> getHeaders() throws AuthFailureError {
        Map<String, String> headers = super.getHeaders();

        if (headers == null
                || headers.equals(Collections.emptyMap())) {
            headers = new HashMap<String, String>();
        }
        return headers;
    }
}
