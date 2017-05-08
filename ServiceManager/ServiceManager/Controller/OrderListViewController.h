//
//  OrderListViewController.h
//  ServiceManager
//
//  Created by will.wang on 16/5/4.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "SearchOrderViewController.h"


@interface OrderListViewController : ViewController

@property(nonatomic, strong)OrderFilterConditionItems *filterCondition;

/**
 *  是否展示导航栏上的过滤筛选按钮
 */
- (BOOL) checkIfShowFilterBtn;
/**
 *  跳转订单查询页面
 */
- (void) gotoOrderSearchViewController;

- (BOOL) isZM;


@end
