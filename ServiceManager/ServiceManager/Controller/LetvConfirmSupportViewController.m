//
//  LetvConfirmSupportViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/8/31.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "LetvConfirmSupportViewController.h"

@interface LetvConfirmSupportViewController ()
@end

@implementation LetvConfirmSupportViewController

- (void)getSupportOrderConent:(RequestCallBackBlockV2)requestCallBackBlock
{
    LetvGetOrderDetailsInputParams *input = [LetvGetOrderDetailsInputParams new];
    input.objectId = [self.orderId description];
    [self.httpClient letv_getOrderDetails:input response:^(NSError *error, HttpResponseData *responseData) {
        LetvOrderContentDetails *orderDetails;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            orderDetails = [[LetvOrderContentDetails alloc]initWithDictionary:responseData.resultData];
        }
        requestCallBackBlock(error, responseData, orderDetails.supportInfo);
    }];
}

- (void)commitTaskConfirm:(ConfirmSupportInputParams*)params
{
    LetvConfirmSupportInputParams *input = [LetvConfirmSupportInputParams new];
    input.supportInfoId = params.supportInfoId.description;
    input.content = params.content;
    input.score = params.score;
    
    [Util showWaitingDialog];
    [self.httpClient letv_repairer_confirmSupport:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            [Util showToast:@"确认成功"];
            [self postNotification:NotificationOrderChanged];
            [self popViewController];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

@end
