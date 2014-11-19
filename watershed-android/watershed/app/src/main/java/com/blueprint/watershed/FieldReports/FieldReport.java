package com.blueprint.watershed.FieldReports;

import android.graphics.Bitmap;

import com.blueprint.watershed.APIObject;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.lang.reflect.Field;

/**
 * Created by maxwolffe on 11/18/14.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class FieldReport implements APIObject {

    private Integer mId;
    private Integer mUserId;
    private String mDescription;
    private Integer mHealth;
    private Boolean mUrgent;
    private Bitmap mPhoto;
    private MiniSite mMiniSite;

    public FieldReport() {
    }

    public FieldReport(Integer userId, String description,
                       Integer health, Boolean urgent, Bitmap photo) {
        mUserId = userId;
        mDescription = description;
        mHealth = health;
        mUrgent = urgent;
        mPhoto = photo;
    }

    // Getters
    public Integer getId() { return mId; }
    public Integer getUserId() {
        return mUserId;
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

    // Setters
    public void setId(Integer id) { mId = id; }
    public void setUserId(Integer userId) {
        mUserId = userId;
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
