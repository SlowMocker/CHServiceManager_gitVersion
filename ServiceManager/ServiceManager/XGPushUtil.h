//
//  AppDelegate+Extension.h
//  ServiceManager
//
//  Created by will.wang on 1/20/16.
//  Copyright © 2016 wangzhi. All rights reserved.
//

#import "XGPush.h"
#import "XGSetting.h"

@interface XGPushUtil : NSObject

+ (BOOL)XGPush_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+ (void)XGPush_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

+ (void)XGPush_application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler;
    
+ (void)XGPush_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

+ (void)XGPush_application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err;
    
+ (void)XGPush_application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo;

+ (void)XGPush_unregisterXGPush;

@end
