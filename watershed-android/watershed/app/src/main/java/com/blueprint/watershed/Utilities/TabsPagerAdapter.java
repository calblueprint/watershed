package com.blueprint.watershed.Utilities;

import android.content.Context;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.util.Log;

import com.blueprint.watershed.Tasks.TaskList.AllTaskListFragment;
import com.blueprint.watershed.Tasks.TaskList.UnclaimedTaskListFragment;
import com.blueprint.watershed.Tasks.TaskList.UserTaskListFragment;

/**
 * Created by Max on 10/19/2014.
 * Sets up adapter for view pager
 */

public class TabsPagerAdapter extends FragmentStatePagerAdapter {

    private Context mContext;
    private FragmentManager mFragmentManager;

    public TabsPagerAdapter(FragmentManager fm, Context context) {
        super(fm);
        mFragmentManager = fm;
        mContext = context;
    }

//    public TabsPagerAdapter(Activity activity) {
//        super();
//        mActivity = activity;
//    }

    @Override
    public Fragment getItem(int index) {
        Log.i("adf", index+"asdf");
        switch (index) {
            case 0:
                return UserTaskListFragment.newInstance();
            case 1:
                return UnclaimedTaskListFragment.newInstance();
            default:
                return AllTaskListFragment.newInstance();
        }
    }

    @Override
    public int getCount() {
        // get item count - equal to number of tabs
        return 3;
    }

    @Override
    public int getItemPosition(Object object) {
        if(mFragmentManager.getFragments().contains(object)) {
            Log.i("asfdasdf", "asdf");
            return POSITION_NONE;
        }
        else {
            Log.i("asfdasdf", "dam");
            return POSITION_UNCHANGED;
        }
    }


    @Override
    public CharSequence getPageTitle(int position) {
        switch (position) {
            case 0:
                return "Your";
            case 1:
                return "Unclaimed";
            case 2:
                return "All";
        }
        return null;
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