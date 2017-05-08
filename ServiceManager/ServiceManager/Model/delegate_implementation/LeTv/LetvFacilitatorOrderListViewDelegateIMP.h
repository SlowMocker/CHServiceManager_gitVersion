//
//  LetvFacilitatorOrderListViewDelegateIMP.h
//  ServiceManager
//
//  Created by will.wang on 16/5/16.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvOrderListViewDelegateIMP.h"

@interface LetvFacilitatorOrderListViewDelegateIMP : LetvOrderListViewDelegateIMP

//requestCallBackBlock, param 3, LetvOrderContentModel array
- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock;

@end
