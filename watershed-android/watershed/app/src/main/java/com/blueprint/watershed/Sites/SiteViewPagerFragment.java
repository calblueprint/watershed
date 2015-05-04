package com.blueprint.watershed.Sites;

import android.support.v4.view.ViewPager;
import android.view.View;


import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.SiteList.SiteListTransformer;
import com.blueprint.watershed.Views.Material.SlidingTabLayout;
import com.blueprint.watershed.Views.ViewPagerAbstractFragment;

/**
 * Created by max wolffe on 4/26/15.
 */
public class SiteViewPagerFragment extends ViewPagerAbstractFragment {

    public static SiteViewPagerFragment newInstance() {
        return new SiteViewPagerFragment();
    }

    protected void initializeViews(View view) {
        mTabs = (SlidingTabLayout) view.findViewById(R.id.pager_title_strip);
        mTabs.setDistributeEvenly(true);
        setUpTabs(mTabs);
        SiteTabsPagerAdapter mAdapter = new SiteTabsPagerAdapter(getChildFragmentManager());
        mViewPager = (ViewPager) view.findViewById(R.id.pager);
        mViewPager.setAdapter(mAdapter);
        if (mParentActivity.getUser().isManager()) {
            mViewPager.setPageTransformer(true, new SiteListTransformer());
        }
        mTabs.setViewPager(mViewPager);
    }
}
