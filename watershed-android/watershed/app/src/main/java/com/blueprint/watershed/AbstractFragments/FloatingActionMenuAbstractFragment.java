package com.blueprint.watershed.AbstractFragments;

import android.support.v4.app.Fragment;

import com.blueprint.watershed.Views.Material.FloatingActionsMenu;

/**
 * Created by charlesx on 4/18/15.
 * Inherited by fragments that have a FloatingActionMenu
 */
public abstract class FloatingActionMenuAbstractFragment extends Fragment {

    public FloatingActionsMenu mMenu;

    public boolean closeMenu() {
        boolean isOpened = mMenu.isExpanded();
        if (isOpened) mMenu.collapse();
        return isOpened;
    }
}
