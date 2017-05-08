//
//  FeatureConfigureHelper.m
//  ServiceManager
//
//  Created by will.wang on 2016/12/22.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "FeatureConfigureHelper.h"

@implementation FeatureSectionItem
- (NSString*) jsonString {
    NSDictionary *objDic = [NSDictionary dictionaryFromPropertyObject:self];
    if (self.features.count > 0) {
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:objDic];

        NSMutableArray *featureArray = [NSMutableArray new];
        for (FeatureConfigItem *feature in self.features) {
            [featureArray addObject:feature.jsonString];
        }
        NSString *featuresJsonStr = [NSString jsonStringWithArray:featureArray];
        [tempDic setObject:featuresJsonStr forKey:@"features"];

        objDic = tempDic;
    }
    return [NSString jsonStringWithDictionary:objDic];
}

- (id)initWithJsonString:(NSString*)jsonString {
    NSDictionary *objDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithString:jsonString] options:NSJSONReadingAllowFragments error:nil];
    self = [super initWithDictionary:objDic];
    if (self) {
        NSString *featuresJsonStr = [objDic objForKey:@"features"];
        NSArray *featuresJsonArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithString:featuresJsonStr] options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableArray *featureArray = [NSMutableArray new];
        for (NSString *featureJsonStr in featuresJsonArray) {
            FeatureConfigItem *feature = [[FeatureConfigItem alloc]initWithJsonString:featureJsonStr];
            [featureArray addObject:feature];
        }
        self.features = featureArray;
    }
    return self;
}
@end



@implementation FeatureConfigItem
- (NSString*)jsonString {
    NSDictionary *objDic = [NSDictionary dictionaryFromPropertyObject:self];
    return [NSString jsonStringWithDictionary:objDic];
}

- (id)initWithJsonString:(NSString*)jsonString {
    NSDictionary *objDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithString:jsonString] options:NSJSONReadingAllowFragments error:nil];
    return [super initWithDictionary:objDic];
}
@end



#pragma mark
#pragma mark FeatureConfigureHelper
@interface FeatureConfigureHelper()

@property(nonatomic, strong)NSString *currentFeaturesKey;
@property(nonatomic, strong)NSArray *featuresArray;

@end

@implementation FeatureConfigureHelper

+ (instancetype)sharedInstance {
    static FeatureConfigureHelper *sFeatureConfigureHelper = nil;
    static dispatch_once_t sOnceToken;
    dispatch_once(&sOnceToken, ^{
        sFeatureConfigureHelper = [[FeatureConfigureHelper alloc]init];
    });
    return sFeatureConfigureHelper;
}

#pragma mark
#pragma mark public methods
- (NSArray*) getDefualtFeatureItems {
    NSString *configKey = [self genarateConfigKey];

    do {
        //如果账号和上次一样，则返回上次的配置项即可
        if ([self.currentFeaturesKey isEqualToString:configKey]) {
            BreakIf(self.featuresArray.count > 0);
        }
        self.currentFeaturesKey = configKey;
        
        //先去缓存（偏好设置）中，查看是否之前有配置过
        self.featuresArray = [self restoreSectionFeaturesFromUserDefaults:configKey];
        BreakIf(self.featuresArray.count > 0);

        //缓存中没有时，则获取
        self.featuresArray = [self genarateSectionFeatures];
    } while (0);
    return self.featuresArray;
}

- (void) resaveFeatureItems {
    [self saveSectionFeaturesToUserDefaults:self.featuresArray key:self.currentFeaturesKey];
}

- (TableViewDataHandle*) convertToTableViewDataSourceModel:(NSArray*)sectionArray onlyVisible:(BOOL)onlyVisible {
    TableViewCellData *cellData;
    TableViewDataHandle *dataSourceModel;
    TableViewSectionHeaderData *header;
    NSInteger sectionIndex = 0, rowIndex = 0;
    
    dataSourceModel = [TableViewDataHandle new];
    
    for (FeatureSectionItem *section in sectionArray) {
        ContinueIf(onlyVisible && !section.visible);
        
        //section header
        header = [TableViewSectionHeaderData makeWithTitle:section.title];
        [dataSourceModel setHeaderData:header forSection:sectionIndex];
        
        //items in section
        rowIndex = 0;
        for (FeatureConfigItem *featureItem in section.features) {
            ContinueIf(onlyVisible && !featureItem.visible);
            cellData = [self makeCollectionItemData:featureItem];
            [dataSourceModel setCellData:cellData forSection:sectionIndex row:rowIndex];
            rowIndex++;
        }
        sectionIndex++;
    }
    
    return dataSourceModel;
}


