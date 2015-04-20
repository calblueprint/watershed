package com.blueprint.watershed.Authentication;

import com.blueprint.watershed.Users.User;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * Created by Mark Miyashita on 12/2/14.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class Session {

    private String mEmail;
    private String mAuthenticationToken;
    private User mUser;

    public Session() {}

    // Getters
    public String getEmail() { return mEmail; }
    public String getAuthenticationToken() { return mAuthenticationToken; }
    public User getUser() { return mUser; }

    // Setters
    public void setEmail(String email) { mEmail = email; }
    public void setAuthenticationToken(String authenticationToken) { mAuthenticationToken = authenticationToken; }
    public void setUser(User user) { mUser = user; }
}
