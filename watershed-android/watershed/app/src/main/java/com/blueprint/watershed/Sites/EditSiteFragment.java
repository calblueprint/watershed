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

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        setTextViews();
    }

    /**
     * Presets the site with site information
     */
    private void setTextViews() {
        if (mSite.getName() != null) mTitleField.setText(mSite.getName());
        if (mSite.getDescription() != null) mDescriptionField.setText(mSite.getDescription());
        if (mSite.getStreet() != null) mAddressField.setText(mSite.getStreet());
        if (mSite.getCity() != null) mCityField.setText(mSite.getCity());
        if (mSite.getState() != null) mStateField.setText(mSite.getState());
        if (mSite.getZipCode() != null) mZipField.setText(String.valueOf(mSite.getZipCode()));
        mSubmitButton.setText("Edit Site");
    }

    public void submitListener(){
        createSite(EDIT, mSite);
    }


}
