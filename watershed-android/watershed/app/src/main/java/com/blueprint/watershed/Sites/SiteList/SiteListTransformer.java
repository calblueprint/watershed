package com.blueprint.watershed.Sites.SiteList;

import android.support.v4.view.ViewPager;
import android.view.View;

import com.blueprint.watershed.R;
import com.blueprint.watershed.Views.Material.FloatingActionButton;

/**
 * Created by charlesx on 3/25/15.
 * Animates the create button.
 */
public class SiteListTransformer implements ViewPager.PageTransformer {
    private static final float MIN_SCALE = 0.75f;
    @Override
    public void transformPage(View view, float position) {
        int pageWidth = view.getWidth();

        FloatingActionButton button = (FloatingActionButton) view.findViewById(R.id.create_site_button);

        if (position < -1) { // [-Infinity,-1)
            // This page is way off-screen to the left.
            view.setAlpha(0);
            button.setAlpha(0f);
        } else if (position <= 0) { // [-1,0]
            // Use the default slide transition when moving to the left page
            button.setTranslationX(-position * pageWidth);

        } else if (position <= 1) { // (0,1]
            button.setTranslationX(-position * pageWidth);
        } else { // (1,+Infinity]
            // This page is way off-screen to the right.
            view.setAlpha(0f);
            button.setAlpha(0f);
        }
    }
}

