//
//  ConfigInfoManager.m
//  HouseMarket
//
//  Created by wangzhi on 15-8-20.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ConfigInfoManager.h"
#import "HttpClientManager.h"
#import "HttpClientManager+Letv.h"
#import "SideBarEntity.h"
#import "ConfigItemInfo.h"
#import "MagicalRecordHelper.h"

@interface ConfigInfoManager()
@end

@implementation ConfigInfoManager

+ (instancetype)sharedInstance
{
    static ConfigInfoManager *sConfigManager = nil;
    static dispatch_once_t sOnceToken;
    dispatch_once(&sOnceToken, ^{
        sConfigManager = [[ConfigInfoManager alloc]init];
    });
    return sConfigManager;
}

- (void)loadConfigInfosIfNoData
{
    if (!self.hasLoadedMainInfo) {
        [self updateConfigInfosWithWaitingDialog:NO];
        DLog(@"Loading config infos");
    }else {
        DLog(@"Config infos has loaded");
    }
}
//updatedate + 3 > today , update > today - 3
- (void)updateConfigInfosIfNeed
{
    if (!self.hasLoadedMainInfo) {
        [self updateConfigInfosWithWaitingDialog:NO];
        DLog(@"Loading config infos");
    }else {
        NSDate *lastUpdateDate = [UserDefaults sharedInstance].mainInfoUpdateDate;
        if ([[NSDate dateWithDaysBeforeNow:3] isLaterThanDate:lastUpdateDate]) {
            //超过3天未更新，且WIFI网络下
            AFNetworkReachabilityManager *reachabilityMgr = [AFNetworkReachabilityManager sharedManager];
            if (AFNetworkReachabilityStatusReachableViaWiFi == reachabilityMgr.networkReachabilityStatus) {
                [self updateConfigInfosWithWaitingDialog:NO];
            }
        }
        DLog(@"Config infos has loaded");
    }
}

- (NSArray*)getConfigItemTypes
{
    NSMutableArray *configTypes = [NSMutableArray new];
    [configTypes addObject:MainConfigInfoTableType1];
    [configTypes addObject:MainConfigInfoTableType2];
    [configTypes addObject:MainConfigInfoTableType3];
    [configTypes addObject:MainConfigInfoTableType4];
    [configTypes addObject:MainConfigInfoTableType5];
    [configTypes addObject:MainConfigInfoTableType6];
    [configTypes addObject:MainConfigInfoTableType7];
    [configTypes addObject:MainConfigInfoTableType8];
    [configTypes addObject:MainConfigInfoTableType9];
    [configTypes addObject:MainConfigInfoTableType10];
    [configTypes addObject:MainConfigInfoTableType10_1];
    [configTypes addObject:MainConfigInfoTableType11];
    [configTypes addObject:MainConfigInfoTableType12];
    [configTypes addObject:MainConfigInfoTableType13];
    [configTypes addObject:MainConfigInfoTableType14];
    [configTypes addObject:MainConfigInfoTableType15];
    [configTypes addObject:MainConfigInfoTableType16];
    [configTypes addObject:MainConfigInfoTableType17];
    [configTypes addObject:MainConfigInfoTableType18];
    [configTypes addObject:MainConfigInfoTableType19];
    [configTypes addObject:MainConfigInfoTableType20];
//    [configTypes addObject:MainConfigInfoTableType21];
    [configTypes addObject:MainConfigInfoTableType22];
    [configTypes addObject:MainConfigInfoTableType23];
    [configTypes addObject:MainConfigInfoTableType24];
    [configTypes addObject:MainConfigInfoTableType25];
    [configTypes addObject:MainConfigInfoTableType26];
    [configTypes addObject:MainConfigInfoTableType27];
    [configTypes addObject:MainConfigInfoTableType28];
    [configTypes addObject:MainConfigInfoTableType29];
    [configTypes addObject:MainConfigInfoTableType30];
    [configTypes addObject:MainConfigInfoTableType31];
    [configTypes addObject:MainConfigInfoTableType34];
    [configTypes addObject:MainConfigInfoTableType35];
    [configTypes addObject:MainConfigInfoTableType36];
    [configTypes addObject:MainConfigInfoTableType37];

    [configTypes addObject:MainConfigInfoTableType100];
    [configTypes addObject:MainConfigInfoTableType101];
    [configTypes addObject:MainConfigInfoTableType102];
    [configTypes addObject:MainConfigInfoTableType103];
    [configTypes addObject:MainConfigInfoTableType104];
    [configTypes addObject:MainConfigInfoTableType105];
    [configTypes addObject:MainConfigInfoTableType106];
    [configTypes addObject:MainConfigInfoTableType107];
    [configTypes addObject:MainConfigInfoTableType108];
    [configTypes addObject:MainConfigInfoTableType109];

    return configTypes;
}

