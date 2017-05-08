//
//  SmartMiModel.m
//  ServiceManager
//
//  Created by Wu on 17/3/27.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "SmartMiModel.h"

#import "DataModelEntities.h"
#import "ConfigInfoManager.h"

@implementation SmartMiModel

@end


@implementation SmartMiEmployeeInfo

@end

@implementation SmartMiRepairerInfo
@end

@implementation SmartMiMyRepairerBaseInfo
@end




@implementation SmartMiOrderContentModel
- (NSString *) customerFullAddress {
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
// 根据工单 status 确定该工单属于哪些类型（新工单...）
- (NSArray *) orderStatusSet {
    return [MiscHelper getOrderStatusGroupsBy:self.status isReceive:self.isReceive workerId:self.workerId];
}

// 判断该工单是否是某种类型（新工单...）
- (BOOL) isOrderStatus:(NSInteger)orderStatus {
    return [self.orderStatusSet containsObject:@(orderStatus)];
}
@end

@implementation SmartMiPartsContentInfo
@end

@implementation SmartMiPartMaintainContent

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

@implementation SmartMiProductModelDes

@end

@implementation SmartMiOrderContentDetails

- (NSString *) customerFullAddress {
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

- (NSString *) customerFullCountyAddress {
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

- (NSString *) productIdStr {
    assert(0);
    assert(1);
    return [MiscHelper productTypeCodeForValue:self.productType];
}

- (NSString *) categroyIdStr {
    return [MiscHelper productCategoryCodeForValue:self.category];
}

@end

@implementation SmartMiSupporterOrderContent
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


@implementation SmartMiOrderTraceInfos
@end

@implementation SmartMiExtendServiceOrderContent

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

@implementation SmartMiExtendProductContent
@end

@implementation SmartMiExtendCustomerInfo
@end


@implementation SmartMiAdditionalBusinessItem
@end

@implementation SmartMiSellFeeListInfos
-(CGFloat)totalPrice{
    if (nil != _netValue && nil != _quantity) {
        return [_netValue floatValue] * [_quantity floatValue];
    }
    return 0;
}
@end

@implementation SmartMiDeviceInfos
@end



