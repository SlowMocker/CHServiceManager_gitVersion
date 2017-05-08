//
//  DataModelEntities.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-11.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "DataModelEntities.h"
#import "ConfigInfoManager.h"

#pragma mark - Part 1 , Common Interface Params

@implementation StreetInfo
@end

@implementation EmployeeInfo
-(instancetype)initWithLetv:(LetvEmployeeInfo*)letvEmployee
{
    self = [super init];
    if (self) {
        self.supportman_id = letvEmployee.supporterId;
        self.supportman_name = letvEmployee.supporterName;
        self.supportman_phone = letvEmployee.supporterPhone;
        self.supportman_type = letvEmployee.supporterType;
        self.supporttask_total = letvEmployee.supportTaskNum;
    }
    return self;
}
@end

@implementation RepairerInfo
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self) {
        if ([dic containsKey:@"repairman_ lo"]) {
            self.repairman_lo = dic[@"repairman_ lo"];
        }
    }
    return self;
}
-(instancetype)initWithLetvRepairerInfo:(LetvRepairerInfo*)letvRepairer
{
    self = [super init];
    if (self) {
        self.repairman_id = letvRepairer.repairManId;
        self.repairman_name = letvRepairer.repairManName;
        self.repairman_phone = letvRepairer.repairManTel;
        self.customer_la = letvRepairer.customerLat;
        self.customer_lo = letvRepairer.customerLon;
        self.repairman_address = letvRepairer.repairManAddr;
    }
    return self;
}

- (instancetype) initWithSmartMiRepairerInfo:(SmartMiRepairerInfo*)smRepairer {
    self = [super init];
    if (self) {
        self.repairman_id = smRepairer.repairManId;
        self.repairman_name = smRepairer.repairManName;
        self.repairman_phone = smRepairer.repairManTel;
        self.customer_la = smRepairer.customerLat;
        self.customer_lo = smRepairer.customerLon;
        self.repairman_address = smRepairer.repairManAddr;
    }
    return self;
}

@end

@implementation MyRepairerBaseInfo
@end

@implementation OrderContent
@end

@implementation BulletinInfo
- (BOOL)isTop{
    return ((nil != _top) && [_top boolValue]);
}

- (NSString*)createTimeText{
    NSString *createDateStr = @"创建时间未知";
    if (![Util isEmptyString:_createTime]) {
        NSDate *createDate = [Util dateWithString:_createTime format:WZDateStringFormat9];
        NSString *showFormat = WZDateStringFormat7;
        if ([createDate isThisYear]) {
            if ([createDate isToday]) {
                showFormat = WZDateStringFormat11;
            }else {
                showFormat = WZDateStringFormat8;
            }
        }
        createDateStr = [NSString dateStringWithDate:createDate strFormat:showFormat];
    }
    return createDateStr;
}
@end

@implementation OrderContentModel
- (NSString*)customerFullAddress{
    NSString *tempAddr = @"";
    
    if (![Util isEmptyString:self.regiontxt]) {
        tempAddr = [tempAddr appendStr:self.regiontxt];
    }
    if (![Util isEmptyString:self.city1]) {
        tempAddr = [tempAddr appendStr:self.city1];
    }
    if (![Util isEmptyString:self.city2]) {
        tempAddr = [tempAddr appendStr:self.city2];
    }
    if (![Util isEmptyString:self.street]) {
        tempAddr = [tempAddr appendStr:self.street];
    }
    if (![Util isEmptyString:self.str_suppl1]) {
        tempAddr = [tempAddr appendStr:self.str_suppl1];
    }
    return tempAddr;
}
- (NSArray*)orderStatusSet
{
    return [MiscHelper getOrderStatusGroupsBy:self.status isReceive:self.wxg_isreceive workerId:self.partner_fwg];
}

- (BOOL)isOrderStatus:(NSInteger)orderStatus
{
    return [self.orderStatusSet containsObject:@(orderStatus)];
}
@end

@implementation PartsContentInfo
@end

@implementation PartMaintainContent

-(BOOL)bAffectPerformOrder{
    BOOL bAffect = NO;
    if ([self.puton_status isEqualToString:@"2"]
        ||[self.puton_status isEqualToString:@"6"]
        ||[self.puton_status isEqualToString:@"7"]) {
        bAffect = YES;
    }
    return bAffect;
}
@end

