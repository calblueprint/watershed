
package com.blueprint.watershed.Views;

import android.app.ActionBar;
import android.app.FragmentTransaction;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;


import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Tasks.TaskTabsPagerAdapter;
import com.blueprint.watershed.Views.Material.SlidingTabLayout;

/**
 * Created by max wolffe on 4/26/15.
 */
public abstract class ViewPagerAbstractFragment extends Fragment implements ActionBar.TabListener {

    protected MainActivity mParentActivity;

    protected SlidingTabLayout mTabs;
    protected ViewPager mViewPager;
    protected TaskTabsPagerAdapter mAdapter;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_view_pager, container, false);
        initializeViews(view);
        return view;
    }

    protected abstract void initializeViews(View view);

    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setToolbarElevation(0);
    }

    protected void setUpTabs(SlidingTabLayout tabs){
        tabs.setCustomTabColorizer(new SlidingTabLayout.TabColorizer() {
            @Override
            public int getIndicatorColor(int position) {
                return getResources().getColor(R.color.white);
            }
        });
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
