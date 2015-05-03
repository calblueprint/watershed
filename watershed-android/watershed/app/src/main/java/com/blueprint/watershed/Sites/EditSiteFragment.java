package com.blueprint.watershed.Sites;

import android.os.Bundle;


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
    }

    public void submitListener(){
        createSite(EDIT, mSite);
    }


}
