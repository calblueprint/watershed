package com.blueprint.watershed.Sites;

import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;


import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Tasks.TaskList.TaskListTransformer;
import com.blueprint.watershed.Tasks.TaskTabsPagerAdapter;
import com.blueprint.watershed.Views.Material.SlidingTabLayout;
import com.blueprint.watershed.Views.ViewPagerAbstractFragment;

/**
 * Created by max wolffe on 4/26/15.
 */
public class SiteViewPagerFragment extends ViewPagerAbstractFragment {

    private MainActivity mParentActivity;

    private TaskTabsPagerAdapter mAdapter;

    public static SiteViewPagerFragment newInstance() {
        return new SiteViewPagerFragment();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_task_view_pager, container, false);
        initializeViews(view);
        return view;
    }

    private void initializeViews(View view) {
        mTabs = (SlidingTabLayout) view.findViewById(R.id.pager_title_strip);
        mTabs.setDistributeEvenly(true);
        setUpTabs(mTabs);
        SiteTabsPagerAdapter mAdapter = new SiteTabsPagerAdapter(getChildFragmentManager());
        mViewPager = (ViewPager) view.findViewById(R.id.pager);
        mViewPager.setAdapter(mAdapter);
        mViewPager.setPageTransformer(true, new TaskListTransformer());
        mTabs.setViewPager(mViewPager);
    }
}
