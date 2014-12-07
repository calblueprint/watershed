package com.blueprint.watershed.Users;

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

public class User extends APIObject {

    private Integer mId;
    private String mEmail;
    private String mName;
    private Integer mRole;

    public User() {
    }

    // Roles
    public Boolean isManager() { return mRole == Role.MANAGER.getValue(); }
    public Boolean isEmployee() { return mRole == Role.EMPLOYEE.getValue(); }
    public Boolean isCommunityMember() { return mRole == Role.COMMUNITY_MEMBER.getValue(); }

    // Getters
    public Integer getId() { return mId; }
    public Integer getRole() { return mRole; }
    public String getName() { return mName; }
    public String getEmail() { return mEmail; }

    // Setters
    public void setId(Integer id) { mId = id; }
    public void setRole(Integer role) { mRole = role; }
    public void setName(String name) { mName = name; }
    public void setEmail(String email) { mEmail = email; }
}
