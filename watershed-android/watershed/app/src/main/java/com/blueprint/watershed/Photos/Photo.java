package com.blueprint.watershed.Photos;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.Base64;
import android.util.Log;
import android.widget.ImageView;

import com.android.volley.Response;
import com.blueprint.watershed.Networking.APIObject;
import com.blueprint.watershed.Networking.NetworkManager;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.io.ByteArrayOutputStream;
import java.util.Date;

/**
 * Created by Mark Miyashita on 11/23/14.
 * Photo object that holds images.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonSerialize(using = PhotoSerializer.class)
public class Photo implements APIObject {

    private Integer mId;
    private String mURL;
    private Bitmap mImage;
    private String mData;
    private Date mCreatedAt;

    public Photo() {}

    public Photo(Bitmap image) {
        mImage = image;
//        mData = getData();
    }

    // Getters
    public Integer getId() { return mId; }
    public String getURL() { return mURL; }
    public Date getCreatedAt() { return mCreatedAt; }

    public String getData() {
//        if (mData == null) {
//            ByteArrayOutputStream stream = new ByteArrayOutputStream();
//            mImage.compress(Bitmap.CompressFormat.PNG, 100, stream);
//            return Base64.encodeToString(stream.toByteArray(), Base64.DEFAULT);
//        }
//        return mData;
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        mImage.compress(Bitmap.CompressFormat.PNG, 100, stream);
        return Base64.encodeToString(stream.toByteArray(), Base64.DEFAULT);
    }

    @JsonIgnore
    public Bitmap getImage(Context context) {
        if (mImage == null) {
            NetworkManager manager = NetworkManager.getInstance(context);
            manager.imageRequest(getURL(), new Response.Listener<Bitmap>() {
                @Override
                public void onResponse(Bitmap bitmap) {
                    mImage = bitmap;
                }
            });
        }
        return mImage;
    }

    @JsonIgnore
    public void getImageAndSetImageView(Context context, final ImageView imageView) {
        if (mImage == null) {
            imageView.setImageBitmap(null);
            NetworkManager manager = NetworkManager.getInstance(context);
            manager.imageRequest(getURL(), new Response.Listener<Bitmap>() {
                @Override
                public void onResponse(Bitmap bitmap) {
                    mImage = bitmap;
                    Log.e("Photo", "Response Returned");
                    imageView.setImageBitmap(mImage);
                    imageView.refreshDrawableState();
                }
            });
        } else {
            imageView.setImageBitmap(mImage);
            imageView.refreshDrawableState();
        }
    }

    // Setters
    public void setId(Integer id) { mId = id; }
    public void setURL(String URL) { mURL = URL; }
    public void setImage(Bitmap image) { mImage = image; }
    public void setCreatedAt(Date date) { mCreatedAt = date; }
}
