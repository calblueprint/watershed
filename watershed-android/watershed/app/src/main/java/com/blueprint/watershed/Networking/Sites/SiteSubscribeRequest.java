package com.blueprint.watershed.Networking.Sites;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Sites.Site;

import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by maxwolffe on 4/8/15.
 */
public class SiteSubscribeRequest extends BaseRequest {
    public SiteSubscribeRequest(final Activity activity, Site site, HashMap<String, JSONObject> params, final Response.Listener<String> listener) {
        super(Request.Method.POST, makeURL("sites/" + site.getId() + "/subscribe"), new JSONObject(params),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String message = "Successful site subscription";
                            listener.onResponse(message);
                        } catch (Exception e) {
                            Log.e("Sub Json exception", e.toString());
                        }
                    }

                }, activity);
    }
}
