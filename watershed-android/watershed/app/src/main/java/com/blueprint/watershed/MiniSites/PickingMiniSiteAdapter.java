package com.blueprint.watershed.MiniSites;

import android.app.Activity;
import android.graphics.Typeface;
import android.support.v4.app.Fragment;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.blueprint.watershed.R;
import com.blueprint.watershed.Tasks.TaskAbstractFragment;

import java.util.List;

/**
 * Created by charlesx on 5/7/15.
 * Adapter for Picking Mini Sites
 */
public class PickingMiniSiteAdapter extends ArrayAdapter<MiniSite> {

    private List<MiniSite> mMiniSites;
    private Activity mActivity;
    private Fragment mFragment;

    public PickingMiniSiteAdapter(Activity activity, List<MiniSite> miniSites, Fragment fragment) {
        super(activity, R.layout.pick_task_object_list_row, miniSites);
        mMiniSites = miniSites;
        mActivity = activity;
        mFragment = fragment;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup container) {
        View row = convertView;
        ViewHolder holder;

        if (row == null) {
            row = mActivity.getLayoutInflater().inflate(R.layout.pick_task_object_list_row, container, false);
            holder = new ViewHolder();
            holder.mTextView = (TextView) row.findViewById(R.id.object_row_text);

            row.setTag(holder);
        } else {
            holder = (ViewHolder) row.getTag();
        }

        final MiniSite miniSite = getItem(position);

        int fontSize;
        int fontWeight;
        String text = miniSite.getName();
        if (miniSite.isHeader()) {
            fontWeight = Typeface.NORMAL;
            fontSize = 18;
            row.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (mFragment instanceof TaskAbstractFragment) {
                        ((TaskAbstractFragment) mFragment).setMiniSite(miniSite);
                    }
                }
            });
        } else {
            fontSize = 15;
            fontWeight = Typeface.BOLD;
            row.setClickable(false);
        }

        holder.mTextView.setTextSize(TypedValue.COMPLEX_UNIT_SP, fontSize);
        holder.mTextView.setText(text);
        holder.mTextView.setTypeface(null, fontWeight);
        return row;
    }

    static class ViewHolder {
        TextView mTextView;
    }
}
