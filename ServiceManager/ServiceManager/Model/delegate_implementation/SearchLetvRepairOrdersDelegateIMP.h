//
//  SearchLetvRepairOrdersDelegateIMP.h
//  ServiceManager
//
//  Created by will.wang on 16/7/1.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvRepairOrderListViewDelegateIMP.h"
#import "SearchOrderViewController.h"

@interface SearchLetvRepairOrdersDelegateIMP : LetvRepairOrderListViewDelegateIMP
@property(nonatomic, weak)SearchOrderViewController *searchVc;

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock;

//searched results
@property (nonatomic, strong)NSError *error;
@property (nonatomic, strong)HttpResponseData *responseData;
@property(nonatomic, strong)NSArray *allSearchedOrders;
@end
