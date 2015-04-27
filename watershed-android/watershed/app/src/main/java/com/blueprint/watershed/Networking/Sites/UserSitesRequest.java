package com.blueprint.watershed.Networking.Users;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Sites.Site;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by maxwolffe on 4/12/15.
 */
public class UserSitesRequest extends BaseRequest {
    public UserSitesRequest(final Activity activity, HashMap<String, JSONObject> params, final Response.Listener<ArrayList<Site>> listener, int id) {
        super(Request.Method.GET, makeUserResourceURL(id, "sites"), new JSONObject(params),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String sitesJson = jsonObject.get("sites").toString();
                            ObjectMapper mapper = getNetworkManager(activity).getObjectMapper();
                            ArrayList<Site> sites = mapper.readValue(sitesJson, new TypeReference<ArrayList<Site>>() {});
                            listener.onResponse(sites);
                        } catch (Exception e) {
                            Log.e("USite Json exception", e.toString());
                        }
                    }

                }, activity);
    }
}