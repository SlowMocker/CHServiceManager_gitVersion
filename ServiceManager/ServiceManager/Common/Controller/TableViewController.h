//
//  TableViewController.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-6.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoEntity.h"
#import "AppDelegate.h"

@interface TableViewController : UITableViewController

//self.view 是否已为空了，当收到内存警告时，将置空
@property(nonatomic, assign)BOOL isSelfViewNil;

//HTTP 网络管理器
@property(nonatomic, strong)HttpClientManager *httpClient;

//用户信息
@property(nonatomic, strong)UserInfoEntity *user;

//顶部空间
@property(nonatomic, assign)CGFloat tableViewTopSpace;

- (void)loginFirstIfNeed;

//子类需注册通知或观察时，重写此方法
- (void)registerNotifications;

//子类需取消注册通知或观察时，重写此方法
- (void)unregisterNotifications;
@end
