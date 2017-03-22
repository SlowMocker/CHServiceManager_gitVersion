//
//  InhouseAppCheckUpdate.h
//  ServiceManager
//
//  Created by will.wang on 10/8/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kInhouseAppKey @"edb2f0a8e0744acbae4af53390232d41"

typedef void(^AppVersionInfoCallBack)(AppVersionInfo* info);

@interface InhouseAppCheckUpdate : NSObject

+ (instancetype)sharedInstance;

//get info
- (void)getAppVerisonInfoWithResponse:(AppVersionInfoCallBack)response;

//download
- (void)downloadApp:(NSString*)downloadUrl;

/*
 * 检查更新，并提示用户是否更新，如用户取消更新、无更新、更新失败时则执行action;
 * bShowInfo 为YES是，在检查时会显示等待框，TOAST等用户提醒。
 */
- (void)checkAppVersion:(BOOL)bShowInfo afterCheckAction:(VoidBlock)action;
@end
