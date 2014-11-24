package com.blueprint.watershed.FieldReports;

import android.graphics.Bitmap;

import com.blueprint.watershed.APIObject;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Users.User;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.lang.reflect.Field;

/**
 * Created by maxwolffe on 11/18/14.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class FieldReport implements APIObject {

    // Attributes
    private Integer mId;
    private String mDescription;
    private Integer mHealth;
    private Boolean mUrgent;
    //private Bitmap mPhoto;

    // Relationships
    private User mUser;
    private MiniSite mMiniSite;

    public FieldReport() {
    }

    public FieldReport(String description, Integer health, Boolean urgent, Bitmap photo,
                       User user, MiniSite miniSite) {
        mDescription = description;
        mHealth = health;
        mUrgent = urgent;
        //mPhoto = photo;
        mUser = user;
        mMiniSite = miniSite;
    }

    /*
     * Relationships
     */

    // Getters
    public User getUser() { return mUser; }
    public MiniSite getMiniSite() { return mMiniSite; }

    // Setters
    public void setUser(User user) { mUser = user; }
    public void setMiniSite(MiniSite miniSite) { mMiniSite = miniSite; }

    /*
     * Attributes
     */

    // Getters
    public Integer getId() { return mId; }
    public String getDescription() {
        return mDescription;
    }
    public Integer getHealth() {
        return mHealth;
    }
    public Boolean getUrgent() {
        return mUrgent;
    }
//    public Bitmap getPhoto(){
//        return mPhoto;
//    }

    // Setters
    public void setId(Integer id) { mId = id; }
    public void setDescription(String description) {
        mDescription = description;
    }
    public void setHealth(Integer health) {
        mHealth = health;
    }
    public void setUrgent(Boolean urgent) {
        mUrgent = urgent;
    }
//    public void setPhoto(Bitmap photo){
//        mPhoto = photo;
//    }
}
