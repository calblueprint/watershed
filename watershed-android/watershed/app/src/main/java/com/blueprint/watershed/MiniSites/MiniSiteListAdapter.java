package com.blueprint.watershed.MiniSites;

import android.support.v4.view.GestureDetectorCompat;
import android.view.GestureDetector;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Views.CoverPhotoPagerView;

import java.util.ArrayList;

/**
 * Created by Mark Miyashita on 11/16/14.
 * Adapter to show minisites
 */
public class MiniSiteListAdapter extends ArrayAdapter<MiniSite> {

    private MainActivity mActivity;
    private ArrayList<MiniSite> mMiniSites;
    private Site mSite;

    public MiniSiteListAdapter(MainActivity activity, ArrayList<MiniSite> miniSites, Site site) {
        super(activity, R.layout.mini_site_list_row, miniSites);
        mActivity = activity;
        mMiniSites = miniSites;
        mSite = site;
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

            row.setTag(holder);
        } else {
            holder = (MiniSiteHolder)row.getTag();
        }

        final MiniSite miniSite = mMiniSites.get(position);
        holder.photosView.configureWithPhotos(miniSite.getPhotos());
        holder.coverPhotoLabel.setText(String.format("%s Field Reports", miniSite.getFieldReportsCount()));
        holder.topLabel.setText(miniSite.getName());

        final TapGestureListener listener = new TapGestureListener(mActivity, mSite, miniSite);
        final GestureDetectorCompat gesture = new GestureDetectorCompat(mActivity, listener);

        row.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mActivity.replaceFragment(MiniSiteFragment.newInstance(mSite, miniSite));
            }
        });

        holder.photosView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                gesture.onTouchEvent(event);
                return false;
            }
        });
        return row;
    }

    static class MiniSiteHolder {
        CoverPhotoPagerView photosView;
        TextView coverPhotoLabel;
        TextView topLabel;
    }

    class TapGestureListener extends GestureDetector.SimpleOnGestureListener {

        public MainActivity activity;
        public Site site;
        public MiniSite minisite;

        public TapGestureListener(MainActivity activity, Site site, MiniSite miniSite) {
            this.activity = activity;
            this.site = site;
            this.minisite = miniSite;
        }

        @Override
        public boolean onSingleTapUp(MotionEvent e) {
            activity.replaceFragment(MiniSiteFragment.newInstance(site, minisite));
            return super.onSingleTapUp(e);
        }
    }
}
