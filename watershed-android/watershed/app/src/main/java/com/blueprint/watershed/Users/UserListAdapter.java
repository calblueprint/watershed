package com.blueprint.watershed.Users;

import android.app.Activity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.blueprint.watershed.R;

import java.util.List;

/**
 * Created by charlesx on 4/28/15.
 */
public class UserListAdapter extends ArrayAdapter<User> {

    private Activity mActivity;
    private List<User> mUsers;

    public UserListAdapter(Activity activity, List<User> users) {
        super(activity, R.layout.user_index_list_row, users);
        mActivity = activity;
        mUsers = users;
    }

    @Override
    public User getItem(int position) { return mUsers.get(position); }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        UserIndexListHolder holder;
        if (row == null) {
            row = mActivity.getLayoutInflater().inflate(R.layout.user_index_list_row, parent, false);

            holder = new UserIndexListHolder();

            holder.mName = (TextView) row.findViewById(R.id.user_name);
        } else {
            holder = (UserIndexListHolder) row.getTag();
        }

        User user = getItem(position);
        holder.mName.setText(user.getName());

        return row;
    }

    static class UserIndexListHolder {
        TextView mName;
    }
}
