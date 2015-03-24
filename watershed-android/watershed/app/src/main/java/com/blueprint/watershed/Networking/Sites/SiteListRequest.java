package com.blueprint.watershed.Networking.Sites;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Sites.SiteListFragment;
import com.blueprint.watershed.Utilities.APIError;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Mark Miyashita on 11/16/14.
 * Makes a request to get all sites
 */
public class SiteListRequest extends BaseRequest {

    public SiteListRequest(final Activity activity, final Response.Listener<ArrayList<Site>> listener,
                           final SiteListFragment fragment) {
        super(Request.Method.GET, makeURL("sites?get_photos=true"), null,
            new Response.Listener<JSONObject>() {
                @Override
                public void onResponse(JSONObject jsonObject) {
                    try {
                        String sitesJson = jsonObject.get("sites").toString();
                        ObjectMapper mapper = getNetworkManager(activity).getObjectMapper();
                        ArrayList<Site> sites = mapper.readValue(sitesJson, new TypeReference<ArrayList<Site>>() {});
                        listener.onResponse(sites);
                    } catch (Exception e) {
                        fragment.setSwipeFalse();
                        Log.e("Site Json exception", e.toString());
                    }
                }

            },
            new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError apiError) {
                        fragment.setSwipeFalse();
                    }
            }, activity);
    }

}
