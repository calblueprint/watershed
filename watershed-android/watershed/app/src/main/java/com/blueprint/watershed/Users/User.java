package com.blueprint.watershed.Users;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import com.blueprint.watershed.FieldReports.FieldReport;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.lang.reflect.Field;
import java.util.ArrayList;
import com.blueprint.watershed.APIObject;

/**
 * Created by maxwolffe on 10/29/14.
 **/
enum Role {
    COMMUNITY_MEMBER(0), EMPLOYEE(1), MANAGER(2);

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
    private Integer mTaskCount;
    private Integer mFieldReportCount;
    private Integer mSiteCount;


    private ArrayList<FieldReport> mfieldReports;

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

    // Roles
    public Boolean isManager() { return mRole == Role.MANAGER.getValue(); }
    public Boolean isEmployee() { return mRole == Role.EMPLOYEE.getValue(); }
    public Boolean isCommunityMember() { return mRole == Role.COMMUNITY_MEMBER.getValue(); }

    // Getters
    public Integer getId() { return mId; }
    public Integer getRole() { return mRole; }
    public String getName() { return mName; }
    public Integer getTasksCount() { return mTaskCount; }
    public Integer getSitesCount() { return mSiteCount; }
    public Integer getFieldReportsCount() { return mFieldReportCount; }

    public String getEmail() { return mEmail; }
    public ArrayList<FieldReport> getFieldReports() { return mfieldReports; }

    // Setters
    public void setId(Integer id) { mId = id; }
    public void setRole(Integer role) { mRole = role; }
    public void setName(String name) { mName = name; }
    public void setEmail(String email) { mEmail = email; }
    public void setTaskcount(Integer count) { mTaskCount = count; }
    public void setSiteCount(Integer count) { mSiteCount = count; }
    public void setFieldReportCount(Integer count) { mFieldReportCount = count; }
}
