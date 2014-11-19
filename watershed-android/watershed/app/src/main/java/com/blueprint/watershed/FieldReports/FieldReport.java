package com.blueprint.watershed.FieldReports;

import android.graphics.Bitmap;

import java.lang.reflect.Field;

/**
 * Created by maxwolffe on 11/18/14.
 */
public class FieldReport {

    private Integer mUserId;
    private Integer mMinisiteId;
    private String mDescription;
    private Integer mHealth;
    private Boolean mUrgent;
    private Bitmap mPhoto;

    public FieldReport() {
    }

    public FieldReport(Integer userId, Integer miniSiteId, String description, Integer health, Boolean urgent, Bitmap photo ){
        mUserId = userId;
        mMinisiteId = miniSiteId;
        mDescription = description;
        mHealth = health;
        mUrgent = urgent;
        mPhoto = photo;
    }

    // Getters
    public Integer getUserId() {
        return mUserId;
    }
    public Integer getMinisiteId() {
        return mMinisiteId;
    }
    public String getDescription() {
        return mDescription;
    }
    public Integer getHealth() {
        return mHealth;
    }
    public Boolean getUrgent() {
        return mUrgent;
    }
    public Bitmap getPhoto(){
        return mPhoto;
    }

    //Setters
    public void setUserId(Integer userId) {
        mUserId = userId;
    }
    public void setMinisiteId(Integer minisiteId) {
        mMinisiteId = minisiteId;
    }

    public void setDescription(String description) {
        mDescription = description;
    }

    public void setHealth(Integer health) {
        mHealth = health;
    }

    public void setUrgent(Boolean urgent) {
        mUrgent = urgent;
    }
    public void setPhoto(Bitmap photo){
        mPhoto = photo;
    }

}
