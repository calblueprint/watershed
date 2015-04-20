package com.blueprint.watershed.Authentication;



import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.blueprint.watershed.R;
import com.facebook.UiLifecycleHelper;

public class FacebookAuthFragment extends Fragment {

    private UiLifecycleHelper uiHelper;

    public static FacebookAuthFragment newInstance() {
        return new FacebookAuthFragment();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        uiHelper.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_facebook_auth, container, false);
    }
}
