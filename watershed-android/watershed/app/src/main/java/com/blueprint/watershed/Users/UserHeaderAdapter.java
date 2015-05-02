package com.blueprint.watershed.Users;

import android.app.Activity;
import android.graphics.Typeface;
import android.support.v4.app.Fragment;
import android.util.TypedValue;
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
 * Shows a list of users you can pick
 */
public class UserHeaderAdapter extends ArrayAdapter<User> {

    Activity mMainActivity;
    List<User> mUsers;
    Fragment mFragment;

    String HEADER = "header";
    String ROW = "row";

    public UserHeaderAdapter(Activity mainActivity, List<User> users, Fragment fragment) {
        super(mainActivity, R.layout.user_list_row, users);
        mMainActivity = mainActivity;
        mUsers = users;
        mFragment = fragment;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        UserHolder holder;
        final User user = getItem(position);

        if (row == null) {
            LayoutInflater inflater = mMainActivity.getLayoutInflater();
            row = inflater.inflate(R.layout.user_list_row, parent, false);

            holder = new UserHolder();
            holder.mTextView = (TextView) row.findViewById(R.id.user_row_text);

            row.setTag(holder);
        } else {
            holder = (UserHolder) row.getTag();
        }

        String text;
        int fontSize;
        int fontWeight;
        if (user.getLayoutType() == null) {
            text = user.getName();
            fontWeight = Typeface.NORMAL;
            fontSize = 18;
            row.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (mFragment instanceof TaskAbstractFragment) {
                        ((TaskAbstractFragment) mFragment).setUser(user);
                    }
                }
            });
        } else {
            fontSize = 15;
            fontWeight = Typeface.BOLD;
            text = user.getLayoutType().toUpperCase();
            row.setClickable(false);
        }
        holder.mTextView.setTextSize(TypedValue.COMPLEX_UNIT_SP, fontSize);
        holder.mTextView.setText(text);
        holder.mTextView.setTypeface(null, fontWeight);
        return row;
    }

    static class UserHolder {
        TextView mTextView;
    }
}
