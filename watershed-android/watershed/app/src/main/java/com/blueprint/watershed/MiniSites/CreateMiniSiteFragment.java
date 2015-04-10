package com.blueprint.watershed.MiniSites;

import android.os.Bundle;
import android.util.Log;
import android.view.View;

import com.android.volley.Response;
import com.blueprint.watershed.Networking.MiniSites.CreateMiniSiteRequest;
import com.blueprint.watershed.Sites.SiteListFragment;
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
    public static CreateMiniSiteFragment newInstance(Integer siteID) {
        CreateMiniSiteFragment fragment = new CreateMiniSiteFragment();
        fragment.setSite(siteID);
        return fragment;
    }

    public CreateMiniSiteFragment() {}

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        setButtonListeners();
        hideDeleteButton();
    }

    private void hideDeleteButton() {
        mScrollView.setPadding(0, 0, 0, 0);
        mDelete.setVisibility(View.GONE);
    }

    @Override
    public void submitMiniSite(MiniSite miniSite) {
        CreateMiniSiteRequest createMiniSiteRequest =
                new CreateMiniSiteRequest(mParentActivity, miniSite, new Response.Listener<MiniSite>() {
                    @Override
                    public void onResponse(MiniSite miniSite) {
                        Utility.hideKeyboard(mParentActivity, mLayout);
                        SiteListFragment siteList = SiteListFragment.newInstance();
                        mParentActivity.replaceFragment(siteList);
                        Log.e("successful mini site", "creation");
                    }
                });

        mNetworkManager.getRequestQueue().add(createMiniSiteRequest);
    }
}
