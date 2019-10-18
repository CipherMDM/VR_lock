package com.example.getinfo;

import android.app.admin.DevicePolicyManager;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
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
import android.graphics.Color;

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



public class MainActivity extends FlutterActivity {

    private PendingIntent pendingIntent;
    private AlarmManager alarmManager;
    private static  FlutterView flutterView;
    private static final String CHANNEL = "com.tarazgroup";
    // To keep track of activity's window focus
    boolean currentFocus;
    Context context=this;
    
    // To keep track of activity's foreground/background status
    boolean isPaused;
    
    Handler collapseNotificationHandler;
    Handler collapsePowerButtonHandler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        flutterView=getFlutterView();
        GeneratedPluginRegistrant.registerWith(this);
    
        hideSystemUI(flutterView);

        transparentStatusAndNavigation();

        
         String[] permissions = {Manifest.permission.WRITE_EXTERNAL_STORAGE};
         this.requestPermissions(permissions,1);
  
        
  
        Intent intent = new Intent(this, MyReceiver.class);
        pendingIntent = PendingIntent.getBroadcast(this, 1019662, intent, 0);
        alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);
        alarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP,System.currentTimeMillis(), 1000, pendingIntent);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall call, Result result) {
                    List<String> allowed_apps=call.argument("allowed_apps");
                    String[] allowed_ = new String[allowed_apps.size()];

                    for(int i =0;i<allowed_apps.size();i++){

                        allowed_[i]=allowed_apps.get(i);

                    }
                    if (call.method.equals("StartService")) {
                        Intent intent = new Intent(context, BackgroundService.class);
                        intent.putExtra("allowed_apps", allowed_);
                        startService(intent);
                        result.success("Android ");
                      }
                }
            });

    }

    private void transparentStatusAndNavigation() {
       
            setWindowFlag(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS
                    | WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION, false);
            getWindow().setStatusBarColor(Color.TRANSPARENT);
            getWindow().setNavigationBarColor(Color.TRANSPARENT);
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
        
    }
    
    private void setWindowFlag(final int bits, boolean on) {
        Window win = getWindow();
        WindowManager.LayoutParams winParams = win.getAttributes();
        if (on) {
            winParams.flags |= bits;
        } else {
            winParams.flags &= ~bits;
        }
        win.setAttributes(winParams);
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
                        collapseNotificationHandler.postDelayed(this, 1L);
                    }
    
                }
            }, 3L);
        }   
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
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
                    | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
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







