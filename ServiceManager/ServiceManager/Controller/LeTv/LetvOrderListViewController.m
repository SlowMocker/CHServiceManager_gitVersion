//
//  LetvOrderListViewController.m
//  ServiceManager
//
//  Created by mac on 16/5/16.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "LetvOrderListViewController.h"

#import "LetvFacilitatorOrderListViewDelegateIMP.h"
#import "LetvRepairOrderListViewDelegateIMP.h"
#import "LetvTelSupportOrderListViewDelegateIMP.h"

@interface LetvOrderListViewController ()
@end

@implementation LetvOrderListViewController

- (void)navBarLeftButtonClicked:(UIButton *)defaultLeftButton
{
    [super navBarLeftButtonClicked:defaultLeftButton];
}

- (BOOL)checkIfShowFilterBtn
{
    return NO;
}

- (void)gotoOrderSearchViewController
{
    SearchOrderViewController *searchVc = [[SearchOrderViewController alloc]init];
    searchVc.title = @"搜索工单(乐视)";
    searchVc.serviceBrandGroup = kServiceBrandGroupLetv;
    [self pushViewController:searchVc];
}

- (WZTableViewDelegateIMP*)getContentTableViewDelegate:(NSInteger)typeId
{
    OrderListViewDelegateIMP *delegateIMP;
    Class impClass;
    
    switch (self.user.userRoleType) {
        case kUserRoleTypeFacilitator:
            impClass = [LetvFacilitatorOrderListViewDelegateIMP class];
            break;
        case kUserRoleTypeRepairer:
            impClass = [LetvRepairOrderListViewDelegateIMP class];
            break;
        case kUserRoleTypeSupporter:
            impClass = [LetvTelSupportOrderListViewDelegateIMP class];
            break;
        default:
            impClass = [OrderListViewDelegateIMP class];
            break;
    }

    if (impClass) {
        delegateIMP = [[impClass alloc]init];
        delegateIMP.viewController = self;
        delegateIMP.userRoleType = self.user.userRoleType;
        delegateIMP.orderStatus = typeId;
    }

    return delegateIMP;
}

@end
