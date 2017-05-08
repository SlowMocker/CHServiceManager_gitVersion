//
//  OrderListViewDelegateIMP.m
//  ServiceManager
//
//  Created by will.wang on 15/8/31.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "OrderListViewDelegateIMP.h"
#import "OrderTableViewCell.h"
#import "OrderDetailViewController.h"
#import "WZSingleCheckViewController.h"
#import "AssignEmployeeViewController.h"
#import "ConfigInfoManager.h"
#import "PerformOrderViewController.h"
#import "AppointmentViewController.h"
#import "AppointmentFailureViewController.h"
#import "ConfirmSupportViewController.h"
#import "SpecialFinishEntry.h"
#import "OrderExtendEditViewController.h"
#import "WeixinCommentQrCodeViewController.h"
#import "RefuseOrderViewController.h"
#import "AppDelegate.h"

//1: 拒绝普通工单时，需要填写备注和选择原因； 0：不需备注，仅选择原因
#define kRefuseOrderWithNote  0

@interface OrderListViewDelegateIMP()
<AppointmentPopMenuViewDelegate, WZSingleCheckViewControllerDelegate>
{
    AppointmentPopMenuView *_appointmentMenu;
    WZSwipeCell *_selectedCell;
}
@end

@implementation OrderListViewDelegateIMP

#pragma mark - override supper methods

- (Class)getTableViewCellClass
{
    return [OrderTableViewCell class];
}

- (void)setCell:(UITableViewCell*)cell withData:(NSObject*)order
{
    OrderTableViewCell *orderCell = (OrderTableViewCell*)cell;
    if (orderCell.bRightButtonsShowing) {
        [orderCell hideRightButtonsWithNoAnimate];
    }
    orderCell.delegate = self;
    orderCell.cellData = order;
}

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock
{
}

- (void)selectCellWithCellData:(NSObject*)cellData
{
}

- (CGFloat)heightForCell:(UITableViewCell*)cell withCellData:(NSObject*)cellData
{
    OrderTableViewCell *orderCell = (OrderTableViewCell*)cell;
    return [orderCell fitHeight];
}

#pragma mark - order cell's delegate

- (void)swipeCellRightButtonsWillShow:(WZSwipeCell*)cell
{
    WZSwipeCell *oldSelectedCell = _selectedCell;
    WZSwipeCell *newSelectedCell = cell;
    
    if (oldSelectedCell != newSelectedCell) {
        [oldSelectedCell hideRightButtons];
        _selectedCell = newSelectedCell;
    }
}

- (void)swipeCell:(WZSwipeCell *)swipeCell menuButtonSelected:(NSInteger)menuButtonTag
{
    kOrderOperationType operateType = (kOrderOperationType)menuButtonTag;
    OrderContent *order = (OrderContent*)swipeCell.cellData;

    switch (operateType) {
        case kOrderOperationTypeView://查看
            [self do_OrderOperationTypeView:order];
            break;
        case kOrderOperationTypeDelete://删除
            [self do_OrderOperationTypeDelete:order];
            break;
        case kOrderOperationTypeAgree://接受
            [self do_OrderOperationTypeAgree:order];
            break;
        case kOrderOperationTypeAssign://派工
            [self do_OrderOperationTypeAssign:order];
            break;
        case kOrderOperationTypeReassign://改派
            [self do_OrderOperationTypeReassign:order];
            break;
        case kOrderOperationTypeExecute://执行
            [self do_OrderOperationTypeExecute:order];
            break;
        case kOrderOperationTypeAppointment://预约
            [self do_OrderOperationTypeAppointment:order];
            break;
        case kOrderOperationTypeChangeAppointment://改约
            [self do_OrderOperationTypeChangeAppointment:order];
            break;
        case kOrderOperationTypeRefuse://拒绝:
            [self do_OrderOperationTypeRefuse:order];
            break;
        case kOrderOperationTypeAppointmentAgain: //二次预约
            [self do_OrderOperationTypeAppointmentAgain:order];
            break;
        case kOrderOperationTypeSpecialFinish://特殊完工
            [self do_OrderOperationTypeSpecialFinish:order];
            break;
        case kOrderOperationTypeExtend: //延保
            [self do_OrderOperationTypeExtend:order];
            break;
        case kOrderOperationTypeUserComment:
            [self do_OrderOperationTypeLetUserComment:order];
            break;
        default:
            break;
    }
}

#pragma mark - handle order operation

-(void)do_OrderOperationTypeView:(OrderContent *)order
{
    OrderDetailViewController *orderDetailVc;
    orderDetailVc = [[OrderDetailViewController alloc]init];
    orderDetailVc.title = @"工单详情";
    orderDetailVc.orderContent = (OrderContentModel *)order;
    [self.viewController pushViewController:orderDetailVc];
}

-(void)do_OrderOperationTypeAgree:(OrderContent *)order
{
    NSString *noteStr = [self getExNoteStrWhenAgreeingOrder:order];
    NSString *message = @"您确定要接受此工单吗?";
    if (![Util isEmptyString:noteStr]) {
        message = [message appendStr:[NSString stringWithFormat:@"(%@)",noteStr]];
    }
    [Util confirmAlertView:message confirmAction:^{
        [self agreeOrder:order];
    }];
}

