//
//  SmartMiSearchFacilitatorOrdersDelegateIMP.h
//  ServiceManager
//
//  Created by Wu on 17/4/15.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "SmartMiFacilitatorOrderListViewDelegateIMP.h"
#import "SearchOrderViewController.h"

@interface SmartMiSearchFacilitatorOrdersDelegateIMP : SmartMiFacilitatorOrderListViewDelegateIMP
@property(nonatomic, weak) SearchOrderViewController *searchVc;

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock;

//searched results
@property (nonatomic, strong)NSError *error;
@property (nonatomic, strong)HttpResponseData *responseData;
@property(nonatomic, strong)NSArray *allSearchedOrders;
@end
