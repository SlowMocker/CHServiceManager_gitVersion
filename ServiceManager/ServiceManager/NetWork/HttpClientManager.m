//
//  HttpClientManager.m
//  BaseProject
//
//  Created by wangzhi on 15-2-2.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "HttpClientManager.h"
#import "RSAForiOS.h"

@implementation HttpClientManager

- (void)setTripleDesKey:(NSString *)tripleDesKey
{
    if (![_tripleDesKey isEqualToString:tripleDesKey]) {
        _tripleDesKey = [tripleDesKey copy];
        [self.netClient setTripleDesKey:_tripleDesKey];
    }
}

+ (instancetype)sharedInstance
{
    static HttpClientManager *sHttpClientMgr = nil;
    static dispatch_once_t sOnceToken;
    dispatch_once(&sOnceToken, ^{
        sHttpClientMgr = [[HttpClientManager alloc]init];
        sHttpClientMgr.netClient = [[NetClientManager alloc]init];
    });

    return sHttpClientMgr;
}

//app的版本信息
- (void)getAppVersionInfo:(RequestCallBackBlock)requestCallBackBlock
{
    NSString *appId = kAppKeyInChangHongPublishPlatform;
    NSString *urlStr;
#if (Build_For_Release)
    urlStr = [NSString stringWithFormat:@"https://oapi.chiq-cloud.com:18080/v1/op/app/%@/versionInfo", appId];
#else
    urlStr = [NSString stringWithFormat:@"https://oapi.chiq-cloud.com:18080/v1/op/app/%@/versionInfo", appId];
#endif

    [[AFHTTPSessionManager manager]GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        HttpResponseData *responseData = [HttpResponseData new];
        responseData.resultCode = kHttpReturnCodeSuccess;
        responseData.resultData = responseObject;
        requestCallBackBlock(nil, responseData);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        requestCallBackBlock(error, nil);
    }];
}

- (void)getMainInfosByTypes:(NSArray*)cfgTypes response:(RequestCallBackBlock)requestCallBackBlock
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    if (cfgTypes.count > 0) {
        [paramsDic setObject:[cfgTypes componentsJoinedByString:@","] forKey:@"types"];
    }
    [paramsDic setObject:@"1" forKey:@"isVirtualData"];

    AFHTTPSessionManager *manager = [self.netClient post:ServerApiGetMainInfoList params:paramsDic additionalHeader:nil response:requestCallBackBlock];
    AFTextResponseSerializer *responseSerializer = (AFTextResponseSerializer*)manager.responseSerializer;
    responseSerializer.isPlainData = YES;
    [manager.session.configuration setTimeoutIntervalForRequest:kNetWorkRequestMainConfigInfoTimeout];
    [manager.session.configuration setTimeoutIntervalForResource:kNetWorkRequestMainConfigInfoTimeout];
}

- (void)getStreetInfos:(StreetListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiGetStreetInfoList params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)getStreetsOfDistrict:(NSString*)districtCode response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"1" forKey:@"methodType"];
    [params setValue:districtCode forKey:@"superCode"];
    [params setValue:MainConfigInfoTableType21 forKey:@"type"];

    [self.netClient get:ServerApiGetStreetInfoList params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)getOrderDetails:(GetOrderDetailsInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiGetOrderDetails params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)getServiceImproveDetails:(GetOrderDetailsInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiGetServiceImproveDetails params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)getDeviceInfos:(GetDeviceInfosInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiGetDeviceInfos params:params additionalHeader:nil response:requestCallBackBlock];
}

-(void)login:(LoginInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiUserLogin params:params additionalHeader:nil response:requestCallBackBlock];
}

-(void)changePassword:(ChangePasswordInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiChangePassword params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)changeUserInfo:(ChangeUserInfoInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiChangeUserInfo params:params additionalHeader:nil response:requestCallBackBlock];
}

-(void)deleteRepairer:(DeleteRepairerInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiDeleteEmployee params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)getEngneerList:(GetEngneerListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiGetEngneerList params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)applySupportHelp:(ApplySupportHelpInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiApplySupportHelp params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)getRepairerList:(GetRepairerListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiGetRepairerList params:params additionalHeader:nil response:requestCallBackBlock];
}

-(void)assignEngineer:(AssignEngineerInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiAssignEngineer params:params additionalHeader:nil response:requestCallBackBlock];
}

-(void)queryBulletList:(QueryBulletListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiQueryBulletinList params:params additionalHeader:nil response:requestCallBackBlock];
}

-(void)queryBulletinDetails:(QueryBulletinDetailsInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiQueryBulletinDetails params:params additionalHeader:nil response:requestCallBackBlock];
}

