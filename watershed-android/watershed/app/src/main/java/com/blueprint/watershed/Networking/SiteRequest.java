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
public class SiteRequest extends BaseRequest {

    public SiteRequest(final Activity activity, Site site, HashMap<String, JSONObject> params, final Response.Listener<Site> listener) {
        super(Request.Method.GET, makeObjectURL("site", site), new JSONObject(params),
            new Response.Listener<JSONObject>() {
                @Override
                public void onResponse(JSONObject jsonObject) {
                    try {
                        String sitesJson = jsonObject.get("site").toString();
                        ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                        Site site = mapper.readValue(sitesJson, new TypeReference<Site>() {
                        });
                        listener.onResponse(site);
                    } catch (Exception e) {
                        Log.e("Json exception", e.toString());
                    }
                }

            }, activity);
    }

}
