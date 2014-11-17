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
    ArrayList<MiniSite> miniSites;

    public MiniSiteListAdapter(Context context, int layoutResourceId, ArrayList<MiniSite> miniSites) {
        super(context, layoutResourceId, miniSites);
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        this.miniSites = miniSites;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        MiniSiteHolder holder = null;

        if (row == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();
            row = inflater.inflate(layoutResourceId, parent, false);

            holder = new MiniSiteHolder();
            //holder.name = (TextView) row.findViewById(R.id.primary_label);
            //holder.description = (TextView) row.findViewById(R.id.secondary_label);

            row.setTag(holder);
        } else {
            holder = (MiniSiteHolder)row.getTag();
        }

        MiniSite miniSite = miniSites.get(position);

        holder.name.setText(miniSite.getName());
        holder.description.setText("");

        return row;
    }

    static class MiniSiteHolder {
        TextView name;
        TextView description;
    }
}
