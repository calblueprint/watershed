package com.blueprint.watershed.FieldReports;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.MiniSites.MiniSiteFragment;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Views.CoverPhotoPagerView;

import java.util.ArrayList;

/**
 * Created by Mark Miyashita on 11/19/14.
 */
public class FieldReportListAdapter extends ArrayAdapter<FieldReport> {

    MainActivity mMainActivity;
    Context context;
    int layoutResourceId;
    ArrayList<FieldReport> fieldReports;

    public FieldReportListAdapter(MainActivity mainActivity, Context context, int layoutResourceId, ArrayList<FieldReport> fieldReports) {
        super(context, layoutResourceId, fieldReports);
        this.mMainActivity = mainActivity;
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        this.fieldReports = fieldReports;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        FieldReportHolder holder = null;

        if (row == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();
            row = inflater.inflate(layoutResourceId, parent, false);

            holder = new FieldReportHolder();
            holder.photosView = (CoverPhotoPagerView) row.findViewById(R.id.cover_photo_pager_view);
            holder.coverPhotoLabel = (TextView) row.findViewById(R.id.cover_photo_label);
            holder.topLabel = (TextView) row.findViewById(R.id.top_label);
            holder.bottomLabel = (TextView) row.findViewById(R.id.bottom_label);

            row.setTag(holder);
        } else {
            holder = (FieldReportHolder)row.getTag();
        }

        final FieldReport fieldReport = fieldReports.get(position);
        holder.photosView.configureWithPhotos(fieldReport.getPhotos());
        holder.coverPhotoLabel.setText(String.format("Rating: %s", fieldReport.getHealthRating()));
        holder.topLabel.setText("12/8/2014");
        holder.bottomLabel.setText(String.format("By: %s", fieldReport.getUserName()));

        row.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                FieldReportFragment fieldReportFragment = new FieldReportFragment();
                fieldReportFragment.configureWithFieldReport(fieldReport);
                mMainActivity.replaceFragment(fieldReportFragment);
            }
        });

        return row;
    }

    static class FieldReportHolder {
        CoverPhotoPagerView photosView;
        TextView coverPhotoLabel;
        TextView topLabel;
        TextView bottomLabel;
    }
}
