package com.blueprint.watershed;

/**
 * Created by Mark Miyashita on 10/14/14.
 */
public class Site {

    private String mName;
    private String mDescription;
    private String mStreet;
    private String mCity;
    private String mState;
    private Integer mZipCode;
    private String mLatitude;
    private String mLongitude;

    public Site(String name, String description, String street, String city, String state, Integer zip_code, String latitude, String longitude) {
        mName = name;
        mDescription = description;
        mStreet = street;
        mCity = city;
        mState = state;
        mZipCode = zip_code;
        mLatitude = latitude;
        mLongitude = longitude;
    }

    public Site(String name, String description) {
        this(name, description, "1000 Andrew Millman Way", "Berkeley", "CA", 94720, "10", "100");
    }

    public Site() {
    }

    // Getters
    public String getName() { return mName; }
    public String getDescription() { return mDescription; }
    public String getStreet() { return mStreet; }
    public String getCity() { return mCity; }
    public String getState() { return mState; }
    public Integer getZipCode() { return mZipCode; }
    public String getLatitude() { return mLatitude; }
    public String getLongitude() { return mLongitude; }

    // Setters
    public void setName(String name) { mName = name; }
    public void setDescription(String description) { mDescription = description; }
    public void setStreet(String street) { mStreet = street; }
    public void setCity(String city) { mCity = city; }
    public void setState(String state) { mState = state; }
    public void setZipCode(Integer zipCode) { mZipCode = zipCode; }
    public void setLatitude(String latitude) { mLatitude = latitude; }
    public void setLongitude(String longitude) { mLongitude = longitude; }
}
