package com.blueprint.watershed.Users;

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

import java.util.ArrayList;

/**
 * Displays user information, tasks, field reports, and sites.
 */
public class UserFragment extends Fragment implements ListView.OnItemClickListener{

    private User mUser;
    private MainActivity mParentActivity;
    private ProfileOptionsAdapter mAdapter;

    // Views
    private TextView mName;
    private TextView mEmail;
    private TextView mRole;
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

    public UserFragment() {}

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        mParentActivity = (MainActivity) getActivity();
        return inflater.inflate(R.layout.fragment_profile, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initializeViews();
        initializeListLayout();
    }

    @Override
    public void onResume(){
        super.onResume();
    }

    /**
     * Displays a user's name, email, and role
     */
    private void initializeViews() {
        mName = (TextView) mParentActivity.findViewById(R.id.profile_name);
        mName.setText(mUser.getName());
        mEmail = (TextView) mParentActivity.findViewById(R.id.profile_email);
        mEmail.setText(mUser.getEmail());
        mRole = (TextView) mParentActivity.findViewById(R.id.profile_role);

        if (mUser.isCommunityMember()) mRole.setText("Community Member");
        else if (mUser.isEmployee()) mRole.setText("Employee");
        else mRole.setText("Manager");
    }

    /**
     * Initializes the ListView that displays a user's field reports
     * (Tasks and Sites loaded only for employees and managers)
     */
    private void initializeListLayout() {
        mList = (ListView) mParentActivity.findViewById(R.id.profile_options);
        ArrayList<String> options = new ArrayList <String>();

        options.add("Field-Reports " + mUser.getFieldReportsCount());
        if (mUser.isEmployee() || mUser.isManager()){
            options.add("Tasks " + mUser.getFieldReportsCount());
            options.add("Sites " + mUser.getSitesCount());
        }

        mAdapter = new ProfileOptionsAdapter(getActivity(), R.layout.option_item, options);
        mList.setAdapter(mAdapter);
        mList.setOnItemClickListener(this);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.create_task_menu, menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle item selection
        switch (item.getItemId()) {
            case R.id.add_task:
                mParentActivity.replaceFragment(EditUserFragment.newInstance(mUser));
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        switch (position) {
            case 0:
                //Field Reports
            case 1:
                // Tasks
            case 2:
                // Sites
        }
    }
}
