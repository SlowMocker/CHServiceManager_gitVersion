//
//  SmartMiOrderListViewDelegateIMP.m
//  ServiceManager
//
//  Created by Wu on 17/3/27.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "SmartMiOrderListViewDelegateIMP.h"

#import "AppointmentPopMenuView.h"

#import "SmartMiOrderDetailsViewController.h"
#import "SmartMiAssignEmployeeViewController.h"
#import "SmartMiAppointmentSuccessViewController.h"
#import "SmartMiAppointmentFailViewController.h"


#import "SmartMi_Install_PerformOrderViewController.h"
#import "SmartMi_Repair_PerformOrderViewController.h"

#import "LetvAppointmentViewController.h"
#import "LetvPerformOrderViewController.h"
#import "LetvConfirmSupportViewController.h"
#import "LetvSpecialPerformOrderViewController.h"

@interface SmartMiOrderListViewDelegateIMP()<WZSingleCheckViewControllerDelegate>

@end

@implementation SmartMiOrderListViewDelegateIMP

#pragma mark
#pragma mark 重写 btn 逻辑
// 查看
- (void) do_OrderOperationTypeView:(OrderContent *)order {
    SmartMiOrderDetailsViewController *orderDetailVc;
    orderDetailVc = [[SmartMiOrderDetailsViewController alloc]init];
    orderDetailVc.title = @"工单详情";
    orderDetailVc.orderContent = (SmartMiOrderContentModel *)order;
    [self.viewController pushViewController:orderDetailVc];
}

// 删除（暂时不用）
-(void) do_OrderOperationTypeDelete:(OrderContent *)order {
    UNIMPLEMENTED;
}

// 派工
-(void) do_OrderOperationTypeAssign:(OrderContent *)order {
    SmartMiOrderContentModel *orderModel = (SmartMiOrderContentModel*)order;
    [self gotoAssignEmployeeViewController:orderModel.objectId.description assignerId:nil];
}

// 改派
-(void) do_OrderOperationTypeReassign:(OrderContent *)order {
    SmartMiOrderContentModel *orderModel = (SmartMiOrderContentModel*)order;
    [self gotoAssignEmployeeViewController:orderModel.objectId.description assignerId:orderModel.workerId];
}

// 执行
-(void) do_OrderOperationTypeExecute:(OrderContent *)order {
    SmartMiOrderContentModel *orderModel = (SmartMiOrderContentModel*)order;
    
    NSInteger separateMinuts = 15; //预约15分钟后才能执行
    NSInteger minutes = separateMinuts;
    
    NSDate *appointmentedDate = [Util dateWithString:[Util defaultStr:orderModel.firstApptOpDate ifStrEmpty:orderModel.lastApptOpDate] format:WZDateStringFormat9];
    if (appointmentedDate != nil) {
        minutes = [[NSDate date] minutesAfterDate:appointmentedDate];
    }
    
    if (minutes >= separateMinuts) {
        [self gotoPerformOrderViewController:orderModel];
    }else {
        [Util showAlertView:nil message:[NSString stringWithFormat:@"对不起，%@分钟后才能执行", @(separateMinuts - minutes)]];
    }
}

// 特殊完工
-(void) do_OrderOperationTypeSpecialFinish:(OrderContent *)order {
    LetvOrderContentModel *orderModel = (LetvOrderContentModel*)order;
    
    [LetvSpecialPerformOrderViewController pushMeFrom:self.viewController orderListVc:self.viewController orderId:orderModel.objectId];
}

// 延保
- (void) do_OrderOperationTypeExtend:(OrderContent*)order {}

// 微信点评
- (void) do_OrderOperationTypeLetUserComment:(OrderContent*)order {}

// 拒绝
- (void) do_OrderOperationTypeRefuse:(OrderContent*)order {
    NSArray *reasonArray = [ConfigInfoManager sharedInstance].refueseReasons;
    NSArray *fmtReasonArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:reasonArray];
    
    WZSingleCheckViewController *checkVc;
    checkVc = [MiscHelper pushToCheckListViewController:@"请选择拒绝原因" checkItems:fmtReasonArray checkedItem:nil from:self.viewController delegate:self];
    checkVc.userInfo = order;
}

// 改约
-(void) do_OrderOperationTypeChangeAppointment:(OrderContent *)order {
    // 改约,只能成功
    [self gotoAppointmentViewController:@"改约成功" order:(SmartMiOrderContentModel *)order type:kAppointmentOperateTypeChangeTime forSuccess:YES];
}

