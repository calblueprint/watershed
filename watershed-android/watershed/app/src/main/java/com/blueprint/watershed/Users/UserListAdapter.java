package com.blueprint.watershed.Users;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Users.DeleteUserRequest;
import com.blueprint.watershed.Networking.Users.UpdateUserRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Utilities.Utility;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by charlesx on 4/28/15.
 */
public class UserListAdapter extends ArrayAdapter<User> {

    private int ADMIN = 1;
    private int VOLUNTEER = 2;

    private MainActivity mParentActivity;
    private List<User> mUsers;
    private UserListFragment mParentFragment;
    private NetworkManager mNetworkManager;

    public UserListAdapter(Activity activity, List<User> users, UserListFragment parentFragment) {
        super(activity, R.layout.user_index_list_row, users);
        mParentActivity = (MainActivity) activity;
        mParentFragment = parentFragment;
        mNetworkManager = mParentActivity.getNetworkManager();
        mUsers = users;
    }

    @Override
    public User getItem(int position) { return mUsers.get(position); }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;

        final UserIndexListHolder holder;
        final User user = getItem(position);

        if (row == null) {
            row = mParentActivity.getLayoutInflater().inflate(R.layout.user_index_list_row, parent, false);
            holder = new UserIndexListHolder();
            holder.mName = (TextView) row.findViewById(R.id.user_name);
            holder.mRole = (TextView) row.findViewById(R.id.user_role);
            holder.mRow = row;
            holder.mToolbar = (LinearLayout) row.findViewById(R.id.user_options);
            row.setTag(holder);
        } else {
            holder = (UserIndexListHolder) row.getTag();
        }

        setButtonListeners(holder, user);

        if (user.getExpanded()) { holder.mToolbar.setVisibility(View.VISIBLE); }
        else { holder.mToolbar.setVisibility(View.GONE); }

        return row;
    }

    private void setButtonListeners(final UserIndexListHolder holder, final User user) {
        View makeAdminButton;
        View makeMemberButton;
        View deleteUserButton;

        makeAdminButton = holder.mToolbar.findViewById(R.id.make_manager);
        makeMemberButton = holder.mToolbar.findViewById(R.id.make_member);
        deleteUserButton = holder.mToolbar.findViewById(R.id.delete_user);
        makeAdminButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mParentFragment.setUserRole(user, ADMIN);
            }
        });

        makeMemberButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mParentFragment.setUserRole(user, VOLUNTEER);
            }
        });
        deleteUserButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mParentFragment.showDeleteCheckDialog(user);
            }
        });

        holder.mName.setText(user.getName());
        holder.mRole.setText(user.getRoleString());
        holder.mRow.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (holder.mToolbar.getVisibility() == View.GONE) {
                    Utility.expand(holder.mToolbar);
                    user.setExpanded(true);
                } else {
                    Utility.collapse(holder.mToolbar);
                    user.setExpanded(false);
                }
            }
        });
    }

    static class UserIndexListHolder {
        TextView mName;
        TextView mRole;
        LinearLayout mToolbar;
        View mRow;
    }
}