#pragma mark
#pragma mark private methods
// 将功能配置转换成 json 做本地存储（偏好设置）。因为涉及到用户自定义功能。
- (void) saveSectionFeaturesToUserDefaults:(NSArray*)sectionArray key:(NSString*)key {
    ReturnIf([Util isEmptyString:key]);
    NSString *jsonStr = [self changeConfigItemsToJsonString:sectionArray];
    [UserDefaults saveObject:jsonStr forKey:key];
}

// 将存储在本地的 json 转换成功能配置 section 对象数组
- (NSArray *) restoreSectionFeaturesFromUserDefaults:(NSString*)key {
    NSString *jsonStr = (NSString*)[UserDefaults restoreObjectForKey:key];
    NSArray *sectionArray = nil;
    
    if (![Util isEmptyString:jsonStr]) {
        sectionArray = [self changeJsonStringToFeatureConfigItems:jsonStr];
    }
    return sectionArray;
}

// 将 json 转为功能配置项
- (NSArray*)changeJsonStringToFeatureConfigItems:(NSString*)jsonStr {
    FeatureSectionItem *section;
    NSDictionary *sectionJsonStrArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithString:jsonStr] options:NSJSONReadingAllowFragments error:nil];

    NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
    for (NSString *sectionJsonStr in sectionJsonStrArray) {
        section = [[FeatureSectionItem alloc]initWithJsonString:sectionJsonStr];
        [sectionArray addObject:section];
    }
    return sectionArray;
}

// 将配置项转为 json
- (NSString*)changeConfigItemsToJsonString:(NSArray*)sectionArray {
    NSMutableArray *sectionJsonArray = [[NSMutableArray alloc]init];
    for(FeatureSectionItem *section in sectionArray){
        [sectionJsonArray addObject:[section jsonString]];
    }
    return [NSString jsonStringWithArray:sectionJsonArray];
}

// 根据角色生成配置 key
- (NSString*) genarateConfigKey {
    UserInfoEntity *user = [UserInfoEntity sharedInstance];
    return [NSString stringWithFormat:@"FeatureConfigForUser%@Role%@", user.userId, @(user.userRoleType)];
}

#pragma mark
#pragma mark may care
// 根据角色获取功能配置
- (NSArray*) genarateSectionFeatures {
    kUserRoleType userRole = [UserInfoEntity sharedInstance].userRoleType;
    switch (userRole) {
        case kUserRoleTypeFacilitator:
            return [self genarateDefaultFacilitatorFeatures];
        case kUserRoleTypeRepairer:
            return [self genarateDefaultRepairFeatures];
        case kUserRoleTypeSupporter:
            return [self genarateDefaultSupporterFeatures];
        default:
            return nil;
    }
}

