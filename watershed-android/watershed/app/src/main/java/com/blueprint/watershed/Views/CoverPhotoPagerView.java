package com.blueprint.watershed.Views;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.ImageView;

import com.blueprint.watershed.Photos.PhotoPagerAdapter;
import com.blueprint.watershed.R;

import java.util.ArrayList;

/**
 * Created by Mark Miyashita on 10/5/14.
 */
public class CoverPhotoPagerView extends ViewPager {

    private ArrayList<ImageView> mImageViews;

    public CoverPhotoPagerView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initializeViews();

        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        inflater.inflate(R.layout.cover_photo_pager_view, this, true);
    }

    public void initializeViews() {
        ViewPager viewPager = (ViewPager) findViewById(R.id.view_pager);
        PhotoPagerAdapter photoPagerAdapter = new PhotoPagerAdapter();
        viewPager.setAdapter(photoPagerAdapter);
    }
}
