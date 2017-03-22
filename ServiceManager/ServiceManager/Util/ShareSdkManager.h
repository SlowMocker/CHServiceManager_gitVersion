//
//  ShareSdkManager.h
//  BaseProject
//
//  Created by wangzhi on 15-2-3.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import "WeiboSDK.h"
#import <RennSDK/RennSDK.h>

@interface ShareContent : NSObject
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *content;
@property(nonatomic, strong)id<ISSCAttachment> image;
@property(nonatomic, copy)NSString *url;
@property(nonatomic, assign)SSPublishContentMediaType mediaType;
@end

@interface ShareImageData : NSObject <ISSCAttachment>
@property(nonatomic, copy)NSString *url;
@property(nonatomic, copy)NSString *path;
@property(nonatomic, copy)NSString *data;
@property(nonatomic, copy)NSString *fileName;
@property(nonatomic, copy)NSString *mimeType;
@property(nonatomic, assign)BOOL isRemoteFile;
@end

@interface ShareSdkManager : NSObject
+ (instancetype)sharedInstance;
- (void)registerApp:(NSString*)appKey;
- (void)connectDefaultShareTypes;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url;
@end
