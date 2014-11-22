package com.blueprint.watershed.Views;

import android.content.Context;
import android.util.AttributeSet;

import android.view.LayoutInflater;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.blueprint.watershed.R;

/**
 * Created by Mark Miyashita on 10/4/14.
 */
public class CoverPhotoView extends RelativeLayout {

    private ImageView mImageView;
    private TextView mPrimaryLabel;
    private TextView mSecondaryLabel;

    public CoverPhotoView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initializeViews();

        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        inflater.inflate(R.layout.cover_photo_view, this, true);
    }

    public void initializeViews() {
        setImageView((ImageView) findViewById(R.id.cover_photo));
        setPrimaryLabel((TextView) findViewById(R.id.primary_label));
        setSecondaryLabel((TextView) findViewById(R.id.secondary_label));
    }

    // Getters
    public ImageView getImageView() { return mImageView; }
    public TextView getPrimaryLabel() { return mPrimaryLabel; }
    public TextView getSecondaryLabel() { return mSecondaryLabel; }

    // Setters
    public void setImageView(ImageView imageView) { mImageView = imageView; }
    public void setPrimaryLabel(TextView primaryLabel) { mPrimaryLabel = primaryLabel; }
    public void setSecondaryLabel(TextView secondaryLabel) { mSecondaryLabel = secondaryLabel; }
}
