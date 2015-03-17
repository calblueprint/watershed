package com.blueprint.watershed.Networking.Users;

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
 * Created by maxwolffe on 3/16/15.
 */
public class UserMiniSitesRequest extends BaseRequest {

    public UserMiniSitesRequest(final Activity activity, HashMap<String, JSONObject> params, final Response.Listener<ArrayList<MiniSite>> listener, int id) {
        super(Request.Method.GET, makeUserResourceURL(id, "mini_sites"), new JSONObject(params),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String sitesJson = jsonObject.get("mini_sites").toString();
                            ObjectMapper mapper = getNetworkManager(activity).getObjectMapper();
                            ArrayList<MiniSite> miniSites = mapper.readValue(sitesJson, new TypeReference<ArrayList<MiniSite>>() {});
                            listener.onResponse(miniSites);
                        } catch (Exception e) {
                            Log.e("UMSite Json exception", e.toString());
                        }
                    }

        }, activity);
    }

}
