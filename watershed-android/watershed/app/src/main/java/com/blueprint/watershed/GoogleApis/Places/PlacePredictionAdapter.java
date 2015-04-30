package com.blueprint.watershed.GoogleApis.Places;

import android.app.Activity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.blueprint.watershed.R;
import com.google.android.gms.location.places.AutocompletePrediction;

import java.util.List;

/**
 * Created by charlesx on 4/24/15.
 * Displays row for predictions
 */
public class PlacePredictionAdapter extends ArrayAdapter<AutocompletePrediction> {

    private Activity mActivity;
    private List<AutocompletePrediction> mPredictions;

    public PlacePredictionAdapter(Activity activity, List<AutocompletePrediction> predictions) {
        super(activity, R.layout.places_prediction_row, predictions);
        mActivity = activity;
        mPredictions = predictions;
    }

    @Override
    public AutocompletePrediction getItem(int position) { return mPredictions.get(position); }

    @Override
    public int getCount() { return mPredictions.size(); }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        PlaceViewHolder holder;

        if (row == null) {
            row = mActivity.getLayoutInflater().inflate(R.layout.places_prediction_row, parent, false);
            holder = new PlaceViewHolder();

            holder.mTopLabel = (TextView) row.findViewById(R.id.top_address_label);
            holder.mBottomLabel = (TextView) row.findViewById(R.id.bottom_address_label);

            row.setTag(holder);
        } else {
            holder = (PlaceViewHolder) row.getTag();
        }

        AutocompletePrediction prediction = getItem(position);

        holder.mTopLabel.setText(prediction.getDescription());
        return row;
    }

    static class PlaceViewHolder {
        TextView mTopLabel;
        TextView mBottomLabel;
    }
}
