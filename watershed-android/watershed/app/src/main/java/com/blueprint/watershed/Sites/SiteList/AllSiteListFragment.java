package com.blueprint.watershed.Sites.SiteList;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.Networking.Sites.SiteListRequest;
import com.blueprint.watershed.R;
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
        SiteListRequest siteListRequest = new SiteListRequest(mParentActivity, new Response.Listener<ArrayList<Site>>() {
            @Override
            public void onResponse(ArrayList<Site> sites) {
                setSites(sites);
                Log.e("Site Response", "Returned");
                if (mSites.size() == 0) hideList();
                else {
                    showList();
                    mAdapter.notifyDataSetChanged();
                }
                setSwipeFalse();
                mInitializeSites = true;
            }
        }, this);
        siteListRequest.setTag(SITE_LIST_REQUEST);
        mNetworkManager.getRequestQueue().add(siteListRequest);
    }
}
