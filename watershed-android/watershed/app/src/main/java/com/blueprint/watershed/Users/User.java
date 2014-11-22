package com.blueprint.watershed.Users;

import com.blueprint.watershed.FieldReports.FieldReport;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.lang.reflect.Field;
import java.util.ArrayList;

/**
 * Created by maxwolffe on 10/29/14.
**/
@JsonIgnoreProperties(ignoreUnknown = true)
public class User {

    private String mEmail;
    private String mName;
    private String mRole;

    private ArrayList<FieldReport> mfieldReports;

    public User(String email, String name, String role){
        mEmail = email;
        mName = name;
        mRole = role;
    }

    public User() {
    }

    public String getName() { return mName; }
    public String getRole() { return mRole; }
    public String getEmail() { return mEmail; }
    public ArrayList<FieldReport> getFieldReports() { return mfieldReports; }

    // Setters
    public void setName(String name) { mName = name; }
    public void setRole(String role) { mRole = role;}
    public void setEmail(String email) { mEmail = email;}
    public void setFieldReports(ArrayList<FieldReport> fieldReports) { mfieldReports = fieldReports;}
}
