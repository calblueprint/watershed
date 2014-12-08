package com.blueprint.watershed.Views;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewParent;
import android.widget.ImageView;

import com.blueprint.watershed.Photos.Photo;
import com.blueprint.watershed.Photos.PhotoPagerAdapter;
import com.blueprint.watershed.R;

import java.util.ArrayList;

/**
 * Created by Mark Miyashita on 10/5/14.
 */
public class CoverPhotoPagerView extends ViewPager {

    private PhotoPagerAdapter mAdapter;

    public CoverPhotoPagerView(Context context, AttributeSet attrs) {
        super(context, attrs);

        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        inflater.inflate(R.layout.cover_photo_pager_view, this, true);
        initializeViews(context);
    }

    public void initializeViews(Context context) {
        mAdapter = new PhotoPagerAdapter(context);
        this.setAdapter(mAdapter);
    }

    public void configureWithPhotos(ArrayList<Photo> photos) {
        mAdapter.configureWithPhotos(photos);
        mAdapter.notifyDataSetChanged();
    }
}
