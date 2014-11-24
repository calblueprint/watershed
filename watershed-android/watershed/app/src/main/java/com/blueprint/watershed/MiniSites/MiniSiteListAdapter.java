package com.blueprint.watershed.MiniSites;

import android.app.Activity;
import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.blueprint.watershed.Photos.PhotoPagerAdapter;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Views.CoverPhotoPagerView;

import java.util.ArrayList;

/**
 * Created by Mark Miyashita on 11/16/14.
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
            holder.photosView = (CoverPhotoPagerView) row.findViewById(R.id.cover_photo_pager_view);

            row.setTag(holder);
        } else {
            holder = (MiniSiteHolder)row.getTag();
        }

        MiniSite miniSite = miniSites.get(position);
        holder.photosView.configureWithPhotos(miniSite.getPhotos());

        return row;
    }

    static class MiniSiteHolder {
        CoverPhotoPagerView photosView;
    }
}
