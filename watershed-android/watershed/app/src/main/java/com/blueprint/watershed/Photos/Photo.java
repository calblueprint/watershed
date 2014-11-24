package com.blueprint.watershed.Photos;

import android.graphics.Bitmap;
import android.util.Base64;

import com.blueprint.watershed.APIObject;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Tasks.Task;
import com.blueprint.watershed.Users.User;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.io.ByteArrayOutputStream;

/**
 * Created by Mark Miyashita on 11/23/14.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class Photo implements APIObject {

    private Integer mId;
    private Bitmap mImage;

    public Photo() {
    }

    public Photo(Bitmap image) {
        mImage = image;
    }

    // Getters
    public Integer getId() { return mId; }

    public String getImage() {
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        mImage.compress(Bitmap.CompressFormat.PNG, 100, stream);
        byte[] byteArray = stream.toByteArray();
        String encodedImage = Base64.encodeToString(byteArray, Base64.DEFAULT);
        return encodedImage;
    }

    // Setters
    public void setId(Integer id) { mId = id; }
    public void setImage(Bitmap image) { mImage = image; }
}
