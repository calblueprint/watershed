package com.blueprint.watershed.Users;

import com.blueprint.watershed.Networking.APIObject;
import com.blueprint.watershed.FieldReports.FieldReport;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.ArrayList;

/**
 * Created by maxwolffe on 10/29/14.
 **/
enum Role {
    COMMUNITY_MEMBER(0), MANAGER(1);

    private int value;

    Role(int value) { this.value = value; }
    public int getValue() { return value; }
}

@JsonIgnoreProperties(ignoreUnknown = true)
public class User implements APIObject {

    private Integer mId;
    private String mEmail;
    private String mName;
    private Integer mRole;
    private Integer mTasksCount;
    private Integer mFieldReportsCount;
    private Integer mSitesCount;
    private String mHeaderType;
    private String mDeviceType;
    private String mRegistrationId;

    public boolean isExpanded = false;

    public static String MANAGER = "Manager";
    public static String COMMUNITY_MEMBER = "Community Member";

    private ArrayList<FieldReport> mFieldReports;

    public User(String email, String name, Integer role){
        mEmail = email;
        mName = name;
        mRole = role;
    }

    public User() {
        mName = "Mark Millman";
        mEmail = "mark@mark.com";
        mRole = 2;
    }

    public User(String string) {
        super();
        mHeaderType = string;
    }

    // Roles
    public Boolean isManager() { return mRole == Role.MANAGER.getValue(); }
    public Boolean isCommunityMember() { return mRole == Role.COMMUNITY_MEMBER.getValue(); }

    public String getRoleString() {
        if (isManager()) return MANAGER;
        else return COMMUNITY_MEMBER;
    }

    // Getters
    public Integer getId() { return mId; }
    public Integer getRole() { return mRole; }
    public String getName() { return mName; }
    
    public Integer getTasksCount() {
        if (mTasksCount == null) return 0;
        return mTasksCount;
    }

    public Integer getSitesCount() {
        if (mSitesCount == null) return 0;
        return mSitesCount;
    }

    public Integer getFieldReportsCount() {
        if (mFieldReportsCount == null) return 0;
        return mFieldReportsCount;
    }

    public String getDeviceType() { return mDeviceType; }
    public String getRegistrationId() { return mRegistrationId; }

    public String getEmail() { return mEmail; }
    public ArrayList<FieldReport> getFieldReports() {
        if (mFieldReports == null){
            return new ArrayList<FieldReport>();
        }
        return mFieldReports;
    }

    // Setters
    public void setId(Integer id) { mId = id; }
    public void setRole(Integer role) { mRole = role; }
    public void setName(String name) { mName = name; }
    public void setEmail(String email) { mEmail = email; }
    public void setTaskscount(Integer count) { mTasksCount = count; }
    public void setSitesCount(Integer count) { mSitesCount = count; }
    public void setFieldReportsCount(Integer count) { mFieldReportsCount = count; }
    public void setDeviceType(String deviceType) { this.mDeviceType = deviceType; }
    public void setRegistrationId(String registrationId) { this.mRegistrationId = registrationId; }

    @JsonIgnore
    public String getLayoutType() { return mHeaderType; }

    @JsonIgnore
    public void setLayoutType(String type) { mHeaderType = type; }

    @JsonIgnore
    public boolean getExpanded() { return isExpanded; }

    @JsonIgnore
    public void setExpanded(boolean expanded) { isExpanded = expanded; }

}
