package com.blueprint.watershed.Tasks;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Tasks.TaskList.TaskListTransformer;
import com.blueprint.watershed.Utilities.TabsPagerAdapter;
import com.blueprint.watershed.Views.Material.SlidingTabLayout;

/**
 * Created by charlesx on 4/16/15.
 */
public class TaskViewPagerFragment extends Fragment {

    private MainActivity mParentActivity;

    private SlidingTabLayout mTabs;
    private ViewPager mViewPager;
    private TabsPagerAdapter mAdapter;

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
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_task_view_pager, container, false);
        initializeViews(view);
        return view;
    }

    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setToolbarElevation(0);
    }

    private void initializeViews(View view) {
        mAdapter = new TabsPagerAdapter(getChildFragmentManager(), mParentActivity);
        //        mAdapter = new TabsPagerAdapter(mParentActivity);
        mViewPager = (ViewPager) view.findViewById(R.id.pager);
        mViewPager.setAdapter(mAdapter);
        mViewPager.setPageTransformer(true, new TaskListTransformer());
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
