package com.blueprint.watershed.Photos;

import android.content.Context;
import android.graphics.Bitmap;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;

import java.util.ArrayList;

/**
 * Created by Mark Miyashita on 11/24/14.
 */
public class PhotoPagerAdapter extends PagerAdapter {

    private LayoutInflater mLayoutInflater;
    private Context mContext;

    private ArrayList<Photo> mPhotos;

    public PhotoPagerAdapter(Context context) {
        mContext = context;
        mLayoutInflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    public void configureWithPhotos(ArrayList<Photo> photos) {
        setPhotos(photos);
    }

    @Override
    public int getCount() {
        return getPhotos().size();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == ((LinearLayout) object);
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        Photo photo = getPhoto(position);
        Bitmap image = photo.getImage(mContext);

        View itemView = mLayoutInflater.inflate(R.layout.cover_photo_item_view, container, false);

        ImageView imageView = (ImageView) itemView.findViewById(R.id.cover_photo);
        imageView.setImageBitmap(image);

        container.addView(itemView);
        return itemView;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((LinearLayout) object);
    }

    // Getters
    public ArrayList<Photo> getPhotos() {
        if (mPhotos == null) {
            mPhotos = new ArrayList<Photo>();
        }
        return mPhotos;
    }

    public Photo getPhoto(int position) { return mPhotos.get(position); }

    // Setters
    public void setPhotos(ArrayList<Photo> photos) {
        mPhotos.clear();
        for (Photo photo : photos) {
            mPhotos.add(photo);
        }
    }
}
