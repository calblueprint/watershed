package com.blueprint.watershed.Utilities;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.location.Address;
import android.location.Geocoder;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.util.TypedValue;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Toast;

import com.blueprint.watershed.R;
import com.google.android.gms.maps.model.LatLng;

import java.io.IOException;
import java.util.List;

/**
 * Created by charlesx on 2/23/15.
 * Useful functions
 */
public class Utility {

    /**
     * Hides the keyboard when you tap anywhere on the screen
     * @param activity - The underlaying activity
     * @param layout - The layout that handles the listener
     */
    public static void setKeyboardListener(final Activity activity, final View layout) {
        layout.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                hideKeyboard(activity, layout);
                return false;
            }
        });
    }

    public static void hideKeyboard(Activity activity, View layout) {
        InputMethodManager inputMethodManager = (InputMethodManager)  activity.getSystemService(FragmentActivity.INPUT_METHOD_SERVICE);
        if (inputMethodManager.isAcceptingText()) {
            View viewFocus = activity.getCurrentFocus();
            if (viewFocus != null) inputMethodManager.hideSoftInputFromWindow(layout.getWindowToken(), 0);
        }
    }

    /**
     * Gets the current app version
     * @param context Context to get information from
     * @return Version of the application
     */
    public static int getAppVersion(Context context) {
        try {
            PackageInfo packageInfo = context.getPackageManager()
                    .getPackageInfo(context.getPackageName(), 0);
            return packageInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            // should never happen
            throw new RuntimeException("Could not get package name: " + e);
        }
    }

    /**
     * Gets current api version
     * @return Current api version
     */
    public static int currentVersion() { return android.os.Build.VERSION.SDK_INT; }

    /**
     * Checks if device is connected to the internet....
     * @param context - Context of call
     * @return Boolean whether or not device is connected to internet
     */
    public static boolean isConnectedToInternet(Context context) {
        ConnectivityManager manager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo info = manager.getActiveNetworkInfo();
        return info != null && info.isConnected();
    }

    /**
     * Converts your DP pixels into regular pixels!
     * @param context Context of application
     * @param dp The number you want to convert to pixels
     * @return int representing number of pixels
     */
    public static int convertDptoPix(Context context, int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,
                dp,
                context.getResources().getDisplayMetrics());
    }


    /**
     * Shows and builds a dialog that warns a user of an action
     * @param activity Activity
     * @param title Title
     * @param message Message you want to put in body
     * @param yesListen Listener if the User clicks ok
     * @param noListen Listener if the User clicks no
     */
    public static void showAndBuildDialog(Activity activity, int title, int message,
                                          DialogInterface.OnClickListener yesListen, DialogInterface.OnClickListener noListen) {
        new AlertDialog.Builder(activity)
                .setTitle(title)
                .setMessage(message)
                .setPositiveButton(android.R.string.yes, yesListen)
                .setNegativeButton(android.R.string.no, noListen)
                .show();
    }

    public static void showAndBuildDialog(Activity activity, String title, String message, String back,
                                          DialogInterface.OnClickListener yesListen, DialogInterface.OnClickListener noListen) {
        AlertDialog.Builder builder = new AlertDialog.Builder(activity)
                                                     .setTitle(title)
                                                     .setMessage(message);

        if (yesListen != null) builder.setPositiveButton(back, yesListen);
        if (noListen != null) builder.setNegativeButton(android.R.string.no, noListen);
        builder.show();
    }

    /**
     * Get latitude/longitude of an address
     * @param context Context of application
     * @param address Address of place to get lat/lng
     * @return returns a LatLng object
     */
    public static LatLng getLatLng(Context context, String address) {
        Geocoder coder = new Geocoder(context);
        List<Address> addresses;
        try {
            addresses = coder.getFromLocationName(address, 1);
            if (address == null) {
                return null;
            }
            Address location = addresses.get(0);
            return new LatLng(location.getLatitude(), location.getLongitude());
        } catch (IOException e ) {
            Log.i("Address exception", e.toString());
        }

        return null;
    }

    /**
     * Sets Empty Error messages.
     * @param errors The field names (eg. City, Street...)
     */
    public static void setEmpty(Context context, List<String> errors) {
        String errorString = "";
        for (String error : errors) errorString += error + ", ";
        errorString = errorString.replaceAll(", $", " ");
        errorString += "cannot be blank!";
        Toast.makeText(context, errorString, Toast.LENGTH_SHORT).show();
    }

    public static int getSecondaryColor(Context context, String primary) {
        if (primary == null) {
            return Color.parseColor("#81B4DE");
        }
        int[] COLORS = context.getResources().getIntArray(R.array.colors);
        int[] SECONDARY_COLORS = context.getResources().getIntArray(R.array.secondary_colors);
        int color = Color.parseColor(primary);
        int foundColor = -1;

        for (int i = 0; i < COLORS.length; i++) {
            if (COLORS[i] == color) foundColor = i;
        }

        if (foundColor == -1) {
            return Color.parseColor("#81B4DE");
        }
        return SECONDARY_COLORS[foundColor];
    }
}