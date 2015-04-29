package com.blueprint.watershed.Users;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.blueprint.watershed.Tasks.TaskList.AllTaskListFragment;

/**
 * Created by maxwolffe on 4/29/15.
 */
public class ManageTabsPagerAdapter extends FragmentPagerAdapter {

    public ManageTabsPagerAdapter(FragmentManager fm) {
        super(fm);
    }

    @Override
    public Fragment getItem(int index) {
        switch (index) {
            case 0:
                return UserListFragment.newInstance();
            case 1:
                return AllTaskListFragment.newInstance();
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
                return "Users";
            case 1:
                return "Tabs";
        }
        return null;
    }
}