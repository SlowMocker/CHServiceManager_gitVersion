//
//  LetvApplySupportViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/23.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvApplySupportViewController.h"

@interface LetvApplySupportViewController ()

@end

@implementation LetvApplySupportViewController

- (void)querySupportersWithOrderId:(NSString*)orderId response:(RequestCallBackBlockV2)requestCallBackBlock
{
    LetvGetEngneerListInputParams *input = [LetvGetEngneerListInputParams new];
    input.objectId = orderId;
    
    [[HttpClientManager sharedInstance] letv_getEngneerList:input response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *supporterList;
        if(!error && kHttpReturnCodeSuccess == responseData.resultCode){
            supporterList = [MiscHelper parserObjectList:responseData.resultData objectClass:@"LetvEmployeeInfo"];
            supporterList = [self convertToEmployeeInfoArray:supporterList];
        }
        requestCallBackBlock(error, responseData, supporterList);
    }];
}

- (void)applySupporter:(EmployeeInfo*)supporter response:(RequestCallBackBlock)requestCallBackBlock
{
    LetvApplySupportHelpInputParams *input = [LetvApplySupportHelpInputParams new];
    input.workerId = self.user.userId;
    input.objectId = self.orderId;
    input.supporterId = supporter.supportman_id;
    
    [self.httpClient letv_applySupportHelp:input response:requestCallBackBlock];
}

- (NSArray*)convertToEmployeeInfoArray:(NSArray*)letvEmployeeArray
{
    NSMutableArray *employeeArray = [[NSMutableArray alloc]init];
    for (LetvEmployeeInfo *letvemployee in letvEmployeeArray) {
        EmployeeInfo *model = [[EmployeeInfo alloc]initWithLetv:letvemployee];
        [employeeArray addObject:model];
    }
    return employeeArray;
}

@end
