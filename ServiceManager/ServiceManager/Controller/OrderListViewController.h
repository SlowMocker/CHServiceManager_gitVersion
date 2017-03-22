//
//  OrderListViewController.h
//  ServiceManager
//
//  Created by will.wang on 16/5/4.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "SearchOrderViewController.h"

/**
 *  工单列表
 */

@interface OrderListViewController : ViewController

@property(nonatomic, strong)OrderFilterConditionItems *filterCondition;

- (BOOL)checkIfShowFilterBtn;

- (void)gotoOrderSearchViewController;

@end