// 获取 服务商 的主页数据配置
- (NSArray*) genarateDefaultFacilitatorFeatures {
    NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
    NSArray *sectionItemsIds;
    kHomeSectionItem featureSectionId;
    FeatureSectionItem *section;
    
    //工具箱
    featureSectionId = kHomeSectionItemTools;
    sectionItemsIds = @[@(kHomePadFeatureItemExtendService),
                        @(kHomePadFeatureItemEmployeeManage),
                        @(kHomePadFeatureItemResource),
                        @(kHomePadFeatureItemServicePrice)
                        ];
    section = [self makeFeatureConfigItemsByItemIds:sectionItemsIds forSection:featureSectionId];
    [sectionArray addObject:section];

    //售后服务（长虹、启客、三洋、迎燕等)
    featureSectionId = kHomeSectionItemCommonBrands;
    sectionItemsIds = @[@(kHomePadFeatureItemOrderManage),
                        @(kHomePadFeatureItemTaskOrderHistory),
                        @(kHomePadFeatureItemSupport),
                        @(kHomePadFeatureItemImprovement),
                        @(kHomePadFeatureItemPartTrace)
                        ];

    section = [self makeFeatureConfigItemsByItemIds:sectionItemsIds forSection:featureSectionId];
    [sectionArray addObject:section];

    //售后服务（乐视）
    featureSectionId = kHomeSectionItemLetvBrand;
    sectionItemsIds = @[@(kHomePadFeatureItemOrderManage),
                        @(kHomePadFeatureItemTaskOrderHistory),
                        @(kHomePadFeatureItemSupport)
                        ];
    section = [self makeFeatureConfigItemsByItemIds:sectionItemsIds forSection:featureSectionId];
    [sectionArray addObject:section];
    
    //智米空调
    featureSectionId = kHomeSectionItemSmartMiBrand;
    sectionItemsIds = @[@(kHomePadFeatureItemOrderManage),
                        @(kHomePadFeatureItemTaskOrderHistory),
                        @(kHomePadFeatureItemSupport),
//                        @(kHomePadFeatureItemImprovement),
//                        @(kHomePadFeatureItemPartTrace)
                        ];
    section = [self makeFeatureConfigItemsByItemIds:sectionItemsIds forSection:featureSectionId];
    [sectionArray addObject:section];
    
    

    return sectionArray;
} 

// 获取 维修工 的主页数据配置
- (NSArray*) genarateDefaultRepairFeatures {
    NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
    NSArray *sectionItemsIds;
    kHomeSectionItem featureSectionId;
    FeatureSectionItem *section;
    
    //工具箱
    featureSectionId = kHomeSectionItemTools;
    sectionItemsIds = @[@(kHomePadFeatureItemExtendService),
                        @(kHomePadFeatureItemResource),
                        @(kHomePadFeatureItemServicePrice)
                        ];
    section = [self makeFeatureConfigItemsByItemIds:sectionItemsIds forSection:featureSectionId];
    [sectionArray addObject:section];
    
    //售后服务（长虹、启客、三洋、迎燕等)
    featureSectionId = kHomeSectionItemCommonBrands;
    sectionItemsIds = @[@(kHomePadFeatureItemOrderManage),
                        @(kHomePadFeatureItemTaskOrderHistory),
                        @(kHomePadFeatureItemSupport),
                        @(kHomePadFeatureItemPartTrace)
                        ];

    section = [self makeFeatureConfigItemsByItemIds:sectionItemsIds forSection:featureSectionId];
    [sectionArray addObject:section];
    
    //售后服务（乐视）
    featureSectionId = kHomeSectionItemLetvBrand;
    sectionItemsIds = @[@(kHomePadFeatureItemOrderManage),
                        @(kHomePadFeatureItemTaskOrderHistory),
                        @(kHomePadFeatureItemSupport)
                        ];
    section = [self makeFeatureConfigItemsByItemIds:sectionItemsIds forSection:featureSectionId];
    [sectionArray addObject:section];
    
    //智米空调
    featureSectionId = kHomeSectionItemSmartMiBrand;
    sectionItemsIds = @[@(kHomePadFeatureItemOrderManage),
                        @(kHomePadFeatureItemTaskOrderHistory),
                        @(kHomePadFeatureItemSupport),
//                        @(kHomePadFeatureItemImprovement),
//                        @(kHomePadFeatureItemPartTrace)
                        ];
    section = [self makeFeatureConfigItemsByItemIds:sectionItemsIds forSection:featureSectionId];
    [sectionArray addObject:section];
    
    return sectionArray;
}

