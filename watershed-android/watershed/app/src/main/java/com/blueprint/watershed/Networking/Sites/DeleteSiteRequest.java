package com.blueprint.watershed.Networking.Sites;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Sites.Site;

import org.json.JSONObject;

/**
 * Created by charlesx on 4/10/15.
 * Creates a request to delete a task
 */
public class DeleteSiteRequest extends BaseRequest {
    public DeleteSiteRequest(MainActivity activity, Site site, final Response.Listener<JSONObject> listener) {
        super(Method.DELETE, makeObjectURL("sites", site), null, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject o) {
                listener.onResponse(o);
            }
        }, activity);
    }
}
