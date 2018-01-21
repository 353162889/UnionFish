package com.zhongju.buyu.sdk;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;

public class BaseSDK {
	private boolean init = false;
	public void init(Activity activity)
	{
		init = true;
	}
	
	public boolean IsInit()
	{
		return init;
	}
	
	public void onDestroy() 
	{
	}

	public void onStop() {
	}

	public void onResume() {
	}

	public void onPause() {
	}
	
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		
	}

	public void onNewIntent(Intent intent) {
	}

	public void onRestart() {
	}
	
	public void onStart() {
	}
	
	public void onBackPressed() {
    }
	
	public void onConfigurationChanged(Configuration newConfig) {
    }
    
	public void onRestoreInstanceState(Bundle savedInstanceState) {
    }
    
	public void onSaveInstanceState(Bundle outState) {
    }
	
	public void pause()
	{
		
	}
	
	public void exit()
	{
		
	}
	
	public String getChannelId()
	{
		return "";
	}
	
	public String getUserID()
	{
		return "";
	}
	
	public String getCustomParam()
	{
		return "";
	}
	
	//SDKµÇÂ¼
	public void login()
	{
		
	}
	
	public boolean isLogined()
	{
		return false;
	}
	
	//SDK×¢Ïú
	public void logout()
	{
		
	}
	
	public boolean isSupportLogout()
	{
		return false;
	}
	
	public boolean isSupportExit()
	{
		return false;
	}
	
	public void accountSwitch()
	{
	
	}
	
	public boolean isSupportAccountSwitch()
	{
		return false;
	}
	
	public void showToolBar()
	{
		
	}
	
	public boolean isSupportShowToolBar()
	{
		return false;
	}
	
	public void payForProduct(String payInfo)
	{
		
	}
	
	public void resetPayState()
	{
		
	}
}
