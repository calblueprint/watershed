package com.blueprint.watershed.Utilities;

import android.support.v4.app.FragmentActivity;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;

/**
 * Created by charlesx on 2/23/15.
 * Useful functions
 */
public class Utility {
    // Hides the keyboard!
    public static void setKeyboardListener(final FragmentActivity activity, final View layout) {
        layout.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                hideKeyboard(activity, layout);
                return false;
            }
        });
    }

    public static void hideKeyboard(FragmentActivity activity, View layout) {
        InputMethodManager inputMethodManager = (InputMethodManager)  activity.getSystemService(FragmentActivity.INPUT_METHOD_SERVICE);
        if (inputMethodManager.isAcceptingText()) {
            View viewFocus = activity.getCurrentFocus();
            if (viewFocus != null) inputMethodManager.hideSoftInputFromWindow(layout.getWindowToken(), 0);
        }
    }
}