//
//  HistoryOrderListViewController.h
//  ServiceManager
//
//  Created by will.wang on 2016/12/26.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "WZTableViewController.h"
#import "OrderListViewDelegateIMP.h"

@interface HistoryOrderListViewController : WZTableViewController
- (OrderListViewDelegateIMP*)getContentTableViewDelegate;

@property(nonatomic, strong)OrderFilterConditionItems *filterCondition;
@property(nonatomic, assign)kServiceBrandGroup serviceBrandGroup;

//recommend init method
- (instancetype)init;
@end
