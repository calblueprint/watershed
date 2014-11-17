package com.blueprint.watershed.MiniSites;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.Site;

import java.util.ArrayList;

/**
 * Created by mark on 11/16/14.
 */
public class MiniSiteListAdapter extends ArrayAdapter<MiniSite> {

    Context context;
    int layoutResourceId;
    ArrayList<Site> sites;

    public MiniSiteListAdapter(Context context, int layoutResourceId, ArrayList<Site> sites) {
        super(context, layoutResourceId, sites);
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        this.sites = sites;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        SiteHolder holder = null;

        if (row == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();
            row = inflater.inflate(layoutResourceId, parent, false);

            holder = new SiteHolder();
            holder.name = (TextView) row.findViewById(R.id.primary_label);
            holder.description = (TextView) row.findViewById(R.id.secondary_label);

            row.setTag(holder);
        } else {
            holder = (SiteHolder)row.getTag();
        }

        Site site = sites.get(position);

        holder.name.setText(site.getName());
        holder.description.setText("");

        return row;
    }

    static class SiteHolder {
        TextView name;
        TextView description;
    }
}
