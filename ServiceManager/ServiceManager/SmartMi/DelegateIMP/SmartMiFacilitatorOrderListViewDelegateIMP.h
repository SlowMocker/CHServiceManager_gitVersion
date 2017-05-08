//
//  SmartMiFacilitatorOrderListViewDelegateIMP.h
//  ServiceManager
//
//  Created by Wu on 17/3/24.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "FacilitatorOrderListViewDelegateIMP.h"
#import "SmartMiOrderListViewDelegateIMP.h"

@interface SmartMiFacilitatorOrderListViewDelegateIMP : SmartMiOrderListViewDelegateIMP

//requestCallBackBlock, param 3, LetvOrderContentModel array
- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock;

@end
