//
//  CheckUpdate.h
//  BaseProject
//
//  Created by wangzhi on 15-1-22.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CheckUpdateDelegate;

@interface CheckUpdate : NSObject
- (void)checkUpdateWithAppId:(NSString*)appId;

@property(nonatomic, assign)id<CheckUpdateDelegate>delegate;

//当前AppStore上的版本
@property(nonatomic, assign, readonly)double versionInAppStore;

//当前正使用的APP的版本
@property(nonatomic, assign, readonly)double versionOfCurrent;

//APP的下载地址
@property(nonatomic, copy, readonly)NSString *trackViewUrl;
@end

@protocol CheckUpdateDelegate <NSObject>
@optional

//开始检查
-(void)onStartCheckUpdate:(CheckUpdate*)object;

//检查到有新版本
-(void)onDidCheckUpdateHasNewVerion:(CheckUpdate*)object;

//检查到没有新版本
-(void)onDidCheckUpdateNoNewVerion:(CheckUpdate*)object;

//检查失败
-(void)onDidCheckUpdateHasError:(CheckUpdate*)object error:(NSError*)error;
@end
