package com.blueprint.watershed.Networking.MiniSites;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Sites.Site;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by Mark Miyashita on 11/19/14.
 */
public class MiniSiteRequest extends BaseRequest {

    public MiniSiteRequest(final Activity activity, MiniSite miniSite, HashMap<String, JSONObject> params, final Response.Listener<MiniSite> listener) {
        super(Request.Method.GET, makeObjectURL("mini_sites", miniSite), new JSONObject(params),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String miniSitesJson = jsonObject.get("mini_site").toString();
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            MiniSite miniSite = mapper.readValue(miniSitesJson, new TypeReference<MiniSite>() {
                            });
                            listener.onResponse(miniSite);
                        } catch (Exception e) {
                            Log.e("Json exception", e.toString());
                        }
                    }

                }, activity);
    }

}
