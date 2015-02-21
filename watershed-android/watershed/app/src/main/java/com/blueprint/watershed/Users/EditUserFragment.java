package com.blueprint.watershed.Users;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;

/**
 * Created by charlesx on 2/21/15.
 * Fragment where you can edit a profile
 */
public class EditUserFragment extends Fragment {

    private MainActivity mParentActivity;

    private User mUser;

    public static EditUserFragment newInstance(User user) {
        EditUserFragment fragment = new EditUserFragment();
        fragment.setUser(user);
        return fragment;
    }

    public void setUser(User user) { mUser = user; }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        return inflater.inflate(R.layout.fragment_edit_user, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initializeViews();
    }

    private void initializeViews() {

    }


}
