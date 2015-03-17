package com.blueprint.watershed.MiniSites;

import android.util.Log;

import com.android.volley.Response;
import com.blueprint.watershed.Networking.MiniSites.CreateMiniSiteRequest;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Sites.SiteListFragment;

import org.json.JSONObject;

import java.util.HashMap;

/**
 * Use the {@link CreateMiniSiteFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class CreateMiniSiteFragment extends MiniSiteAbstractFragment {

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment CreateMiniSiteFragment.
     */
    public static CreateMiniSiteFragment newInstance(Site site) {
        CreateMiniSiteFragment fragment = new CreateMiniSiteFragment();
        fragment.setSite(site);
        return fragment;
    }

    public CreateMiniSiteFragment() {}

    @Override
    public void submitMiniSite(MiniSite miniSite) {
        HashMap<String, JSONObject> params = new HashMap<>();

        CreateMiniSiteRequest createMiniSiteRequest =
                new CreateMiniSiteRequest(getActivity(), miniSite, params, new Response.Listener<MiniSite>() {
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
