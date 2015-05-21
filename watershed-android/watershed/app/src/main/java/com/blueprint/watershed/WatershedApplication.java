package com.blueprint.watershed;

import android.app.Application;
import android.content.Context;
import android.content.res.Configuration;

import com.squareup.leakcanary.LeakCanary;
import com.squareup.leakcanary.RefWatcher;

/**
 * Created by maxwolffe on 5/21/15.
 */
public class WatershedApplication extends Application {

    private RefWatcher refWatcher;

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
    }

    @Override
    public void onCreate() {
        super.onCreate();
        refWatcher = LeakCanary.install(this);
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
    }

    @Override
    public void onTerminate() {
        super.onTerminate();
    }

    public static RefWatcher getRefWatcher(Context context) {
        WatershedApplication application = (WatershedApplication) context.getApplicationContext();
        return application.refWatcher;
    }

}
