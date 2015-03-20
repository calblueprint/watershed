package com.blueprint.watershed.Photos;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.blueprint.watershed.R;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Mark Miyashita on 11/24/14.
 */
public class PhotoPagerAdapter extends PagerAdapter {

    private LayoutInflater mLayoutInflater;
    private Context mContext;

    private List<Photo> mPhotos;

    public PhotoPagerAdapter(Context context, List<Photo> photos) {
        mContext = context;
        mLayoutInflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        setPhotos(photos);
    }

    public void configureWithPhotos(List<Photo> photos) {
        setPhotos(photos);
    }

    @Override
    public int getCount() {
        return getPhotos().size();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == object;
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        Photo photo = getPhoto(position);

        View itemView = mLayoutInflater.inflate(R.layout.cover_photo_item_view, container, false);

        ImageView imageView = (ImageView) itemView.findViewById(R.id.cover_photo);
        photo.getImageAndSetImageView(mContext, imageView);

        TextView primaryLabel = (TextView) itemView.findViewById(R.id.primary_label);
        primaryLabel.setText("");

        TextView secondaryLabel = (TextView) itemView.findViewById(R.id.secondary_label);
        secondaryLabel.setText("");

        container.addView(itemView);
        return itemView;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((View) object);
    }

    @Override
    public int getItemPosition(Object object) {
        return POSITION_NONE;
    }

    // Getters
    public List<Photo> getPhotos() {
        if (mPhotos == null) {  mPhotos = new ArrayList<>(); }
        return mPhotos;
    }

    public Photo getPhoto(int position) { return mPhotos.get(position); }

    // Setters
    public void setPhotos(List<Photo> photos) { mPhotos = photos; }

    public void deletePhoto(int position) {
        if (mPhotos.size() == 0) return;
        mPhotos.remove(position);
        notifyDataSetChanged();
    }
}
