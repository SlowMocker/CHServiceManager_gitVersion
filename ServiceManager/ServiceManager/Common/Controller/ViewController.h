//
//  ViewController.h
//  BaseProject
//
//  Created by wangzhi on 15-1-12.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpClientManager.h"
#import "HttpClientManager+Letv.h"
#import "UserInfoEntity.h"
//#import "AppDelegate.h"
#import "ConfigInfoManager.h"

/**
 * Base ViewController, 通常情况下每一个常规VC最好都继承它
 */

@interface ViewController : UIViewController

@property(nonatomic, assign)BOOL needToRefresh;

//self.view 是否已为空了，当收到内存警告时，将置空
@property(nonatomic, assign)BOOL isSelfViewNil;

//HTTP 网络管理器
@property(nonatomic, strong)HttpClientManager *httpClient;
//用户信息
@property(nonatomic, strong)UserInfoEntity *user;

//配置信息
@property(nonatomic, strong)ConfigInfoManager *configInfoMgr;

//右滑返回,默认为NO，需在viewDidAppear或viewWillDisAppear中设置
@property(nonatomic, assign)BOOL disableRightPanBack;;

//默认行为为返回到上一级，子类可以重写
- (void)navBarLeftButtonClicked:(UIButton*)defaultLeftButton;

//return LoginViewController object
- (ViewController*)loginFirstIfNeed;

//子类需注册通知或观察时，重写此方法
- (void)registerNotifications;

//子类需取消注册通知或观察时，重写此方法
- (void)unregisterNotifications;

//默认返回
- (void)setDefaultNavBarLeftButton;

//如果没有数据，弹框提示更新,并返回YES， 有主数据时，返回NO
- (BOOL)alertUpdateMainConfigInfoIfNeed;

//Exit current user
- (void)exitCurrentUser;
@end

