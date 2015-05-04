package com.blueprint.watershed.Users;

import android.app.Activity;
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
import com.blueprint.watershed.Networking.Users.UpdateUserRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Utilities.Utility;

import org.json.JSONException;
import org.json.JSONObject;

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

    public UserListAdapter(Activity activity, List<User> users) {
        super(activity, R.layout.user_index_list_row, users);
        mParentActivity = (MainActivity) activity;
        mNetworkManager = mParentActivity.getNetworkManager();
        mUsers = users;
    }

    @Override
    public User getItem(int position) { return mUsers.get(position); }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        View makeAdminButton;
        View makeMemberButton;
        View deleteUserButton;

        final UserIndexListHolder holder;
        if (row == null) {
            row = mParentActivity.getLayoutInflater().inflate(R.layout.user_index_list_row, parent, false);
            holder = new UserIndexListHolder();
            holder.mName = (TextView) row.findViewById(R.id.user_name);
            holder.mToolbar = (LinearLayout) row.findViewById(R.id.user_options);
            row.setTag(holder);
        } else {
            holder = (UserIndexListHolder) row.getTag();
        }

        final User user = getItem(position);

        makeAdminButton = holder.mToolbar.findViewById(R.id.make_manager);
        makeMemberButton = holder.mToolbar.findViewById(R.id.make_member);
        deleteUserButton = holder.mToolbar.findViewById(R.id.delete_user);
        makeAdminButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setUserRole(user, ADMIN);
            }
        });

        makeMemberButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setUserRole(user, VOLUNTEER);
            }
        });
        deleteUserButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });


        holder.mName.setText(user.getName());
        holder.mName.setOnClickListener(new View.OnClickListener() {
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

        if (user.getExpanded()) { holder.mToolbar.setVisibility(View.VISIBLE); }
        else { holder.mToolbar.setVisibility(View.GONE); }

        return row;
    }

    private void setUserRole(User user, int role) {
        JSONObject userObj = new JSONObject();
        JSONObject params = new JSONObject();
        try {
            params.put("role", role);
            userObj.put("user", params);
        } catch (JSONException e) {
            Log.i("JSONEXCEPTION", e.toString());
        }

        UpdateUserRequest request = new UpdateUserRequest(mParentActivity, user, userObj,
                new Response.Listener<User>() {
                    @Override
                    public void onResponse(User user) {
                    }
                },BaseRequest.makeUserResourceURL(user.getId(), "register"));
        mNetworkManager.getRequestQueue().add(request);
    }

    static class UserIndexListHolder {
        TextView mName;
        LinearLayout mToolbar;
    }
}
