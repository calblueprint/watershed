package com.blueprint.watershed.MiniSites;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Views.CoverPhotoPagerView;

import java.util.ArrayList;

/**
 * Created by Mark Miyashita on 11/16/14.
 * Adapter to show minisites
 */
public class MiniSiteListAdapter extends ArrayAdapter<MiniSite> {

    private MainActivity mActivity;
    private ArrayList<MiniSite> mMiniSites;

    public MiniSiteListAdapter(MainActivity activity, ArrayList<MiniSite> miniSites) {
        super(activity, R.layout.mini_site_list_row, miniSites);
        mActivity = activity;
        mMiniSites = miniSites;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        MiniSiteHolder holder;

        if (row == null) {
            LayoutInflater inflater = mActivity.getLayoutInflater();
            row = inflater.inflate(R.layout.mini_site_list_row, parent, false);

            holder = new MiniSiteHolder();
            holder.photosView = (CoverPhotoPagerView) row.findViewById(R.id.cover_photo_pager_view);
            holder.coverPhotoLabel = (TextView) row.findViewById(R.id.cover_photo_label);
            holder.topLabel = (TextView) row.findViewById(R.id.top_label);
            holder.bottomLabel = (TextView) row.findViewById(R.id.bottom_label);

            row.setTag(holder);
        } else {
            holder = (MiniSiteHolder)row.getTag();
        }

        final MiniSite miniSite = mMiniSites.get(position);
        holder.photosView.configureWithPhotos(miniSite.getPhotos());
        holder.coverPhotoLabel.setText(String.format("%s Field Reports", miniSite.getFieldReportsCount()));
        holder.topLabel.setText(miniSite.getName());
        holder.bottomLabel.setText(miniSite.getLocation());

        row.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                MiniSiteFragment miniSiteFragment = MiniSiteFragment.newInstance(miniSite.getSiteId(), miniSite);
                mActivity.replaceFragment(miniSiteFragment);
            }
        });

        return row;
    }

    static class MiniSiteHolder {
        CoverPhotoPagerView photosView;
        TextView coverPhotoLabel;
        TextView topLabel;
        TextView bottomLabel;
    }
}
