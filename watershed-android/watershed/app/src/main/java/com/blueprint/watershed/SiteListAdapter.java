package com.blueprint.watershed;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

/**
 * Created by Mark Miyashita on 10/14/14.
 */
public class SiteListAdapter extends ArrayAdapter<Site> {

    Context context;
    int layoutResourceId;
    Site data[] = null;

    public SiteListAdapter(Context context, int layoutResourceId, Site[] data) {
        super(context, layoutResourceId, data);
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        this.data = data;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        SiteHolder holder = null;

        if (row == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();
            row = inflater.inflate(layoutResourceId, parent, false);

            holder = new SiteHolder();
            holder.name = (TextView) row.findViewById(R.id.name);
            holder.description = (TextView) row.findViewById(R.id.description);

            row.setTag(holder);
        } else {
            holder = (SiteHolder)row.getTag();
        }

        Site site = data[position];

        holder.name.setText(site.getName());
        holder.description.setText(site.getDescription());

        return row;
    }

    static class SiteHolder {
        TextView name;
        TextView description;
    }
}
