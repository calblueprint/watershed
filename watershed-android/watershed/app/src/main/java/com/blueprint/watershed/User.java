package com.blueprint.watershed;

/**
 * Created by maxwolffe on 10/29/14.
**/
public class User {

    private String mEmail;
    private String mEncrypted_password;
    private String mName;
    private Integer mRole;
    private String mAuth_Token;

    public User(String email, String encrypted_password, String name, Integer role, String authentication_token){
        mEmail = email;
        mEncrypted_password = encrypted_password;
        mName = name;
        mRole = role;
        mAuth_Token = authentication_token;
    }

    public String getName() { return mName; }
    public String getPassword() { return mEncrypted_password; }
    public Integer getRole() { return mRole; }
    public String getEmail() { return mEmail; }
    public String getToken() { return mAuth_Token; }

    // Setters
    public void setName(String name) { mName = name; }
    public void getRole(Integer role) { mRole = role;}
    public void getEmail(String email) { mEmail = email;}
}
