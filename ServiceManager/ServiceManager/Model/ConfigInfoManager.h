//
//  ConfigManager.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-11.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

//主数据表Type
typedef const NSString *MainConfigInfoTableType;

static MainConfigInfoTableType MainConfigInfoTableType1 = @"1";//品牌
static MainConfigInfoTableType MainConfigInfoTableType2 = @"2";//产品大类
static MainConfigInfoTableType MainConfigInfoTableType3 = @"3";//品类
static MainConfigInfoTableType MainConfigInfoTableType4 = @"4";//信息来源
static MainConfigInfoTableType MainConfigInfoTableType5 = @"5";//服务商拒绝原因
static MainConfigInfoTableType MainConfigInfoTableType6 = @"6";//预约未成功
static MainConfigInfoTableType MainConfigInfoTableType7 = @"7";//未完工原因
static MainConfigInfoTableType MainConfigInfoTableType8 = @"8";//处理措施
static MainConfigInfoTableType MainConfigInfoTableType9 = @"9";//故障现象
static MainConfigInfoTableType MainConfigInfoTableType10 = @"10";//故障大类
static MainConfigInfoTableType MainConfigInfoTableType10_1 = @"10-1";//故障代码
static MainConfigInfoTableType MainConfigInfoTableType11 = @"11";//优先级
static MainConfigInfoTableType MainConfigInfoTableType12 = @"12";//保内/保外
static MainConfigInfoTableType MainConfigInfoTableType13 = @"13";//服务类型（服务改善单）
static MainConfigInfoTableType MainConfigInfoTableType14 = @"14";//服务改善类型
static MainConfigInfoTableType MainConfigInfoTableType15 = @"15";//服务改善原因
static MainConfigInfoTableType MainConfigInfoTableType16 = @"16";//服务改善细分原因
static MainConfigInfoTableType MainConfigInfoTableType17 = @"17";//工单状态
static MainConfigInfoTableType MainConfigInfoTableType18 = @"18";//省
static MainConfigInfoTableType MainConfigInfoTableType19 = @"19";//市
static MainConfigInfoTableType MainConfigInfoTableType20 = @"20";//区域
static MainConfigInfoTableType MainConfigInfoTableType21 = @"21";//街道
static MainConfigInfoTableType MainConfigInfoTableType22 = @"22";//智能物料类别
static MainConfigInfoTableType MainConfigInfoTableType23 = @"23";//智能销售物料
static MainConfigInfoTableType MainConfigInfoTableType24 = @"24";//成交原因
static MainConfigInfoTableType MainConfigInfoTableType25 = @"25";//价格区间
static MainConfigInfoTableType MainConfigInfoTableType26 = @"26";//订单类型
static MainConfigInfoTableType MainConfigInfoTableType27 = @"27";//保外流失原因
static MainConfigInfoTableType MainConfigInfoTableType28 = @"28";//京东鉴定结果
static MainConfigInfoTableType MainConfigInfoTableType29 = @"29";//家多保“产品数量”
static MainConfigInfoTableType MainConfigInfoTableType30 = @"30";//家多保“机器类型2
static MainConfigInfoTableType MainConfigInfoTableType31 = @"31";//服务类别

static MainConfigInfoTableType MainConfigInfoTableType34 = @"34";//销售活动

static MainConfigInfoTableType MainConfigInfoTableType35 = @"35";//活动内容
static MainConfigInfoTableType MainConfigInfoTableType36 = @"36";//备件未审核通过的原因
static MainConfigInfoTableType MainConfigInfoTableType37 = @"37";//安装说明

static MainConfigInfoTableType MainConfigInfoTableType1001 = @"1001";//延保品牌

static MainConfigInfoTableType MainConfigInfoTableType1002 = @"1002";//家多保延保年限
static MainConfigInfoTableType MainConfigInfoTableType1003 = @"1003";//单品延保年限

//letv relative
static MainConfigInfoTableType MainConfigInfoTableType100 = @"100";//乐视故障代码
static MainConfigInfoTableType MainConfigInfoTableType101 = @"101";//承重墙类型
static MainConfigInfoTableType MainConfigInfoTableType102 = @"102";//是否官方购买挂架
static MainConfigInfoTableType MainConfigInfoTableType103 = @"103";//产品质保代码（保内外标志）
static MainConfigInfoTableType MainConfigInfoTableType104 = @"104";//安装方式
static MainConfigInfoTableType MainConfigInfoTableType105 = @"105";//家庭网络环境
static MainConfigInfoTableType MainConfigInfoTableType106 = @"106";//一级工单状态
static MainConfigInfoTableType MainConfigInfoTableType107 = @"107";//二级工单状态
static MainConfigInfoTableType MainConfigInfoTableType108 = @"108";//配件处理类型（处理代码）
static MainConfigInfoTableType MainConfigInfoTableType109 = @"109";//服务请求类型

@interface ConfigInfoManager : NSObject
@property(atomic, assign)BOOL hasLoadedMainInfo; //是否下载过主数据
@property(nonatomic, strong)NSArray *refueseReasons;//拒绝原因
@property(nonatomic, strong)NSArray *appointmentFailureReasons;

@property(nonatomic, strong)NSArray *brands;//品牌eg: 长虹
-(NSArray *)productsOfBrand:(NSString*)brandId; //产品大类, eg: 彩电
-(NSArray *)subProductsOfProduct:(NSString*)productId; //产品子类（品类）eg:等离子彩电
- (NSArray*)subProductsOfTV;//彩电下的品类
-(NSArray *)mutiExtendServiceProductTypes; //家多保支持的产品类型
- (NSArray*)extendServiceBrands;//延保品牌
- (NSString*)productCodeOfSubProduct:(NSString*)subProductCode;//由品类找产品大类

