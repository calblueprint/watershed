package com.blueprint.watershed.Networking;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Sites.Site;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by Mark Miyashita on 11/16/14.
 */
public class SiteListRequest extends BaseRequest {

    public SiteListRequest(HashMap<String, JSONObject> params, final Response.Listener<ArrayList<Site>> listener, final Activity activity) {
        super(Request.Method.GET, url("sites"), new JSONObject(params),
            new Response.Listener<JSONObject>() {
                @Override
                public void onResponse(JSONObject jsonObject) {
                    try {
                        String sitesJson = jsonObject.get("sites").toString();
                        ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                        ArrayList<Site> sites = mapper.readValue(sitesJson, new TypeReference<ArrayList<Site>>() {
                        });
                        listener.onResponse(sites);
                    } catch (Exception e) {
                        Log.e("Json exception", e.toString());
                    }
                }

        }, activity);
    }

}
