//
//  AppDelegate.h
//  BaseProject
//
//  Created by wangzhi on 15-1-12.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRSideViewController.h"
#import "HomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *_apnsCertName;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic, readonly) UIViewController *topViewController;

@property (strong, nonatomic) YRSideViewController *sideViewController;

//首页TAB VC
@property (strong, nonatomic)HomeViewController *homeViewController;


- (void)startHomeViewController;

- (void)startLoginViewController;

- (void)updatePushAlias:(NSString*)alias;

- (void)unbindAliasForPush;

@end

