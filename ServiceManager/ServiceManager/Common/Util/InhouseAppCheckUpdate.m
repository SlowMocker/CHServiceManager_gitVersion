//
//  InhouseAppCheckUpdate.m
//  ServiceManager
//
//  Created by will.wang on 10/8/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "InhouseAppCheckUpdate.h"
#import <UIAlertView+Blocks.h>
#import "AppUpdateAlertView.h"

@implementation InhouseAppCheckUpdate

+ (instancetype)sharedInstance
{
    static InhouseAppCheckUpdate *sCheckUpdate = nil;
    static dispatch_once_t sOnceToken;
    dispatch_once(&sOnceToken, ^{
        sCheckUpdate = [[InhouseAppCheckUpdate alloc]init];
    });
    return sCheckUpdate;
}

- (void)getAppVerisonInfoWithResponse:(AppVersionInfoCallBack)response
{
    [[HttpClientManager sharedInstance]getAppVersionInfo:^(NSError *error, HttpResponseData *responseData) {
        AppVersionInfo *versionInfo;
        if (!error && responseData.resultCode == kHttpReturnCodeSuccess) {
            versionInfo = [[AppVersionInfo alloc]initWithDictionary:responseData.resultData];
        }
        response(versionInfo);
    }];
}

- (void)downloadApp:(NSString*)downloadUrl
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:downloadUrl]];
}

- (void)checkAppVersion:(BOOL)bShowInfo afterCheckAction:(VoidBlock)action
{
    if (bShowInfo) {
        [Util showWaitingDialog];
    }
    [self getAppVerisonInfoWithResponse:^(AppVersionInfo *info) {
        if (bShowInfo) {
            [Util dismissWaitingDialog];
        }
        if (info) {
            info.downloadUrl = [NSString stringWithFormat:@"https://oapi.chiq-cloud.com:18080/v1/op/appPacket/%@", kAppKeyInChangHongPublishPlatform];
            NSInteger curVersion = [[NSString appBundleVersion]integerValue];
            NSInteger serverVersion = [info.number integerValue];
    
            if (curVersion < serverVersion) {
                BOOL bMustUpgrade = ![info.upgradeType isEqualToString:@"NORMAL"];
                
                AppUpdateAlertView *alertView = [[AppUpdateAlertView alloc]init];
                alertView.titleLabel.text = @"发现新版本，是否更新？";
                alertView.textLabel.text = info.Description;
                [alertView.okButton setTitle:@"更新" forState:UIControlStateNormal];
                alertView.okButtonClickedBlock = ^(id sender){
                    [self downloadApp:info.downloadUrl];
                };
                
                [alertView.cancelButton setTitle:bMustUpgrade ? @"退出":@"取消" forState:UIControlStateNormal];
                alertView.cancelButtonClickedBlock = ^(id sender){
                    if (bMustUpgrade) {
                        exit(0);
                    }else { //取消
                        if (action) {
                            action();
                        }
                    }
                };
                [alertView show];
            }else {
                if (bShowInfo) {
                    [Util showToast:@"没有新版本"];
                }
                if (action) { //没新版本
                    action();
                }
            }
        }else {
            if (bShowInfo) {
                [Util showToast:@"检查失败"];
            }
            if (action) { //检查失败
                action();
            }
        }
    }];
}

@end
