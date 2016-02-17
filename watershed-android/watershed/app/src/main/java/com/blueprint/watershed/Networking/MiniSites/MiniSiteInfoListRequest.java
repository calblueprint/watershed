package com.blueprint.watershed.Networking.MiniSites;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Networking.BaseRequest;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Mark Miyashita on 11/19/14.
 * Makes request to get MiniSites (information only)
 */
public class MiniSiteInfoListRequest extends BaseRequest {

    public MiniSiteInfoListRequest(final Activity activity, final Response.Listener<ArrayList<MiniSite>> listener) {
        super(Request.Method.GET, makeURL("mini_sites?get_photos=false"), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String miniSitesJson = jsonObject.get("mini_sites").toString();
                            ObjectMapper mapper = getNetworkManager(activity).getObjectMapper();
                            ArrayList<MiniSite> miniSites = mapper.readValue(miniSitesJson, new TypeReference<ArrayList<MiniSite>>() {
                            });
                            listener.onResponse(miniSites);
                        } catch (Exception e) {
                            Log.e("Json exception", e.toString());
                        }
                    }

                }, activity);
    }
}
