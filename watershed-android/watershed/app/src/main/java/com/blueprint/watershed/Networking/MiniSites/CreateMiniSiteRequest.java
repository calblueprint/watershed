package com.blueprint.watershed.Networking.MiniSites;

import android.app.Activity;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.MiniSites.MiniSite;

/**
 * Created by maxwolffe on 2/24/15.
 */
public class CreateMiniSiteRequest extends CreateEditMiniSiteRequest {
    public CreateMiniSiteRequest(final Activity activity, final MiniSite miniSite, final Response.Listener<MiniSite> listener) {
        super(activity, miniSite, listener, Request.Method.POST, makeURL("mini_sites"));
    }
}
