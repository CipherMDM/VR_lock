package com.example.getinfo;

import android.app.Service;
import android.content.*;
import android.os.*;
import android.widget.Toast;


import android.app.admin.DevicePolicyManager;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterView;
import android.app.Service;
import java.util.ArrayList;
import android.view.KeyEvent;
import java.util.*;
import java.util.List;
import android.os.Handler;
import 	java.lang.reflect.Method;
import android.app.usage.UsageStatsManager;
import 	android.app.usage.UsageStats;
import java.util.Arrays;
import android.content.Intent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.Toast;
import 	android.view.ViewGroup;
import android.content.Context;
import android.view.MotionEvent;
import android.view.Gravity;
import android.graphics.PixelFormat;
import android.provider.Settings;
import android.view.WindowManager;
import android.view.Window;
import android.content.ComponentName;
import android.view.GestureDetector;
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
import android.Manifest;
import android.app.Service;
import android.content.*;
import android.os.*;
import android.widget.Toast;
import android.net.Uri;

public class BackgroundService extends Service {

    public Context context = this;
    public Handler handler = null;
    public static Runnable runnable = null;
    String[] _apps;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }


    @Override
    public void onCreate() {
        Toast.makeText(this, "Service created!", Toast.LENGTH_LONG).show();
        
        handler = new Handler();
        runnable = new Runnable() {
            public void run() {
              
               
                List<String> apps = new ArrayList<>();
                for(String i : _apps){
                      apps.add(i);
                }


                if(!apps.contains(getForegroundApp())){
                    showHomeScreen();
                  }
                handler.postDelayed(runnable, 1000);
            }
        };

        handler.postDelayed(runnable, 15000);
    }

    @Override
    public void onDestroy() {
        /* IF YOU WANT THIS SERVICE KILLED WITH THE APP THEN UNCOMMENT THE FOLLOWING LINE */
        //handler.removeCallbacks(runnable);
        Toast.makeText(this, "Service stopped", Toast.LENGTH_LONG).show();
    }

    @Override
    public void onStart(Intent intent, int startid) {
        Bundle extras = intent.getExtras(); 
        _apps = (String[]) extras.get("allowed_apps");
        onCreate();
        Toast.makeText(this, "Service started by user.", Toast.LENGTH_LONG).show();
    }


    public String getForegroundApp() {
        String currentApp = "NULL";
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            UsageStatsManager usm = (UsageStatsManager) this.getSystemService(Context.USAGE_STATS_SERVICE);
            long time = System.currentTimeMillis();
            List<UsageStats> appList = usm.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, time - 1000 * 1000, time);
            if (appList != null && appList.size() > 0) {
                SortedMap<Long, UsageStats> mySortedMap = new TreeMap<Long, UsageStats>();
                for (UsageStats usageStats : appList) {
                    mySortedMap.put(usageStats.getLastTimeUsed(), usageStats);
                }
                if (mySortedMap != null && !mySortedMap.isEmpty()) {
                    currentApp = mySortedMap.get(mySortedMap.lastKey()).getPackageName();
                }
            }
        } else {
            ActivityManager am = (ActivityManager) this.getSystemService(Context.ACTIVITY_SERVICE);
            List<ActivityManager.RunningAppProcessInfo> tasks = am.getRunningAppProcesses();
            currentApp = tasks.get(0).processName;
        }
    
        return currentApp;
    }

    public boolean showHomeScreen(){
        Intent startMain = new Intent(Intent.ACTION_MAIN);
        startMain.addCategory(Intent.CATEGORY_HOME);
        startMain.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(startMain);
        return true;
    }
  



}
