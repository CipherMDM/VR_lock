package com.example.getinfo;

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


public class MainActivity extends FlutterActivity {

    private PendingIntent pendingIntent;
    private AlarmManager alarmManager;
    private static  FlutterView flutterView;
    private static final String CHANNEL = "com.tarazgroup";

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        flutterView=getFlutterView();
        GeneratedPluginRegistrant.registerWith(this);
        
        doNotLockScreen();
        hideSystemUI(flutterView);
      
  
        Intent intent = new Intent(this, MyReceiver.class);
        pendingIntent = PendingIntent.getBroadcast(this, 1019662, intent, 0);
        alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);
        alarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP,System.currentTimeMillis(), 1000, pendingIntent);

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
         sendBroadcast(closeDialog);
       }
   }

         private WindowManager amanager;
         
         public static void preventStatusBarExpansion(Context context) {
            WindowManager manager = ((WindowManager) context.getApplicationContext().getSystemService(Context.WINDOW_SERVICE));
        
            WindowManager.LayoutParams localLayoutParams = new WindowManager.LayoutParams();
            localLayoutParams.type = WindowManager.LayoutParams.TYPE_SYSTEM_ERROR;
            localLayoutParams.gravity = Gravity.TOP;
            localLayoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE|WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL|WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN;
        
            localLayoutParams.width = WindowManager.LayoutParams.MATCH_PARENT;
        
            int resId = context.getResources().getIdentifier("status_bar_height", "dimen", "android");
            int result = 0;
            if (resId > 0) {
              result = context.getResources().getDimensionPixelSize(resId);
            } else {
              // Use Fallback size:
              result = 60; // 60px Fallback
            }
        
            localLayoutParams.height = result;
            localLayoutParams.format = PixelFormat.TRANSPARENT;
        
            CustomViewGroup customViewGroup = new CustomViewGroup(context);
            manager.addView(customViewGroup, localLayoutParams);
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



