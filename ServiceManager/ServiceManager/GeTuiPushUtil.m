//
//  GeTuiPushUtil.m
//  ServiceManager
//
//  Created by will.wang on 3/8/16.
//  Copyright © 2016 wangzhi. All rights reserved.
//

#import "GeTuiPushUtil.h"
#import "AppDelegate.h"
#import "WeixinCommentQrCodeViewController.h"
#import "ExtendReceiveAccountQrCodeController.h"


static NSString *PushMessageTypeNormalText = nil; //常规文本通知
static NSString *PushMessageTypeWeixinComment = @"0"; //用户微信点评通知
static NSString *PushMessageTypeReceivedAccount = @"9"; //延保收款

@interface GeTuiPushUtil()
@property(nonatomic, copy)NSString *clientId;
@end

@implementation GeTuiPushUtil

+ (instancetype)sharedInstance
{
    static GeTuiPushUtil *sGeTuiPushUtil = nil;
    static dispatch_once_t sOnceToken;
    dispatch_once(&sOnceToken, ^{
        sGeTuiPushUtil = [[GeTuiPushUtil alloc]init];
    });
    return sGeTuiPushUtil;
}

//处理线上透传消息
- (void)handleOnlineTransparentNotification:(PushMessageContent*)message
{
    UIViewController *topVc = [((AppDelegate*)[[UIApplication sharedApplication]delegate]) topViewController];

    if (message.type == nil) {
        [Util showAlertView:@"收到通知" message:message.data.description];
    }else if ([message.type isEqualToString:PushMessageTypeWeixinComment]){
        [self postNotification:NotificationNameWeixinComment object:self userInfo:(NSDictionary*)message.data];
    }else if ([message.type isEqualToString:PushMessageTypeReceivedAccount]){
        if ([topVc isKindOfClass:[ExtendReceiveAccountQrCodeController class]]) {
            [self postNotification:NotificationNameReceivedAccount object:self userInfo:(NSDictionary*)message.data];
        }else {
            [Util showAlertView:@"延保收款成功通知" message:message.message];
        }
    }
}

#pragma mark - 用户通知(推送) _自定义方法

/** 自定义：APP被“推送”启动时处理推送消息处理（APP 未启动--》启动）*/
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions {
    if (!launchOptions)
        return;
    
    /*
     通过“远程推送”启动APP
     UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
     */
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        DLog(@"\n>>>[Launching RemoteNotification]:%@", userInfo);
    }
}

/** 注册用户通知 */
- (void)registerUserNotification {
    
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    
    // 判读系统版本是否是“iOS 8.0”以上
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        // 注册远程通知 -根据远程通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

- (BOOL)gt_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    // Override point for customization after application launch.
    
    // 通过 appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGetuiPushAppId appKey:kGetuiPushAppKey appSecret:kGetuiPushAppSecret delegate:self];

    // 注册APNS
    [self registerUserNotification];

    // 处理远程通知启动APP
    [self receiveNotificationByLaunchingOptions:launchOptions];
    
    return YES;
}

#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用

/** 已登记用户通知 */
- (void)gt_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (NSString*)gt_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [GeTuiSdk registerDeviceToken:myToken];
    
    DLog(@"\n>>>[DeviceToken Success]:%@\n\n", myToken);
    
    return myToken;
}

/** 远程通知注册失败委托 */
- (void)gt_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [GeTuiSdk registerDeviceToken:@""]; /// 如果 APNS 注册失败,通 知个推服务器
    DLog(@"\n>>>[DeviceToken Error]:%@\n\n",error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)gt_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0; // 标签
    NSLog(@"--------------[Receive RemoteNotification]: %@",userInfo);
    DLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
}

/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)gt_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    // 处理APN
    DLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)gt_application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复 SDK 运行 [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)bindAlias:(NSString*)alias{
    // 绑定别名
    [GeTuiSdk bindAlias:alias];
    [UserDefaults setPushAlias:alias];
}

- (void)unbindAlias:(NSString*)alias{
    // 取消绑定别名
    [GeTuiSdk unbindAlias:alias];
    [UserDefaults setPushAlias:@""];
}

#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    
    self.clientId = clientId;
    
    UserInfoEntity *user = [UserInfoEntity sharedInstance];
    if (user.isLogined && nil != user.userId) {
        [self bindAlias:user.userId];
    }

    // [4-EXT-1]: 个推SDK已注册，返回clientId
    DLog(@"\n>>>[GeTuiSdk RegisterClientID]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    DLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

///** SDK收到透传消息回调 */ // 需要替换接口  这个接口已经废弃
- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId andOffLine:(BOOL)offLine fromApplication:(NSString *)appId {
    
    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
        PushMessageContent *message = [[PushMessageContent alloc]init];
        NSDictionary *messageDic = [NSDictionary dictionaryWithJsonString:payloadMsg];
        if (messageDic) {
            message.type = [messageDic objForKey:@"type"];
            message.data = [messageDic objForKey:@"data"];
            message.message = [messageDic objForKey:@"message"];
        }else {
            message.type =  PushMessageTypeNormalText;
            message.data = payloadMsg;
        }
        if (!offLine) { //线上透传消息
            [self handleOnlineTransparentNotification:message];
        }
    }
    [GeTuiSdk sendFeedbackMessage:90001 taskId:taskId msgId:aMsgId];
}
// 替换上面的接口(目前还是调用的上面的接口)
//- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
//    NSData *payload = payloadData;
//    NSString *payloadMsg = nil;
//    if (payload) {
//        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
//        PushMessageContent *message = [[PushMessageContent alloc]init];
//        NSDictionary *messageDic = [NSDictionary dictionaryWithJsonString:payloadMsg];
//        if (messageDic) {
//            message.type = [messageDic objForKey:@"type"];
//            message.data = [messageDic objForKey:@"data"];
//            message.message = [messageDic objForKey:@"message"];
//        }else {
//            message.type =  PushMessageTypeNormalText;
//            message.data = payloadMsg;
//        }
//        if (!offLine) { //线上透传消息
//            [self handleOnlineTransparentNotification:message];
//        }
//    }
//    [GeTuiSdk sendFeedbackMessage:90001 taskId:taskId msgId:msgId];
//}




/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    DLog(@"\n>>>[GexinSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // [EXT]:通知SDK运行状态
    DLog(@"\n>>>[GexinSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        DLog(@"\n>>>[GexinSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    DLog(@"\n>>>[GexinSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}

@end