@implementation ProductModelDes
-(instancetype)initWithLetv:(LetvProductModelDes*)letvProductModel
{
    self = [super init];
    if (self) {
        self.product_id = letvProductModel.model;
        self.short_text = letvProductModel.modelDesc;
        self.zz0017 = letvProductModel.category;
        self.zz0018 = letvProductModel.brand;
        self.zzfld000003 = letvProductModel.productType;
    }
    return self;
}

- (instancetype) initWithSmartMi:(SmartMiProductModelDes *)smartMiProductModel {
    self = [super init];
    if (self) {
        self.product_id = smartMiProductModel.model;
        self.short_text = smartMiProductModel.modelDesc;
        self.zz0017 = smartMiProductModel.category;
        self.zz0018 = smartMiProductModel.brand;
        self.zzfld000003 = smartMiProductModel.productType;
    }
    return self;
}

@end

@implementation OrderContentDetails

- (NSString*)customerFullAddress{
    NSString *tempAddr = @"";

    if (![Util isEmptyString:self.regiontxt]) {
        tempAddr = [tempAddr appendStr:self.regiontxt];
    }
    if (![Util isEmptyString:self.city1]) {
        tempAddr = [tempAddr appendStr:self.city1];
    }
    if (![Util isEmptyString:self.city2]) {
        tempAddr = [tempAddr appendStr:self.city2];
    }
    if (![Util isEmptyString:self.street]) {
        tempAddr = [tempAddr appendStr:self.street];
    }
    if (![Util isEmptyString:self.str_suppl1]) {
        tempAddr = [tempAddr appendStr:self.str_suppl1];
    }
    return tempAddr;
}

- (NSString*)customerFullCountyAddress{
    NSString *tempAddr = @"";

    if (![Util isEmptyString:self.regiontxt]) {
        tempAddr = [tempAddr appendStr:self.regiontxt];
    }
    if (![Util isEmptyString:self.city1]) {
        tempAddr = [tempAddr appendStr:self.city1];
    }
    if (![Util isEmptyString:self.city2]) {
        tempAddr = [tempAddr appendStr:self.city2];
    }

    return tempAddr;
}

-(BOOL)isAirConditioning{
    return [self.zzfld000003 isEqualToString:@"空调"];
}

-(BOOL)isTV{
    return [self.zzfld000003 isEqualToString:@"彩电"];
}

-(NSString*)brandIdStr{
    return [MiscHelper productBrandCodeForValue:self.zzfld000000];
}
-(NSString*)productIdStr{
    return [MiscHelper productTypeCodeForValue:self.zzfld000003];
}
-(NSString*)categroyIdStr{
    return [MiscHelper productCategoryCodeForValue:self.zzfld000001];
}
- (kProductType)productType{
    if (self.isAirConditioning) {
        if ([self.brandIdStr isEqualToString:@"CH"]) {
            return kProductTypeChangHongAirConditioning;
        }else if([self.brandIdStr isEqualToString:@"CHIQ"]){
            return kProductTypeChiqAirConditioning;
        }else if ([self.brandIdStr isEqualToString:@"XZYY"]){
            return kProductTypeYingYanAirConditioning;
        }
    }else if (self.isTV){
        if ([self.brandIdStr isEqualToString:@"CH"]) {
            return kProductTypeChangHongTV;
        }else if([self.brandIdStr isEqualToString:@"CHIQ"]){
            return kProductTypeChiqTV;
        }else if ([self.brandIdStr isEqualToString:@"SY"]){
            return kProductTypeSanYoTV;
        }
    }
    return kProductTypeOther;
}
@end