- (void)updateConfigInfosWithWaitingDialog:(BOOL)showWaitingDialog
{
    ReturnIf(self.isLoading);

    self.isLoading = YES;
    if (showWaitingDialog) {
        [Util showWaitingDialog];
    }

    NSArray *configItems = [self getConfigItemTypes];
    [[HttpClientManager sharedInstance] getMainInfosByTypes:configItems response:^(NSError *error, HttpResponseData *responseData) {
        if (!error && (kHttpReturnCodeSuccess == responseData.resultCode)) {
            [self cacheMainInfosToLocal:responseData.resultData complete:^(BOOL contextDidSave, NSError *error) {
                self.isLoading = NO;
                if (contextDidSave && !error) {
                    self.hasLoadedMainInfo = YES;
                    [UserDefaults sharedInstance].mainInfoUpdateDate = [NSDate date];
                    [self postNotification:NotificationMainConfigInfoUpdated];
                    if (showWaitingDialog) {
                        [Util dismissWaitingDialog];
                        [Util showToast:@"更新成功"];
                    }
                }else {
                    DLog(@"save main data error: %@", error.localizedDescription);
                }
            }];
        }else {
            self.isLoading = NO;
            [self postNotification:NotificationMainConfigInfoUpdateFailed];
            if (showWaitingDialog) {
                [Util dismissWaitingDialog];
                [Util showErrorToastIfError:responseData otherError:error];
            }
        }
    }];
}

- (BOOL)cacheMainInfosToLocal:(NSArray*)configItemArray complete:(MRSaveCompletionHandler)completion
{
    ReturnIf(!configItemArray || ![configItemArray isKindOfClass:[NSArray class]] || configItemArray.count <= 0)NO;

    //remove old first
    [ConfigItemInfo MR_truncateAll];
    
    //insert new
    ConfigItemInfo *configItem;
    for (NSDictionary *dic in configItemArray) {
        configItem = [ConfigItemInfo MR_createEntity];
        configItem.code = [dic objForKey:@"code"];
        configItem.value = [dic objForKey:@"val"];
        configItem.superCode = [dic objForKey:@"supercode"];
        configItem.superParentCode = [dic objForKey:@"superparentcode"];
        configItem.itemId = [NSString intStr:[dic integerForKey:@"id"]];
        configItem.type = [dic objForKey:@"type"];
    }
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreWithCompletion:completion];
    
    return YES;
}

- (void)setBSavePassword:(BOOL)bSavePassword
{
    NSNumber *booNum = [NSNumber numberWithBool:bSavePassword];
    [UserDefaults saveObject:booNum forKey:UserDefaultKeySavePassword];
}

- (BOOL)bSavePassword
{
    NSNumber *boolNum = (NSNumber*)[UserDefaults restoreObjectForKey:UserDefaultKeySavePassword];
    return boolNum ? [boolNum boolValue] : YES; //default is save
}

- (void)setHasLoadedMainInfo:(BOOL)hasLoadedMainInfo
{
    NSNumber *booNum = [NSNumber numberWithBool:hasLoadedMainInfo];
    [UserDefaults saveObject:booNum forKey:UserDefaultKeyHasLoadedMainInfo];
}

- (BOOL)hasLoadedMainInfo
{
    NSNumber *boolNum = (NSNumber*)[UserDefaults restoreObjectForKey:UserDefaultKeyHasLoadedMainInfo];
    return boolNum ? [boolNum boolValue] : NO;
}

#pragma mark - get config items

