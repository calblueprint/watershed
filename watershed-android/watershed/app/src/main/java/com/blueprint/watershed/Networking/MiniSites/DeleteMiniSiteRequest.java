package com.blueprint.watershed.Networking.MiniSites;

import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Sites.Site;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

/**
 * Created by charlesx on 3/18/15.
 */
public class DeleteMiniSiteRequest extends BaseRequest{

    public DeleteMiniSiteRequest(final MainActivity activity, MiniSite miniSite, final Response.Listener<Site> listener) {
        super(Request.Method.DELETE, makeObjectURL("mini_sites", miniSite), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String sitesJson = jsonObject.get("site").toString();
                            ObjectMapper mapper = getNetworkManager(activity).getObjectMapper();
                            Site site = mapper.readValue(sitesJson, new TypeReference<Site>() {});
                            listener.onResponse(site);
                        } catch (Exception e) {
                            Log.e("Delete mini exception", e.toString());
                        }
                    }

                }, activity);
    }
}
