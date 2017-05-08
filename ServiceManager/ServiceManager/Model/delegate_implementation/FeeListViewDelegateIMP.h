//
//  FeeListViewDelegateIMP.h
//  ServiceManager
//
//  Created by will.wang on 16/3/31.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "WZTableViewDelegateIMP.h"
#import "PriceListViewController.h"
#import "SellFeeListCell.h"

@interface FeeListViewDelegateIMP : WZTableViewDelegateIMP<WZTableViewDelegate>
@property(nonatomic, weak)PriceListViewController *priceListViewController;

//读取费用列表
//requestCallBackBlock param 3 type must be SellFeeListInfos array
-(void)queryExpenseListWithResponse:(RequestCallBackBlockV2)requestCallBackBlock;

//删除, requestCallBackBlock param 3 为已经删除的数据项
- (void)deleteFeeItemInfo:(SellFeeListCell*)sellCell response:(RequestCallBackBlockV2)requestCallBackBlock;

//进入编辑页编辑费用项
- (void)editFeeItem:(kSellFeeListHandleType)handleType atCell:(SellFeeListCell*)cell;

//检查所有的费用项是否已同步
- (BOOL)checkIsAllSyncToCRM;

//计算费用总价
- (CGFloat)calcTotalPrice;

@end