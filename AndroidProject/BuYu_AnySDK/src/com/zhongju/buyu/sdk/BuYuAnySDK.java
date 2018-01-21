package com.zhongju.buyu.sdk;

import java.util.ArrayList;
import java.util.Map;

import com.anysdk.framework.IAPWrapper;
import com.anysdk.framework.PluginWrapper;
import com.anysdk.framework.UserWrapper;
import com.anysdk.framework.java.AnySDK;
import com.anysdk.framework.java.AnySDKIAP;
import com.anysdk.framework.java.AnySDKListener;
import com.anysdk.framework.java.AnySDKUser;
import com.zhongju.buyu.app.UnityAppBridge;
import com.zhongju.buyu.app.UnityAppCode;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.Log;

public class BuYuAnySDK extends BaseSDK {
	private static String appKey = "84541FC8-EA5E-6BC6-35A3-E4572F6759F1";
    private static String appSecret = "ea6e650fc65862f844db1ba556161010";
    private static String privateKey = "88BC8B6E3A6C443204A8A27E497F8B53";
    private static String oauthLoginServer = "http://112.74.100.29:8085/";
	@Override
	public void init(Activity activity) {
		/**
		 * appKey、appSecret、privateKey不能使用Sample中的值，需要从打包工具中游戏管理界面获取，替换
		 * oauthLoginServer参数是游戏服务提供的用来做登陆验证转发的接口地址。
		 */
		AnySDK.getInstance().init(activity, appKey, appSecret, privateKey,
				oauthLoginServer);

		/**
		 * 初始化完成后，必须立即为系统设置监听，否则无法即使监听到回调信息
		 */
		setListener();
		super.init(activity);
	}
	
