package com.blueprint.watershed.Sites;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Views.CircularTextView;
import com.blueprint.watershed.Views.CoverPhotoPagerView;

/**
 * Created by Mark Miyashita on 10/14/14.
 * Adapter that holds all the sites.
 */
public class SiteListAdapter extends RecyclerView.Adapter<SiteListAdapter.ViewHolder> {

    MainActivity mParentActivity;
    Context context;
    int layoutResourceId;
    SiteMapper sites;

    public static class ViewHolder extends RecyclerView.ViewHolder {
        // each data item is just a string in this case
        RelativeLayout parentView;
        CoverPhotoPagerView photosView;
        CircularTextView numberOfTasksView;
        TextView topLabel;
        TextView bottomLabel;
        public ViewHolder(View view) {
            super(view);
            parentView = (RelativeLayout) view.findViewById(R.id.site_list_row);
            photosView = (CoverPhotoPagerView) view.findViewById(R.id.cover_photo_pager_view);
            numberOfTasksView = (CircularTextView) view.findViewById(R.id.number_of_tasks_view);
            topLabel = (TextView) view.findViewById(R.id.top_label);
            bottomLabel = (TextView) view.findViewById(R.id.bottom_label);
        }
    }

    public SiteListAdapter(MainActivity mainActivity, int layoutResourceId, SiteMapper sites) {
        this.mParentActivity = mainActivity;
        this.layoutResourceId = layoutResourceId;
        this.context = mainActivity;
        this.sites = sites;
    }

    // Create new views (invoked by the layout manager)
    @Override
    public SiteListAdapter.ViewHolder onCreateViewHolder(ViewGroup parent,
                                                   int viewType) {
        // create a new view
        View v = LayoutInflater.from(parent.getContext()).inflate(layoutResourceId, parent, false);
        // set the view's size, margins, paddings and layout parameters
        return new ViewHolder(v);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        // - get element from your dataset at this position
        // - replace the contents of the view with that element
        if (sites.size() > 0 && position < sites.size()) {
            final Site site = sites.getSiteWithPosition(position);
            holder.photosView.configureWithPhotos(site.getPhotos());
            holder.numberOfTasksView.configureLabels(Integer.toString(site.getTasksCount()), "TASKS");
            holder.topLabel.setText(site.getName());
            holder.bottomLabel.setText(String.format("%s Sites", site.getMiniSitesCount()));
            holder.parentView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    SiteFragment siteFragment = new SiteFragment();
                    siteFragment.configureWithSite(site);

                    mParentActivity.replaceFragment(siteFragment);
                }
            });
        }
    }

    @Override
    public int getItemCount() {
        return sites.size();
    }
}
