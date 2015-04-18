package com.blueprint.watershed.Sites;

import android.annotation.TargetApi;
import android.content.Context;
import android.support.v7.widget.CardView;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Views.CoverPhotoPagerView;

import java.util.List;

/**
 * Created by Mark Miyashita on 10/14/14.
 * Adapter that holds all the sites.
 */
public class SiteListAdapter extends RecyclerView.Adapter<SiteListAdapter.ViewHolder> {

    protected MainActivity mParentActivity;
    protected Context context;
    protected int layoutResourceId;
    protected List<Site> sites;

    public SiteListAdapter(MainActivity mainActivity, int layoutResourceId, List<Site> sites) {
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

    @SuppressWarnings("deprecation")
    @TargetApi(21)
    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {
        // - get element from your dataset at this position
        // - replace the contents of the view with that element
        if (sites.size() > 0 && position < sites.size()) {
            final Site site = sites.get(position);
            holder.photosView.configureWithPhotos(site.getPhotos());
            holder.topLabel.setText(site.getName());
            holder.bottomLabel.setText(String.format("%s, %s", site.getCity(), site.getState()));

            int numSites = site.getMiniSitesCount();
            String numSitesString = String.format("%s Site", numSites);
            if (numSites > 1 || numSites == 0) numSitesString += "s";
            holder.sitesLabel.setText(numSitesString);

            View.OnClickListener listener = new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    mParentActivity.replaceFragment(SiteFragment.newInstance(site));
                }
            };
            holder.parentView.setOnClickListener(listener);
        }
    }

    @Override
    public int getItemCount() {
        return sites.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        // each data item is just a string in this case
        RelativeLayout parentView;
        CoverPhotoPagerView photosView;
        TextView topLabel;
        TextView bottomLabel;
        TextView sitesLabel;
        CardView cardView;

        public ViewHolder(View view) {
            super(view);
            parentView = (RelativeLayout) view.findViewById(R.id.site_list_row);
            photosView = (CoverPhotoPagerView) view.findViewById(R.id.cover_photo_pager_view);
            topLabel = (TextView) view.findViewById(R.id.top_label);
            bottomLabel = (TextView) view.findViewById(R.id.bottom_label);
            sitesLabel = (TextView) view.findViewById(R.id.number_mini_sites_label);
            cardView = (CardView) view.findViewById(R.id.site_card_view);
        }
    }
}
