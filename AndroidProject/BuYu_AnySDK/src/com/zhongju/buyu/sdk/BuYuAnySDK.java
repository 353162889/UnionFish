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
		 * appKey��appSecret��privateKey����ʹ��Sample�е�ֵ����Ҫ�Ӵ����������Ϸ��������ȡ���滻
		 * oauthLoginServer��������Ϸ�����ṩ����������½��֤ת���Ľӿڵ�ַ��
		 */
		AnySDK.getInstance().init(activity, appKey, appSecret, privateKey,
				oauthLoginServer);

		/**
		 * ��ʼ����ɺ󣬱�������Ϊϵͳ���ü����������޷���ʹ�������ص���Ϣ
		 */
		setListener();
		super.init(activity);
	}
	
	public void setListener() {
		/**
		 * Ϊ�û�ϵͳ���ü���
		 */
		AnySDKUser.getInstance().setListener(new AnySDKListener() {

			@Override
			public void onCallBack(int arg0, String arg1) {
				Log.d(String.valueOf(arg0), arg1);
				switch (arg0) {
				case UserWrapper.ACTION_RET_INIT_SUCCESS:// ��ʼ��SDK�ɹ��ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.InitSuccess,arg1);
					break;
				case UserWrapper.ACTION_RET_INIT_FAIL:// ��ʼ��SDKʧ�ܻص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.InitFail,arg1);
					break;
				case UserWrapper.ACTION_RET_LOGIN_SUCCESS:// ��½�ɹ��ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.LoginSuccess,arg1);
					break;
				case UserWrapper.ACTION_RET_LOGIN_NO_NEED:// ��½ʧ�ܻص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.LoginNoNeed,arg1);
				case UserWrapper.ACTION_RET_LOGIN_TIMEOUT:// ��½ʧ�ܻص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.LoginNetworkError,arg1);
				case UserWrapper.ACTION_RET_LOGIN_CANCEL:// ��½ȡ���ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.LoginCancel,arg1);
				case UserWrapper.ACTION_RET_LOGIN_FAIL:// ��½ʧ�ܻص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.LoginFail,arg1);
					break;
				case UserWrapper.ACTION_RET_LOGOUT_SUCCESS:// �ǳ��ɹ��ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.LogoutSuccess,arg1);
					break;
				case UserWrapper.ACTION_RET_LOGOUT_FAIL:// �ǳ�ʧ�ܻص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.LogoutFail,arg1);
					break;
				case UserWrapper.ACTION_RET_PLATFORM_ENTER:// ƽ̨���Ľ���ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.PlatformEnter,arg1);
					break;
				case UserWrapper.ACTION_RET_PLATFORM_BACK:// ƽ̨�����˳��ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.PlatformBack,arg1);
					break;
				case UserWrapper.ACTION_RET_PAUSE_PAGE:// ��ͣ����ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.PausePage,arg1);
					break;
				case UserWrapper.ACTION_RET_EXIT_PAGE:// �˳���Ϸ�ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.ExitPage,arg1);
					break;
				case UserWrapper.ACTION_RET_ANTIADDICTIONQUERY:// �����Բ�ѯ�ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.AntiAddictionQuery,arg1);
					break;
				case UserWrapper.ACTION_RET_REALNAMEREGISTER:// ʵ��ע��ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.RealNameRegister,arg1);
					break;
				case UserWrapper.ACTION_RET_ACCOUNTSWITCH_SUCCESS:// �л��˺ųɹ��ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.AccountSwitchSuccess,arg1);
					break;
				case UserWrapper.ACTION_RET_ACCOUNTSWITCH_FAIL:// �л��˺�ʧ�ܻص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.AccountSwitchFail,arg1);
					break;
				case UserWrapper.ACTION_RET_OPENSHOP:// ����Ϸ�̵�ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.OpenShop,arg1);
					break;
				default:
					break;
				}
			}
		});

		/**
		 * Ϊ֧��ϵͳ���ü���
		 */
		AnySDKIAP.getInstance().setListener(new AnySDKListener() {

			@Override
			public void onCallBack(int arg0, String arg1) {
				Log.d(String.valueOf(arg0), arg1);
				switch (arg0) {
				case IAPWrapper.PAYRESULT_INIT_FAIL:// ֧����ʼ��ʧ�ܻص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayInitFail,arg1);
					break;
				case IAPWrapper.PAYRESULT_INIT_SUCCESS:// ֧����ʼ���ɹ��ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayInitSuccess,arg1);
					break;
				case IAPWrapper.PAYRESULT_SUCCESS:// ֧���ɹ��ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.PaySuccess,arg1);
					break;
				case IAPWrapper.PAYRESULT_FAIL:// ֧��ʧ�ܻص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayFail,arg1);
					break;
				case IAPWrapper.PAYRESULT_CANCEL:// ֧��ȡ���ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayCancel,arg1);
					break;
				case IAPWrapper.PAYRESULT_NETWORK_ERROR:// ֧����ʱ�ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayNetworkError,arg1);
					break;
				case IAPWrapper.PAYRESULT_PRODUCTIONINFOR_INCOMPLETE:// ֧����ʱ�ص�
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayProductionInforIncomplete,arg1);
					break;
				/**
				 * ������:���ڽ����лص� ֧����������SDKû�лص����������Ϊ֧�����ڽ�����
				 * ��Ϸ�����̿������ȥ�ж��Ƿ���Ҫ�ȴ��������ȴ��������һ�ε�֧��
				 */
				case IAPWrapper.PAYRESULT_NOW_PAYING:
					UnityAppBridge.SendUnityMsg(UnityAppCode.PayNowPaying,arg1);
					break;
				case IAPWrapper.PAYRESULT_RECHARGE_SUCCESS:// ��ֵ�ɹ��ص�
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
	
	//SDK��¼
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
    
	//SDKע��
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
