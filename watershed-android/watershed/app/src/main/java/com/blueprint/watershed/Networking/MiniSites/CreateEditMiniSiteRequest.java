package com.blueprint.watershed.Networking.MiniSites;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Networking.BaseRequest;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by maxwolffe on 2/24/15.
 */
public class CreateEditMiniSiteRequest extends BaseRequest {

    Activity mActivity;
    MiniSite mMiniSite;

    public CreateEditMiniSiteRequest(final Activity activity, final MiniSite miniSite, final Response.Listener<MiniSite> listener,
                                     int requestType, String url) {
        super(requestType, url, miniSiteParams(activity, miniSite),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String miniSiteJson = jsonObject.get("mini_site").toString();
                            Log.e("miniSite JSON", miniSiteJson);
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            MiniSite miniSite = mapper.readValue(miniSiteJson, new TypeReference<MiniSite>() {
                            });
                            listener.onResponse(miniSite);
                        } catch (Exception e) {
                            Log.e("Json exception", e.toString());
                        }
                    }
                }, activity);

        mMiniSite = miniSite;
        mActivity = activity;
    }

    /**
     * Generates a JSON object of the created site to be sent to the server.
     * @param activity
     * @param miniSite - miniSite object to be created.
     * @return Site Json object with site parameters
     */
    protected static JSONObject miniSiteParams(final Activity activity, final MiniSite miniSite) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        ObjectMapper mapper = getNetworkManager(activity).getObjectMapper();

        try {
//            Log.e("Mini Site JSON", miniSiteJson.toString());
            JSONObject miniSiteJson = new JSONObject(mapper.writeValueAsString(miniSite));
            params.put("mini_site", miniSiteJson);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new JSONObject(params);
    }
}
