//
//  TecSupportOrderListViewDelegateIMP.m
//  ServiceManager
//
//  Created by will.wang on 16/7/4.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "TecSupportOrderListViewDelegateIMP.h"
#import "OrderTableViewCell.h"
#import "ConfirmSupportViewController.h"
#import "OrderTableViewCellDataSetter.h"

@interface TecSupportOrderListViewDelegateIMP ()
@end

@implementation TecSupportOrderListViewDelegateIMP

#pragma mark - override supper methods

- (NSInteger)orderStatus{
    return [self getOrderProgressStatus];
}

- (NSInteger)getOrderProgressStatus
{
    NSInteger status = NSNotFound;
    switch ([UserInfoEntity sharedInstance].userRoleType) {
        case kUserRoleTypeFacilitator:
            status = kFacilitatorOrderStatusConfirm;
            break;
        case kUserRoleTypeRepairer:
            status = kRepairerOrderStatusConfirm;
            break;
        default:
            break;
    }
    return status;
}

- (Class)getTableViewCellClass
{
    return [OrderTableViewCell class];
}

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock
{
    NSString *statusStr = (NSNotFound != self.orderStatus) ? [NSString intStr:self.orderStatus] : nil;

    RequestCallBackBlock responseBlcok = ^(NSError *error, HttpResponseData *responseData) {
        NSArray *orderItems;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            orderItems = [MiscHelper parserOrderList:responseData.resultData];
        }
        requestCallBackBlock(error, responseData, orderItems);
    };

    if (kUserRoleTypeFacilitator == self.user.userRoleType) {
        FacilitatorOrderListInPutParams *input = [FacilitatorOrderListInPutParams new];
        input.pagenow = [NSString intStr:pageInfo.currentPage];
        input.partner = self.user.userId;
        input.status = statusStr;
        [self.httpClient facilitator_orderList:input response:responseBlcok];
    }else if (kUserRoleTypeRepairer == self.user.userRoleType) {
        RepairOrderListInPutParams *input = [RepairOrderListInPutParams new];
        input.pagenow = [NSString intStr:pageInfo.currentPage];
        input.repairmanid = self.user.userId;
        input.type_id = statusStr;
        [self.httpClient repairer_orderList:input response:responseBlcok];
    }
}

- (void)setCell:(OrderTableViewCell *)cell withData:(OrderContent *)order
{
    [super setCell:cell withData:order];
    
    cell.cellData = order;
    
    cell.topContentView.userInteractionEnabled = NO;
    
    //set cell subviews layout
    [self setCellLayoutType:cell];
    
    //set data to cell
    [self setOrderContentModel:order toCell:cell];
}

- (void)selectCellWithCellData:(NSObject *)cellData
{
    [self do_OrderOperationTypeConfirm:(OrderContent*)cellData];
}

- (void)setOrderContentModel:(OrderContent *)order toCell:(OrderTableViewCell *)cell
{
    OrderContentModel *contentOrder = (OrderContentModel*)order;

    [OrderTableViewCellDataSetter setOrderContentModel:contentOrder toCell:cell];
    
    //do not show duration time
    NSString *tempStr = [MiscHelper getOrderProccessStatusStrById:contentOrder.status repairerHandle:contentOrder.wxg_isreceive];
    cell.topOrderContentView.statusLabel.text = tempStr;
}

- (void)do_OrderOperationTypeConfirm:(OrderContent*)order
{
    OrderContentModel *orderModel = (OrderContentModel*)order;
    ConfirmSupportViewController *confirmVc = [[ConfirmSupportViewController alloc]init];
    confirmVc.orderId = orderModel.object_id.description;
    confirmVc.orderStatus = self.orderStatus;
    [self.viewController pushViewController:confirmVc];
}

- (void)setCellLayoutType:(OrderTableViewCell*)cell
{
    cell.topOrderContentView.layoutType = kOrderItemContentViewLayoutType3;
}

- (CGFloat)heightForCell:(UITableViewCell*)cell withCellData:(NSObject*)cellData
{
    return [cell fitHeight];
}

@end
