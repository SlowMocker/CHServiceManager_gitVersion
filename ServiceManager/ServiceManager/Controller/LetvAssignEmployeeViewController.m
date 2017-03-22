//
//  LetvAssignEmployeeViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/10.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvAssignEmployeeViewController.h"

@interface LetvAssignEmployeeViewController ()

@end

@implementation LetvAssignEmployeeViewController

- (void)requestRepairerListWithResponse:(RequestCallBackBlockV2)responseBlock{
    LetvGetRepairerListInputParams *input = [LetvGetRepairerListInputParams new];
    input.objectId = [self.orderId description];
    
    [Util showWaitingDialog];
    [self.httpClient letv_getRepairerList:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
    
        NSArray *repairers;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            repairers = [MiscHelper parserObjectList:responseData.resultData objectClass:@"LetvRepairerInfo"];
            repairers = [self convertLetvRepairerInfoArrayToRepairerInfoArray:repairers];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
        responseBlock(error, responseData, repairers);
    }];
}

- (NSArray*)convertLetvRepairerInfoArrayToRepairerInfoArray:(NSArray*)letvRepairers
{
    NSMutableArray *repairers = [NSMutableArray new];
    for (LetvRepairerInfo *letvRepair in letvRepairers) {
        RepairerInfo *repairer = [[RepairerInfo alloc]initWithLetvRepairerInfo:letvRepair];
        [repairers addObject:repairer];
    }
    return repairers;
}

- (void)assignOrderToRepairer:(RepairerInfo*)repairer response:(RequestCallBackBlock)responseBlock
{
    LetvAssignEngineerInputParams *input = [LetvAssignEngineerInputParams new];
    input.objectId = [self.orderId description];
    input.repairManId = repairer.repairman_id;

    [Util showWaitingDialog];
    [self.httpClient letv_assignEngineer:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        responseBlock(error, responseData);
    }];
}

@end
