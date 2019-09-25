package com.example.getinfo;
import android.app.admin.DeviceAdminReceiver;
import android.content.Context;
import android.content.Intent;

import android.util.Log;
import android.widget.Toast;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;
import android.app.ActivityManager;
import android.content.ComponentName;
import android.widget.Toast;
import android.app.admin.DevicePolicyManager;
import android.app.ActivityManager;
import android.content.Context;
import android.app.admin.DeviceAdminReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;
import android.content.pm.PackageManager;
import android.app.PendingIntent;
import android.content.pm.PackageInstaller;

public class MyDeviceAdminReceiver extends DeviceAdminReceiver {

    Activity activity;
         MyDeviceAdminReceiver(Activity activity){
        this.activity= activity;
  }


    /**
     * method to show toast
     *
     * @param context the application context on which the toast has to be displayed
     * @param msg     the message which will be displayed in the toast
     */
    private void showToast(Context context, CharSequence msg) {
        Log.e("MyDeviceAdminRec...", "::>>>>1 ");
        Toast.makeText(context, msg, Toast.LENGTH_SHORT).show();
    }
    

    @Override
    public void onEnabled(Context context, Intent intent) {
        Log.e("MyDeviceAdminRec...", "::>>>>2 ");
        showToast(context, "Sample Device Admin: enabled");
    }

    @Override
    public CharSequence onDisableRequested(Context context, Intent intent) {
        Log.e("MyDeviceAdminRec...", "::>>>>3 ");
        return "This is an optional message to warn the user about disabling.";
    }

    @Override
    public void onDisabled(Context context, Intent intent) {
        Log.e("MyDeviceAdminRec...", "::>>>>4 ");
        showToast(context, "Sample Device Admin: disabled");
    }

    @Override
    public void onPasswordChanged(Context context, Intent intent) {
        Log.e("MyDeviceAdminRec...", "::>>>>5 ");
        showToast(context, "Sample Device Admin: pw changed");
    }

    @Override
    public void onPasswordFailed(Context context, Intent intent) {
        Log.e("MyDeviceAdminRec...", "::>>>>6 ");
        showToast(context, "Sample Device Admin: pw failed");
    }

    @Override
    public void onPasswordSucceeded(Context context, Intent intent) {
        Log.e("MyDeviceAdminRec...", "::>>>>7 ");
        showToast(context, "Sample Device Admin: pw succeeded");
    }

    @Override
    public void onProfileProvisioningComplete(Context context, Intent intent) {
     // Enable the profile
     DevicePolicyManager manager =(DevicePolicyManager) context.getSystemService(Context.DEVICE_POLICY_SERVICE);
     ComponentName componentName = new ComponentName(context,this.getClass());
     manager.setProfileName(componentName, "WorkProfile");
 
     // If I do not do this, the application will not enter in profile mode, and I don't know why 
 
     Intent launch = new Intent(context, this.activity.getClass());
     launch.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
     context.startActivity(launch);
    }
}
