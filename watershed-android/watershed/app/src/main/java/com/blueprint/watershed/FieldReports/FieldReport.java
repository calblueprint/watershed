package com.blueprint.watershed.FieldReports;

import android.graphics.Bitmap;

import com.blueprint.watershed.APIObject;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Users.User;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.lang.reflect.Field;

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
    //private Bitmap mPhoto;

    // Relationships
    private User mUser;
    private MiniSite mMiniSite;

    public FieldReport() {
    }

    public FieldReport(String description, Integer healthRating, Boolean urgent, Bitmap photo,
                       User user, MiniSite miniSite) {
        mDescription = description;
        mHealthRating = healthRating;
        mUrgent = urgent;
        //mPhoto = photo;
        mUser = user;
        mMiniSite = miniSite;
    }

    /*
     * Relationships
     */

    // Getters
    @JsonIgnore
    public User getUser() { return mUser; }

    @JsonIgnore
    public MiniSite getMiniSite() { return mMiniSite; }

    // Setters
    @JsonProperty
    public void setUser(User user) { mUser = user; }

    @JsonProperty
    public void setMiniSite(MiniSite miniSite) { mMiniSite = miniSite; }

    /*
     * Attributes
     */

    // Getters
    @JsonIgnore
    public Integer getId() { return mId; }

    public String getDescription() {
        return mDescription;
    }
    public Integer getHealthRating() {
        return mHealthRating;
    }
    public Boolean getUrgent() {
        return mUrgent;
    }
//    public Bitmap getPhoto(){
//        return mPhoto;
//    }

    // Setters
    @JsonProperty
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
//    public void setPhoto(Bitmap photo){
//        mPhoto = photo;
//    }
}
