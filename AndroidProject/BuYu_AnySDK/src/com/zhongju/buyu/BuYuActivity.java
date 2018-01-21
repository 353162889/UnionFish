package com.zhongju.buyu;

import java.util.List;

import com.unity3d.player.UnityPlayerActivity;
import com.zhongju.buyu.app.UnityAppBridge;
import com.zhongju.buyu.sdk.BaseSDK;
import com.zhongju.buyu.sdk.BuYuAnySDK;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.KeyEvent;

public class BuYuActivity extends UnityPlayerActivity {
	private static Activity mAct;
	private BaseSDK baseSDK;
	private boolean isAppForeground = true;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mAct = this;
		baseSDK = new BaseSDK();
		UnityAppBridge.Init(this);
	}
	
	public void InitSDK()
	{
		baseSDK = new BuYuAnySDK();
		baseSDK.init(mAct);
	}
	
	public BaseSDK GetSDK()
	{
		return baseSDK;
	}
	
	public static void Exit() {
		mAct.finish();
		System.exit(0);
	}

	@Override
	protected void onDestroy() {
		baseSDK.onDestroy();
		super.onDestroy();
	};

	@Override
	protected void onStop() {
		baseSDK.onStop();
		super.onStop();
		if (!isAppOnForeground()) {
			isAppForeground = false;
		}
	}

	@Override
	protected void onResume() {
		baseSDK.onResume();
		super.onResume();
		if (!isAppForeground) {
			isAppForeground = true;
			baseSDK.pause();
		}
	}

	@Override
	protected void onPause() {
		baseSDK.onPause();
		super.onPause();
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		baseSDK.onActivityResult(requestCode, resultCode, data);
		super.onActivityResult(requestCode, resultCode, data);
		
	}

	@Override
	protected void onNewIntent(Intent intent) {
		baseSDK.onNewIntent(intent);
		super.onNewIntent(intent);
	}

	@Override
	protected void onRestart() {
		baseSDK.onRestart();
		super.onRestart();
	}
	
	@Override
	protected void onStart() {
		baseSDK.onStart();
		super.onStart();
	}
	
	@Override
	public void onBackPressed() {
		baseSDK.onBackPressed();
        super.onBackPressed();
    }
	
    @Override
	public void onConfigurationChanged(Configuration newConfig) {
    	baseSDK.onConfigurationChanged(newConfig);
        super.onConfigurationChanged(newConfig);
    }
    
    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
    	baseSDK.onRestoreInstanceState(savedInstanceState);
        super.onRestoreInstanceState(savedInstanceState);
    }
    
    @Override
    protected void onSaveInstanceState(Bundle outState) {
    	baseSDK.onSaveInstanceState(outState);
        super.onSaveInstanceState(outState);
    }
 	
	public boolean isAppOnForeground() {
		ActivityManager activityManager = (ActivityManager) getApplicationContext()
				.getSystemService(Context.ACTIVITY_SERVICE);
		String packageName = getApplicationContext().getPackageName();
		List<RunningAppProcessInfo> appProcesses = activityManager
				.getRunningAppProcesses();
		if (appProcesses == null)
			return false;
		for (RunningAppProcessInfo appProcess : appProcesses) {
			if (appProcess.processName.equals(packageName)
					&& appProcess.importance == RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
				return true;
			}
		}
		return false;
	}


	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
//		if (keyCode == KeyEvent.KEYCODE_BACK) {
//			/**
//			 * �ж��Ƿ�֧�ֵ����˳�����Ľӿ�
//			 */
//			if(baseSDK.IsInit())
//			{
//				baseSDK.exit();
//			}
//			else
//			{
//				
//			}
//			return true;
//		}
		return super.onKeyDown(keyCode, event);
	}
	

}
