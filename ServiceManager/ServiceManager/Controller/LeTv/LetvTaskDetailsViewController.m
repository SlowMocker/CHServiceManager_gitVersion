//
//  LetvTaskDetailsViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/17.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvTaskDetailsViewController.h"

@interface LetvTaskDetailsViewController ()
@end

@implementation LetvTaskDetailsViewController

- (void)confirmTecSupportOrder:(NSString*)supportId response:(RequestCallBackBlock)requestCallBackBlock
{
    LetvSupporterAcceptInPutParams *input = [LetvSupporterAcceptInPutParams new];
    input.supportInfoId = supportId;

    [Util showWaitingDialog];
    [self.httpClient letv_supporter_accept:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        requestCallBackBlock(error, responseData);
    }];
}

@end
