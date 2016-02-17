package com.blueprint.watershed.MiniSites;

import android.os.Bundle;
import android.view.MenuItem;
import android.widget.Toast;

import com.android.volley.Response;
import com.blueprint.watershed.Networking.MiniSites.EditMiniSiteRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Utilities.Utility;

/**
 * Created by charlesx on 3/17/15.
 */
public class EditMiniSiteFragment extends MiniSiteAbstractFragment {

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment CreateMiniSiteFragment.
     */
    public static EditMiniSiteFragment newInstance(Site site, MiniSite miniSite) {
        EditMiniSiteFragment fragment = new EditMiniSiteFragment();
        fragment.setSite(site);
        fragment.setMiniSite(miniSite);
        return fragment;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        setMiniSiteInfo();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.save:
                validateAndSubmitMiniSite();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    private void setMiniSiteInfo() {
        if (mMiniSite.getName() != null) mTitleField.setText(mMiniSite.getName());
        if (mMiniSite.getStreet() != null) mAddressField.setText(mMiniSite.getStreet());
        if (mMiniSite.getDescription() != null) mDescriptionField.setText(mMiniSite.getDescription());
        if (mMiniSite.getPhotos() != null) {
            setPhotos(mMiniSite.getPhotos());
            mImageAdapter.setPhotos(getPhotos());
            mImageAdapter.notifyDataSetChanged();
        }
    }

    @Override
    public void submitMiniSite(MiniSite miniSite) {
        EditMiniSiteRequest editMiniSiteRequest =
                new EditMiniSiteRequest(mParentActivity, miniSite, new Response.Listener<MiniSite>() {
                    @Override
                    public void onResponse(MiniSite miniSite) {
                        mMiniSite = miniSite;
                        Toast.makeText(mParentActivity, R.string.edit_mini_site, Toast.LENGTH_SHORT).show();
                        Utility.hideKeyboard(mParentActivity, mLayout);
                        mParentActivity.getSupportFragmentManager().popBackStack();
                    }
                });

        mParentActivity.addRequest(editMiniSiteRequest);
    }


}
