//
//  SearchTelSupportOrdersDelegateIMP.h
//  ServiceManager
//
//  Created by will.wang on 16/7/1.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "TelSupportOrderListViewDelegateIMP.h"
#import "SearchOrderViewController.h"

@interface SearchTelSupportOrdersDelegateIMP : TelSupportOrderListViewDelegateIMP
@property(nonatomic, weak)SearchOrderViewController *searchVc;

//- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock;
@end
