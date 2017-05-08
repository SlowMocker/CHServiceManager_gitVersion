//
//  SmartMiAssignEmployeeViewController.m
//  ServiceManager
//
//  Created by Wu on 17/3/27.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "SmartMiAssignEmployeeViewController.h"

@interface SmartMiAssignEmployeeViewController ()
@end

@implementation SmartMiAssignEmployeeViewController

#pragma mark
#pragma mark over write interfaces
// 获取维修工列表
- (void) requestRepairerListWithResponse:(RequestCallBackBlockV2)responseBlock {
    SmartMiGetRepairerListInputParams *input = [SmartMiGetRepairerListInputParams new];
    input.objectId = [self.orderId description];
    
    [Util showWaitingDialog];
    [self.httpClient smartMi_getRepairerList:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        NSArray *repairers;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            repairers = [MiscHelper parserObjectList:responseData.resultData objectClass:@"SmartMiRepairerInfo"];
            repairers = [self convertSmartMiRepairerInfoArrayToRepairerInfoArray:repairers];

        }
        else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
        responseBlock(error, responseData, repairers);
    }];
}

- (NSArray<RepairerInfo *> *) convertSmartMiRepairerInfoArrayToRepairerInfoArray:(NSArray<SmartMiRepairerInfo *> *)smartMiRepairers {
    NSMutableArray *repairers = [NSMutableArray new];
    for (SmartMiRepairerInfo *smRepair in smartMiRepairers) {
        RepairerInfo *repairer = [[RepairerInfo alloc] initWithSmartMiRepairerInfo:smRepair];
        [repairers addObject:repairer];
    }
    return repairers;
}

// 派工
- (void) assignOrderToRepairer:(RepairerInfo*)repairer response:(RequestCallBackBlock)responseBlock {
    SmartMiAssignEngineerInputParams *input = [SmartMiAssignEngineerInputParams new];
    input.objectId = [self.orderId description];
    input.repairManId = repairer.repairman_id;
    
    [Util showWaitingDialog];
    [self.httpClient smartMi_assignEngineer:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        responseBlock(error, responseData);
    }];
}

@end
