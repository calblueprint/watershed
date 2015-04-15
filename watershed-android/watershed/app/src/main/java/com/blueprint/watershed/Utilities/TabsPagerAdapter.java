package com.blueprint.watershed.Utilities;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.blueprint.watershed.Tasks.TaskFragment;

/**
 * Created by Max on 10/19/2014.
 * Sets up adapter for view pager
 */

public class TabsPagerAdapter extends FragmentPagerAdapter {

    public TabsPagerAdapter(FragmentManager fm) {
        super(fm);
    }

    @Override
    public Fragment getItem(int index) {
        switch (index) {
            case 0:
                return TaskFragment.newInstance(0);
            case 1:
                return TaskFragment.newInstance(1);
        }

        return null;
    }

    @Override
    public int getCount() {
        // get item count - equal to number of tabs
        return 2;
    }

    @Override
    public CharSequence getPageTitle(int position) {
        switch (position) {
            case 0:
                return "User Tasks";
            case 1:
                return "All Tasks";
        }
        return null;
    }

}