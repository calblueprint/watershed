package com.blueprint.watershed.Users;

/**
 * Created by maxwolffe on 10/29/14.
**/
public class User {

    private Integer mId;
    private String mEmail;
    private String mName;
    private Integer mRole;

    public User() {
    }

    public Integer getId() { return mId; }
    public Integer getRole() { return mRole; }
    public String getName() { return mName; }
    public String getEmail() { return mEmail; }

    // Setters
    public void setId(Integer id) { mId = id; }
    public void getRole(Integer role) { mRole = role; }
    public void setName(String name) { mName = name; }
    public void getEmail(String email) { mEmail = email; }
}
