package com.blueprint.watershed.AbstractFragments;

import android.support.v4.app.Fragment;

import com.blueprint.watershed.Views.Material.FloatingActionsMenu;

/**
 * Created by charlesx on 4/18/15.
 * Inherited by fragments that have a FloatingActionMenu
 */
public abstract class FloatingActionMenuAbstractFragment extends Fragment {

    public FloatingActionsMenu mMenu;

    /**
     * Checks if mMenu is open
     * @return Boolean that tells you whether or not the menu was open
     */
    public boolean isMenuOpen() {
        return mMenu.isExpanded();
    }

    /**
     * Closes mMenu
     */
    public void closeMenu() {
        mMenu.collapse();
    }
}
