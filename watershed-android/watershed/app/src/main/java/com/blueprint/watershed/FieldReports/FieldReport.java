package com.blueprint.watershed.FieldReports;

import android.graphics.Bitmap;

import com.blueprint.watershed.APIObject;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Photos.Photo;
import com.blueprint.watershed.Tasks.Task;
import com.blueprint.watershed.Users.User;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.lang.reflect.Field;
import java.util.ArrayList;

/**
 * Created by maxwolffe on 11/18/14.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class FieldReport implements APIObject {

    // Attributes
    private Integer mId;
    private String mDescription;
    private Integer mHealthRating;
    private Boolean mUrgent;

    // Relationships
    private User mUser;
    private MiniSite mMiniSite;
    private Task mTask;
    private Photo mPhoto;

    public FieldReport() {
    }

    public FieldReport(String description, Integer healthRating, Boolean urgent, Photo photo,
                       User user, MiniSite miniSite, Task task) {
        mDescription = description;
        mHealthRating = healthRating;
        mUrgent = urgent;
        mUser = user;
        mMiniSite = miniSite;
        mTask = task;
        mPhoto = photo;
    }

    /*
     * Relationships
     */

    // Getters
    @JsonIgnore
    public User getUser() { return mUser; }

    @JsonIgnore
    public String getUserName() {
        return mUser == null ? "Derek Hitchcock" : mUser.getName();
    }

    @JsonIgnore
    public MiniSite getMiniSite() { return mMiniSite; }

    @JsonIgnore
    public Task getTask() { return mTask; }

    public Photo getPhoto() { return mPhoto; }

    @JsonIgnore
    public ArrayList<Photo> getPhotos() {
        ArrayList<Photo> photos = new ArrayList<Photo>();
        Photo photo = getPhoto();
        if (photo != null) {
            photos.add(photo);
        }
        return photos;
    }

    // Setters
    public void setUser(User user) { mUser = user; }
    public void setMiniSite(MiniSite miniSite) { mMiniSite = miniSite; }
    public void setTask(Task task) { mTask = task; }

    @JsonProperty("photo_attributes")
    public void setPhoto(Photo photo) { mPhoto = photo; }

    /*
     * Attributes
     */

    // Getters
    @JsonIgnore
    public Integer getId() { return mId; }

    public Integer getUserId() { return mUser.getId(); }
    public Integer getTaskId() { return mTask.getId(); }
    public Integer getMiniSiteId() { return mMiniSite.getId(); }
    public String getDescription() {
        return mDescription;
    }
    public Integer getHealthRating() {
        return mHealthRating;
    }
    public Boolean getUrgent() {
        return mUrgent;
    }

    // Setters
    public void setId(Integer id) { mId = id; }
    public void setDescription(String description) {
        mDescription = description;
    }
    public void setHealthRating(Integer healthRating) {
        mHealthRating = healthRating;
    }
    public void setUrgent(Boolean urgent) {
        mUrgent = urgent;
    }
}
