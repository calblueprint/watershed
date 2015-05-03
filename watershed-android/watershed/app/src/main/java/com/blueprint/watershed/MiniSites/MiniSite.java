package com.blueprint.watershed.MiniSites;

import com.blueprint.watershed.Networking.APIObject;
import com.blueprint.watershed.FieldReports.FieldReport;
import com.blueprint.watershed.Networking.MiniSites.MiniSiteSerializer;
import com.blueprint.watershed.Photos.Photo;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Mark Miyashita on 11/16/14.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonSerialize(using = MiniSiteSerializer.class)
public class MiniSite implements APIObject {

    private Integer mId;
    private String mName;
    private String mDescription;
    private String mStreet;
    private String mCity;
    private String mState;
    private Integer mZipCode;
    private Float mLatitude;
    private Float mLongitude;
    private Integer mFieldReportsCount;
    private Integer mSiteId;

    private List<FieldReport> mFieldReports;
    private List<Photo> mPhotos;

    public MiniSite() {
    }

    public String toString() {
        return "MiniSite: " + getName();
    }

    // Relationships
    public List<FieldReport> getFieldReports() {
        if (mFieldReports == null) {
            mFieldReports = new ArrayList<FieldReport>();
        }
        return mFieldReports;
    }

    public FieldReport getFieldReport(int position) { return mFieldReports.get(position); }

    public List<Photo> getPhotos() {
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
    public Float getLatitude() { return mLatitude; }
    public Float getLongitude() { return mLongitude; }
    public Integer getFieldReportsCount() { return mFieldReportsCount; }
    public Integer getSiteId() { return mSiteId; }

    @JsonIgnore
    public String getLocation() {
        return String.format("%s\n%s, %s %d", getStreet(), getCity(), getState(), getZipCode());
    }

    @JsonIgnore
    public String getLocationOneLine() {
        if (getCity() != null) return String.format("%s, %s, %s, %d", getStreet(), getCity(), getState(), getZipCode());
        return getStreet();
    }

    // Setters
    public void setId(Integer id) { mId = id; }
    public void setName(String name) { mName = name; }
    public void setDescription(String description) { mDescription = description; }
    public void setStreet(String street) { mStreet = street; }
    public void setCity(String city) { mCity = city; }
    public void setState(String state) { mState = state; }
    public void setZipCode(Integer zipCode) { mZipCode = zipCode; }
    public void setLatitude(Float latitude) { mLatitude = latitude; }
    public void setLongitude(Float longitude) { mLongitude = longitude; }
    public void setFieldReportsCount(Integer fieldReportsCount) { mFieldReportsCount = fieldReportsCount; }
    public void setPhotos(List<Photo> Photos){mPhotos = Photos;}
    public void setSiteId(Integer siteId) { mSiteId = siteId; }
}
