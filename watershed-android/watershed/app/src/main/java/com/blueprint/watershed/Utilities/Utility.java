package com.blueprint.watershed.Utilities;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.support.v4.app.FragmentActivity;
import android.util.TypedValue;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;

import java.util.Arrays;

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
     * @return
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
     * @return
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

    public static String[] COLORS = { "#F44336", "#673AB7", "#03A9F4", "#4CAF50", "#FF5722", "#607D8B",
                                     "#00BCD4", "#9C27B0", "#E91E63", "#3F51B5", "#009688" };
    public static String[] SECONDARY_COLORS = { "#D32F2F", "#512DA8", "#0288D1", "#388E3C", "#E64A19", "#455A64",
                                                "#0097A7", "#7B1FA2", "#C2185B", "#303F9F", "#00796B" };

    public static String getSecondaryColor(String primary) {
        if (primary == null) return "#1976D2";
        return SECONDARY_COLORS[Arrays.asList(COLORS).indexOf(primary)];
    }
}