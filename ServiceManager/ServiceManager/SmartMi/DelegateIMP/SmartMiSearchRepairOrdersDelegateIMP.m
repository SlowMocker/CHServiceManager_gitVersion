//
//  SmartMiSearchRepairOrdersDelegateIMP.m
//  ServiceManager
//
//  Created by Wu on 17/4/15.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "SmartMiSearchRepairOrdersDelegateIMP.h"

@implementation SmartMiSearchRepairOrdersDelegateIMP
- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock
{
    requestCallBackBlock(self.error, self.responseData, [MiscHelper smartMi_filterOrders:self.allSearchedOrders byStatus:self.orderStatus]);
}
@end
