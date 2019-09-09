package com.example.getinfo;

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


public class MainActivity extends FlutterActivity {

    private PendingIntent pendingIntent;
    private AlarmManager alarmManager;
    private static  FlutterView flutterView;
    private static final String CHANNEL = "com.tarazgroup";
    // To keep track of activity's window focus
    boolean currentFocus;
    
    // To keep track of activity's foreground/background status
    boolean isPaused;
    
    Handler collapseNotificationHandler;
    Handler collapsePowerButtonHandler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        flutterView=getFlutterView();
        GeneratedPluginRegistrant.registerWith(this);
        
        doNotLockScreen();
        hideSystemUI(flutterView);
        
        View decorView = getWindow().getDecorView();
        // Hide the status bar.
        int uiOptions = View.SYSTEM_UI_FLAG_FULLSCREEN;
        decorView.setSystemUiVisibility(uiOptions);
        // Remember that you should never show the action bar if the
        // status bar is hidden, so hide that too if necessary.

       
    

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
        WindowManager.LayoutParams.FLAG_FULLSCREEN);
       
        
      
      
  
        Intent intent = new Intent(this, MyReceiver.class);
        pendingIntent = PendingIntent.getBroadcast(this, 1019662, intent, 0);
        alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);
        alarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP,System.currentTimeMillis(), 1000, pendingIntent);

    }

    public void collapseNow() {

        // Initialize 'collapseNotificationHandler'

        if (collapseNotificationHandler == null) {
            collapseNotificationHandler = new Handler();
        }
    
        // If window focus has been lost && activity is not in a paused state
        // Its a valid check because showing of notification panel
        // steals the focus from current activity's window, but does not 
        // 'pause' the activity
        if (!currentFocus && !isPaused) {
    
            // Post a Runnable with some delay - currently set to 300 ms
            collapseNotificationHandler.postDelayed(new Runnable() {
    
                @Override
                public void run() {
    
                    // Use reflection to trigger a method from 'StatusBarManager'                
    
                    Object statusBarService = getSystemService("statusbar");
                    Class<?> statusBarManager = null;
    
                    try {
                        statusBarManager = Class.forName("android.app.StatusBarManager");
                    } catch (ClassNotFoundException e) {
                        e.printStackTrace();
                    }
    
                    Method collapseStatusBar = null;
    
                    try {
    
                        // Prior to API 17, the method to call is 'collapse()'
                        // API 17 onwards, the method to call is `collapsePanels()`
    
                      
                            collapseStatusBar = statusBarManager .getMethod("collapsePanels");
                      
                    } catch (NoSuchMethodException e) {
                        e.printStackTrace();
                    }
    
                    collapseStatusBar.setAccessible(true);
    
                    try {
                        collapseStatusBar.invoke(statusBarService);
                    } catch (IllegalArgumentException e) {
                        e.printStackTrace();
                    } catch (IllegalAccessException e) {
                        e.printStackTrace();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
    
                    // Check if the window focus has been returned
                    // If it hasn't been returned, post this Runnable again
                    // Currently, the delay is 100 ms. You can change this
                    // value to suit your needs.
                    if (!currentFocus && !isPaused) {
                        collapseNotificationHandler.postDelayed(this, 100L);
                    }
    
                }
            }, 300L);
        }   
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        alarmManager.cancel(pendingIntent);
    }

    @Override
    public void onBackPressed() {
	// nothing to do here
	// … really      
   }
   private List blockedKeys = new ArrayList();

   @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        return false;
    }
  

   @Override
   public boolean dispatchKeyEvent(KeyEvent event) {
     blockedKeys.add(KeyEvent.KEYCODE_VOLUME_DOWN);
     blockedKeys.add(KeyEvent.KEYCODE_VOLUME_UP); 
     blockedKeys.add(KeyEvent.KEYCODE_HOME);  

     
     if (blockedKeys.contains(event.getKeyCode())) {
       return true;
     } else {
       return super.dispatchKeyEvent(event);
     }
   }
   private void hideSystemUI(View view) {
     System.out.println("xxxxx");
    // Set the IMMERSIVE flag.
    // Set the content to appear under the system bars so that the content
    // doesn't resize when the system bars hide and show.
    view.setSystemUiVisibility(
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                    | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                    | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION // hide nav bar
                    | View.SYSTEM_UI_FLAG_FULLSCREEN // hide status bar
                    | View.SYSTEM_UI_FLAG_IMMERSIVE);
   }

   

  
   @Override
   public void onWindowFocusChanged(boolean hasFocus) {
       super.onWindowFocusChanged(hasFocus);
       if(!hasFocus)
       {
         Intent closeDialog=new Intent(Intent.ACTION_CLOSE_SYSTEM_DIALOGS);
         collapseNow();
         sendBroadcast(closeDialog);
        
        
       }
   }

         private WindowManager amanager;
         
         public static void preventStatusBarExpansion(Context context) {
                          WindowManager manager = ((WindowManager) context.getApplicationContext()
                          .getSystemService(Context.WINDOW_SERVICE));
                  
                      Activity activity = (Activity)context;
                      WindowManager.LayoutParams localLayoutParams = new WindowManager.LayoutParams();
                      localLayoutParams.type = WindowManager.LayoutParams.TYPE_SYSTEM_ERROR;
                      localLayoutParams.gravity = Gravity.TOP;
                      localLayoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE|
                  
                      // this is to enable the notification to recieve touch events
                      WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL |
                  
                      // Draws over status bar
                      WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN;
                  
                      localLayoutParams.width = WindowManager.LayoutParams.MATCH_PARENT;
                      int resId = activity.getResources().getIdentifier("status_bar_height", "dimen", "android");
                      int result = 0;
                      if (resId > 0) {
                          result = activity.getResources().getDimensionPixelSize(resId);
                      }
                  
                      localLayoutParams.height = result;
                  
                      localLayoutParams.format = PixelFormat.TRANSPARENT;
                  
                      CustomViewGroup view = new CustomViewGroup(context);
                  
                      manager.addView(view, localLayoutParams);
        }

       private void doNotLockScreen() {
          getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
          getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
          getWindow().addFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD);
          getWindow().addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
       }
       

    
      
           
   

    static void callFlutter(){
        MethodChannel methodChannel=new MethodChannel(flutterView, CHANNEL);
        methodChannel.invokeMethod("I say hello every minute!!","");
    }

    public static class CustomViewGroup extends ViewGroup {
      public CustomViewGroup(Context context) {
          super(context);
      }
  
      @Override
      protected void onLayout(boolean changed, int l, int t, int r, int b) {
      }
  
      @Override
      public boolean onInterceptTouchEvent(MotionEvent ev) {
          // Intercepted touch!
          return true;
      }
  }
  
}




class MyDeviceAdminReceiver extends DeviceAdminReceiver {

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



