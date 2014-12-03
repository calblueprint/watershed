package com.blueprint.watershed.Authentication;

import com.blueprint.watershed.Users.User;

/**
 * Created by Mark Miyashita on 12/2/14.
 */
public class Session {
    private String mEmail;
    private String mAuthToken;
    private User mUser;

    public Session() {
    }

    // Getters
    public String getEmail() { return mEmail; }
    public String getAuthToken() { return mAuthToken; }
    public User getUser() { return mUSer; }

    // Setters
    public void setEmail(String email) { mEmail = email; }
    public void setAuthToken(String authToken) { mAuthToken = authToken; }
    public void setUser(User user) { mUser = user; }
}
