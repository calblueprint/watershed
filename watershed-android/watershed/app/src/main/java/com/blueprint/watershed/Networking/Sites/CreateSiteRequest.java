package com.blueprint.watershed.Networking.Sites;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Sites.Site;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by maxwolffe on 2/16/15.
 */
public class CreateSiteRequest extends BaseRequest {
    Site mSite;
    Activity mActivity;

    /**
     * Sends a request to the server to create a new site.
     *
     * @param activity - typically MainActivity, an activity that has a network manager.
     * @param site - site to be created
     * @param params - params for a new site. JSON Object
     * @param listener - A response listener to be called once the response is returned.
     */
    public CreateSiteRequest(final Activity activity, final Site site, HashMap<String, JSONObject> params, final Response.Listener<Site> listener) {
        super(Request.Method.POST, makeURL("sites"), siteParams(activity, site),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String siteJson = jsonObject.get("site").toString();
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            Site site = mapper.readValue(siteJson, new TypeReference<Site>() {
                            });
                            listener.onResponse(site);
                        } catch (Exception e) {
                            Log.e("Json exception", e.toString());
                        }
                    }
                }, activity);

        mSite = site;
        mActivity = activity;
    }

    /**
     * Generates a JSON object of the created site to be sent to the server.
     * @param activity
     * @param site - site object to be created.
     * @return Site Json object with site parameters
     */
    protected static JSONObject siteParams(final Activity activity, final Site site) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();

        try {
            JSONObject siteJson = new JSONObject(mapper.writeValueAsString(site));
            Log.e("Site Request ;)", siteJson.toString());
            params.put("site", siteJson);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new JSONObject(params);
    }
}

