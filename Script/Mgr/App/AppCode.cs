using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public enum AppCode
{
    //用户
    InitSuccess = 0,/**< enum SDK初始化成功事件 */
    InitFail = 1,/**< enum  SDK初始化失败事件 */
    LoginSuccess = 2,/**< enum SDK登录成功时间*/
    LoginNetworkError = 3,/**< enum 登陆失败回调*/
    LoginNoNeed = 4,/**< enum 登陆失败回调*/
    LoginFail = 5,/**< enum 登陆失败回调 */
    LoginCancel = 6,/**< enum 登陆取消回调 */
    LogoutSuccess = 7,/**< enum 登出成功回调 */
    LogoutFail = 8,/**< enum 登出失败回调 */
    PlatformEnter = 9,/**< enum 平台中心进入回调 */
    PlatformBack = 10,/**< enum 平台中心退出回调 */
    PausePage = 11,/**< enum 暂停界面回调 */
    ExitPage = 12,/**< enum 退出游戏回调 */
    AntiAddictionQuery = 13,/**< enum 防沉迷查询回调 */
    RealNameRegister = 14,/**< enum 实名注册回调 */
    AccountSwitchSuccess = 15,/**< enum 切换账号成功回调 */
    AccountSwitchFail = 16,/**< enum 切换账号失败回调 */
    OpenShop = 17,/**< enum 应用汇  悬浮窗点击粮饷按钮回调 */
    AccountSwitchCancel = 18,/**< enum 切换账号取消 */
    GameExitPage = 19,/**< enum 退出游戏页 */

    //支付
    PaySuccess = 1000,/**< enum 支付成功 */
    PayFail = 1001,/**< enum 支付失败 */
    PayCancel = 1002,/**< enum 支付取消 */
    PayNetworkError = 1003,/**< enum 支付网络出现错误 */
    PayProductionInforIncomplete = 1004,/**< enum 支付信息提供不完全 */
    PayInitSuccess = 1005,/**< enum 支付初始化成功 */
    PayInitFail = 1006,/**< enum 支付初始化失败 */
    PayNowPaying = 1007,/**< enum 正在支付 */
    PayRechargeSuccess = 1008,/**< enum value is callback of  succeeding in recharging. */
}
