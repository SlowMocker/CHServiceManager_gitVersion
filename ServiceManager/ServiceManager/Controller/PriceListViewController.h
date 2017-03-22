//
//  PriceListViewController.h
//  ServiceManager
//
//  Created by will.wang on 16/3/31.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "WZTableViewDelegateIMP.h"

/**
 * 费用清单
 */

@interface PriceListViewController : ViewController
@property(nonatomic, assign)kPriceManageType feeManageType;

@property(nonatomic, copy)NSString *orderKeyId;
@property(nonatomic, copy)NSString *orderObjectId;
@property(nonatomic, copy)NSString *brandCode;
@property(nonatomic, copy)NSString *categoryCode;

//bShow: YES for show, No for hide
- (void)showSyncButton:(BOOL)bShow;

- (void)addButtonClicked:(UIButton*)sender;

- (WZTableViewDelegateIMP*)getFeeListViewDelegateIMP;
@end
