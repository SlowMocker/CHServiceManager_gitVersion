//
//  GeTuiPushUtil.h
//  ServiceManager
//
//  Created by will.wang on 3/8/16.
//  Copyright © 2016 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeTuiSdk.h"

@interface GeTuiPushUtil : NSObject <GeTuiSdkDelegate>

+ (instancetype)sharedInstance;

- (BOOL)gt_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (NSString*)gt_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (void)gt_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

- (void)gt_application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

- (void)gt_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

- (void)gt_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)gt_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;

- (void)unbindAlias:(NSString*)alias;

- (void)bindAlias:(NSString*)alias;

@end
