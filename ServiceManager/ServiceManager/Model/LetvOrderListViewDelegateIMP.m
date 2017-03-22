//
//  OrderListViewDelegateIMP.m
//  ServiceManager
//
//  Created by will.wang on 15/8/31.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "LetvOrderListViewDelegateIMP.h"
#import "AppointmentPopMenuView.h"

#import "LetvOrderDetailsViewController.h"
#import "LetvAssignEmployeeViewController.h"
#import "LetvAppointmentViewController.h"
#import "LetvPerformOrderViewController.h"
#import "LetvConfirmSupportViewController.h"
#import "LetvSpecialPerformOrderViewController.h"

@interface LetvOrderListViewDelegateIMP()<WZSingleCheckViewControllerDelegate>
@end

@implementation LetvOrderListViewDelegateIMP


#pragma mark - handle order operation

-(void)do_OrderOperationTypeView:(OrderContent *)order
{
    LetvOrderDetailsViewController *orderDetailVc;
    orderDetailVc = [[LetvOrderDetailsViewController alloc]init];
    orderDetailVc.title = @"工单详情";
    orderDetailVc.orderContent = (LetvOrderContentModel *)order;
    [self.viewController pushViewController:orderDetailVc];
}

-(void)do_OrderOperationTypeDelete:(OrderContent *)order
{
    UNIMPLEMENTED;
}

-(void)do_OrderOperationTypeAssign:(OrderContent *)order
{
    LetvOrderContentModel *orderModel = (LetvOrderContentModel*)order;
    [self gotoAssignEmployeeViewController:orderModel.objectId.description assignerId:nil];
}

-(void)do_OrderOperationTypeReassign:(OrderContent *)order
{
    LetvOrderContentModel *orderModel = (LetvOrderContentModel*)order;
    [self gotoAssignEmployeeViewController:orderModel.objectId assignerId:orderModel.workerId];
}

-(void)do_OrderOperationTypeExecute:(OrderContent *)order
{
    LetvOrderContentModel *orderModel = (LetvOrderContentModel*)order;
    
    NSInteger separateMinuts = 15; //预约15分钟后才能执行
    NSInteger minutes = separateMinuts;

    NSString *lastApptOperDate = [Util defaultStr:orderModel.firstApptOpDate ifStrEmpty:orderModel.lastApptOpDate];
    lastApptOperDate = [Util defaultStr:orderModel.dispatchDate ifStrEmpty:lastApptOperDate];

    NSDate *appointmentedDate = [Util dateWithString:lastApptOperDate format:WZDateStringFormat9];
    if (appointmentedDate != nil) {
        minutes = [[NSDate date] minutesAfterDate:appointmentedDate];
    }
    
    if (minutes >= separateMinuts) {
        [self gotoPerformOrderViewController:orderModel];
    }else {
        [Util showAlertView:nil message:[NSString stringWithFormat:@"对不起，%@分钟后才能执行", @(separateMinuts - minutes)]];
    }
}

-(void)do_OrderOperationTypeSpecialFinish:(OrderContent *)order
{
    LetvOrderContentModel *orderModel = (LetvOrderContentModel*)order;

    [LetvSpecialPerformOrderViewController pushMeFrom:self.viewController orderListVc:self.viewController orderId:orderModel.objectId];
}

-(void)do_OrderOperationTypeChangeAppointment:(OrderContent *)order
{
    //改约,只能成功
    [self gotoAppointmentViewController:@"改约成功" order:(LetvOrderContentModel*)order type:kAppointmentOperateTypeChangeTime forSuccess:YES];
}

- (void)do_OrderOperationTypeAppointmentAgain:(OrderContent*)order
{
    //二次预约,只能成功
    [self gotoAppointmentViewController:@"改约成功" order:(LetvOrderContentModel*)order type:kAppointmentOperateType2ndTime forSuccess:YES];
}

- (void)do_OrderOperationTypeExtend:(OrderContent*)order
{
}

- (void)do_OrderOperationTypeLetUserComment:(OrderContent*)order
{
}

- (void)do_OrderOperationTypeRefuse:(OrderContent*)order
{
    NSArray *reasonArray = [ConfigInfoManager sharedInstance].refueseReasons;
    NSArray *fmtReasonArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:reasonArray];
    
    WZSingleCheckViewController *checkVc;
    checkVc = [MiscHelper pushToCheckListViewController:@"请选择拒绝原因" checkItems:fmtReasonArray checkedItem:nil from:self.viewController delegate:self];
    checkVc.userInfo = order;
}

- (void)singleCheckViewController:(WZSingleCheckViewController *)viewController didChecked:(CheckItemModel *)checkedItem
{
    OrderContent *order = (OrderContentModel*)viewController.userInfo;
    [self refuseOrder:order reason:checkedItem];
}

- (void)gotoAppointmentViewController:(NSString*)title order:(OrderContent*)orderContent type:(kAppointmentOperateType)appointType
{
    [self gotoAppointmentViewController:title order:(LetvOrderContentModel *)orderContent type:appointType forSuccess:YES];
}

- (void)gotoAppointmentViewController:(NSString*)title order:(LetvOrderContentModel*)orderContent type:(kAppointmentOperateType)appointType forSuccess:(BOOL)bSuccess
{
    LetvAppointmentViewController *appointmentVc = [[LetvAppointmentViewController alloc]init];
    appointmentVc.title = title;
    appointmentVc.letvOrderContent = orderContent;
    appointmentVc.appointmentOperateType = appointType;
    appointmentVc.bAppointmentSuccess = bSuccess;
    [self.viewController pushViewController:appointmentVc];
}

- (void)gotoPerformOrderViewController:(LetvOrderContentModel*)order
{
    LetvPerformOrderViewController *performVc = [[LetvPerformOrderViewController alloc]init];
    performVc.orderListViewController = self.viewController;
    performVc.orderId = order.objectId.description;
    [self.viewController pushViewController:performVc];
}

//assignerId : 当前已派工给哪位，改派时需要
- (void)gotoAssignEmployeeViewController:(NSString*)orderId assignerId:(NSString*)assignerId
{
    LetvAssignEmployeeViewController *assignVc = [[LetvAssignEmployeeViewController alloc]init];
    assignVc.orderId = orderId;
    assignVc.title = [Util isEmptyString:assignerId] ? @"派工" : @"改派";
    assignVc.assignerId = assignerId;
    [self.viewController pushViewController:assignVc];
}

- (void)setAppointmentPopMenuView:(AppointmentPopMenuView*)menuView with:(OrderContent*)orderContent
{
    LetvOrderContentModel *orderModel = (LetvOrderContentModel*)orderContent;

    menuView.orderId = orderModel.objectId.description;
    menuView.customerName = orderModel.name;
    menuView.customerTels = orderModel.phoneNum;
}

- (void)popMenuViewAppointFailure:(AppointmentPopMenuView*)popView
{
    LetvAppointmentViewController *appointmentVc = [[LetvAppointmentViewController alloc]init];
    LetvOrderContentModel *orderModel = (LetvOrderContentModel*)popView.userInfo;

    appointmentVc.title = [NSString stringWithFormat:@"%@约失败",[popView getAppointmentOperateTypeKeyWord]];
    appointmentVc.letvOrderContent = orderModel;
    appointmentVc.bAppointmentSuccess = NO;
    [self.viewController pushViewController:appointmentVc];
}

@end
