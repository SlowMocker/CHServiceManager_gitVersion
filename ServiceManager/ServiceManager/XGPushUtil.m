//
//  AppDelegate+Extension.m
//  ServiceManager
//
//  Created by will.wang on 1/20/16.
//  Copyright © 2016 wangzhi. All rights reserved.
//

#import "XGPushUtil.h"

#define _IPHONE80_ 80000

@implementation XGPushUtil

+ (void)registerPushForIOS8{

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;

    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";

    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;

    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];

    inviteCategory.identifier = @"INVITE_CATEGORY";

    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];

    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif

}

+ (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

+ (BOOL)XGPush_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //online
//    [XGPush startApp:2200178109 appKey:@"I3BFQB3449ZT"];

    [XGPush startApp:2200178104 appKey:@"IKI2J94QP69M"];

    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [[self class] registerPush];
            }
            else{
                [[self class] registerPushForIOS8];
            }
#else
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];

    //推送反馈(app不在前台运行时，点击推送激活时)
    void (^successBlock)(void) = ^(void){
        DLog(@"[XGPush]handleLaunching's successBlock");
    };
    void (^errorBlock)(void) = ^(void){
        DLog(@"[XGPush]handleLaunching's errorBlock");
    };

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];

    return YES;
}

+ (void)XGPush_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
#endif
}

//按钮点击事件回调
+ (void)XGPush_application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        DLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    completionHandler();
#endif

}

+ (void)XGPush_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    void (^successBlock)(void) = ^(void){
        DLog(@"[XGPush]register device success");
    };

    void (^errorBlock)(void) = ^(void){
        DLog(@"[XGPush]register device error");
    };

    // 设置账号
    	[XGPush setAccount:[UserInfoEntity sharedInstance].userId];

    //注册设备
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];

    DLog(@"[XGPush] deviceToken is %@", deviceTokenStr);
}

+ (void)XGPush_application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    DLog(@"[XGPush] register notification error:%@",err);
}

+ (void)XGPush_application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    if (application.applicationState == UIApplicationStateActive) {
        NSString *message = [[userInfo objForKey:@"aps"] objForKey:@"alert"];
        if (![Util isEmptyString:message]) {
            [Util showAlertView:@"收到通知" message:message];
        }
    }
    [XGPush handleReceiveNotification:userInfo];
}

+ (void)XGPush_unregisterXGPush
{
    [XGPush unRegisterDevice];
}

@end
