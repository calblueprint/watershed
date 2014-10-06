package com.blueprint.watershed;

import android.content.Context;
import android.util.AttributeSet;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * Created by Mark Miyashita on 10/4/14.
 */
public class CoverPhotoView extends View {

    private ImageView mImageView;
    private TextView mPrimaryLabel;
    private TextView mSecondaryLabel;

    public CoverPhotoView(Context context, AttributeSet attrs) {
       super(context, attrs);
       initializeViews();
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
