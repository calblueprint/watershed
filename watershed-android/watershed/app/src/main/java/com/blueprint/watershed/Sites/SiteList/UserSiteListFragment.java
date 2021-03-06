package com.blueprint.watershed.Sites.SiteList;

import com.android.volley.Response;
import com.blueprint.watershed.Networking.Sites.UserSitesRequest;
import com.blueprint.watershed.Sites.Site;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * List fragment for sites a user has subscribed to.
 */
public class UserSiteListFragment extends SiteListAbstractFragment {

    public static UserSiteListFragment newInstance() { return new UserSiteListFragment(); }

    /**
     * Request to get all the sites, updates and shows them according,
     * or displays a text view telling the user that there are no sites.
     */
    @Override
    public void getSitesRequest() {
        UserSitesRequest siteListRequest =
            new UserSitesRequest(mParentActivity, new HashMap<String, JSONObject>(), new Response.Listener<ArrayList<Site>>() {
            @Override
            public void onResponse(ArrayList<Site> sites) {
                setSites(sites);
                toggleList();
                setSwipeFalse();
            }
        }, mParentActivity.getUserId());

        siteListRequest.setTag(SITE_LIST_REQUEST);
        mNetworkManager.getRequestQueue().add(siteListRequest);
    }

    public boolean rightSiteType(Site site) { return site.getSubscribed(); }
}
