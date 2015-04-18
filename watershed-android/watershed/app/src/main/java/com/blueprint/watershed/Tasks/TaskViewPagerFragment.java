package com.blueprint.watershed.Tasks;

import android.app.ActionBar;
import android.app.FragmentTransaction;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.PagerTabStrip;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Tasks.TaskList.TaskListTransformer;
import com.blueprint.watershed.Utilities.TabsPagerAdapter;

/**
 * Created by charlesx on 4/16/15.
 */
public class TaskViewPagerFragment extends Fragment implements ActionBar.TabListener {

    private MainActivity mParentActivity;

    private PagerTabStrip mPagerTabStrip;
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
        mPagerTabStrip = (PagerTabStrip) view.findViewById(R.id.pager_title_strip);
        mAdapter = new TabsPagerAdapter(getChildFragmentManager());
        mViewPager = (ViewPager) view.findViewById(R.id.pager);
        mViewPager.setAdapter(mAdapter);
        mViewPager.setPageTransformer(true, new TaskListTransformer());
    }

    @Override
    public void onTabReselected(ActionBar.Tab tab, FragmentTransaction ft) {}

    @Override
    public void onTabSelected(ActionBar.Tab tab, FragmentTransaction ft) {
        mViewPager.setCurrentItem(tab.getPosition());
    }

    @Override
    public void onTabUnselected(ActionBar.Tab tab, FragmentTransaction ft) {}
}
