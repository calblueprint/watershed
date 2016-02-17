package com.blueprint.watershed.Sites.SiteList;

import com.android.volley.Response;
import com.blueprint.watershed.Networking.Sites.SiteListRequest;
import com.blueprint.watershed.Sites.Site;

import java.util.ArrayList;

public class AllSiteListFragment extends SiteListAbstractFragment {

    public static AllSiteListFragment newInstance() { return new AllSiteListFragment(); }

    @Override
    /**
     * Request to get all the sites, updates and shows them according,
     * or displays a text view telling the user that there are no sites.
     */
    public void getSitesRequest() {
        SiteListRequest siteListRequest =
            new SiteListRequest(mParentActivity, new Response.Listener<ArrayList<Site>>() {
                @Override
                public void onResponse(ArrayList<Site> sites) {
                    setSites(sites);
                    toggleList();
                    setSwipeFalse();
            }
        }, this);

        siteListRequest.setTag(SITE_LIST_REQUEST);
        mNetworkManager.getRequestQueue().add(siteListRequest);
    }

    public boolean rightSiteType(Site site) { return true; }
}
