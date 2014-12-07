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
    private Integer mTasksCount;
    private Integer mFieldReportsCount;
    private Integer mSitesCount;


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
    public Integer getTasksCount() { return mTasksCount; }
    public Integer getSitesCount() { return mSitesCount; }
    public Integer getFieldReportsCount() { return mFieldReportsCount; }

    public String getEmail() { return mEmail; }
    public ArrayList<FieldReport> getFieldReports() { return mfieldReports; }

    // Setters
    public void setId(Integer id) { mId = id; }
    public void setRole(Integer role) { mRole = role; }
    public void setName(String name) { mName = name; }
    public void setEmail(String email) { mEmail = email; }
    public void setTaskscount(Integer count) { mTasksCount = count; }
    public void setSitesCount(Integer count) { mSitesCount = count; }
    public void setFieldReportsCount(Integer count) { mFieldReportsCount = count; }
}
