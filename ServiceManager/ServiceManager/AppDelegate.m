//
//  AppDelegate.m
//  BaseProject
//
//  Created by wangzhi on 15-1-12.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "CheckUpdate.h"
#import "YRSideViewController.h"
#import "InhouseAppCheckUpdate.h"

#import <AFNetworkActivityIndicatorManager.h>
#import "ConfigInfoManager.h"

#ifdef ENABLE_SHARE_SDK
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import "WeiboSDK.h"
#import <RennSDK/RennSDK.h>
#import "ShareSdkManager.h"
#endif

#import "BMapKit.h"
#import "UserInfoEntity.h"
#import "LoginViewController.h"

#import "MagicalRecordHelper.h"

#import "ConfigItemInfo.h"
#import "GeTuiPushUtil.h"

@interface AppDelegate ()<CheckUpdateDelegate, UIAlertViewDelegate,BMKGeneralDelegate>
{
    CheckUpdate *_checkUpdateMgr;
    BMKMapManager *_mapManager;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NetClientManager startMonitorNetworkReachability];

    [MagicalRecordHelper setup];

#ifdef ENABLE_FEATURE_PUSH //注册远程通知
    [[GeTuiPushUtil sharedInstance] gt_application:application didFinishLaunchingWithOptions:launchOptions];
#endif

#ifdef ENABLE_SHARE_SDK //ShareSdk
    ShareSdkManager *shareMgr = [ShareSdkManager sharedInstance];
    [shareMgr registerApp:kShareSdkAppKey];
    [shareMgr connectDefaultShareTypes];
#endif

    //检查更新
    [[InhouseAppCheckUpdate sharedInstance]checkAppVersion:NO afterCheckAction:nil];

    //添加首页
    [self launchFirstViewController];

    //开启AF网络指示器
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    //百度地图
    _mapManager = [[BMKMapManager alloc]init];
    [_mapManager start:kBaiduAppkey generalDelegate:self];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround]; //当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    [BMKMapView didForeGround]; //当应用恢复前台状态时调用，恢复地图的渲染和opengl相关的操作
    [[ConfigInfoManager sharedInstance]updateConfigInfosIfNeed];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecordHelper cleanup];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
#ifdef ENABLE_SHARE_SDK
    return [[ShareSdkManager sharedInstance]application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
#endif
    return NO;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
#ifdef ENABLE_SHARE_SDK
    return [[ShareSdkManager sharedInstance]application:application handleOpenURL:url];
#endif
    return NO;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
#ifdef ENABLE_FEATURE_PUSH
    NSString *deviceTokenStr = [[GeTuiPushUtil sharedInstance] gt_application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    [UserDefaults setPushDeviceToken:deviceTokenStr];
#endif
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{

#ifdef ENABLE_FEATURE_PUSH
    [[GeTuiPushUtil sharedInstance] gt_application:application didFailToRegisterForRemoteNotificationsWithError:error];
#endif

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

#ifdef ENABLE_FEATURE_PUSH
    [[GeTuiPushUtil sharedInstance] gt_application:application didReceiveRemoteNotification:userInfo];
#endif

}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
#ifdef ENABLE_FEATURE_PUSH
    [[GeTuiPushUtil sharedInstance] gt_application:application performFetchWithCompletionHandler:completionHandler];
#endif
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    DLog(@"收到了本地通知：%@", notification.alertBody);
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{

#ifdef ENABLE_FEATURE_PUSH
    [[GeTuiPushUtil sharedInstance] gt_application:application didRegisterUserNotificationSettings:notificationSettings];
#endif

}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{

#ifdef ENABLE_FEATURE_PUSH
#endif

}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
#ifdef ENABLE_FEATURE_PUSH
    [[GeTuiPushUtil sharedInstance] gt_application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
#endif

}

- (void)updatePushAlias:(NSString*)alias{
#ifdef ENABLE_FEATURE_PUSH
    [[GeTuiPushUtil sharedInstance]bindAlias:alias];
#endif
}

- (void)unbindAliasForPush{
#ifdef ENABLE_FEATURE_PUSH
    NSString *curAlias = [UserDefaults pushAlias];
    if (![Util isEmptyString:curAlias]) {
        [[GeTuiPushUtil sharedInstance]unbindAlias:curAlias];
    }
#endif
}

#pragma mark - 设置主页面

- (void)launchFirstViewController
{
    UserInfoEntity *user = [UserInfoEntity sharedInstance];
    if (user.isLogined) {
        [self startHomeViewController];
    }else {
        [self startLoginViewController];
    }
}

- (void)startHomeViewController
{
    self.homeViewController = [[HomeViewController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:self.homeViewController];

    self.window.rootViewController = homeNav;
    self.window.backgroundColor = kColorWhite;
    [self.window makeKeyAndVisible];
}

- (UIViewController*)topViewController{
    UIViewController *rootVc = self.window.rootViewController;
    if ([rootVc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *rootNavVc = (UINavigationController*)rootVc;
        return [rootNavVc topViewController];
    }else {
        return rootVc;
    }
}

- (void)startLoginViewController
{
    LoginViewController *loginVc  = [[LoginViewController alloc]init];
    self.window.rootViewController = loginVc;
    self.window.backgroundColor = kColorWhite;
    [self.window makeKeyAndVisible];
}

#pragma mark - 检查新版本

- (void)checkLatestVersion
{
    _checkUpdateMgr = [[CheckUpdate alloc] init];
    _checkUpdateMgr.delegate = self;
    [_checkUpdateMgr checkUpdateWithAppId:kAppIdInAppStore];
}

-(void)onDidCheckUpdateHasNewVerion:(CheckUpdate*)object
{
    NSString *promptMsg = @"检查到新版本，是否更新？";
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:promptMsg delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"更新", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex && [_checkUpdateMgr.trackViewUrl isNotEmpty]) {
        //更新
        NSURL *updateUrl = [NSURL URLWithString:_checkUpdateMgr.trackViewUrl];
        [[UIApplication sharedApplication]openURL:updateUrl];
    }else {
        //不更新
    }
}

@end