- (NSArray*)brands
{
    return [self findConfigItemsByType:MainConfigInfoTableType1];
}

- (NSArray*)refueseReasons
{
    return [self findConfigItemsByType:MainConfigInfoTableType5];
}

- (NSArray*)appointmentFailureReasons
{
    return [self findConfigItemsByType:MainConfigInfoTableType6];
}

-(NSArray *)productsOfBrand:(NSString*)brandId
{
    return [self findConfigItemsByType:MainConfigInfoTableType2 superCode:brandId];
}

-(NSArray *)subProductsOfProduct:(NSString*)productId
{
    return [self findConfigItemsByType:MainConfigInfoTableType3 superCode:productId];
}

- (NSArray*)subProductsOfTV
{
    return [self subProductsOfProduct:@"TV0010"];
}

-(NSArray *)mutiExtendServiceProductTypes
{
    return [self findConfigItemsByType:MainConfigInfoTableType30];
}

- (NSArray*)extendServiceBrands
{
    return [self findConfigItemsByType:MainConfigInfoTableType1001];
}

- (NSString*)productCodeOfSubProduct:(NSString*)subProductCode
{
    ConfigItemInfo *subProductItem = [self findConfigItemInfoByType:MainConfigInfoTableType3 code:subProductCode];
    return subProductItem.superCode;
}

-(NSArray *)solutionsOfProduct:(NSString*)productId
{
    return [self findConfigItemsByType:MainConfigInfoTableType8];
}

- (NSArray *)normalSolutionsOfProduct:(NSString*)productId isNew:(BOOL)isNew
{
    if (isNew) {
        return [self newMachineSolutionsOfProduct:productId];
    }else {
        NSArray *solutions = [self solutionsOfProduct:productId];
        NSArray *specialSolutions = [self specialSolutionsOfProduct:productId];
        NSMutableArray *normalSolutions = [NSMutableArray arrayWithArray:solutions];
        [normalSolutions removeObjectsInArray:specialSolutions];
        return normalSolutions;
    }
}

- (NSArray *)newMachineSolutionsOfProduct:(NSString*)productId
{
    NSArray *solutions = [self solutionsOfProduct:productId];
    NSMutableArray *specialSolutions = [NSMutableArray new];

    NSArray *specialSolutionsCodes = @[@"Z080"];
    for (ConfigItemInfo *solItem in solutions) {
        if ([specialSolutionsCodes containsObject:solItem.code]) {
            [specialSolutions addObject:solItem];
        }
    }
    return specialSolutions;
}

- (NSArray *)specialSolutionsOfProduct:(NSString*)productId
{
    NSArray *solutions = [self solutionsOfProduct:productId];
    NSMutableArray *specialSolutions = [NSMutableArray new];

    NSArray *specialSolutionsCodes = @[@"Z140",
                                       @"Z150",
                                       @"Z130",
                                       @"Z120",
                                       @"Z070",
                                       @"Z030",
                                       @"Z010",
                                       @"Z040",
                                       @"Z020"];
    for (ConfigItemInfo *solItem in solutions) {
        if ([specialSolutionsCodes containsObject:solItem.code]) {
            [specialSolutions addObject:solItem];
        }
    }
    return specialSolutions;
}

-(NSArray *)jdIdentifyResults
{
    return [self findConfigItemsByType:MainConfigInfoTableType28];
}

-(NSArray *)serviceFeeTypes
{
    return [self findConfigItemsByType:MainConfigInfoTableType31];
}

-(NSArray *)smartProductTypes
{
    return [self findConfigItemsByType:MainConfigInfoTableType22];
}

-(NSArray *)smartProductCodes
{
    return [self findConfigItemsByType:MainConfigInfoTableType23];
}

-(NSArray *)issuesOfProduct:(NSString*)productId
{
    return [self findConfigItemsByType:MainConfigInfoTableType9 superCode:productId];
}

-(NSArray *)transactionReasonsOfProduct:(NSString*)productId
{
    return [self findConfigItemsByType:MainConfigInfoTableType24];
}

-(NSArray *)priceRangesOfProduct:(NSString*)productId
{
    NSArray *array = [self findConfigItemsByType:MainConfigInfoTableType25];
    return array;
}

