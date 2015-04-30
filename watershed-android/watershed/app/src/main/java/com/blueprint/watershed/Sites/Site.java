package com.blueprint.watershed.Sites;

import com.blueprint.watershed.APIObject;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.Networking.Sites.SiteSerializer;
import com.blueprint.watershed.Photos.Photo;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.ArrayList;

/**
 * Created by Mark Miyashita on 10/14/14.
 * Object that represents a site.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonSerialize(using = SiteSerializer.class)
public class Site implements APIObject {

    public int TRIM_LENGTH = 140;

    // Attributes
    private Integer mId;
    private String mName;
    private String mDescription;
    private String mStreet;
    private String mCity;
    private String mState;
    private Integer mZipCode;
    private String mLatitude;
    private String mLongitude;
    private Integer mTasksCount;
    private Integer mMiniSitesCount;
    private Boolean mSubscribed;

    // Relationships
    private ArrayList<MiniSite> mMiniSites;
    private ArrayList<Photo> mPhotos;

    public Site() {}

    public String toString() {
        return "Site: " + getName();
    }

    // Relationships
    public ArrayList<MiniSite> getMiniSites() {
        if (mMiniSites == null) {
            mMiniSites = new ArrayList<MiniSite>();
        }
        return mMiniSites;
    }

    public MiniSite getMiniSite(int position) { return mMiniSites.get(position); }

    public boolean isMiniSiteEmpty() { return mMiniSites == null; }

    public ArrayList<Photo> getPhotos() {
        if (mPhotos == null) {
            mPhotos = new ArrayList<Photo>();
        }
        return mPhotos;
    }

    public Photo getPhoto(int position) { return mPhotos.get(position); }

    // Getters
    public Integer getId() { return mId; }
    public String getName() { return mName; }
    public String getDescription() { return mDescription; }
    public String getStreet() { return mStreet; }
    public String getCity() { return mCity; }
    public String getState() { return mState; }
    public Integer getZipCode() { return mZipCode; }
    public String getLatitude() { return mLatitude; }
    public String getLongitude() { return mLongitude; }
    public Integer getTasksCount() { return mTasksCount; }
    public Integer getMiniSitesCount() { return mMiniSitesCount; }
    public Boolean getSubscribed() { return mSubscribed; }

    @JsonIgnore
    public String getLocationOneLine() {
        if (getCity() != null) return String.format("%s, %s, %s", getStreet(), getCity(), getState());
        else return getStreet();
    }

    @JsonIgnore
    public String getTrimmedText() {
        if (shouldShowDescriptionDialog()) {
            return String.format("%s...read more", getDescription().substring(0, TRIM_LENGTH) + "...");
        } else {
            return getDescription();
        }
    }

    @JsonIgnore
    public boolean shouldShowDescriptionDialog() {
        return getDescription().length() > TRIM_LENGTH;
    }

    // Setters
    public void setId(Integer id) { mId = id; }
    public void setName(String name) { mName = name; }
    public void setDescription(String description) { mDescription = description; }
    public void setStreet(String street) { mStreet = street; }
    public void setCity(String city) { mCity = city; }
    public void setState(String state) { mState = state; }
    public void setZipCode(Integer zipCode) { mZipCode = zipCode; }
    public void setLatitude(String latitude) { mLatitude = latitude; }
    public void setLongitude(String longitude) { mLongitude = longitude; }
    public void setTasksCount(Integer tasksCount) { mTasksCount = tasksCount; }
    public void setMiniSitesCount(Integer miniSitesCount) { mMiniSitesCount = miniSitesCount; }
    public void setSubscribed(Boolean subscribed) {
        this.mSubscribed = subscribed;
    }

    @Override
    public boolean equals(Object object) {
        if (object == null || !(object instanceof Site)) return false;
        Site site = (Site) object;
        if (!getId().equals(site.getId()) ||
            !getName().equals(site.getName()) ||
            !getDescription().equals(site.getDescription()) ||
            !getStreet().equals(site.getStreet()) ||
            !getCity().equals(site.getCity()) ||
            !getState().equals(site.getState()) ||
            !getZipCode().equals(site.getZipCode()) ||
            !getLatitude().equals(site.getLatitude()) ||
            !getLongitude().equals(site.getLongitude()) ||
            !getTasksCount().equals(site.getTasksCount()) ||
            !getMiniSitesCount().equals(site.getMiniSitesCount()) ||
            getPhotos().size() != site.getPhotos().size() ||
            getMiniSites().size() != site.getMiniSites().size()) return false;
        for (int i = 0; i < getPhotos().size(); i++) {
            if (!getPhoto(i).getId().equals(site.getPhoto(i).getId())) return false;
        }

        for (int i = 0; i < getMiniSites().size(); i++) {
            if (!getMiniSite(i).getId().equals(site.getMiniSite(i).getId())) return false;
        }
        return true;
    }
}
