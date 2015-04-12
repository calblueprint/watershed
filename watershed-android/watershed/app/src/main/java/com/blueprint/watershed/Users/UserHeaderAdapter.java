package com.blueprint.watershed.Users;

import android.app.Activity;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.blueprint.watershed.R;
import com.blueprint.watershed.Tasks.TaskAbstractFragment;

import java.util.List;

/**
 * Created by Mark Miyashita on 11/19/14.
 */
public class UserHeaderAdapter extends ArrayAdapter<User> {

    Activity mMainActivity;
    List<User> mUsers;
    Fragment mFragment;

    public UserHeaderAdapter(Activity mainActivity, List<User> users, Fragment fragment) {
        super(mainActivity, R.layout.user_item_row, users);
        mMainActivity = mainActivity;
        mUsers = users;
        mFragment = fragment;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        UserHolder holder;
        final User user = getItem(position);

        int id;
        if (user.getLayoutType() == null) id = R.layout.user_header_row;
        else                              id = R.layout.user_item_row;

        if (row == null) {
            LayoutInflater inflater = mMainActivity.getLayoutInflater();
            row = inflater.inflate(id, parent, false);

            holder = new UserHolder();
            holder.mTextView = (TextView) row.findViewById(R.id.user_row_text);
            row.setTag(holder);
        } else {
            holder = (UserHolder) row.getTag();
        }

        String text;
        if (user.getLayoutType() == null) {
            text = user.getName();
            row.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (mFragment instanceof TaskAbstractFragment) {
                        ((TaskAbstractFragment) mFragment).setUser(user);
                    }
                }
            });
        } else {
            text = user.getLayoutType();
        }
        holder.mTextView.setText(text);
        return row;
    }

    static class UserHolder {
        TextView mTextView;
    }
}