// 二次预约
- (void) do_OrderOperationTypeAppointmentAgain:(OrderContent*)order {
    // 二次预约,只能成功
    [self gotoAppointmentViewController:@"改约成功" order:(SmartMiOrderContentModel *)order type:kAppointmentOperateType2ndTime forSuccess:YES];
}

- (void) gotoAppointmentViewController:(NSString*)title order:(SmartMiOrderContentModel *)orderContent type:(kAppointmentOperateType)appointType forSuccess:(BOOL)bSuccess {
    SmartMiAppointmentSuccessViewController *appointmentVc = [[SmartMiAppointmentSuccessViewController alloc]init];
    appointmentVc.title = title;
    appointmentVc.smartMiOrderContent = orderContent;
    appointmentVc.appointmentOperateType = appointType;
    [self.viewController pushViewController:appointmentVc];
}
// 预约工单时的弹出选择框数据设置，子类需重写
- (void) setAppointmentPopMenuView:(AppointmentPopMenuView*)menuView with:(OrderContent*)orderContent {
    SmartMiOrderContentModel *orderModel = (SmartMiOrderContentModel*)orderContent;
    menuView.orderId = orderModel.objectId.description;
    menuView.customerName = orderModel.name;
    menuView.customerTels = orderModel.phoneNum;
}

// 预约失败（AppointmentPopMenuViewDelegate）
- (void) popMenuViewAppointFailure:(AppointmentPopMenuView*)popView {
    SmartMiAppointmentFailViewController *appointmentVc = [[SmartMiAppointmentFailViewController alloc]init];
    appointmentVc.title = [NSString stringWithFormat:@"%@约失败",[popView getAppointmentOperateTypeKeyWord]];
    appointmentVc.smartMiOrderContent = (SmartMiOrderContentModel *)popView.userInfo;
    [self.viewController pushViewController:appointmentVc];
}

// 预约弹窗确定按钮点击事件 (实际该接口是写在 AppointmentPopMenuViewDelegate 成功弹窗监听代理方法里)
- (void) gotoAppointmentViewController:(NSString*)title order:(OrderContent*)orderContent type:(kAppointmentOperateType)appointType {
    [self gotoAppointmentViewController:title order:(SmartMiOrderContentModel *)orderContent type:appointType forSuccess:YES];
}


#pragma mark
#pragma mark WZSingleCheckViewControllerDelegate
- (void) singleCheckViewController:(WZSingleCheckViewController *)viewController didChecked:(CheckItemModel *)checkedItem {
    // TODO: 拒绝待修改
    OrderContent *order = (OrderContentModel*)viewController.userInfo;
    [self refuseOrder:order reason:checkedItem];
}

#pragma mark
#pragma mark private methods
// 进入执行界面
- (void) gotoPerformOrderViewController:(SmartMiOrderContentModel*)order {
//    LetvPerformOrderViewController *performVc = [[LetvPerformOrderViewController alloc]init];
//    performVc.orderListViewController = self.viewController;
//    performVc.orderId = order.objectId.description;
//    [self.viewController pushViewController:performVc];

    if ([order.orderTypeVal containsString:@"安装"]) {
        // 安装执行
        SmartMi_Install_PerformOrderViewController *performVc = [[SmartMi_Install_PerformOrderViewController alloc]init];
        performVc.orderId = order.objectId;
        [self.viewController pushViewController:performVc];
    }
    else {
        // 维修执行
        SmartMi_Repair_PerformOrderViewController *performVc = [[SmartMi_Repair_PerformOrderViewController alloc]init];
        [self.viewController pushViewController:performVc];
    }
}

/**
 *  跳转派工页面
 *
 *  @note assignerId 为 nil 是派工，否则是改派
 *
 *  @param orderId    工单号
 *  @param assignerId 当前已派工给哪位，改派时需要
 */
- (void) gotoAssignEmployeeViewController:(NSString*)orderId assignerId:(NSString*)assignerId {
    SmartMiAssignEmployeeViewController *assignVc = [[SmartMiAssignEmployeeViewController alloc]init];
    assignVc.orderId = orderId;
    assignVc.title = [Util isEmptyString:assignerId] ? @"派工" : @"改派";
    assignVc.assignerId = assignerId;
    [self.viewController pushViewController:assignVc];
}
@end