-(void)getTopBulletListWithResponse:(RequestCallBackBlock)requestCallBackBlock
{
    [self.netClient get:ServerApiGetTopBulletinList params:nil additionalHeader:nil response:requestCallBackBlock];
}

-(void)getQiniuUploadTokenWithResponse:(RequestCallBackBlock)requestCallBackBlock
{
    [self.netClient get:ServerApiGetQiniuUploadToken params:nil additionalHeader:nil response:requestCallBackBlock];
}

- (void)getQuestionnaireSurveyWithResponse:(RequestCallBackBlock)requestCallBackBlock
{
    [self.netClient get:ServerApiGetQuestionnaireSurvey params:nil additionalHeader:nil response:requestCallBackBlock];
}

-(void)submitFeedback:(SubmitFeedbackInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiSubmitFeedback params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)facilitator_appointmentOrder:(AppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    
    [self.netClient post:ServerApiAppointmentOrder params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)facilitator_changeAppointmentOrder:(ChangeAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];

    [self.netClient post:ServerApiChangeAppointmentOrder params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)editFeeOrder:(EditFeeOrderInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiEditFeeOrder params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)deleteFeeOrder:(DeleteFeeOrderInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiDeleteFeeOrder params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)deleteAllFeeOrder:(DeleteAllFeeOrderInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiDeleteAllFeeOrder params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)syncFeeBillList:(SyncFeeBillListInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiSyncFeeBillList params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)queryFeeBillStatus:(QueryFeeBillStatusInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiQueryFeeBillStatus params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)repairerManageList:(RepairerMangerListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiRepairerManagerList params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)facilitator_newRepairer:(NewRepairerInputParams *)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    
    [self.netClient post:ServerApiNewRepairer params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)partTracklist:(PartTracklistInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiPartTracklist params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)setPartTraceStatus:(SetPartTraceStatusInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiSetPartTraceStatus params:params additionalHeader:nil response:requestCallBackBlock];
}


- (void)queryExpenseList:(ExpenseListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiQueryExpenseList params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)agreeOrderUrge:(AgreeUrgeInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiAgreeOrderUrge params:params additionalHeader:nil response:requestCallBackBlock];
}

-(void)repairSignIn:(RepairSignInInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiRepairSignIn params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)getMachineCategory:(MachineCategoryInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiGetMachineCategory params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)repairFinishBill:(FinishBillInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiFinishBill params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)repairSpecialFinishBill:(SpecialFinishBillInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiSpecialFinishBill params:params additionalHeader:nil response:requestCallBackBlock];
}

-(void)setJdIdentifyImageUploadStatus:(JdIdentifyImageUploadStatusInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiJdIdentiyUploadImageStatus params:params additionalHeader:nil response:requestCallBackBlock];
}

//创建或编辑单品延保单
- (void)editSingleExtendServiceOrder:(SingleExtendOrderEditInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    BOOL isEContract = [input.econtract isEqualToString:@"1"];
    NSString *postUrl = isEContract ? ServerApiEditEContractSingleExtendServiceOrder : ServerApiEditSingleExtendServiceOrder;

    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:postUrl params:params additionalHeader:nil response:requestCallBackBlock];
}

//创建或编辑多品延保单
- (void)editMutiExtendServiceOrder:(MutiExtendOrderEditInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    BOOL isEContract = [input.econtract isEqualToString:@"1"];
    NSString *postUrl = isEContract ? ServerApiEditEContractMutiExtendServiceOrder : ServerApiEditMutiExtendServiceOrder;

    [self.netClient post:postUrl params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)extendOrderList:(ExtendOrderListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiGetExtendOrderList params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)deleteExtendOrder:(DeleteExtendOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiDeleteExtendOrder params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)extendOrderDetails:(ExtendOrderDetailsInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiGetExtendOrderDetails params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)findMachineModel:(FindMachineModelInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiFindMachineModel params:params additionalHeader:nil response:requestCallBackBlock];
}

-(void)repairer_orderList:(RepairOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];

    [self.netClient get:ServerApiGetRepairOrderList params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)repairer_selectParts:(RepairerSelectPartsInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    input.querystep = @"10";
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiRepairSelectParts params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)repairer_partTypes:(RepairerPartTypesInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    input.querystep = @"20";
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiRepairSelectParts params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)repairer_partList:(RepairerPartListInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    input.querystep = @"30";
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiRepairSelectParts params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)repairer_partFindInfo:(RepairerPartGetInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    input.querystep = @"40";
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiRepairSelectParts params:params additionalHeader:nil response:requestCallBackBlock];
}

