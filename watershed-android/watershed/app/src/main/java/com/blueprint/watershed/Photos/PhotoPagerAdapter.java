package com.blueprint.watershed.Photos;

import android.content.Context;
import android.graphics.Bitmap;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;

import java.util.ArrayList;

/**
 * Created by Mark Miyashita on 11/24/14.
 */
public class PhotoPagerAdapter extends PagerAdapter {

    private ArrayList<Photo> mPhotos;

    public void configureWithPhotos(ArrayList<Photo> photos) {
        mPhotos = photos;
    }

    @Override
    public int getCount() {
        return mPhotos.size();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == ((ImageView) object);
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        Context context = container.getContext();
        ImageView imageView = new ImageView(context);
        int padding = 10;
        imageView.setPadding(padding, padding, padding, padding);
        imageView.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
        imageView.setImageBitmap(getImage(position));
        container.addView(imageView, 0);
        return imageView;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((ImageView) object);
    }

    // Getters
    public Photo getPhoto(int position) { return mPhotos.get(position); }
    public Bitmap getImage(int position) { return getPhoto(position).getImage(); }
}
