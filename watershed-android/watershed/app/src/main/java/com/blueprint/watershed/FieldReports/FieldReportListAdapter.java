package com.blueprint.watershed.FieldReports;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;

import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Created by Mark Miyashita on 11/19/14.
 */
public class FieldReportListAdapter extends ArrayAdapter<FieldReport> {

    MainActivity mMainActivity;
    Context context;
    int layoutResourceId;
    List<FieldReport> fieldReports;

    public FieldReportListAdapter(MainActivity mainActivity, Context context, int layoutResourceId, List<FieldReport> fieldReports) {
        super(context, layoutResourceId, fieldReports);
        this.mMainActivity = mainActivity;
        this.layoutResourceId = layoutResourceId;
        this.context = context;
        this.fieldReports = fieldReports;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        FieldReportHolder holder;

        if (row == null) {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();
            row = inflater.inflate(layoutResourceId, parent, false);

            holder = new FieldReportHolder();
            holder.coverPhotoLabel = (TextView) row.findViewById(R.id.cover_photo_label);
            holder.topLabel = (TextView) row.findViewById(R.id.top_label);
            holder.bottomLabel = (TextView) row.findViewById(R.id.bottom_label);

            row.setTag(holder);
        } else {
            holder = (FieldReportHolder)row.getTag();
        }

        final FieldReport fieldReport = fieldReports.get(position);
        holder.coverPhotoLabel.setText(String.valueOf(fieldReport.getHealthRating()));

        int color;
        if (fieldReport.getHealthRating() < 3) {
            color = R.color.red_500;
        } else if (fieldReport.getHealthRating() < 5) {
            color = R.color.yellow_500;
        } else {
            color = R.color.green_500;
        }
        holder.coverPhotoLabel.setTextColor(mMainActivity.getResources().getColor(color));

        String date = new SimpleDateFormat("MMMM dd, yyyy").format(fieldReport.getCreatedAt());
        holder.topLabel.setText("Field Report - " + date);
        holder.bottomLabel.setText(String.format("Submitted by: %s", fieldReport.getUserName()));

        row.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                FieldReportFragment fieldReportFragment = FieldReportFragment.newInstance(fieldReport);
                mMainActivity.replaceFragment(fieldReportFragment);
            }
        });

        return row;
    }

    static class FieldReportHolder {
        TextView coverPhotoLabel;
        TextView topLabel;
        TextView bottomLabel;
    }
}
