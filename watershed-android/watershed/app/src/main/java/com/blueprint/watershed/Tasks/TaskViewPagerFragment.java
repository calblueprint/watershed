package com.blueprint.watershed.Tasks;

import android.os.Bundle;

import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Tasks.TaskList.AllTaskListFragment;
import com.blueprint.watershed.Tasks.TaskList.TaskListTransformer;

import com.blueprint.watershed.Tasks.TaskList.UnclaimedTaskListFragment;
import com.blueprint.watershed.Tasks.TaskList.UserTaskListFragment;

import com.blueprint.watershed.Views.Material.SlidingTabLayout;
import com.blueprint.watershed.Views.ViewPagerAbstractFragment;

/**
 * Created by charlesx on 4/16/15.
 */
public class TaskViewPagerFragment extends ViewPagerAbstractFragment {


    private MainActivity mParentActivity;

    public static TaskViewPagerFragment newInstance() {
        return new TaskViewPagerFragment();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
    }

    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setToolbarElevation(0);
    }

    protected void initializeViews(View view) {
        mTabs = (SlidingTabLayout) view.findViewById(R.id.pager_title_strip);
        mTabs.setDistributeEvenly(true);
        setUpTabs(mTabs);
        TaskTabsPagerAdapter mAdapter = new TaskTabsPagerAdapter(getChildFragmentManager());

        mViewPager = (ViewPager) view.findViewById(R.id.pager);
        mViewPager.setPageTransformer(true, new TaskListTransformer());
        mViewPager.setOffscreenPageLimit(2);
        mViewPager.setAdapter(mAdapter);

        mAdapter.addFragment(new UserTaskListFragment());
        mAdapter.addFragment(new UnclaimedTaskListFragment());
        mAdapter.addTitles("Your", "Unclaimed");
        mAdapter.notifyDataSetChanged();


        mTabs = (SlidingTabLayout) view.findViewById(R.id.pager_title_strip);
        mTabs.setDistributeEvenly(true);
        setUpTabs(mTabs);
        mTabs.setViewPager(mViewPager);
    }

    public void setUpTabs(SlidingTabLayout tabs){
        tabs.setCustomTabColorizer(new SlidingTabLayout.TabColorizer() {
            @Override
            public int getIndicatorColor(int position) {
                return getResources().getColor(R.color.white);
            }
        });
    }
}
