//
//  HttpClientManager+SmartMi.m
//  ServiceManager
//
//  Created by Wu on 17/3/24.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "HttpClientManager+SmartMi.h"

@implementation HttpClientManager (SmartMi)
#pragma mark
#pragma mark base
- (NSString *) getFullUrlPath:(NSString*)relativePath {
    return [NSString stringWithFormat:@"%@%@", kSmartMiServerBaseUrl, relativePath];
}

- (void) post:(NSString*)relativePath params:(NSObject*)params response:(RequestCallBackBlock)requestCallBackBlock {
    NSDictionary *paramDic = [NSDictionary dictionaryFromPropertyObject:params];
    NSString *reqUrlPath = [self getFullUrlPath:relativePath];
    [self.netClient post:reqUrlPath params:paramDic additionalHeader:nil response:requestCallBackBlock];
}

- (void) get:(NSString*)relativePath params:(NSObject*)params response:(RequestCallBackBlock)requestCallBackBlock {
    NSDictionary *paramDic = [NSDictionary dictionaryFromPropertyObject:params];
    NSString *reqUrlPath = [self getFullUrlPath:relativePath];
    [self.netClient get:reqUrlPath params:paramDic additionalHeader:nil response:requestCallBackBlock];
}

#pragma mark
#pragma mark interface
#pragma mark
#pragma mark __common（通用）
// 维修人员列表,用于派工
- (void) smartMi_getRepairerList:(SmartMiGetRepairerListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    [self get:SmartMiServerApiGetRepairerList params:input response:requestCallBackBlock];
}

// 签到
- (void) smartMi_repairSignIn:(SmartMiRepairSignInInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock  {
    [self post:SmartMiServerApiRepairSignIn params:input response:requestCallBackBlock];
}

// 工单详情
- (void) smartMi_getOrderDetails:(SmartMiGetOrderDetailsInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    [self get:SmartMiServerApiGetOrderDetails params:input response:requestCallBackBlock];
}

#pragma mark
#pragma mark __facilitator（服务商）
// 工单列表
- (void) smartMi_facilitator_orderList:(SmartMiFacilitatorOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    [self get:SmartMiServerApiGetSvcProviderOrderList params:input response:requestCallBackBlock];
}

// 接受、拒绝
- (void) smartMi_facilitator_refuseOrder:(SmartMiFacilitatorRefuseOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    [self post:SmartMiServerApiFacilitatorRefuseOrder params:input response:requestCallBackBlock];
}

// 预约（成功、失败）提交
- (void) smartMi_facilitator_appointmentOrder:(SmartMiFacilitatorAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    [self post:SmartMiServerApiAppointmentOrder params:input response:requestCallBackBlock];
}

// 改约、二次预约
- (void) smartMi_facilitator_changeAppointmentOrder:(SmartMiFacilitatorChangeAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    [self post:SmartMiServerApiChangeAppointmentOrder params:input response:requestCallBackBlock];
}

// 派工给服务工程师
-(void) smartMi_assignEngineer:(SmartMiAssignEngineerInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    [self post:SmartMiServerApiAssignEngineer params:input response:requestCallBackBlock];
}

#pragma mark
#pragma mark __repairer（维修工）

-(void) smartMi_repairer_orderList:(SmartMiRepairOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    [self get:SmartMiServerApiGetRepairOrderList params:input response:requestCallBackBlock];
}

- (void) smartMi_repairer_refuseOrder:(SmartMiRepairRefuseOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:SmartMiServerApiRepairerRefuseOrder params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void) smartMi_repairer_appointmentOrder:(SmartMiRepairerAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:SmartMiRepairerAppointmentOrder params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void) smartMi_repairer_agreeOrderUrge:(SmartMiRepairerAgreeOrderUrgeInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:SmartMiAgreeOrderUrge params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void) smartMi_repairer_queryAircraftBrand:(SmartMiRepairerQueryAircraftBrandInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    [self get:SmartMiQueryAircraftBrand params:input response:requestCallBackBlock];
}

- (void) smartMi_repairer_queryFuzzyAircraft:(SmartMiRepairerQueryFuzzyAircraftInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    [self get:SmartMiQueryFuzzyAircraft params:input response:requestCallBackBlock];
}

- (void) smartMi_repairer_finishWork:(SmartMiRepairerFinishWorkInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:SmartMiFinishWork params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void) smartMi_repairer_cancelWork:(SmartMiRepairerCancelWorkInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:SmartMiCancelWork params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void) smartMi_repairer_queryList4RepairmanByObjectid:(SmartMiRepairerQueryList4RepairmanByObjectidInputParams*)input response:(RequestCallBackBlockV2)requestCallBackBlock {
    [self get:SmartMiQueryList4RepairmanByObjectid params:input response:^(NSError *error, HttpResponseData *responseData) {
         NSArray *orderItems;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            orderItems = [MiscHelper parserObjectList:responseData.resultData objectClass:@"SmartMiOrderContentModel"];
        }
        requestCallBackBlock(error, responseData, orderItems);
    }];
}


- (void) smartMi_repairer_saveImageUrl:(SmartMiRepairerSaveImageUrlInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock {
    [self post:SmartMiSaveImageUrl params:input response:requestCallBackBlock];
}

#pragma mark
#pragma mark __support（技术支持）


@end
