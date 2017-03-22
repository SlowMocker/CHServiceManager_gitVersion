//
//  TecSupportOrderListViewDelegateIMP.h
//  ServiceManager
//
//  Created by will.wang on 16/7/4.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "WZTableViewDelegateIMP.h"
#import "OrderTableViewCell.h"

/**
 *  服务商和维修人员使用的技术支持工单列表，
 *  技术支持人员使用的列表在另外的地方
 */

@interface TecSupportOrderListViewDelegateIMP : WZTableViewDelegateIMP<WZTableViewDelegate>

@property(nonatomic, assign,readonly)NSInteger orderStatus;

- (void)do_OrderOperationTypeConfirm:(OrderContent*)order;

- (void)setOrderContentModel:(OrderContent *)order toCell:(OrderTableViewCell *)cell;

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock;

@end
