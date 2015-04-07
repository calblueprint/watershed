package com.blueprint.watershed.Networking.Sites;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Sites.Site;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by maxwolffe on 4/7/15.
 */
public class EditSiteRequest extends BaseRequest {

    /**
     * Sends a request to the server to create a new site.
     *
     * @param activity - typically MainActivity, an activity that has a network manager.
     * @param site - site to be created
     * @param params - params for a new site. JSON Object
     * @param listener - A response listener to be called once the response is returned.
     */
    public EditSiteRequest(final Activity activity, final Site site, HashMap<String, JSONObject> params, final Response.Listener<Site> listener) {
        super(Request.Method.PUT, makeURL("sites/" + site.getId()), siteParams(activity, site),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            Log.e("Successful site editing", "woot");
                            String siteJson = jsonObject.get("site").toString();
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            Site site = mapper.readValue(siteJson, new TypeReference<Site>() {
                            });
                            listener.onResponse(site);
                        } catch (Exception e) {
                            Log.e("Edit Site Json exception", e.toString());
                        }
                    }
                }, activity);
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
            Log.e("attempting to edit site", "woot?");
            JSONObject siteJson = new JSONObject(mapper.writeValueAsString(site));
            params.put("site", siteJson);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new JSONObject(params);
    }
}
