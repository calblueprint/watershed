package com.blueprint.watershed.Sites;

/**
 * Created by maxwolffe on 4/26/15.
 */

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.blueprint.watershed.Sites.SiteList.AllSiteListFragment;
import com.blueprint.watershed.Sites.SiteList.UserSiteListFragment;

/**
 * Created by Max on 4/26/2015.
 * Sets up adapter for view pager
 */

public class SiteTabsPagerAdapter extends FragmentPagerAdapter {

    public SiteTabsPagerAdapter(FragmentManager fm) {
        super(fm);
    }

    @Override
    public Fragment getItem(int index) {
        switch (index) {
            case 0:
                return UserSiteListFragment.newInstance();
            case 1:
                return AllSiteListFragment.newInstance();
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
                return "Your";
            case 1:
                return "All";
        }
        return null;
    }

}