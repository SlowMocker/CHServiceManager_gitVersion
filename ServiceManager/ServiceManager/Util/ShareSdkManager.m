//
//  ShareSdkManager.m
//  BaseProject
//
//  Created by wangzhi on 15-2-3.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ShareSdkManager.h"

@implementation ShareContent

@end

@implementation ShareImageData
- (void)load:(void(^)())completeHandler
faultHandler:(void(^)(NSError *error))faultHandler
{
}
- (void)loadCustomImages:(void (^)())completeHandler
            faultHandler:(void (^)(NSError *))faultHandler
{
}
@end

@interface ShareSdkManager ()<ISSShareViewDelegate>
@end

@implementation ShareSdkManager

+ (instancetype)sharedInstance
{
    static ShareSdkManager *sShareSdkManager = nil;
    static dispatch_once_t sOnceToken;
    dispatch_once(&sOnceToken, ^{
        sShareSdkManager = [[ShareSdkManager alloc]init];
    });

    return sShareSdkManager;
}

- (void)registerApp:(NSString*)appKey
{
    [ShareSDK registerApp:appKey];
}

// 新浪微博,QQ,QQ空间, 微信
- (void)connectDefaultShareTypes
{
    //新浪微博
    //没有审核通过的应用需要在开发中应用中添加测试账号
    //添加新浪微博开放平台 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"2687190541"
                appSecret:@"a2db927e409d79f4b14caf6e74c0cd50"
                             redirectUri:@"http://www.wangpuduo.cn/"];
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"2687190541"
                    appSecret:@"a2db927e409d79f4b14caf6e74c0cd50"
                              redirectUri:@"http://www.wangpuduo.cn/"
                              weiboSDKCls:[WeiboSDK class]];

    //添加微信 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatSessionWithAppId:@"wx2af68f6258118ac3"
                    appSecret:@"1ef9b8e8ee98b4c46e20cb1fd18854b3"
                           wechatCls:[WXApi class]];
    [ShareSDK connectWeChatTimelineWithAppId:@"wx2af68f6258118ac3"
                                  appSecret:@"1ef9b8e8ee98b4c46e20cb1fd18854b3"
                                  wechatCls:[WXApi class]];
    //添加QQ
    [ShareSDK connectQQWithAppId:@"1104728816"
                        qqApiCls:[QQApi class]];
}

- (void)startShare:(ShareContent *)shareData currentViewController:(UIViewController*)currentViewController
{
    NSString *tempStr;
    id<ISSContainer> container = [ShareSDK container];

    id<ISSContent> publishContent = [ShareSDK content:shareData.content
                                       defaultContent:@"找商铺、写字楼，尽在成都【旺铺多】"
                                                image:shareData.image
                                                title:shareData.title
                                                  url:shareData.url
                                    description:shareData.content
                                            mediaType:shareData.mediaType];

    [publishContent addQQUnitWithType:@(SSPublishContentMediaTypeNews) content:shareData.content title:shareData.title url:shareData.url image:shareData.image];

    tempStr = [NSString stringWithFormat:@"%@,详情点击%@",shareData.title, shareData.url];
    [publishContent addSinaWeiboUnitWithContent:tempStr image:nil];

    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:self];

    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {

                                if (state == SSPublishContentStateSuccess)
                                {
                                    if (type == ShareTypeSinaWeibo) {
                                        [Util showToast:@"分享成功"];
                                    }else if (type == ShareTypeWeixiTimeline){
                                        [Util showToast:@"分享成功"];
                                    }
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAIED", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

@end
