package com.blueprint.watershed.Photos;

import android.graphics.Bitmap;

import com.blueprint.watershed.APIObject;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Tasks.Task;
import com.blueprint.watershed.Users.User;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * Created by mark on 11/23/14.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class Photo implements APIObject {

    private Integer mId;
    private Bitmap mImage;

    public Photo() {
    }

    // Getters
    public Integer getId() { return mId; }
    public Bitmap getImage() { return mImage; }

    // Setters
    public void setId(Integer id) { mId = id; }
    public void setImage(Bitmap image) { mImage = image; }
}
