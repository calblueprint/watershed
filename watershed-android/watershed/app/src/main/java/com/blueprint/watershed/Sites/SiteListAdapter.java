package com.blueprint.watershed.Sites;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.blueprint.watershed.R;
import com.blueprint.watershed.Views.CircularTextView;
import com.blueprint.watershed.Views.CoverPhotoPagerView;

import java.util.ArrayList;

/**
 * Created by Mark Miyashita on 10/14/14.
 */
public class SiteListAdapter extends ArrayAdapter<Site> implements View.OnClickListener {

    Context context;
    int layoutResourceId;
    ArrayList<Site> sites;

    public SiteListAdapter(Context context, int layoutResourceId, ArrayList<Site> sites) {
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
            holder.photosView = (CoverPhotoPagerView) row.findViewById(R.id.cover_photo_pager_view);
            holder.numberOfTasksView = (CircularTextView) row.findViewById(R.id.number_of_tasks_view);
            holder.topLabel = (TextView) row.findViewById(R.id.top_label);
            holder.bottomLabel = (TextView) row.findViewById(R.id.bottom_label);

            row.setTag(holder);
        } else {
            holder = (SiteHolder)row.getTag();
        }

        Site site = sites.get(position);

        holder.photosView.configureWithPhotos(site.getPhotos());
        holder.numberOfTasksView.configureLabels(Integer.toString(site.getTasksCount()), "Tasks");
        holder.topLabel.setText(site.getName());
        holder.bottomLabel.setText(String.format("%s Sites", site.getMiniSitesCount()));

        row.setOnClickListener(this);
        return row;
    }

    static class SiteHolder {
        CoverPhotoPagerView photosView;
        CircularTextView numberOfTasksView;
        TextView topLabel;
        TextView bottomLabel;
    }

    @Override
    public void onClick(View view) {
        Log.d("Sample", "Clicked on tag: " + view.getTag());
    }
}
