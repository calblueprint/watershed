package com.blueprint.watershed.Notifications;

import android.app.IntentService;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.R;
import com.google.android.gms.gcm.GoogleCloudMessaging;

/**
 * Created by charlesx on 4/12/15.
 * Sends a notification to the user
 */
public class GcmIntentService extends IntentService {

    public static final int NOTIFICATION_ID = 1;
    private NotificationManager mNotificationManager;
    private NotificationCompat.Builder builder;

    public GcmIntentService() {
        super("GcmIntentService");
    }

    @Override
    public void onHandleIntent(Intent intent) {
        Bundle extras = intent.getExtras();
        GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(this);

        String messageType = gcm.getMessageType(intent);

        if (!extras.isEmpty()) {
            if (GoogleCloudMessaging.MESSAGE_TYPE_MESSAGE.equals(messageType)) {
                String message = extras.getString("message");
                String type = extras.getString("type");
                String object = extras.getString("object");
                sendNotification(message, type, object);
            }
        }
    }

    private void sendNotification(String message, String type, String object) {
        Bundle intentBundle = new Bundle();

        intentBundle.putString("type", type);
        intentBundle.putString(type, object);

        mNotificationManager = (NotificationManager) this.getSystemService(Context.NOTIFICATION_SERVICE);
        Intent intent = new Intent(this, MainActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK |
                        Intent.FLAG_ACTIVITY_CLEAR_TASK |
                        Intent.FLAG_ACTIVITY_SINGLE_TOP);

        PendingIntent contentIntent = PendingIntent.getActivity(this, 0, new Intent(this, MainActivity.class), 0);
        NotificationCompat.Builder mBuilder =
            new NotificationCompat.Builder(this)
                .setSmallIcon(R.drawable.tasks_dark)
                .setContentTitle("Watershed Notification")
                .setStyle(new NotificationCompat.BigTextStyle())
                .setContentText(message)
                .setAutoCancel(true);

        mBuilder.addExtras(intentBundle);
        mBuilder.setContentIntent(contentIntent);

        mNotificationManager.notify(NOTIFICATION_ID, mBuilder.build());
    }
}