-(NSArray *)componentTypes
{
    return [self findConfigItemsByType:MainConfigInfoTableType22];
}

-(NSArray *)subcomponentTypesOfType:(NSString*)typeId
{
    return [self findConfigItemsByType:MainConfigInfoTableType23 superCode:typeId];
}

-(NSArray *)unfinishedReasons
{
    return [self findConfigItemsByType:MainConfigInfoTableType7];
}

-(NSArray *)abandonReasons
{
    return [self findConfigItemsByType:MainConfigInfoTableType27];
}

-(NSArray *)promotionalActivityNames
{
    return [self findConfigItemsByType:MainConfigInfoTableType34];
}

-(ConfigItemInfo *)promotionalActivityByCode:(NSString*)nameCode
{
    return [self findConfigItemInfoByType:MainConfigInfoTableType34 code:nameCode];
}

-(NSArray *)promotionalActivitySubNamesOf:(NSString*)nameCode
{
    return [self findConfigItemsByType:MainConfigInfoTableType35 superCode:nameCode];
}

-(ConfigItemInfo *)promotionalSubActivityByCode:(NSString*)subNameCode
{
    return [self findConfigItemInfoByType:MainConfigInfoTableType35 code:subNameCode];
}

- (NSArray *)provincesOfChina
{
    return [self findConfigItemsByType:MainConfigInfoTableType18];
}

- (NSArray *)citiesOfProvince:(NSString*)provinceId
{
    return [self findConfigItemsByType:MainConfigInfoTableType19 superCode:provinceId];
}

- (NSArray *)districtsOfCity:(NSString*)cityId
{
    return [self findConfigItemsByType:MainConfigInfoTableType20 superCode:cityId];
}

- (NSArray *)streetsOfDistrict:(NSString*)districtId
{
    return [self findConfigItemsByType:MainConfigInfoTableType21 superCode:districtId];
}

- (NSArray*)issueCategoriesOfProduct:(NSString*)productId brandId:(NSString*)brandId
{
    return [self findConfigItemsByType:MainConfigInfoTableType10 superCode:productId superParentCode:brandId];
}

- (NSArray*)issueCodesOfCategory:(NSString*)categoryId brandId:(NSString*)brandId
{
    return [self findConfigItemsByType:MainConfigInfoTableType10_1 superCode:categoryId superParentCode:brandId];
}

-(NSArray *)orderRepairTypes
{
    NSMutableArray *itemArray = [[NSMutableArray alloc]init];
    
    NSArray *keyItems = @[@"ZRA1", @"ZR01", @"OTHER"];
    NSArray *valueItems = @[@"新机安装", @"上门维修",@"其它"];
    
    for (NSInteger index = 0; index < MIN(keyItems.count, valueItems.count);index++) {
        CheckItemModel *configItem = [CheckItemModel new];
        configItem.key = keyItems[index];
        configItem.value = valueItems[index];
        [itemArray addObject:configItem];
    }
    return itemArray;
}

-(NSArray *)warrantyYearItems
{
    NSMutableArray *itemArray = [[NSMutableArray alloc]init];

    NSArray *keyItems = @[@"YBTV_101", @"YBTV_102", @"YBTV_103"];
    NSArray *yearItems = @[@"一年", @"两年", @"三年"];

    for (NSInteger index = 0; index < MIN(keyItems.count, yearItems.count);index++) {
        CheckItemModel *configItem = [CheckItemModel new];
        configItem.key = keyItems[index];
        configItem.value = yearItems[index];
        [itemArray addObject:configItem];
    }
    return itemArray;
}

-(NSArray *)mutiWarrantyYearItems
{
    NSMutableArray *itemArray = [[NSMutableArray alloc]init];
    
    NSArray *keyItems = @[@"YBQJB_101", @"YBQJB_102"];
    NSArray *yearItems = @[@"一年", @"两年"];

    for (NSInteger index = 0; index < MIN(keyItems.count, yearItems.count);index++) {
        CheckItemModel *configItem = [CheckItemModel new];
        configItem.key = keyItems[index];
        configItem.value = yearItems[index];
        [itemArray addObject:configItem];
    }
    return itemArray;
}

