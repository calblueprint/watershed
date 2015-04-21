package com.blueprint.watershed.Utilities;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.blueprint.watershed.Tasks.TaskList.AllTaskListFragment;
import com.blueprint.watershed.Tasks.TaskList.UnclaimedTaskListFragment;
import com.blueprint.watershed.Tasks.TaskList.UserTaskListFragment;

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
                return UserTaskListFragment.newInstance();
            case 1:
                return AllTaskListFragment.newInstance();
            case 2:
                return AllTaskListFragment.newInstance(); //return UnclaimedTaskListFragment.newInstance();
        }

        return null;
    }

    @Override
    public int getCount() {
        // get item count - equal to number of tabs
        return 3;
    }

    @Override
    public CharSequence getPageTitle(int position) {
        switch (position) {
            case 0:
                return "Your";
            case 1:
                return "All";
            case 2:
                return "Unclaimed";
        }
        return null;
    }

}