@implementation SupporterOrderContent
-(instancetype)initWithLetv:(LetvSupporterOrderContent*)supportInfo{
    self = [super init];
    if (self) {
        self.acceptTime = supportInfo.acceptTime;
        self.applyTime = supportInfo.applyTime;
        self.confirmTime = supportInfo.confirmTime;
        self.content = supportInfo.content;
        self.score = supportInfo.score;
        self.status = supportInfo.status;
        self.Id = supportInfo.Id;
        self.supporterId = supportInfo.supporterId;
        self.supporterName = supportInfo.supporterName;
        self.supporterPhone = supportInfo.supporterPhone;
        self.workerId = supportInfo.workerId;
        self.workerName = supportInfo.workerName;
        self.workerPhone = supportInfo.workerPhone;
        self.dispatch_id = supportInfo.dispatchInfoId;
        self.objectId = supportInfo.objectId;
        self.regiontxt = supportInfo.province;
        self.city1 = supportInfo.city;
        self.city2 = supportInfo.county;
        self.street = supportInfo.street;
        self.str_suppl1 = supportInfo.detailAddr;
        self.zzfld000000 = supportInfo.brand;
        self.zzfld000003 = supportInfo.productType;
        self.zzfld000001 = supportInfo.category;
        self.zzfld00000q = supportInfo.model;
        self.order_type = supportInfo.orderType;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self) {
        if ([dic containsKey:@"supportInfoId"]) {
            self.Id = [dic objForKey:@"supportInfoId"];
        }
    }
    return self;
}

- (NSString*)customerFullAddress{
    NSString *tempAddr = @"";
    
    if (![Util isEmptyString:self.regiontxt]) {
        tempAddr = [tempAddr appendStr:self.regiontxt];
    }
    if (![Util isEmptyString:self.city1]) {
        tempAddr = [tempAddr appendStr:self.city1];
    }
    if (![Util isEmptyString:self.city2]) {
        tempAddr = [tempAddr appendStr:self.city2];
    }
    if (![Util isEmptyString:self.street]) {
        tempAddr = [tempAddr appendStr:self.street];
    }
    if (![Util isEmptyString:self.str_suppl1]) {
        tempAddr = [tempAddr appendStr:self.str_suppl1];
    }
    return tempAddr;
}
@end

@implementation LetvSupporterOrderContent
- (NSString*)customerFullAddress{
    NSString *tempAddr = @"";
    
    if (![Util isEmptyString:self.province]) {
        tempAddr = [tempAddr appendStr:self.province];
    }
    if (![Util isEmptyString:self.city]) {
        tempAddr = [tempAddr appendStr:self.city];
    }
    if (![Util isEmptyString:self.county]) {
        tempAddr = [tempAddr appendStr:self.county];
    }
    if (![Util isEmptyString:self.street]) {
        tempAddr = [tempAddr appendStr:self.street];
    }
    if (![Util isEmptyString:self.detailAddr]) {
        tempAddr = [tempAddr appendStr:self.detailAddr];
    }
    return tempAddr;
}
@end

@implementation OrderTraceInfos
@end

@implementation ExtendServiceOrderContent

- (BOOL)editable{
    BOOL isEContract = (1 == [self.econtract integerValue]);
    BOOL canEdit = NO;
    if (isEContract) {
        if ([self.status isEqualToString:@"SC20"]) {
            canEdit = YES;
        }
    }else {
        if ([self.status isEqualToString:@"SC30"]) {
            canEdit = YES;
        }
    }
    return canEdit;
}

@end

@implementation ExtendProductContent
@end

@implementation ExtendCustomerInfo
@end

@implementation AppVersionInfo
@end

@implementation AdditionalBusinessItem
@end

@implementation SellFeeListInfos
-(instancetype)initWithLetvSellFeeListInfos:(LetvSellFeeListInfos*)feeItem
{
    self =[super init];
    if (self) {
        self.Id = feeItem.Id;
        self.orderedProd = feeItem.bomCode;
        self.prodDescription = feeItem.Description;
        self.quantity = feeItem.quantity;
        self.netValue = feeItem.unitPrice;
        self.zzfld00002v = feeItem.receiptNum;
        self.zzfld00005e = feeItem.classify;
        self.createTime = feeItem.createTime;
        self.itmType = feeItem.itmType;
        self.dispatchId = feeItem.dispatchInfoId;
        self.objectId = feeItem.objectId;
        self.isSendtoCrm = feeItem.isSend2Crm;
    }
    return self;
}

-(CGFloat)totalPrice{
    if (nil != _netValue && nil != _quantity) {
        return [_netValue floatValue] * [_quantity floatValue];
    }
    return 0;
}
@end

@implementation DeviceInfos
@end

@implementation CHIQYunAirConditioningInfos
@end

#pragma mark - Part 2 , Letv Interface Params


