package com.blueprint.watershed.Sites;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.blueprint.watershed.R;


public class EditSiteFragment extends SiteAbstractFragment {

    private Site mSite;

    public static EditSiteFragment newInstance(Site site){
        EditSiteFragment fragment = new EditSiteFragment();
        fragment.setSite(site);
        return fragment;
    }

    private void setSite(Site site){ mSite = site; }
    /**
     * Presets the task with task information
     */
    private void setTextViews() {
        if (mSite.getName() != null) mTitleField.setText(mSite.getName());
        if (mSite.getDescription() != null) mDescriptionField.setText(mSite.getDescription());
        if (mSite.getStreet() != null) mAddressField.setText((mSite.getStreet()));
        if (mSite.getCity() != null) mCityField.setText(String.valueOf(mSite.getCity()));
        if (mSite.getZipCode() != null) mZipField.setText(String.valueOf(mSite.getZipCode()));
    }

    public void submitListener(){
        createSite(EDIT, mSite);
    }


}