//添加组件信息
- (void)repairer_addPart:(RepairerAddPartInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    input.operate_type = @"-2";

    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiRepairOperateParts params:params additionalHeader:nil response:requestCallBackBlock];
}

//删除组件信息
- (void)repairer_deletePart:(RepairerDeletePartInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
#if 1
    input.operate_type = @"-1";

    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiRepairOperateParts params:params additionalHeader:nil response:requestCallBackBlock];
#else
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:input.dispatchparts_id forKey:@"dispatchparts_id"];
    [params setObject:@"unusedobjectid" forKey:@"object_id"];

    [self.netClient post:@"/repairman/deleteParts/" params:params additionalHeader:nil response:requestCallBackBlock];
#endif
}

//更新组件信息
- (void)repairer_updatePart:(RepairerUpdatePartInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    input.operate_type = @"-3";

    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiRepairOperateParts params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)repairer_getPartsInfo:(GetPartsInfoInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiGetPartInfo params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)repairer_appointmentOrder:(RepairerAppointmentOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiRepairerAppointmentOrder params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)repairer_confirmSupport:(ConfirmSupportInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiRepairerConfirmSupportOrder params:params additionalHeader:nil response:requestCallBackBlock];
}

-(void)facilitator_orderList:(FacilitatorOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiGetSvcProviderOrderList params:params additionalHeader:nil response:requestCallBackBlock];
}

-(void)facilitator_serviceImproveList:(ServiceImproveListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiGetServiceImproveList params:params additionalHeader:nil response:requestCallBackBlock];
}

-(void)supporter_orderList:(SupporterOrderListInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiGetSupporterOrderList params:params additionalHeader:nil response:requestCallBackBlock];
}

-(void)supporter_accept:(SupporterAcceptInPutParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiSupporterAcceptTask params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)getCHIQAirConditioningInfo:(NSString*)machineBarCode response:(RequestCallBackBlock)requestCallBackBlock
{
    NSString *reqUrlStr;

    //配置服务器地址
#if (Build_For_Release)
    reqUrlStr = @"http://chiq2.chiq-cloud.com/chiq2/api/v2/wggBarcode/getFromDb/";
#else
    reqUrlStr = @"http://58.220.10.10/chiq2/api/v2/wggBarcode/getFromDb/";
#endif
    reqUrlStr = [NSString stringWithFormat:@"%@%@", reqUrlStr, machineBarCode];
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [sessionManager GET:reqUrlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        HttpResponseData *response = [[HttpResponseData alloc]init];
        response.resultCode = kHttpReturnCodeSuccess;
        response.resultData = responseObject;
        requestCallBackBlock(nil, response);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        HttpResponseData *response = [[HttpResponseData alloc]init];
        response.resultCode = kHttpReturnCodeErrorNet;
        response.resultInfo = error.localizedDescription;
        requestCallBackBlock(error, response);
    }];
}

- (void)queryActivityContentDetail:(QueryActivityContentDetailInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient get:ServerApiQueryActivityContentDetail params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)getWeixinCommentQrCode:(WeixinCommentQrCodeInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiGetWeixinCommentQrCode params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)getExtendPayOrderInfo:(ExtendPayOrderInfoInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiGetExtendPayOrderInfo params:params additionalHeader:nil response:requestCallBackBlock];
}


- (void)saveImageInfos:(SaveImageInfosInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiSaveImageInfos params:params additionalHeader:nil response:requestCallBackBlock];
}

#pragma mark - Facilitator API

- (void)facilitator_refuseOrder:(RefuseOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiFacilitatorRefuseOrder params:params additionalHeader:nil response:requestCallBackBlock];
}

#pragma mark - Repairer API

- (void)repairer_refuseOrder:(RepairRefuseOrderInputParams*)input response:(RequestCallBackBlock)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];
    [self.netClient post:ServerApiRepairerRefuseOrder params:params additionalHeader:nil response:requestCallBackBlock];
}

- (void)uploadImage:(UIImage*)image toPath:(NSString*)path response:(RequestCallBackBlock)requestCallBackBlock
{
    NSData *imageData = UIImagePNGRepresentation(image);
    [self.netClient upload:path imageData:imageData response:requestCallBackBlock];
}

- (void)searchOrders:(SearchOrdersInputParams*)input response:(RequestCallBackBlockV2)requestCallBackBlock
{
    NSDictionary *params = [NSDictionary dictionaryFromPropertyObject:input];

    [self.netClient get:ServerApiSearchOrders params:params additionalHeader:nil response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *orderItems;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            orderItems = [MiscHelper parserOrderList:responseData.resultData];
        }
        requestCallBackBlock(error, responseData, orderItems);
    }];
}

@end
