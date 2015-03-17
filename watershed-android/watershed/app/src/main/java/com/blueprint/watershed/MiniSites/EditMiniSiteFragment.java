package com.blueprint.watershed.MiniSites;

import android.util.Log;

import com.android.volley.Response;
import com.blueprint.watershed.Networking.MiniSites.EditMiniSiteRequest;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Sites.SiteListFragment;

/**
 * Created by charlesx on 3/17/15.
 */
public class EditMiniSiteFragment extends MiniSiteAbstractFragment {

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment CreateMiniSiteFragment.
     */
    public static EditMiniSiteFragment newInstance(Site site, MiniSite miniSite) {
        EditMiniSiteFragment fragment = new EditMiniSiteFragment();
        fragment.setSite(site);
        fragment.setMiniSite(miniSite);
        return fragment;
    }

    public EditMiniSiteFragment() {}

    @Override
    public void submitMiniSite(MiniSite miniSite) {
        EditMiniSiteRequest createMiniSiteRequest =
                new EditMiniSiteRequest(mParentActivity, miniSite, new Response.Listener<MiniSite>() {
                    @Override
                    public void onResponse(MiniSite miniSite) {
                        SiteListFragment siteList = SiteListFragment.newInstance();
                        mParentActivity.replaceFragment(siteList);
                        Log.e("successful mini site", "creation");
                    }
                });
        mNetworkManager.getRequestQueue().add(createMiniSiteRequest);
    }
}
