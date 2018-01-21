package com.zhongju.buyu.app;

import com.unity3d.player.UnityPlayer;
import com.zhongju.buyu.BuYuActivity;

import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.NetworkInfo.State;

public class UnityAppBridge {
	
	final public static String UnityObject = "Drive";
	final public static String UnityMethod = "OnAppCallback";
	final public static String UnityLog = "OnAppLog";
	
	public static UnityAppBridge curAppBridge = new UnityAppBridge();
	public static BuYuActivity curActivity;
	
	public static void Init(BuYuActivity activity)
	{
		curActivity = activity;
	}
	
	public static void SendUnityMsg(int code)
	{
		SendUnityMsg(code,"");
	}
	
	public static void SendUnityMsg(int code,String msg)
	{
		String result = String.format("code=%d&msg=%s", code,msg);
		UnityPlayer.UnitySendMessage(UnityObject,UnityMethod,result);
	}
	
	public static void UnityLog(String msg)
	{
		UnityPlayer.UnitySendMessage(UnityObject,UnityLog,msg);
	}
	
	public void InitSDK()
	{
		curActivity.InitSDK();
	}
	
	public String GetChannelId()
	{
		return curActivity.GetSDK().getChannelId();
	}
	
	public String GetUserID()
	{
		return curActivity.GetSDK().getUserID();
	}
	
	public String GetCustomParam()
	{
		return curActivity.GetSDK().getCustomParam();
	}
	
	//SDKµÇÂ¼
	public void Login()
	{
		UnityLog("[UnityAppBridge]Login");
		curActivity.GetSDK().login();
	}
	
	public boolean IsLogined()
	{
		UnityLog("[UnityAppBridge]IsLogined");
		return curActivity.GetSDK().isLogined();
	}
	
	//SDK×¢Ïú
	public void Logout()
	{
		curActivity.GetSDK().logout();
	}
	
	public boolean IsSupportLogout()
	{
		return curActivity.GetSDK().isSupportLogout();
	}
	
	public void AnySDKExit()
	{
		curActivity.GetSDK().exit();
	}
	
	public boolean IsSupportExit()
	{
		return curActivity.GetSDK().isSupportExit();
	}
	
	public void AccountSwitch()
	{
		curActivity.GetSDK().accountSwitch();
	}
	
	public boolean IsAccountSwitch()
	{
		return curActivity.GetSDK().isSupportAccountSwitch();
	}
	
	public void ShowToolBar()
	{
		curActivity.GetSDK().showToolBar();
	}
	
	public boolean IsShowToolBar()
	{
		return curActivity.GetSDK().isSupportShowToolBar();
	}
	
	public void PayForProduct(String payInfo)
	{
		curActivity.GetSDK().payForProduct(payInfo);
	}
	
	public void ResetPayState()
	{
		curActivity.GetSDK().resetPayState();
	}
	
	public static int getMobileNetworkState()
	{
		ConnectivityManager conMan = (ConnectivityManager) curActivity.getSystemService(Context.CONNECTIVITY_SERVICE);
		@SuppressWarnings("deprecation")
		NetworkInfo info = conMan.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
		if(info == null)return NetState.UNKNOWN;
		State mobile = info.getState();
		return GetNetState(mobile);
	}
	
	public static int getWifiNetworkState()
	{
		ConnectivityManager conMan = (ConnectivityManager) curActivity.getSystemService(Context.CONNECTIVITY_SERVICE);
		@SuppressWarnings("deprecation")
		NetworkInfo info = conMan.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
		if(info == null)return NetState.UNKNOWN;
		State wifi = info.getState();
		return GetNetState(wifi);
	}
	
	private static int GetNetState(State state)
	{
		if(state == State.CONNECTED)
		{
			return NetState.CONNECTED;
		}
		else if(state == State.CONNECTING)
		{
			return NetState.CONNECTING;
		}
		else if(state == State.DISCONNECTED)
		{
			return NetState.DISCONNECTED;
		}
		else if(state == State.DISCONNECTING)
		{
			return NetState.DISCONNECTING;
		}
		else if(state == State.SUSPENDED)
		{
			return NetState.SUSPENDED;
		}
		return NetState.UNKNOWN;
	}
	
    public static boolean isNetConnected() {
        ConnectivityManager conn = (ConnectivityManager) curActivity.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo info = conn.getActiveNetworkInfo();
        return (info != null && info.isConnected());
    }
	
	public static void openWifiSetting()
	{
		curActivity.startActivity(new Intent(android.provider.Settings.ACTION_WIFI_SETTINGS));
	}
	
	public static void openWirelessSetting()
	{
		curActivity.startActivity(new Intent(android.provider.Settings.ACTION_WIRELESS_SETTINGS));
	}
}
