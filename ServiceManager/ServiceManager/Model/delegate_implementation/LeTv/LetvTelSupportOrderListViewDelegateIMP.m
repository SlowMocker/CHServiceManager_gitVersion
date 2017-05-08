//
//  LetvTelSupportOrderListViewDelegateIMP.m
//  ServiceManager
//
//  Created by will.wang on 16/5/12.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvTelSupportOrderListViewDelegateIMP.h"
#import "LetvOrderDetailsViewController.h"
#import "LetvTaskDetailsViewController.h"
#import "OrderTableViewCellDataSetter.h"

@implementation LetvTelSupportOrderListViewDelegateIMP

#pragma mark - override super methods

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock
{
    LetvSupporterOrderListInPutParams *input = [LetvSupporterOrderListInPutParams new];
    input.currentPage = [NSString intStr:pageInfo.currentPage];
    input.supporterId = self.user.userId;
    input.status = [NSString intStr:self.orderStatus];

    [self.httpClient letv_supporter_orderList:input response:^(NSError *error, HttpResponseData *responseData) {

        NSArray *supportItems;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            supportItems = [MiscHelper parserObjectList:responseData.resultData objectClass:@"LetvSupporterOrderContent"];
        }
        requestCallBackBlock(error, responseData, supportItems);
    }];
}

-(void)do_OrderOperationTypeView:(OrderContent *)orderContent
{
    LetvSupporterOrderContent *order = (LetvSupporterOrderContent*)orderContent;
    LetvOrderDetailsViewController *orderDetailVc;
    orderDetailVc = [[LetvOrderDetailsViewController alloc]init];
    orderDetailVc.title = @"工单详情";
    
    LetvOrderContentModel *orderContentModel = [LetvOrderContentModel new];
    orderContentModel.objectId = [order.objectId description];

    orderDetailVc.orderContent = orderContentModel;
    [self.viewController pushViewController:orderDetailVc];
}

- (void)pushToTaskDetailsViewController:(OrderContent*)orderContent confirmMode:(BOOL)bConfirmMode
{
    LetvSupporterOrderContent *order = (LetvSupporterOrderContent*)orderContent;
    TaskDetailsViewController *taskDetailsVc = [[LetvTaskDetailsViewController alloc]init];
    taskDetailsVc.title = @"任务详情";
    taskDetailsVc.orderContent = [[SupporterOrderContent alloc]initWithLetv:order];
    taskDetailsVc.orderStatus = self.orderStatus;
    taskDetailsVc.isConfirmMode = bConfirmMode;
    [self.viewController pushViewController:taskDetailsVc];
}

- (void)setSupporterOrderContent:(OrderContent*)orderContent toCell:(OrderTableViewCell*)cell
{
    LetvSupporterOrderContent *supporterOrderContent = (LetvSupporterOrderContent*)orderContent;

    OrderItemContentView *mainView = cell.topOrderContentView;
    
    mainView.orderIdLabel.text = supporterOrderContent.objectId;
    
    mainView.contentLabel.attributedText = [OrderTableViewCellDataSetter buildOrderAttrStr:nil catgory:supporterOrderContent.productType customer:nil];
    
    [mainView showPrior:NO showUrgent:NO];
    BOOL bInstallOrder = [supporterOrderContent.serviceReqType isEqualToString:@"18"];
    [mainView updateProductRepairTypeToViews:bInstallOrder ? @"新" : @"修"];
    
    mainView.addressLabel.text = [Util defaultStr:@"客户地址未知" ifStrEmpty:supporterOrderContent.customerFullAddress];
    
    mainView.executeNameLabel.hidden = [Util isEmptyString:supporterOrderContent.workerName];
    mainView.executeNameLabel.text = [supporterOrderContent.workerName truncatingTailWhenLengthGreaterThan:6];
    
    if (self.orderStatus == kSupporterOrderStatusConfirmed) {
        mainView.statusLabel.text = supporterOrderContent.content;
        mainView.starView.score = [supporterOrderContent.score floatValue]/5;
    }else {
        mainView.statusLabel.hidden = YES;
        mainView.starView.hidden = YES;
    }
}

@end