// 获取 技术支持 的主页数据配置
- (NSArray *) genarateDefaultSupporterFeatures {
    NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
    NSArray *sectionItemsIds;
    kHomeSectionItem featureSectionId;
    FeatureSectionItem *section;

    //售后服务（长虹、启客、三洋、迎燕等)
    featureSectionId = kHomeSectionItemCommonBrands;
    sectionItemsIds = @[@(kHomePadFeatureItemTaskManage)];

    section = [self makeFeatureConfigItemsByItemIds:sectionItemsIds forSection:featureSectionId];
    [sectionArray addObject:section];

    //售后服务（乐视）
    featureSectionId = kHomeSectionItemLetvBrand;
    sectionItemsIds = @[@(kHomePadFeatureItemTaskManage)];

    section = [self makeFeatureConfigItemsByItemIds:sectionItemsIds forSection:featureSectionId];
    [sectionArray addObject:section];
    
    //智米空调
    featureSectionId = kHomeSectionItemSmartMiBrand;
    sectionItemsIds = @[@(kHomePadFeatureItemTaskManage)];
    section = [self makeFeatureConfigItemsByItemIds:sectionItemsIds forSection:featureSectionId];
    [sectionArray addObject:section];
    
    return sectionArray;
}

// 根据功能项组ID和功能项ID数组生成功能组项数据
- (FeatureSectionItem *) makeFeatureConfigItemsByItemIds:(NSArray*)itemIds forSection:(kHomeSectionItem)featureSection {
    ReturnIf(itemIds.count <= 0)nil;

    NSMutableArray *featureArray = [[NSMutableArray alloc]init];
    kHomePadFeatureItem itemId;

    for (NSNumber *itemIdObj in itemIds) {
        itemId = (kHomePadFeatureItem)[itemIdObj integerValue];
        [featureArray addObject:[self makeDefaultFeatureConfigItem:itemId featureSection:featureSection]];
    }

    FeatureSectionItem *section = [[FeatureSectionItem alloc]init];
    section.sectionId = featureSection;
    section.title = getHomeSectionItemName(section.sectionId);
    section.visible = YES;
    section.features = featureArray;

    return section;
}

// 生成默认的功能项属性数据
- (FeatureConfigItem*)makeDefaultFeatureConfigItem:(kHomePadFeatureItem)itemId featureSection:(kHomeSectionItem)featreSection {
    FeatureConfigItem *feature = [FeatureConfigItem new];
    feature.itemId = itemId;
    feature.featureSection = featreSection;

    NSString *imageName, *backGroundColorHex;

    switch (itemId) {
        case kHomePadFeatureItemOrderManage:
            imageName = @"ic_description_white_36pt";
            backGroundColorHex = @"#00CCFF";
            break;
        case kHomePadFeatureItemSupport:
            imageName = @"ic_comment_white_36pt";
            backGroundColorHex = @"#999900";
            break;
        case kHomePadFeatureItemPartTrace:
            imageName = @"ic_swap_horiz_white_36pt";
            backGroundColorHex = @"#669999";
            break;
        case kHomePadFeatureItemImprovement:
            imageName = @"ic_face_white_36pt";
            backGroundColorHex = @"#999900";
            break;
        case kHomePadFeatureItemTaskManage:
            imageName = @"ic_assignment_white_36pt";
            backGroundColorHex = @"#00CCFF";
            break;
        case kHomePadFeatureItemExtendService:
            imageName = @"ic_assignment_white";
            backGroundColorHex = @"#666666";
            break;
        case kHomePadFeatureItemResource:
            imageName = @"ic_receipt_white";
            backGroundColorHex = @"#666666";
            break;
        case kHomePadFeatureItemEmployeeManage:
            imageName = @"ic_group_white";
            backGroundColorHex = @"#666666";
            break;
        case kHomePadFeatureItemTaskOrderHistory:
            imageName = @"ic_description_white";
            backGroundColorHex = @"#0d6797";
            break;
        case kHomePadFeatureItemServicePrice:
            imageName = @"ic_local_atm_white";
            backGroundColorHex = @"#666666";
            break;
        default:
            return feature;
    }

    //fill data
    feature.itemText = getHomePadFeatureItemName(feature.itemId);
    feature.itemIcon = imageName;
    feature.itemBackgroundColorHex = backGroundColorHex;
    feature.visible = YES;

    return feature;
}

- (TableViewCellData*)makeCollectionItemData:(FeatureConfigItem*)featureConfigItem {
    TableViewCellData *cellData = [TableViewCellData new];
    cellData.otherData = featureConfigItem;
    
    return cellData;
}


@end