-(void)do_OrderOperationTypeDelete:(OrderContent *)order
{
    DLog(@"Delete Order");
}

-(void)do_OrderOperationTypeAssign:(OrderContent *)order
{
    OrderContentModel *orderModel = (OrderContentModel*)order;
    AssignEmployeeViewController *assignVc = [[AssignEmployeeViewController alloc]init];
    assignVc.orderId = orderModel.object_id.description;
    assignVc.title = @"派工";
    [self.viewController pushViewController:assignVc];
}

-(void)do_OrderOperationTypeReassign:(OrderContent *)order
{
    OrderContentModel *orderModel = (OrderContentModel*)order;
    AssignEmployeeViewController *assignVc = [[AssignEmployeeViewController alloc]init];
    assignVc.orderId = orderModel.object_id.description;
    assignVc.title = @"改派";
    assignVc.assignerId = orderModel.partner_fwg;
    [self.viewController pushViewController:assignVc];
}

-(void)do_OrderOperationTypeExecute:(OrderContent *)order
{
    OrderContentModel *orderModel = (OrderContentModel*)order;

    NSInteger separateMinuts = 15; //预约15分钟后才能执行
    NSInteger minutes = separateMinuts;

    NSDate *appointmentedDate = [Util dateWithString:[Util defaultStr:orderModel.date_pg ifStrEmpty:orderModel.last_yy_time] format:WZDateStringFormat9];
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
    OrderContentModel *orderModel = (OrderContentModel*)order;

    SpecialFinishEntry *specialFinish = [SpecialFinishEntry new];

    [specialFinish gotoSpecialPerformVCByOrderId:orderModel.object_id orderListVc:self.viewController fromVc:self.viewController];
}

-(void)do_OrderOperationTypeAppointment:(OrderContent *)order
{
    [self showAppointmentMenuView:order];
}

-(void)do_OrderOperationTypeChangeAppointment:(OrderContent *)order
{
    //改约,只能成功
    [self gotoAppointmentViewController:@"改约成功" order:(OrderContentModel*)order type:kAppointmentOperateTypeChangeTime];
}

- (void)do_OrderOperationTypeAppointmentAgain:(OrderContent*)order
{
    //二次预约,只能成功
    [self gotoAppointmentViewController:@"改约成功" order:(OrderContentModel*)order type:kAppointmentOperateType2ndTime];
}

- (void)do_OrderOperationTypeExtend:(OrderContent*)order
{
    OrderContentModel *orderModel = (OrderContentModel*)order;

    //request order details to get unhandle part count
    GetOrderDetailsInputParams *input = [GetOrderDetailsInputParams new];
    input.object_id = orderModel.object_id;
    
    [Util showWaitingDialog];
    [[HttpClientManager sharedInstance] getOrderDetails:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        OrderContentDetails *orderDetails;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            orderDetails = [MiscHelper parserOrderContentDetails: responseData.resultData];
            OrderExtendEditViewController *extendEditVc = [[OrderExtendEditViewController alloc]init];
            extendEditVc.orderDetails = orderDetails;
            extendEditVc.extendOrderEditMode = kExtendOrderEditModeAppend;
            extendEditVc.extendServiceType = kExtendServiceTypeSingle;
            [self.viewController pushViewController:extendEditVc];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)do_OrderOperationTypeLetUserComment:(OrderContent*)order
{
    OrderContentModel *orderModel = (OrderContentModel*)order;
    WeixinCommentQrCodeViewController *vc = [[WeixinCommentQrCodeViewController alloc]init];
    vc.orderId = orderModel.object_id;
    [self.viewController pushViewController:vc];
}

#if kRefuseOrderWithNote

- (void)do_OrderOperationTypeRefuse:(OrderContent*)order
{
    RefuseOrderViewController *refuseVc = [[RefuseOrderViewController alloc]init];
    refuseVc.title = @"拒绝原因";
    refuseVc.order = order;
    refuseVc.confirmBlock = ^(id sender){
        RefuseOrderViewController *vc = (RefuseOrderViewController*)sender;
        CheckItemModel *reasonMdl = [CheckItemModel modelWithValue:vc.checkedReasonItem.value forKey:vc.checkedReasonItem.key];
        reasonMdl.extData = vc.textView.text;

        [self refuseOrder:order reason:reasonMdl];
    };
    [self.viewController pushViewController:refuseVc];
}

#else

- (void)do_OrderOperationTypeRefuse:(OrderContent*)order
{
    NSArray *reasonArray = [ConfigInfoManager sharedInstance].refueseReasons;
    NSArray *fmtReasonArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:reasonArray];
    
    WZSingleCheckViewController *checkVc;
    checkVc = [MiscHelper pushToCheckListViewController:@"请选择拒绝原因" checkItems:fmtReasonArray checkedItem:nil from:self.viewController delegate:self];
    checkVc.userInfo = order;
}
#endif