- (NSString *)warrantyYearValueById:(NSString*)yearId
{
    ReturnIf([Util isEmptyString:yearId])nil;

    for (CheckItemModel *model in [self warrantyYearItems]) {
        ReturnIf([yearId isEqualToString:model.key])model.value;
    }
    return nil;
}

- (NSString *)mutiWarrantyYearValueById:(NSString*)yearId
{
    ReturnIf([Util isEmptyString:yearId])nil;
    
    for (CheckItemModel *model in [self mutiWarrantyYearItems]) {
        ReturnIf([yearId isEqualToString:model.key])model.value;
    }
    return nil;
}

-(NSArray*)warrantyItems
{
    NSMutableArray *configItems = [NSMutableArray new];
    KeyValueModel *item;
    
    item = [KeyValueModel modelWithValue:@"保内" forKey:@"10"];
    [configItems addObject:item];
    item = [KeyValueModel modelWithValue:@"保外" forKey:@"20"];
    [configItems addObject:item];
    item = [KeyValueModel modelWithValue:@"延保" forKey:@"30"];
    [configItems addObject:item];
    
    return configItems;
}

#pragma mark - find items api

- (ConfigItemInfo*)findConfigItemInfoByType:(MainConfigInfoTableType)type code:(NSString*)code
{
    ReturnIf([Util isEmptyString:(NSString*)type] || [Util isEmptyString:code])nil;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@ AND code = %@", type, code];
    NSArray *findItems = [ConfigItemInfo MR_findAllSortedBy:@"itemId" ascending:YES withPredicate:predicate];

    return (findItems.count > 0) ? findItems[0] : nil;
}

- (ConfigItemInfo*)findConfigItemInfoByType:(MainConfigInfoTableType)type code:(NSString*)code superCode:(NSString*)superCode superParentCode:(NSString*)superParentCode
{
    ReturnIf([Util isEmptyString:(NSString*)type] || [Util isEmptyString:code] || [Util isEmptyString:superCode] || [Util isEmptyString:superParentCode])nil;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@ AND code = %@ AND superCode = %@ AND superParentCode = %@", type, code, superCode, superParentCode];
    NSArray *findItems = [ConfigItemInfo MR_findAllSortedBy:@"itemId" ascending:YES withPredicate:predicate];
    
    return (findItems.count > 0) ? findItems[0] : nil;
}

- (ConfigItemInfo*)findConfigItemInfoByType:(MainConfigInfoTableType)type value:(NSString*)value
{
    ReturnIf([Util isEmptyString:(NSString*)type] || [Util isEmptyString:value])nil;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@ AND value = %@", type, value];
    NSArray *findItems = [ConfigItemInfo MR_findAllSortedBy:@"itemId" ascending:YES withPredicate:predicate];

    return (findItems.count > 0) ? findItems[0] : nil;
}

- (NSArray*)findConfigItemsByType:(MainConfigInfoTableType)type
{
    return [ConfigItemInfo MR_findByAttribute:@"type" withValue:type andOrderBy:@"itemId" ascending:YES];
}

- (NSArray*)findConfigItemsByType:(MainConfigInfoTableType)type superCode:(NSString*)superCode
{
    ReturnIf([Util isEmptyString:(NSString*)type])nil;

    NSPredicate *predicate;
    if ([Util isEmptyString:superCode]) {
        predicate = [NSPredicate predicateWithFormat:@"type = %@", type];
    }else {
        predicate = [NSPredicate predicateWithFormat:@"type = %@ AND superCode = %@", type, superCode];
    }
    return [ConfigItemInfo MR_findAllSortedBy:@"itemId" ascending:YES withPredicate:predicate];
}

