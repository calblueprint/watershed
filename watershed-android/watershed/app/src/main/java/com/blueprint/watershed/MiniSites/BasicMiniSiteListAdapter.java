package com.blueprint.watershed.MiniSites;

import android.app.Activity;
import android.content.Context;
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
 * Created by maxwolffe on 3/16/15.
 */
public class BasicMiniSiteListAdapter extends ArrayAdapter<MiniSite> {

        MainActivity mMainActivity;
        Context context;
        int layoutResourceId;
        ArrayList<MiniSite> miniSites;

        public BasicMiniSiteListAdapter(MainActivity mainActivity, Context context, int layoutResourceId, ArrayList<MiniSite> miniSites) {
            super(context, layoutResourceId, miniSites);
            this.mMainActivity = mainActivity;
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
                holder.topLabel = (TextView) row.findViewById(R.id.top_label);
                holder.bottomLabel = (TextView) row.findViewById(R.id.bottom_label);

                row.setTag(holder);
            } else {
                holder = (MiniSiteHolder)row.getTag();
            }

            final MiniSite miniSite = miniSites.get(position);
            holder.topLabel.setText(miniSite.getName());
            holder.bottomLabel.setText(miniSite.getLocation());

            row.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    MiniSiteFragment miniSiteFragment = new MiniSiteFragment();
                    miniSiteFragment.configureWithMiniSite(miniSite);

                    mMainActivity.replaceFragment(miniSiteFragment);
                }
            });

            return row;
        }

        static class MiniSiteHolder {
            TextView topLabel;
            TextView bottomLabel;
        }
    }

