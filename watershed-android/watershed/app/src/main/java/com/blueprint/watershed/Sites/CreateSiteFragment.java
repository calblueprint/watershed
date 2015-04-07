package com.blueprint.watershed.Sites;

import android.os.Bundle;
import android.support.v4.app.Fragment;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * to handle interaction events.
 * Use the {@link CreateSiteFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class CreateSiteFragment extends SiteAbstractFragment {

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment CreateSiteFragment.
     */
    public static CreateSiteFragment newInstance() {
        CreateSiteFragment fragment = new CreateSiteFragment();
        Bundle args = new Bundle();
        fragment.setArguments(args);
        return fragment;
    }

    public void startSiteRequest() { validateSiteRequest(null, "CREATE"); }
}