- (NSArray*)findConfigItemsByType:(MainConfigInfoTableType)type superCode:(NSString*)superCode superParentCode:(NSString*)superParentCode
{
    ReturnIf([Util isEmptyString:(NSString*)type])nil;
    
    NSPredicate *predicate;
    do {
        if ([Util isEmptyString:superCode]) {
            predicate = [NSPredicate predicateWithFormat:@"type = %@", type];
            break;
        }
        if ([Util isEmptyString:superParentCode]) {
            predicate = [NSPredicate predicateWithFormat:@"type = %@ AND superCode = %@", type, superCode];
            break;
        }
        predicate = [NSPredicate predicateWithFormat:@"type = %@ AND superCode = %@ And superParentCode = %@", type, superCode, superParentCode];
    } while (NO);
    return [ConfigItemInfo MR_findAllSortedBy:@"itemId" ascending:YES withPredicate:predicate];
}

- (NSString*)getConfigItemValueByType:(MainConfigInfoTableType)type code:(NSString*)code
{
    ConfigItemInfo *cfgItem = [self findConfigItemInfoByType:type code:code];
    return cfgItem.value;
}

- (NSString*)getConfigItemCodeByType:(MainConfigInfoTableType)type value:(NSString*)value
{
    ConfigItemInfo *cfgItem = [self findConfigItemInfoByType:type value:value];
    return cfgItem.code;
}

#pragma mark - Letv Relative

-(NSArray*)letv_issueCodesOfCategory:(NSString *)categoryId brandId:(NSString *)brandId
{
    return [self findConfigItemsByType:MainConfigInfoTableType100];
}

- (NSArray*)letv_bearingWallItems
{
    NSMutableArray *configItems = [NSMutableArray new];
    KeyValueModel *item;
    
    item = [KeyValueModel modelWithValue:@"是" forKey:@"Y"];
    [configItems addObject:item];
    item = [KeyValueModel modelWithValue:@"否" forKey:@"N"];
    [configItems addObject:item];
    item = [KeyValueModel modelWithValue:@"其它" forKey:@"O"];
    [configItems addObject:item];

    return configItems;

//    return [self findConfigItemsByType:MainConfigInfoTableType101];
}

-(NSArray*)letv_rackFromLetvItems
{
    NSMutableArray *configItems = [NSMutableArray new];
    KeyValueModel *item;
    
    item = [KeyValueModel modelWithValue:@"是" forKey:@"Y"];
    [configItems addObject:item];
    item = [KeyValueModel modelWithValue:@"否" forKey:@"N"];
    [configItems addObject:item];
    item = [KeyValueModel modelWithValue:@"其它" forKey:@"O"];
    [configItems addObject:item];
    
    return configItems;
    
//    return [self findConfigItemsByType:MainConfigInfoTableType102];
}

-(NSArray*)letv_warrantyItems
{
    NSMutableArray *configItems = [NSMutableArray new];
    KeyValueModel *item;
    
    item = [KeyValueModel modelWithValue:@"保内" forKey:@"10"];
    [configItems addObject:item];
    item = [KeyValueModel modelWithValue:@"保外" forKey:@"20"];
    [configItems addObject:item];

    return configItems;

//    return [self findConfigItemsByType:MainConfigInfoTableType103];
}

-(NSArray*)letv_installWayItems
{
    NSMutableArray *configItems = [NSMutableArray new];
    KeyValueModel *item;

    item = [KeyValueModel modelWithValue:@"座架" forKey:@"10"];
    [configItems addObject:item];
    item = [KeyValueModel modelWithValue:@"挂架" forKey:@"20"];
    [configItems addObject:item];
    item = [KeyValueModel modelWithValue:@"未安装" forKey:@"30"];
    [configItems addObject:item];
    
    return configItems;

//    return [self findConfigItemsByType:MainConfigInfoTableType104];
}

-(NSArray*)letv_networkTypes
{
    return [self findConfigItemsByType:MainConfigInfoTableType105];
}

-(NSArray*)letv_orderLevel1Statuses
{
    return [self findConfigItemsByType:MainConfigInfoTableType106];
}

-(NSArray*)letv_orderLevel2Statuses:(NSString*)level1Code
{
    return [self findConfigItemsByType:MainConfigInfoTableType107 superCode:level1Code];
}

-(NSArray*)letv_handleCodes
{
    return [self findConfigItemsByType:MainConfigInfoTableType108];
}

-(NSArray*)letv_serviceRequestTypes
{
    return [self findConfigItemsByType:MainConfigInfoTableType109];
}

@end