@implementation LetvOrderContentModel
-(NSString*)customerFullAddress{
    NSString *tempAddr = @"";

    if (![Util isEmptyString:self.province]) {
        tempAddr = [tempAddr appendStr:self.province];
    }
    if (![Util isEmptyString:self.city]) {
        tempAddr = [tempAddr appendStr:self.city];
    }
    if (![Util isEmptyString:self.county]) {
        tempAddr = [tempAddr appendStr:self.county];
    }
    if (![Util isEmptyString:self.town]) {
        tempAddr = [tempAddr appendStr:self.town];
    }
    if (![Util isEmptyString:self.street]) {
        tempAddr = [tempAddr appendStr:self.street];
    }
    if (![Util isEmptyString:self.detailAddr]) {
        tempAddr = [tempAddr appendStr:self.detailAddr];
    }

    return tempAddr;
}

- (NSArray*)orderStatusSet
{
    return [MiscHelper getOrderStatusGroupsBy:self.status isReceive:self.isReceive workerId:self.workerId];
}

- (BOOL)isOrderStatus:(NSInteger)orderStatus
{
    return [self.orderStatusSet containsObject:@(orderStatus)];
}
@end

@implementation LetvOrderContentDetails

- (NSString*)customerFullCountyAddress
{
    NSString *tempAddr = @"";
    
    if (![Util isEmptyString:self.province]) {
        tempAddr = [tempAddr appendStr:self.province];
    }
    if (![Util isEmptyString:self.city]) {
        tempAddr = [tempAddr appendStr:self.city];
    }
    if (![Util isEmptyString:self.county]) {
        tempAddr = [tempAddr appendStr:self.county];
    }
    return tempAddr;
}

-(NSString*)customerFullAddress{
    NSString *tempAddr = self.customerFullCountyAddress;

    if (![Util isEmptyString:self.town]) {
        tempAddr = [tempAddr appendStr:self.town];
    }
    if (![Util isEmptyString:self.street]) {
        tempAddr = [tempAddr appendStr:self.street];
    }
    if (![Util isEmptyString:self.detailAddr]) {
        tempAddr = [tempAddr appendStr:self.detailAddr];
    }
    
    return tempAddr;
}

- (NSString*)serviceReqTypeVal
{
    ConfigItemInfo *reqTypeItem =
    [[ConfigInfoManager sharedInstance]findConfigItemInfoByType:MainConfigInfoTableType109 code:self.serviceReqType];
    return reqTypeItem.value;
}

- (SupporterOrderContent*)supportInfo{
    SupporterOrderContent *support = [SupporterOrderContent new];

    support.acceptTime = self.acceptTime;
    support.applyTime = self.applyTime;
    support.confirmTime = self.confirmTime;
    support.content = self.content;
    support.score = self.score;
    support.status = self.supprotStatus;
    support.Id = self.supportInfoId;
    support.supporterId = self.supporterId;
    support.supporterName = self.supporterName;
    support.supporterPhone = self.supporterPhone;
    support.workerId = self.workerId;
    support.workerName = self.workerName;
    //support.workerPhone = orderDetail.???
    support.dispatch_id = self.Id.description;
    support.objectId = self.objectId;
    support.regiontxt = self.province;
    support.city1 = self.city;
    support.city2 = self.county;
    support.street = self.street;
    support.str_suppl1 = self.detailAddr;
    support.zzfld000000 = self.brand;
    support.zzfld000003 = self.productType;
    support.zzfld000001 = self.category;
    support.zzfld00000q = self.model;
    support.order_type = self.orderType;
    
    return support;
}
@end

@implementation LetvRepairerInfo
@end

@implementation LetvProductModelDes
@end

@implementation LetvEmployeeInfo
@end

@implementation LetvSellFeeListInfos
-(CGFloat)totalPrice{
    if (nil != _unitPrice && nil != _quantity) {
        return [_unitPrice floatValue] * [_quantity floatValue];
    }
    return 0;
}
@end

@implementation LetvBomContent
@end

@implementation OrderFilterConditionItems
- (void)cleanItemsData
{
    _brands = @"";
    _productTypes = @"";
    _orderTypes = @"";
}
@end

@implementation QuestionnaireSurvey
- (NSString*)surveyEntityId{
    return [NSString stringWithFormat:@"%@_%@", _surveyUrl, _enabledTime];
}
@end

@implementation PushMessageContent
@end

@implementation ExtendOrderPaymentInfo
@end

