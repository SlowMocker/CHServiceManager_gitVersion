//
//  LetvTecSupportOrderListViewDelegateIMP.m
//  ServiceManager
//
//  Created by will.wang on 16/7/4.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvTecSupportOrderListViewDelegateIMP.h"
#import "LetvConfirmSupportViewController.h"
#import "OrderTableViewCellDataSetter.h"

@implementation LetvTecSupportOrderListViewDelegateIMP

- (void)do_OrderOperationTypeConfirm:(OrderContent*)order
{
    LetvOrderContentModel *orderModel = (LetvOrderContentModel*)order;
    LetvConfirmSupportViewController *confirmVc = [[LetvConfirmSupportViewController alloc]init];
    confirmVc.orderId = orderModel.objectId.description;
    confirmVc.orderStatus = self.orderStatus;
    [self.viewController pushViewController:confirmVc];
}

- (void)setOrderContentModel:(OrderContent *)order toCell:(OrderTableViewCell *)cell
{
    LetvOrderContentModel *contentOrder = (LetvOrderContentModel*)order;

    [OrderTableViewCellDataSetter setLetvOrderContentModel:contentOrder toCell:cell];

    //do not show duration time
    NSString *tempStr = [MiscHelper getOrderProccessStatusStrById:contentOrder.status repairerHandle:contentOrder.isReceive];
    cell.topOrderContentView.statusLabel.text = tempStr;
}

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock
{
    NSString *statusStr = (NSNotFound != self.orderStatus) ? [NSString intStr:self.orderStatus] : nil;
    
    RequestCallBackBlock responseBlcok = ^(NSError *error, HttpResponseData *responseData) {
        NSArray *orderItems;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            orderItems = [MiscHelper parserObjectList:responseData.resultData objectClass:@"LetvOrderContentModel"];
        }
        requestCallBackBlock(error, responseData, orderItems);
    };
    
    if (kUserRoleTypeFacilitator == self.user.userRoleType) {
        LetvFacilitatorOrderListInPutParams *input = [LetvFacilitatorOrderListInPutParams new];
        input.currentPage = [NSString intStr:pageInfo.currentPage];
        input.serverId = self.user.userId;
        input.status = statusStr;
        [self.httpClient letv_facilitator_orderList:input response:responseBlcok];
    }else if (kUserRoleTypeRepairer == self.user.userRoleType) {
        LetvRepairOrderListInPutParams *input = [LetvRepairOrderListInPutParams new];
        input.currentPage = [NSString intStr:pageInfo.currentPage];
        input.repairManId = self.user.userId;
        input.status = statusStr;
        [self.httpClient letv_repairer_orderList:input response:responseBlcok];
    }
}

@end