-(NSArray *)solutionsOfProduct:(NSString*)productId; //维修措施
- (NSArray *)newMachineSolutionsOfProduct:(NSString*)productId; //新机安装措施
- (NSArray *)normalSolutionsOfProduct:(NSString*)productId isNew:(BOOL)isNew; //常规维修措施
- (NSArray *)specialSolutionsOfProduct:(NSString*)productId;//特殊完工维修措施
-(NSArray *)jdIdentifyResults;  //京东鉴定结果
-(NSArray *)serviceFeeTypes;    //费用管理服务类别
-(NSArray *)smartProductTypes;  //智能物料类别
-(NSArray *)smartProductCodes;  //智能销售物料
-(NSArray *)issuesOfProduct:(NSString*)productId; //故障现象
-(NSArray *)transactionReasonsOfProduct:(NSString*)productId;//成交原因
-(NSArray *)priceRangesOfProduct:(NSString*)productId;//价格区间

-(NSArray *)componentTypes; //物料类别
-(NSArray *)subcomponentTypesOfType:(NSString*)typeId; //物料子类别
-(NSArray *)unfinishedReasons; //未完工原因
-(NSArray *)abandonReasons; //放弃维修原因
-(NSArray *)promotionalActivityNames;   //活动项
-(ConfigItemInfo *)promotionalActivityByCode:(NSString*)nameCode; //活动
-(NSArray *)promotionalActivitySubNamesOf:(NSString*)nameCode;   //活动子名称（内容）
-(ConfigItemInfo *)promotionalSubActivityByCode:(NSString*)subNameCode; //活动

//address
-(NSArray *)provincesOfChina;
- (NSArray *)citiesOfProvince:(NSString*)provinceId;
- (NSArray *)districtsOfCity:(NSString*)cityId;
- (NSArray *)streetsOfDistrict:(NSString*)districtId;

//故障类别
- (NSArray*)issueCategoriesOfProduct:(NSString*)productId brandId:(NSString*)brandId;

//故障代码
- (NSArray*)issueCodesOfCategory:(NSString*)categoryId brandId:(NSString*)brandId;

//Local Definition : Item CheckItemModel
- (NSArray *)warrantyYearItems;
-(NSArray *)mutiWarrantyYearItems;
- (NSString *)warrantyYearValueById:(NSString*)yearId;
- (NSString *)mutiWarrantyYearValueById:(NSString*)yearId;

- (NSArray *)orderRepairTypes;//工单修理类型: 新机安装、维修工单、其它

//产品质保代码（保内外标志）, return KeyValueModel array
-(NSArray*)warrantyItems;

+ (instancetype)sharedInstance;

//无数据 时加载主数据
- (void)loadConfigInfosIfNoData;

//无数据时，或超过一天未更新且WIFI网络下加载主数据
- (void)updateConfigInfosIfNeed;

- (void)updateConfigInfosWithWaitingDialog:(BOOL)showWaitingDialog;

//cache password or not
@property(nonatomic, assign)BOOL bSavePassword;

@property(atomic, assign)BOOL isLoading;

//find first config item info by type and code, params can not be nil
- (ConfigItemInfo*)findConfigItemInfoByType:(MainConfigInfoTableType)type code:(NSString*)code;

//find first config item info, params can not be nil
- (ConfigItemInfo*)findConfigItemInfoByType:(MainConfigInfoTableType)type code:(NSString*)code superCode:(NSString*)superCode superParentCode:(NSString*)superParentCode;

//find first config item info by type and value
- (ConfigItemInfo*)findConfigItemInfoByType:(MainConfigInfoTableType)type value:(NSString*)value;

//find config items by type
- (NSArray*)findConfigItemsByType:(MainConfigInfoTableType)type;

//return all if superCode is nil
- (NSArray*)findConfigItemsByType:(MainConfigInfoTableType)type superCode:(NSString*)superCode;

- (NSArray*)findConfigItemsByType:(MainConfigInfoTableType)type superCode:(NSString*)superCode superParentCode:(NSString*)superParentCode;

//get value by type and code
- (NSString*)getConfigItemValueByType:(MainConfigInfoTableType)type code:(NSString*)code;

//get code by type and value
- (NSString*)getConfigItemCodeByType:(MainConfigInfoTableType)type value:(NSString*)code;

#pragma mark - letv relative

//乐视故障代码
-(NSArray*)letv_issueCodesOfCategory:(NSString *)categoryId brandId:(NSString *)brandId;

//承重墙类型,return KeyValueModel array
- (NSArray*)letv_bearingWallItems;

//是否官方购买挂架,return KeyValueModel array
-(NSArray*)letv_rackFromLetvItems;

//产品质保代码（保内外标志）, return KeyValueModel array
-(NSArray*)letv_warrantyItems;

//安装方式,return KeyValueModel array
-(NSArray*)letv_installWayItems;

//家庭网络环境
-(NSArray*)letv_networkTypes;

//一级工单状态
-(NSArray*)letv_orderLevel1Statuses;

//二级工单状态
-(NSArray*)letv_orderLevel2Statuses:(NSString*)level1Code;

//配件处理类型（处理代码）
-(NSArray*)letv_handleCodes;

//服务请求类型
-(NSArray*)letv_serviceRequestTypes;
@end
