package com.blueprint.watershed;

import android.util.Log;

import com.android.volley.NetworkResponse;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.toolbox.HttpHeaderParser;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONArray;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by maxwolffe on 10/29/14.
 */
public class LoginRequest extends Request<String> {

    private Map<String, String> mParams;

    private ObjectMapper mMapper;


    public LoginRequest(String param1, String param2, String url, Response.Listener<String> listener, Response.ErrorListener errorListener) {
        super(Method.POST, url, errorListener);
        mMapper = new ObjectMapper();
        mParams = new HashMap<String, String>();
        mParams.put("email", param1);
        mParams.put("password", param2);
    }

    @Override
    protected Response<T> parseNetworkResponse(
            NetworkResponse response) {
        try {
            String json = new String(response.data,
                    HttpHeaderParser.parseCharset(response.headers));
            return Response.success(mMapper.readValue(json, User.class),
                    HttpHeaderParser.parseCacheHeaders(response));
        }
    }

    @Override
    public Map<String, String> getParams() {
        return mParams;
    }

}
