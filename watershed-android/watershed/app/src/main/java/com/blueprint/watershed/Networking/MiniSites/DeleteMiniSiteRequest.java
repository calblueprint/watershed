package com.blueprint.watershed.Networking.MiniSites;

import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Networking.BaseRequest;

import org.json.JSONObject;

/**
 * Created by charlesx on 3/18/15.
 */
public class DeleteMiniSiteRequest extends BaseRequest{

    public DeleteMiniSiteRequest(final MainActivity activity, MiniSite miniSite, final Response.Listener<JSONObject> listener) {
        super(Request.Method.DELETE, makeObjectURL("mini_sites", miniSite), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            listener.onResponse(jsonObject);
                        } catch (Exception e) {
                            Log.e("Mini Site Request Json exception", e.toString());
                        }
                    }

                }, activity);
    }
}
