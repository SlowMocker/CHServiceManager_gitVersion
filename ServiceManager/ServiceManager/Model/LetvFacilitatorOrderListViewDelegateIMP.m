//
//  LetvFacilitatorOrderListViewDelegateIMP.m
//  ServiceManager
//
//  Created by mac on 15/8/27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "LetvFacilitatorOrderListViewDelegateIMP.h"
#import "OrderTableViewCellDataSetter.h"

@implementation LetvFacilitatorOrderListViewDelegateIMP

#pragma mark - override supper methods

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock
{
    LetvFacilitatorOrderListInPutParams *input = [LetvFacilitatorOrderListInPutParams new];
    input.currentPage = [NSString intStr:pageInfo.currentPage];
    input.serverId = self.user.userId;
    input.status = [NSString intStr:self.orderStatus];

    [self.httpClient letv_facilitator_orderList:input response:^(NSError *error, HttpResponseData *responseData) {
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
    LetvRefuseOrderInputParams *input = [LetvRefuseOrderInputParams new];
    input.objectId = [orderModel.objectId description];
    input.flag = @"0";
    
    [Util showWaitingDialog];
    [self.httpClient letv_facilitator_refuseOrder:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        requestCallBackBlock(error, responseData);
    }];
}

- (void)refuseOrder:(OrderContent*)order reason:(CheckItemModel*)reason response:(RequestCallBackBlock)requestCallBackBlock
{
    LetvOrderContentModel *orderModel = (LetvOrderContentModel*)order;
    LetvRefuseOrderInputParams *refuseItem = [LetvRefuseOrderInputParams new];
    refuseItem.objectId = orderModel.objectId.description;
    refuseItem.flag = @"1";
    refuseItem.reason = reason.key;
    
    [Util showWaitingDialog];
    [self.httpClient letv_facilitator_refuseOrder:refuseItem response:^(NSError *error, HttpResponseData *responseData) {
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
        case kFacilitatorOrderStatusNew:
        case kFacilitatorOrderStatusReceived:
            layoutType = kOrderItemContentViewLayoutType1;
            break;
        case kFacilitatorOrderStatusAssigned:
        case kFacilitatorOrderStatusRefused:
        case kFacilitatorOrderStatusAppointFailure:
        case kFacilitatorOrderStatusWaitForAppointment:
            layoutType = kOrderItemContentViewLayoutType2;
            break;
        case kFacilitatorOrderStatusAppointed:
        case kFacilitatorOrderStatusWaitForExecution:
        case kFacilitatorOrderStatusUnfinish:
            layoutType = kOrderItemContentViewLayoutType6;
            break;
        case kFacilitatorOrderStatusFinished:
            layoutType = kOrderItemContentViewLayoutType5;
            break;
        default:
            break;
    }
    
    cell.topOrderContentView.layoutType = layoutType;
}

#pragma mark - make cell's right menu buttons

- (NSMutableArray*)makeCellRightButtons
{
    NSMutableArray *operateMenuBtnModels = [[NSMutableArray alloc]init];
    BOOL showView = YES;
    MenuButtonModel *menuBtnModel;
    
    switch (self.orderStatus) {
        case kFacilitatorOrderStatusNew:
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeAgree];
            [operateMenuBtnModels addObject:menuBtnModel];
            
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeRefuse];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kFacilitatorOrderStatusReceived:
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeAssign];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kFacilitatorOrderStatusAssigned:
        case kFacilitatorOrderStatusRefused:
        case kFacilitatorOrderStatusAppointed:
        case kFacilitatorOrderStatusAppointFailure:
        case kFacilitatorOrderStatusUnfinish:
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeReassign];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kFacilitatorOrderStatusWaitForAppointment:
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeAppointment];
            [operateMenuBtnModels addObject:menuBtnModel];
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeReassign];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kFacilitatorOrderStatusWaitForExecution:
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeSpecialFinish];
            [operateMenuBtnModels addObject:menuBtnModel];

            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeExecute];
            [operateMenuBtnModels addObject:menuBtnModel];

            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeChangeAppointment];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kFacilitatorOrderStatusAppointTrace:
        case kFacilitatorOrderStatusFinished:
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
