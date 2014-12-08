package com.blueprint.watershed.Views;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.blueprint.watershed.R;

/**
 * Created by Mark Miyashita on 12/7/14.
 */
public class CircularTextView extends RelativeLayout {

    private TextView mPrimaryLabel;
    private TextView mSecondaryLabel;

    public CircularTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initializeViews();

        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        inflater.inflate(R.layout.circular_text_view, this, true);
    }

    public void initializeViews() {
        setPrimaryLabel((TextView) findViewById(R.id.primary_label));
        setSecondaryLabel((TextView) findViewById(R.id.secondary_label));
    }

    // Getters
    public TextView getPrimaryLabel() { return mPrimaryLabel; }
    public TextView getSecondaryLabel() { return mSecondaryLabel; }

    // Setters
    public void setPrimaryLabel(TextView primaryLabel) { mPrimaryLabel = primaryLabel; }
    public void setSecondaryLabel(TextView secondaryLabel) { mSecondaryLabel = secondaryLabel; }
}