	public void setListener() {
		/**
		 * 为用户系统设置监听
		 */
		AnySDKUser.getInstance().setListener(new AnySDKListener() {

			@Override
			public void onCallBack(int arg0, String arg1) {
				Log.d(String.valueOf(arg0), arg1);
				switch (arg0) {
				case UserWrapper.ACTION_RET_INIT_SUCCESS:// 初始化SDK成功回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.InitSuccess,arg1);
					break;
				case UserWrapper.ACTION_RET_INIT_FAIL:// 初始化SDK失败回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.InitFail,arg1);
					break;
				case UserWrapper.ACTION_RET_LOGIN_SUCCESS:// 登陆成功回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.LoginSuccess,arg1);
					break;
				case UserWrapper.ACTION_RET_LOGIN_NO_NEED:// 登陆失败回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.LoginNoNeed,arg1);
				case UserWrapper.ACTION_RET_LOGIN_TIMEOUT:// 登陆失败回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.LoginNetworkError,arg1);
				case UserWrapper.ACTION_RET_LOGIN_CANCEL:// 登陆取消回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.LoginCancel,arg1);
				case UserWrapper.ACTION_RET_LOGIN_FAIL:// 登陆失败回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.LoginFail,arg1);
					break;
				case UserWrapper.ACTION_RET_LOGOUT_SUCCESS:// 登出成功回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.LogoutSuccess,arg1);
					break;
				case UserWrapper.ACTION_RET_LOGOUT_FAIL:// 登出失败回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.LogoutFail,arg1);
					break;
				case UserWrapper.ACTION_RET_PLATFORM_ENTER:// 平台中心进入回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.PlatformEnter,arg1);
					break;
				case UserWrapper.ACTION_RET_PLATFORM_BACK:// 平台中心退出回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.PlatformBack,arg1);
					break;
				case UserWrapper.ACTION_RET_PAUSE_PAGE:// 暂停界面回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.PausePage,arg1);
					break;
				case UserWrapper.ACTION_RET_EXIT_PAGE:// 退出游戏回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.ExitPage,arg1);
					break;
				case UserWrapper.ACTION_RET_ANTIADDICTIONQUERY:// 防沉迷查询回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.AntiAddictionQuery,arg1);
					break;
				case UserWrapper.ACTION_RET_REALNAMEREGISTER:// 实名注册回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.RealNameRegister,arg1);
					break;
				case UserWrapper.ACTION_RET_ACCOUNTSWITCH_SUCCESS:// 切换账号成功回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.AccountSwitchSuccess,arg1);
					break;
				case UserWrapper.ACTION_RET_ACCOUNTSWITCH_FAIL:// 切换账号失败回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.AccountSwitchFail,arg1);
					break;
				case UserWrapper.ACTION_RET_OPENSHOP:// 打开游戏商店回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.OpenShop,arg1);
					break;
				default:
					break;
				}
			}
		});

		/**
		 * 为支付系统设置监听
		 */
		AnySDKIAP.getInstance().setListener(new AnySDKListener() {

			@Override
			public void onCallBack(int arg0, String arg1) {
				Log.d(String.valueOf(arg0), arg1);
				switch (arg0) {
				case IAPWrapper.PAYRESULT_INIT_FAIL:// 支付初始化失败回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayInitFail,arg1);
					break;
				case IAPWrapper.PAYRESULT_INIT_SUCCESS:// 支付初始化成功回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayInitSuccess,arg1);
					break;
				case IAPWrapper.PAYRESULT_SUCCESS:// 支付成功回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.PaySuccess,arg1);
					break;
				case IAPWrapper.PAYRESULT_FAIL:// 支付失败回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayFail,arg1);
					break;
				case IAPWrapper.PAYRESULT_CANCEL:// 支付取消回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayCancel,arg1);
					break;
				case IAPWrapper.PAYRESULT_NETWORK_ERROR:// 支付超时回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayNetworkError,arg1);
					break;
				case IAPWrapper.PAYRESULT_PRODUCTIONINFOR_INCOMPLETE:// 支付超时回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayProductionInforIncomplete,arg1);
					break;
				/**
				 * 新增加:正在进行中回调 支付过程中若SDK没有回调结果，就认为支付正在进行中
				 * 游戏开发商可让玩家去判断是否需要等待，若不等待则进行下一次的支付
				 */
				case IAPWrapper.PAYRESULT_NOW_PAYING:
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayNowPaying,arg1);
					break;
				case IAPWrapper.PAYRESULT_RECHARGE_SUCCESS:// 充值成功回调
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayRechargeSuccess,arg1);
					break;
				default:
					break;
				}
			}
		});
	}
	
	@Override
	public void onDestroy() {
		PluginWrapper.onDestroy();
		AnySDK.getInstance().release();
	}

	@Override
	public void onStop() {
		PluginWrapper.onStop();
	}

	@Override
	public void onResume() {
		PluginWrapper.onResume();
	}

	@Override
	public void onPause() {
		PluginWrapper.onPause();
	}
	
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		PluginWrapper.onActivityResult(requestCode, resultCode, data);
		
	}

	@Override
	public void onNewIntent(Intent intent) {
		PluginWrapper.onNewIntent(intent);
	}

	@Override
	public void onRestart() {
		PluginWrapper.onRestart();
	}
	
	@Override
	public void onStart() {
		PluginWrapper.onStart();
	}
	
	@Override
	public void onBackPressed() {
		PluginWrapper.onBackPressed();
    }
	
    @Override
	public void onConfigurationChanged(Configuration newConfig) {
    	PluginWrapper.onConfigurationChanged(newConfig);
    }
    
    @Override
    public void onRestoreInstanceState(Bundle savedInstanceState) {
    	PluginWrapper.onRestoreInstanceState(savedInstanceState);
    }
    
    @Override
    public void onSaveInstanceState(Bundle outState) {
    	PluginWrapper.onSaveInstanceState(outState);
    }
    
    
    @Override
    public String getChannelId()
	{
    	return AnySDK.getInstance().getChannelId();
	}
	
    @Override
	public String getUserID()
	{
    	return AnySDKUser.getInstance().getUserID();
	}
	
    @Override
	public String getCustomParam()
	{
		return AnySDK.getInstance().getCustomParam();
	}
	
	//SDK登录
    @Override
	public void login()
	{
		AnySDKUser.getInstance().login();
	}
    
    @Override
    public boolean isLogined()
	{
		return AnySDKUser.getInstance().isLogined();
	}
    
	//SDK注销
    @Override
	public void logout()
	{
    	if(isSupportLogout())
    	{
    		AnySDKUser.getInstance().callFunction("logout");
    	}
	}
	
    @Override
	public boolean isSupportLogout()
	{
    	return AnySDKUser.getInstance().isFunctionSupported("logout");
	}
    
    @Override
    public void pause()
	{
    	if (AnySDKUser.getInstance().isFunctionSupported("pause")) {
    		AnySDKUser.getInstance().callFunction("pause");
		}
	}
    
    @Override
    public void exit()
	{
    	if (isSupportExit()) {
			AnySDKUser.getInstance().callFunction("exit");
		}
	}

	
    @Override
	public boolean isSupportExit()
	{
		return AnySDKUser.getInstance().isFunctionSupported("exit");
	}
	
    @Override
	public void accountSwitch()
	{
    	if(isSupportAccountSwitch()){
    		AnySDKUser.getInstance().callFunction("accountSwitch");
    	}
	}
	
    @Override
	public boolean isSupportAccountSwitch()
	{
		return AnySDKUser.getInstance().isFunctionSupported("accountSwitch");
	}
	
    @Override
	public void showToolBar()
	{
		if(isSupportShowToolBar())
		{
			AnySDKUser.getInstance().callFunction("showToolBar");
		}
	}
	
    @Override
	public boolean isSupportShowToolBar()
	{
		return AnySDKUser.getInstance().isFunctionSupported("showToolBar");
	}
	
    @Override
	public void payForProduct(String payInfo)
	{
    	ArrayList<String> pluginIds = AnySDKIAP.getInstance().getPluginId();
    	Map<String,String> orders = SDKUtil.StringToMap(payInfo);
    	AnySDKIAP.getInstance().payForProduct(pluginIds.get(0), orders);
	}
    
    @Override
    public void resetPayState()
	{
    	AnySDKIAP.getInstance().resetPayState();
	}
}
