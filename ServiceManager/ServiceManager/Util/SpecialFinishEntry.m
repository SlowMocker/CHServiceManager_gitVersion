//
//  SpecialFinishEntry.m
//  ServiceManager
//
//  Created by will.wang on 2016/12/15.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "SpecialFinishEntry.h"
#import "SpecialPerformViewController.h"

@implementation SpecialFinishEntry

//查询工单详情，成功返回OrderContentDetails
- (void)requestOrderDetails:(NSString*)orderId response:(RequestCallBackBlockV2)requestCallBackBlock
{
    //request order details to get unhandle part count
    GetOrderDetailsInputParams *input = [GetOrderDetailsInputParams new];
    input.object_id = orderId.description;

    [[HttpClientManager sharedInstance] getOrderDetails:input response:^(NSError *error, HttpResponseData *responseData) {
        OrderContentDetails *orderDetails;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            orderDetails = [MiscHelper parserOrderContentDetails: responseData.resultData];
        }
        requestCallBackBlock(error, responseData, orderDetails);
    }];
}

//未处理的备件数
- (NSInteger)getUnhandlePartCount:(OrderContentDetails*)orderDetails
{
    return orderDetails.tDispatchParts.count;
}

//查询工单是否含有费用项，有则返回NSNumber
- (void)queryFeeItemSyncStatus:(NSString*)orderId response:(RequestCallBackBlockV2)requestCallBackBlock{
    QueryFeeBillStatusInputParams *input = [QueryFeeBillStatusInputParams new];
    input.objectId = orderId;
    
    [[HttpClientManager sharedInstance] queryFeeBillStatus:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        NSInteger totalFeeItemCount = 0;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            NSInteger znNotSendToCrmCount = [[responseData.resultData objForKey:@"znNotSendToCrmCount"]integerValue];
            NSInteger bwSendToCrmCount = [[responseData.resultData objForKey:@"bwSendToCrmCount"]integerValue];
            NSInteger bwNotSendToCrmCount = [[responseData.resultData objForKey:@"bwNotSendToCrmCount"]integerValue];
            NSInteger znSendToCrmCount = [[responseData.resultData objForKey:@"znSendToCrmCount"]integerValue];
            
            totalFeeItemCount = znNotSendToCrmCount + bwSendToCrmCount + bwNotSendToCrmCount + znSendToCrmCount;
        }
        requestCallBackBlock(error, responseData, @(totalFeeItemCount));
    }];
}

- (void)gotoSpecialPerformVCByOrderId:(NSString*)orderId orderListVc:(ViewController*)orderListVc fromVc:(ViewController*)fromVc
{
    [Util showWaitingDialog];
    [self requestOrderDetails:orderId response:^(NSError *error, HttpResponseData *responseData, id extData) {
        [Util dismissWaitingDialog];

        if (nil != extData) {
            [self gotoSpecialPerformVCByOrderDetails:extData orderListVc:orderListVc fromVc:fromVc];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)gotoSpecialPerformVCByOrderDetails:(OrderContentDetails*)orderDetails orderListVc:(ViewController*)orderListVc fromVc:(ViewController*)fromVc
{
    BOOL bUnhandlePart = [self getUnhandlePartCount:orderDetails];
    
    [Util showWaitingDialog];
    [self queryFeeItemSyncStatus:orderDetails.object_id response:^(NSError *error, HttpResponseData *responseData, id extData) {
        [Util dismissWaitingDialog];

        NSNumber *totalFeeItemCount = (NSNumber*)extData;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            if ([totalFeeItemCount integerValue] <= 0) {
                if (bUnhandlePart) {
                    [Util confirmAlertView:nil message:@"当前工单有备件未处理，确认要特殊完工？" confirmTitle:@"确认" confirmAction:^{
                        [self pushSpecialPerformVC:orderDetails orderListVc:orderListVc fromVc:fromVc];
                    } cancelTitle:@"取消" cancelAction:nil];
                }else {
                    [self pushSpecialPerformVC:orderDetails orderListVc:orderListVc fromVc:fromVc];
                }
            }else {
                [Util showAlertView:nil message:@"工单含有费用项，不能进行特殊完工"];
            }
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)pushSpecialPerformVC:(OrderContentDetails*)orderDetails orderListVc:(ViewController*)orderListVc fromVc:(ViewController*)srcVc
{
    BOOL isBrandXZYY = [orderDetails.brandIdStr isEqualToString:@"XZYY"];

    SpecialPerformViewController *specialPerformVc = [[SpecialPerformViewController alloc]init];
    specialPerformVc.orderListViewController = orderListVc;
    specialPerformVc.isBrandXZYY = isBrandXZYY;
    specialPerformVc.orderDetails = orderDetails;
    specialPerformVc.orderId = orderDetails.object_id.description;
    [srcVc pushViewController:specialPerformVc];
}

@end
