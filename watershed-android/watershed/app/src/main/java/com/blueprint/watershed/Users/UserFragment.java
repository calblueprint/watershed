package com.blueprint.watershed.Users;

import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Utilities.Utility;

import java.util.ArrayList;

/**
 * Displays user information, tasks, field reports, and sites.
 */
public class UserFragment extends Fragment implements ListView.OnItemClickListener {

    private static final String PREFERENCES = "LOGIN_PREFERENCES";

    private User mUser;
    private MainActivity mParentActivity;
    private ProfileOptionsAdapter mAdapter;

    // Views
    private TextView mNameView;
    private TextView mEmailView;
    private TextView mRoleView;
    private ListView mList;

    public static UserFragment newInstance(User user) {
        UserFragment fragment = new UserFragment();
        fragment.setUser(user);
        return fragment;
    }

    /**
     * Sets the fragment's user.
     * @param user - A User object.
     */
    public void setUser(User user) { mUser = user; }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mParentActivity = (MainActivity) getActivity();
        setHasOptionsMenu(true);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        return inflater.inflate(R.layout.fragment_profile, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initializeViews();
        initializeListLayout();
    }

    /**
     * Displays a user's name, email, and role
     */
    private void initializeViews() {
        mNameView = (TextView) mParentActivity.findViewById(R.id.profile_name);
        mNameView.setText(mUser.getName());
        mEmailView = (TextView) mParentActivity.findViewById(R.id.profile_email);
        mEmailView.setText(mUser.getEmail());
        mRoleView = (TextView) mParentActivity.findViewById(R.id.profile_role);
        mRoleView.setText(mUser.getRoleString());
    }

    /**
     * Initializes the ListView that displays a user's field reports
     * (Tasks and Sites loaded only for employees and managers)
     */
    private void initializeListLayout() {
        mList = (ListView) mParentActivity.findViewById(R.id.profile_options);
        ArrayList<String> options = new ArrayList <String>();

        options.add("Field Reports: " + mUser.getFieldReportsCount());

        mAdapter = new ProfileOptionsAdapter(getActivity(), R.layout.option_item, options);
        mList.setAdapter(mAdapter);
        mList.setOnItemClickListener(this);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.user_profile_menu, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public void onResume(){
        super.onResume();
        mParentActivity.setMenuAction(true);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.edit:
                editUser();
                break;
            case R.id.logout:
                confirmLogout();
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        switch (position) {
            case 0:
                UserFieldReportFragment fieldReportFragment = UserFieldReportFragment.newInstance(mUser);
                mParentActivity.replaceFragment(fieldReportFragment);
                break;
            case 1:
                UserTaskFragment taskFragment = UserTaskFragment.newInstance(mUser);
                mParentActivity.replaceFragment(taskFragment);
                break;
            case 2:
                UserMiniSiteFragment siteFragment = UserMiniSiteFragment.newInstance(mUser);
                mParentActivity.replaceFragment(siteFragment);
        }
    }

    private void editUser() { mParentActivity.replaceFragment(EditUserFragment.newInstance(mUser)); }

    private void confirmLogout() {
        Utility.showAndBuildDialog(mParentActivity, R.string.logout_title, R.string.logout_message,
            new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    MainActivity.logoutCurrentUser(mParentActivity);
                }
            },
            new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                }
            });
    }
}
