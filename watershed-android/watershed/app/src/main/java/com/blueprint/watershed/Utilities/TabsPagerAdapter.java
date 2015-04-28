package com.blueprint.watershed.Utilities;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import java.util.ArrayList;
import java.util.Arrays;

/**
 * Created by Max on 10/19/2014.
 * Sets up adapter for view pager
 */

public class TabsPagerAdapter extends FragmentStatePagerAdapter {

    private ArrayList<Fragment> mFragments;
    private ArrayList<String> mTitles;

    public TabsPagerAdapter(FragmentManager fm) {
        super(fm);
        mFragments = new ArrayList<Fragment>();
        mTitles = new ArrayList<String>();
    }

//    public TabsPagerAdapter(Activity activity) {
//        super();
//        mActivity = activity;
//    }

    @Override
    public Fragment getItem(int index) {
        return mFragments.get(index);
    }

    @Override
    public int getCount() {
        return mFragments.size();
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return mTitles.get(position);
    }

    public void addFragment(Fragment fragment) {
        mFragments.add(fragment);
        notifyDataSetChanged();
    }

    public void addTitles(String... titles) {
        mTitles.addAll(Arrays.asList(titles));
    }

//    @Override
//    public boolean isViewFromObject(View view, Object o) {
//        return o == view;
//    }

//    @Override
//    public Object instantiateItem(ViewGroup container, int position) {
//        // Inflate a new layout from our resources
//        Fragment fragment;
//        switch (position) {
//            case 0:
//                fragment = UserTaskListFragment.newInstance();
//                break;
//            case 1:
//                fragment = UnclaimedTaskListFragment.newInstance();
//                break;
//            default:
//                fragment = AllTaskListFragment.newInstance();
//        }
//
//        if (fragment.getView() != null) container.addView(fragment.getView());
//
//        Log.i("ASD", "instantiateItem() [position: " + position + "]");
//
//        // Return the View
//        return fragment.getView();
//    }
//
}