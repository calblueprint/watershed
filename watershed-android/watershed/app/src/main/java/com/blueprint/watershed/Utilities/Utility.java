package com.blueprint.watershed.Utilities;

import android.app.Activity;
import android.support.v4.app.FragmentActivity;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;

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
}