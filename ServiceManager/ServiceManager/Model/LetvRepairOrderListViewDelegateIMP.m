//
//  LetvRepairOrderListViewDelegateIMP.m
//  ServiceManager
//
//  Created by will.wang on 16/5/16.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvRepairOrderListViewDelegateIMP.h"
#import "OrderTableViewCellDataSetter.h"

@implementation LetvRepairOrderListViewDelegateIMP

#pragma mark - override supper methods

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock
{
    LetvRepairOrderListInPutParams *input = [LetvRepairOrderListInPutParams new];
    input.currentPage = [NSString intStr:pageInfo.currentPage];
    input.repairManId = self.user.userId;
    input.status = [NSString intStr:self.orderStatus];

    [self.httpClient letv_repairer_orderList:input response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *orderItems;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            orderItems = [MiscHelper parserObjectList:responseData.resultData objectClass:@"LetvOrderContentModel"];
        }
        requestCallBackBlock(error, responseData, orderItems);
    }];
}

- (void)agreeOrder:(OrderContent*)order response:(RequestCallBackBlock)requestCallBackBlock
{
    LetvOrderContentModel *orderModel = (LetvOrderContentModel*)order;
    LetvRepairRefuseOrderInputParams *input = [LetvRepairRefuseOrderInputParams new];
    input.objectId = [orderModel.objectId description];;
    input.isreceivesign = @"0";
    input.realname = self.user.userName;
    
    [Util showWaitingDialog];
    [self.httpClient letv_repairer_refuseOrder:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        requestCallBackBlock(error, responseData);
    }];
}

- (void)refuseOrder:(OrderContent*)order reason:(CheckItemModel*)reason response:(RequestCallBackBlock)requestCallBackBlock
{
    LetvOrderContentModel *orderModel = (LetvOrderContentModel*)order;
    LetvRepairRefuseOrderInputParams *input = [LetvRepairRefuseOrderInputParams new];
    input.objectId = [ orderModel.objectId description];
    input.isreceivesign = @"1";
    input.realname = self.user.userName;
    input.declinefounid = reason.key;

    [Util showWaitingDialog];
    [self.httpClient letv_repairer_refuseOrder:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        requestCallBackBlock(error, responseData);
    }];
}

- (void)setCell:(OrderTableViewCell *)cell withData:(OrderContent *)order
{
    [super setCell:cell withData:order];
    
    //1, create right menu buttons
    NSArray *operateMenuBtnModels = [self makeCellRightButtons];
    cell.topContentView.userInteractionEnabled = (operateMenuBtnModels.count > 0);
    [cell setRightButtonsWithModels:operateMenuBtnModels];
    
    //2, set cell subviews layout
    [self setCellLayoutType:cell];
    
    //3, set data to cell
    [OrderTableViewCellDataSetter setLetvOrderContentModel:(LetvOrderContentModel*)order toCell:cell];
}

#pragma mark - set cell's layout type

- (void)setCellLayoutType:(OrderTableViewCell*)cell
{
    kOrderItemContentViewLayoutType layoutType = kOrderItemContentViewLayoutType1;
    
    switch (self.orderStatus) {
        case kRepairerOrderStatusNew:
            layoutType = kOrderItemContentViewLayoutType1;
            break;
        case kRepairerOrderStatusAppointFailure:
        case kRepairerOrderStatusWaitForAppointment:
            layoutType = kOrderItemContentViewLayoutType2;
            break;
        case kRepairerOrderStatusFinished:
            layoutType = kOrderItemContentViewLayoutType5;
            break;
        case kRepairerOrderStatusWaitForExecution:
        case kRepairerOrderStatusUnfinish:
            layoutType = kOrderItemContentViewLayoutType6;
            break;
        default:
            break;
    }
    
    cell.topOrderContentView.layoutType = layoutType;
}

- (NSMutableArray*)makeCellRightButtons
{
    NSMutableArray *operateMenuBtnModels = [[NSMutableArray alloc]init];
    BOOL showView = YES;
    MenuButtonModel *menuBtnModel;
    
    switch (self.orderStatus) {
        case kRepairerOrderStatusNew:
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeAgree];
            [operateMenuBtnModels addObject:menuBtnModel];
            
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeRefuse];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kRepairerOrderStatusWaitForAppointment:
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeAppointment];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kRepairerOrderStatusAppointFailure:
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeChangeAppointment];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kRepairerOrderStatusWaitForExecution :
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeSpecialFinish];
            [operateMenuBtnModels addObject:menuBtnModel];

            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeExecute];
            [operateMenuBtnModels addObject:menuBtnModel];
            
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeChangeAppointment];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kRepairerOrderStatusUnfinish:
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeSpecialFinish];
            [operateMenuBtnModels addObject:menuBtnModel];

            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeExecute];
            [operateMenuBtnModels addObject:menuBtnModel];
            
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeAppointmentAgain];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kRepairerOrderStatusTrace:
            break;
        default:
            break;
    }
    if (showView) {
        menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeView];
        [operateMenuBtnModels addObject:menuBtnModel];
    }
    return operateMenuBtnModels;
}

@end
