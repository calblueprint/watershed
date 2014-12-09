package com.blueprint.watershed.MiniSites;
import com.blueprint.watershed.APIObject;
import com.blueprint.watershed.FieldReports.FieldReport;
import com.blueprint.watershed.Photos.Photo;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.ArrayList;

/**
 * Created by Mark Miyashita on 11/16/14.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class MiniSite implements APIObject {

    private Integer mId;
    private String mName;
    private String mDescription;
    private String mStreet;
    private String mCity;
    private String mState;
    private Integer mZipCode;
    private String mLatitude;
    private String mLongitude;
    private Integer mFieldReportsCount;

    private ArrayList<FieldReport> mFieldReports;
    private ArrayList<Photo> mPhotos;

    public MiniSite() {
    }

    public String toString() {
        return "MiniSite: " + getName();
    }

    // Relationships
    public ArrayList<FieldReport> getFieldReports() {
        if (mFieldReports == null) {
            mFieldReports = new ArrayList<FieldReport>();
        }
        return mFieldReports;
    }

    public FieldReport getFieldReport(int position) { return mFieldReports.get(position); }

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
    public Integer getFieldReportsCount() { return mFieldReportsCount; }

    @JsonIgnore
    public String getLocation() {
        return String.format("%s, %s, %s %s", getStreet(), getCity(), getState(), getZipCode());
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
    public void setmFieldReportsCount(Integer fieldReportsCount) { mFieldReportsCount = fieldReportsCount; }
}
