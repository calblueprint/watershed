package com.blueprint.watershed;

/**
 * Created by maxwolffe on 10/29/14.
**/
public class User {

    private String mEmail;
    private String mName;
    // private Integer mRole;

    public User(String email, String name){
        mEmail = email;
        mName = name;
        // mRole = role;
    }

    public String getName() { return mName; }
    // public Integer getRole() { return mRole; }
    public String getEmail() { return mEmail; }

    // Setters
    public void setName(String name) { mName = name; }
    // public void getRole(Integer role) { mRole = role;}
    public void getEmail(String email) { mEmail = email;}
}
