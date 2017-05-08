//
//  LoginViewController.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-9.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "UserInfoEntity.h"

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>
- (void)loginViewControllerLoginSuccess:(LoginViewController*)loginVc;
@end

@interface LoginViewController : ViewController
@property(nonatomic, copy)NSString *defaultUserName;    //进入后显示
@property(nonatomic, assign)id<LoginViewControllerDelegate>delegate;
@end
