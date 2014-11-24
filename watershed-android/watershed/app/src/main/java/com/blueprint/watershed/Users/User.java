package com.blueprint.watershed.Users;

/**
 * Created by maxwolffe on 10/29/14.
**/
public class User {

    private Integer mId;
    private String mEmail;
    private String mName;
    // private Integer mRole;

    public User() {
    }

    public Integer getId() { return mId; }
    public String getName() { return mName; }
    // public Integer getRole() { return mRole; }
    public String getEmail() { return mEmail; }

    // Setters
    public void setId(Integer id) { mId = id; }
    public void setName(String name) { mName = name; }
    // public void getRole(Integer role) { mRole = role;}
    public void getEmail(String email) { mEmail = email;}
}
