//
//  TabBarItemViewController.m
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-5-21.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "TabBarItemViewController.h"
#import "AppDelegate.h"

@implementation TabBarItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = nil;
}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [kAppDelegate.homeTabBarVc.tabBar setHidden:NO];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//- (void)pushViewController:(UIViewController *)vc
//{
//    if (nil != vc) {
//        [kAppDelegate.homeTabBarVc.tabBar setHidden:YES];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}

@end
