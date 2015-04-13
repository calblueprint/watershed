package com.blueprint.watershed.Notifications;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;

import java.io.FileDescriptor;

/**
 * Created by charlesx on 4/12/15.
 */
public class GcmIntentService extends Service {
    @Override
    public IBinder onBind(Intent intent) {
        return new IBinder() {
            @Override
            public String getInterfaceDescriptor() throws RemoteException {
                return null;
            }

            @Override
            public boolean pingBinder() {
                return false;
            }

            @Override
            public boolean isBinderAlive() {
                return false;
            }

            @Override
            public IInterface queryLocalInterface(String descriptor) {
                return null;
            }

            @Override
            public void dump(FileDescriptor fd, String[] args) throws RemoteException {

            }

            @Override
            public void dumpAsync(FileDescriptor fd, String[] args) throws RemoteException {

            }

            @Override
            public boolean transact(int code, Parcel data, Parcel reply, int flags) throws RemoteException {
                return false;
            }

            @Override
            public void linkToDeath(DeathRecipient recipient, int flags) throws RemoteException {

            }

            @Override
            public boolean unlinkToDeath(DeathRecipient recipient, int flags) {
                return false;
            }
        }
    }
}
