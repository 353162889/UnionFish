package com.zhongju.buyu.app;

public class UnityAppCode {
	//用户
	public static final int InitSuccess = 0;/**< enum SDK初始化成功事件 */
	public static final int InitFail = 1;/**< enum  SDK初始化失败事件 */
	public static final int LoginSuccess = 2;/**< enum SDK登录成功时间*/
	public static final int LoginNetworkError = 3;/**< enum 登陆失败回调*/
	public static final int LoginNoNeed = 4;/**< enum 登陆失败回调*/
	public static final int LoginFail = 5;/**< enum 登陆失败回调 */
	public static final int LoginCancel = 6;/**< enum 登陆取消回调 */
	public static final int LogoutSuccess = 7;/**< enum 登出成功回调 */
	public static final int LogoutFail = 8;/**< enum 登出失败回调 */
	public static final int PlatformEnter = 9;/**< enum 平台中心进入回调 */
	public static final int PlatformBack = 10;/**< enum 平台中心退出回调 */
	public static final int PausePage = 11;/**< enum 暂停界面回调 */
	public static final int ExitPage = 12;/**< enum 退出游戏回调 */
	public static final int AntiAddictionQuery = 13;/**< enum 防沉迷查询回调 */
	public static final int RealNameRegister = 14;/**< enum 实名注册回调 */
	public static final int AccountSwitchSuccess = 15;/**< enum 切换账号成功回调 */
	public static final int AccountSwitchFail = 16;/**< enum 切换账号失败回调 */
	public static final int OpenShop = 17;/**< enum 应用汇  悬浮窗点击粮饷按钮回调 */
	public static final int AccountSwitchCancel = 18;/**< enum 切换账号取消 */
	public static final int GameExitPage = 19;/**< enum 退出游戏页 */

    //支付
	public static final int PaySuccess = 1000;/**< enum 支付成功 */
	public static final int PayFail = 1001;/**< enum 支付失败 */
	public static final int PayCancel = 1002;/**< enum 支付取消 */
	public static final int PayNetworkError = 1003;/**< enum 支付网络出现错误 */
	public static final int PayProductionInforIncomplete = 1004;/**< enum 支付信息提供不完全 */
	public static final int PayInitSuccess = 1005;/**< enum 支付初始化成功 */
	public static final int PayInitFail = 1006;/**< enum 支付初始化失败 */
	public static final int PayNowPaying = 1007;/**< enum 正在支付 */
	public static final int PayRechargeSuccess = 1008;/**< enum value is callback of  succeeding in recharging. */
}