- (void)singleCheckViewController:(WZSingleCheckViewController *)viewController didChecked:(CheckItemModel *)checkedItem
{
#if !kRefuseOrderWithNote
    OrderContent *order = (OrderContentModel*)viewController.userInfo;
    [self refuseOrder:order reason:checkedItem];
#endif
}

- (void)showAppointmentMenuView:(OrderContent*)orderContent
{
    _appointmentMenu = [[AppointmentPopMenuView alloc]init];
    _appointmentMenu.viewController = self.viewController;
    _appointmentMenu.userInfo = orderContent;
    _appointmentMenu.delegate = self;
    _appointmentMenu.appointmentOperateType = kAppointmentOperateType1stTime;

    [self setAppointmentPopMenuView:_appointmentMenu with:orderContent];

    [_appointmentMenu popupAppointmentPopMenuView];
}

- (void)setAppointmentPopMenuView:(AppointmentPopMenuView*)menuView with:(OrderContent*)orderContent
{
    OrderContentModel *orderModel = (OrderContentModel*)orderContent;

    menuView.orderId = orderModel.object_id.description;
    menuView.customerName = orderModel.custname;
    menuView.customerTels = orderModel.telnumber;
}

// 需要子类重写
- (void)gotoAppointmentViewController:(NSString*)title order:(OrderContent*)orderContent type:(kAppointmentOperateType)appointType
{
    AppointmentViewController *appointmentVc = [[AppointmentViewController alloc]init];
    appointmentVc.title = title;
    appointmentVc.orderContent = (OrderContentModel*)orderContent;
    appointmentVc.appointmentOperateType = appointType;
    [self.viewController pushViewController:appointmentVc];
}

- (void)gotoPerformOrderViewController:(OrderContentModel*)order
{
    PerformOrderViewController *performVc = [[PerformOrderViewController alloc]init];
    performVc.orderListViewController = self.viewController;
    performVc.orderId = order.object_id.description;
    [self.viewController pushViewController:performVc];
}

#pragma mark - others

- (void)agreeOrder:(NSString*)orderId response:(RequestCallBackBlock)requestCallBackBlock
{
    UNIMPLEMENTED;
}

- (NSString*)getExNoteStrWhenAgreeingOrder:(OrderContent*)order
{
    return @"";
}

- (void)refuseOrder:(OrderContent*)order reason:(CheckItemModel*)reason response:(RequestCallBackBlock)requestCallBackBlock
{
    UNIMPLEMENTED;
}

- (void)refuseOrder:(OrderContent*)order reason:(CheckItemModel*)reason
{
    [self refuseOrder:order reason:reason response:^(NSError *error, HttpResponseData *responseData) {
        if (!error) {
            NSString *promptStr = [Util getErrorDescritpion:responseData otherError:error];
            if (kHttpReturnCodeSuccess == responseData.resultCode) {
                promptStr = @"已拒绝";
            }
            switch (responseData.resultCode) {
                case kHttpReturnCodeSuccess:
                case kHttpReturnCodeChangedAssign:
                    [self deleteCellInCellData:order];
                    [self postNotification:NotificationOrderChanged];
                    [MiscHelper popToOrderListViewController:kAppDelegate.topViewController];
                    break;
                default:
                    break;
            }
            [Util showToast:promptStr];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)agreeOrder:(OrderContent *)order
{
    [self agreeOrder:order response:^(NSError *error, HttpResponseData *responseData) {
        if (!error) {
            NSString *promptStr = [Util getErrorDescritpion:responseData otherError:error];
            if (kHttpReturnCodeSuccess == responseData.resultCode) {
                promptStr = @"已接受";
            }
            switch (responseData.resultCode) {
                case kHttpReturnCodeSuccess:
                case kHttpReturnCodeChangedAssign:
                    [self deleteCellInCellData:order];
                    [self postNotification:NotificationOrderChanged];
                    [MiscHelper popToOrderListViewController:self.viewController];
                    break;
                default:
                    break;
            }
            [Util showToast:promptStr];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

#pragma mark
#pragma mark AppointmentPopMenuViewDelegate

- (void)popMenuViewAppointSuccess:(AppointmentPopMenuView*)popView {
    NSString *title = [NSString stringWithFormat:@"%@约成功",[popView getAppointmentOperateTypeKeyWord]];
    [self gotoAppointmentViewController:title order:(OrderContentModel*)popView.userInfo type:popView.appointmentOperateType];
}

- (void)popMenuViewAppointFailure:(AppointmentPopMenuView*)popView {
    AppointmentFailureViewController *appointmentVc = [[AppointmentFailureViewController alloc]init];
    appointmentVc.title = [NSString stringWithFormat:@"%@约失败",[popView getAppointmentOperateTypeKeyWord]];
    appointmentVc.orderContent = (OrderContentModel*)popView.userInfo;
    [self.viewController pushViewController:appointmentVc];
}

- (MenuButtonModel*)makeMenuButtonModel:(kOrderOperationType)operateType {
    return [Util makeMenuButtonModel:operateType];
}
@end
