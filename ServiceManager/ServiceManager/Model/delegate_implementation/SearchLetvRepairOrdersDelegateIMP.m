//
//  SearchLetvRepairOrdersDelegateIMP.m
//  ServiceManager
//
//  Created by will.wang on 16/7/1.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "SearchLetvRepairOrdersDelegateIMP.h"

@implementation SearchLetvRepairOrdersDelegateIMP

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock
{
//    requestCallBackBlock(self.error, self.responseData, self.allSearchedOrders);

    requestCallBackBlock(self.error, self.responseData, [MiscHelper letv_filterOrders:self.allSearchedOrders byStatus:self.orderStatus]);
}

@end
