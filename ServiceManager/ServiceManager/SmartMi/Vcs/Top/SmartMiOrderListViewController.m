//
//  SmartMiOrderListViewController.m
//  ServiceManager
//
//  Created by Wu on 17/3/23.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "SmartMiOrderListViewController.h"

// tableView 数据获取代理
#import "SmartMiFacilitatorOrderListViewDelegateIMP.h"
#import "SmartMiRepairOrderListViewDelegateIMP.h"
#import "SmartMiTelSupportOrderListViewDelegateIMP.h"

@interface SmartMiOrderListViewController ()

@end

@implementation SmartMiOrderListViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.title = @"工单列表(智米)";
}

/**
 *  获取需要的 tableView 的代理
 *
 *  @param typeId 角色
 *
 *  @return tableView 代理
 */
- (WZTableViewDelegateIMP*) getContentTableViewDelegate:(NSInteger)typeId {
    OrderListViewDelegateIMP *delegateIMP;
    Class impClass;
    
    switch (self.user.userRoleType) {
        case kUserRoleTypeFacilitator:
            impClass = [SmartMiFacilitatorOrderListViewDelegateIMP class];
            break;
        case kUserRoleTypeRepairer:
            impClass = [SmartMiRepairOrderListViewDelegateIMP class];
            break;
        case kUserRoleTypeSupporter:
            impClass = [SmartMiTelSupportOrderListViewDelegateIMP class];
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

/**
 *  vc 返回按钮事件（viewController 的扩展方法重写）
 */
- (void) navBarLeftButtonClicked:(UIButton *)defaultLeftButton {
    [super navBarLeftButtonClicked:defaultLeftButton];
}
/**
 *  导航栏是否需要显示过滤按钮
 */
- (BOOL) checkIfShowFilterBtn {
    return NO;
}
/**
 *  跳转到搜索页面
 */
- (void) gotoOrderSearchViewController {
    SearchOrderViewController *searchVc = [[SearchOrderViewController alloc]init];
    searchVc.title = @"搜索工单(智米)";
    searchVc.serviceBrandGroup = kServiceBrandGroupSmartMi;
    [self pushViewController:searchVc];
}

- (BOOL) isZM {
    return YES;
}


@end


