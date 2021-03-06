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
        String[] description = prediction.getDescription().split(",");
        String street = description[0].trim();

        String city = null;
        if (description.length > 1) city = description[1].trim();

        String state = null;
        if (description.length > 2) state = description[2].trim();

        holder.mTopLabel.setText(street);
        if (city != null && state != null) holder.mBottomLabel.setText(city + ", " + state);
        return row;
    }

    static class PlaceViewHolder {
        TextView mTopLabel;
        TextView mBottomLabel;
    }
}
