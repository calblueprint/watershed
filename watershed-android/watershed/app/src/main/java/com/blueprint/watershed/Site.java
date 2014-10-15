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
    // Latitude
    // Longitude

    public Site(String name, String description, String street, String city, String state, Integer zipCode) {
        mName = name;
        mDescription = description;
        mStreet = street;
        mCity = city;
        mState = state;
        mZipCode = zipCode;
    }

    public Site() {
        new Site("Awesome Site", "This is the best site ever.", "1000 Andrew Millman Way", "Berkeley", "CA", 94720);
    }

    // Getters
    public String getName() { return mName; }
    public String getDescription() { return mDescription; }
    public String getStreet() { return mStreet; }
    public String getCity() { return mCity; }
    public String getState() { return mState; }
    public Integer getZipCode() { return mZipCode; }

    // Setters
    public void setName(String name) { mName = name; }
    public void setDescription(String description) { mDescription = description; }
    public void setStreet(String street) { mStreet = street; }
    public void setCity(String city) { mCity = city; }
    public void setState(String state) { mState = state; }
    public void setZipCode(Integer zipCode) { mZipCode = zipCode; }
}
