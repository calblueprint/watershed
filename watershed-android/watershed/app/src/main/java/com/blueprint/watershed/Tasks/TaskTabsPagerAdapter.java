package com.blueprint.watershed.Tasks;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import java.util.ArrayList;
import java.util.Arrays;

/**
 * Created by Max on 10/19/2014.
 * Sets up adapter for view pager
 */

public class TaskTabsPagerAdapter extends FragmentPagerAdapter {

    private ArrayList<Fragment> mFragments;
    private ArrayList<String> mTitles;

    public TaskTabsPagerAdapter(FragmentManager fm) {
        super(fm);
        mFragments = new ArrayList<Fragment>();
        mTitles = new ArrayList<String>();
    }

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
}