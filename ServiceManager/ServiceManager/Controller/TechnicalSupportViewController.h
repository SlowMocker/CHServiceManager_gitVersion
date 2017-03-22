//
//  TechnicalSupportViewController.h
//  ServiceManager
//
//  Created by will.wang on 16/5/4.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "WZTableViewController.h"
#import "OrderListViewDelegateIMP.h"
#import "TecSupportOrderListViewDelegateIMP.h"

/**
 *  技术支持（技术点评）
 */

@interface TechnicalSupportViewController : WZTableViewController

- (TecSupportOrderListViewDelegateIMP*)getOrderListViewDelegateIMP;

@end
