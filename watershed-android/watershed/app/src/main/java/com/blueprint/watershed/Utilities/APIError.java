package com.blueprint.watershed.Utilities;

/**
 * Created by Mark Miyashita on 12/7/14.
 */
public class APIError {

    private String mMessage;

    public APIError() {
        mMessage = "An error has occurred.";
    }

    // Getters
    public String getMessage() { return mMessage; }

    // Setters
    public void setMessage(String message) { mMessage = message; }
}
