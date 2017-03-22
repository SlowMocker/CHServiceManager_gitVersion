//
//  ViewController.m
//  BaseProject
//
//  Created by wangzhi on 15-1-12.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "TripleDES.h"
#import "RSAForiOS.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ViewController

- (HttpClientManager*)httpClient
{
    if (nil == _httpClient) {
        _httpClient = [HttpClientManager sharedInstance];
    }
    return _httpClient;
}

- (ConfigInfoManager*)configInfoMgr
{
    if (nil == _configInfoMgr) {
        _configInfoMgr = [ConfigInfoManager sharedInstance];
    }
    return _configInfoMgr;
}

- (UserInfoEntity*)user
{
    if (nil == _user) {
        _user = [UserInfoEntity sharedInstance];
    }
    return _user;
}

- (void)setDisableRightPanBack:(BOOL)disableRightPanBack{
    _disableRightPanBack = disableRightPanBack;
    UIGestureRecognizer *panGesture = self.navigationController.interactivePopGestureRecognizer;
    panGesture.enabled = !_disableRightPanBack;
    panGesture.delegate = _disableRightPanBack ? nil : self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.isSelfViewNil = NO;

    [self setNavBarBackgroundColor:kColorDefaultBlue];

    [self setBackGroundColor:kColorDefaultBackGround];

    //默认导航栏左按钮
    [self setDefaultNavBarLeftButton];

    [self setTitleColor:kColorWhite];

    //设置backBar为空
    [self setDefaultNavBarBackButton];
    
    [self registerNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [kAppDelegate.homeTabBarVc.tabBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.disableRightPanBack = NO;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;
        self.isSelfViewNil = YES;
    }
}

- (void)dealloc
{
    [self unregisterNotifications];
}

//默认导航栏左按钮
- (void)setDefaultNavBarLeftButton
{
    [self setNavBarLeftButton:ImageNamed(@"go_back_white") highlighted:ImageNamed(@"go_back_white") clicked:@selector(navBarLeftButtonClicked:)];
}

//默认行为是返回上一级页面
- (void)navBarLeftButtonClicked:(UIButton*)defaultLeftButton
{
    [self popViewController];
}

- (void)setDefaultNavBarBackButton
{
    self.navigationItem.backBarButtonItem = nil;
}

- (ViewController*)loginFirstIfNeed
{
    LoginViewController *loginVc = [[LoginViewController alloc]init];
    [self pushViewController:loginVc];
    return loginVc;
}

- (void)registerNotifications
{

}

- (void)unregisterNotifications
{
}

- (BOOL)alertUpdateMainConfigInfoIfNeed
{
    BOOL needAlert = !self.configInfoMgr.hasLoadedMainInfo;
    if (needAlert) {
        [Util showAlertView:nil message:@"请先更新主数据" okAction:^{
            //back to Settings view controller
//            kAppDelegate.homeTabBarVc.selectedIndex = kAppDelegate.homeTabBarVc.viewControllers.count - 1;
            [self popToRootViewController];
        }];
    }
    return needAlert;
}

- (void)exitCurrentUser
{
    [Util logoutLocalUser];
    [kAppDelegate unbindAliasForPush];
    [kAppDelegate startLoginViewController];
}

@end
