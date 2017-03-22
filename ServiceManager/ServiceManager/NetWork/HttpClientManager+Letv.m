//
//  HttpClientManager+Letv.m
//  ServiceManager
//
//  Created by will.wang on 16/5/16.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "HttpClientManager+Letv.h"
#import "InterFaceAPI.h"

@implementation HttpClientManager(LetvInterFace)

- (void)post:(NSString*)relativePath params:(NSObject*)params response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *paramDic = [NSDictionary dictionaryFromPropertyObject:params];
    NSString *reqUrlPath = [self getFullUrlPath:relativePath];
    [self.netClient post:reqUrlPath params:paramDic additionalHeader:nil response:requestCallBackBlock];
}

- (void)get:(NSString*)relativePath params:(NSObject*)params response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *paramDic = [NSDictionary dictionaryFromPropertyObject:params];
    NSString *reqUrlPath = [self getFullUrlPath:relativePath];
    [self.netClient get:reqUrlPath params:paramDic additionalHeader:nil response:requestCallBackBlock];
}

- (NSString*)getFullUrlPath:(NSString*)relativePath
{
    return [NSString stringWithFormat:@"%@%@", kLetvServerBaseUrl, relativePath];
}

#pragma mark - Letv App Interface

- (void)letv_getRepairerList:(LetvGetRepairerListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self get:LetvServerApiGetRepairerList params:input response:requestCallBackBlock];
}

-(void)letv_assignEngineer:(LetvAssignEngineerInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiAssignEngineer params:input response:requestCallBackBlock];
}

-(void)letv_facilitator_orderList:(LetvFacilitatorOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self get:LetvServerApiGetSvcProviderOrderList params:input response:requestCallBackBlock];
}

- (void)letv_facilitator_refuseOrder:(LetvRefuseOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiFacilitatorRefuseOrder params:input response:requestCallBackBlock];
}

- (void)letv_getOrderDetails:(LetvGetOrderDetailsInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self get:LetvServerApiGetOrderDetails params:input response:requestCallBackBlock];
}

- (void)letv_repairer_confirmSupport:(LetvConfirmSupportInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiRepairerConfirmSupportOrder params:input response:requestCallBackBlock];
}

-(void)letv_supporter_orderList:(LetvSupporterOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self get:LetvServerApiGetSupporterOrderList params:input response:requestCallBackBlock];
}

-(void)letv_repairer_orderList:(LetvRepairOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self get:LetvServerApiGetRepairOrderList params:input response:requestCallBackBlock];
}

- (void)letv_repairer_refuseOrder:(LetvRepairRefuseOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiRepairerRefuseOrder params:input response:requestCallBackBlock];
}

-(void)letv_supporter_accept:(LetvSupporterAcceptInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiSupporterAcceptTask params:input response:requestCallBackBlock];
}

- (void)letv_repairer_appointmentOrder:(LetvRepairerAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiRepairerAppointmentOrder params:input response:requestCallBackBlock];
}

- (void)letv_facilitator_appointmentOrder:(LetvAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiAppointmentOrder params:input response:requestCallBackBlock];
}

- (void)letv_facilitator_changeAppointmentOrder:(LetvChangeAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiChangeAppointmentOrder params:input response:requestCallBackBlock];
}

- (void)letv_repairFinishBill:(LetvFinishBillInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiFinishBill params:input response:requestCallBackBlock];
}

- (void)letv_specialRepairFinishBill:(LetvSpecialFinishBillInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvSpecialServerApiFinishBill params:input response:requestCallBackBlock];
}

- (void)letv_queryBomCodes:(LetvQueryBomCodesInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self get:LetvServerApiQueryBomCodes params:input response:requestCallBackBlock];
}

- (void)letv_agreeOrderUrge:(LetvAgreeUrgeInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiAgreeOrderUrge params:input response:requestCallBackBlock];
}

-(void)letv_repairSignIn:(LetvRepairSignInInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiRepairSignIn params:input response:requestCallBackBlock];
}

- (void)letv_findMachineModel:(LetvFindMachineModelInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self get:LetvServerApiFindMachineModel params:input response:requestCallBackBlock];
}

- (void)letv_queryExpenseList:(LetvExpenseListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self get:LetvServerApiQueryExpenseList params:input response:requestCallBackBlock];
}

- (void)letv_editFeeOrder:(LetvEditFeeOrderInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiEditFeeOrder params:input response:requestCallBackBlock];
}

- (void)letv_getFeeItemCount:(LetvGetFeeItemCountInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self get:LetvServerGetFeeItemCount params:input response:requestCallBackBlock];
}

- (void)letv_deleteFeeOrder:(LetvDeleteFeeOrderInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiDeleteFeeOrder params:input response:requestCallBackBlock];
}

- (void)letv_deleteAllFeeOrder:(LetvDeleteAllFeeOrderInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiDeleteAllFeeOrder params:input response:requestCallBackBlock];
}

- (void)letv_getEngneerList:(LetvGetEngneerListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self get:LetvServerApiGetEngneerList params:input response:requestCallBackBlock];
}

- (void)letv_applySupportHelp:(LetvApplySupportHelpInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    [self post:LetvServerApiApplySupportHelp params:input response:requestCallBackBlock];
}

- (void)letv_searchOrders:(LetvSearchOrdersInputParams*)input response:(RequestCallBackBlockV2)requestCallBackBlock
{
    [self get:LetvServerApiSearchOrders params:input response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *orderItems;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            orderItems = [MiscHelper parserObjectList:responseData.resultData objectClass:@"LetvOrderContentModel"];
        }
        requestCallBackBlock(error, responseData, orderItems);
    }];
}

@end
