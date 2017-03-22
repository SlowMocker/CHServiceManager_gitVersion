//
//  WZCheckListViewController.h
//  ServiceManager
//
//  Created by will.wang on 15/8/31.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "WZTableView.h"

@class WZCheckListViewController;

@protocol WZCheckListViewControllerDelegate <NSObject>
- (void)checkListViewController:(WZCheckListViewController*)viewController didCheck:(CheckItemModel*)checkedItem;
@end

@interface WZCheckListViewController : ViewController
@property(nonatomic, strong)id userInfo;
@property(nonatomic, weak)id<WZCheckListViewControllerDelegate>delegate;
@property(nonatomic, strong)NSArray *checkItemArray; //item:CheckItemModel
@end
