package com.blueprint.watershed.MiniSites;

import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;

import com.android.volley.Response;
import com.blueprint.watershed.Networking.MiniSites.CreateMiniSiteRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Sites.SiteViewPagerFragment;
import com.blueprint.watershed.Utilities.Utility;

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
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        setButtonListeners();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.save:
                validateAndSubmitMiniSite();
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void submitMiniSite(MiniSite miniSite) {
        CreateMiniSiteRequest createMiniSiteRequest =
                new CreateMiniSiteRequest(mParentActivity, miniSite, new Response.Listener<MiniSite>() {
                    @Override
                    public void onResponse(MiniSite miniSite) {
                        Utility.hideKeyboard(mParentActivity, mLayout);
                        SiteViewPagerFragment siteList = SiteViewPagerFragment.newInstance();
                        mParentActivity.replaceFragment(siteList);
                        Log.e("successful mini site", "creation");
                    }
                });

        mNetworkManager.getRequestQueue().add(createMiniSiteRequest);
    }
}
