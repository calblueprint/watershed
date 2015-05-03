package com.blueprint.watershed.Users;

import android.view.View;
import com.blueprint.watershed.R;
import android.support.v4.view.ViewPager;
import com.blueprint.watershed.Views.Material.SlidingTabLayout;
import com.blueprint.watershed.Views.ViewPagerAbstractFragment;

/**
 * Created by max wolffe on 4/26/15.
 */
public class ManageViewPagerFragment extends ViewPagerAbstractFragment {

    public static ManageViewPagerFragment newInstance() {
        return new ManageViewPagerFragment();
    }

    protected void initializeViews(View view) {
        mTabs = (SlidingTabLayout) view.findViewById(R.id.pager_title_strip);
        mTabs.setDistributeEvenly(true);
        setUpTabs(mTabs);
        ManageTabsPagerAdapter mAdapter = new ManageTabsPagerAdapter(getChildFragmentManager());
        mViewPager = (ViewPager) view.findViewById(R.id.pager);
        mViewPager.setAdapter(mAdapter);
        mTabs.setViewPager(mViewPager);
    }
}


