package com.blueprint.watershed.Users;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.blueprint.watershed.R;

import java.util.ArrayList;

/**
 * Created by maxwolffe on 12/7/14.
 * Shows tasks, field reports, and minisites
 */
public class ProfileOptionsAdapter extends ArrayAdapter<String> {

    Context context;
    int layoutResourceId;
    ArrayList<String> options;

    public ProfileOptionsAdapter(Context context, int layoutResourceId, ArrayList<String> counts) {
        super(context, layoutResourceId, counts);
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        this.options = counts;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        OptionHolder holder;

        if (row == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();
            row = inflater.inflate(layoutResourceId, parent, false);

            holder = new OptionHolder();
            holder.option = (TextView) row.findViewById(R.id.primary_label);
            holder.count = (TextView) row.findViewById(R.id.secondary_label);

            row.setTag(holder);
        } else {
            holder = (OptionHolder)row.getTag();
        }

        String option = options.get(position);
        String[] optionList = option.split(" ");
        if (optionList[1].equals("null")){
            holder.option.setText(optionList[0] + " 0");
        }
        else {
            holder.option.setText(option);
        }
        holder.count.setText("");

        return row;
    }

    static class OptionHolder {
        TextView option;
        TextView count;
    }
}
