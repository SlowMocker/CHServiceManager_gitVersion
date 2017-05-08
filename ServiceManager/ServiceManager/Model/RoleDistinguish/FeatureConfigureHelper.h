//
//  FeatureConfigureHelper.h
//  ServiceManager
//
//  Created by will.wang on 2016/12/22.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

// 这个类主要用于配置死数据
// 因为该 App 对应三个角色(服务商、技术支持、维修工)，不同的角色界面配置不一样，功能不一样
// 这个地方可以进行优化:
// 1.（使用本地数据库将不同的配置信息,用户自定义时只是修改本地数据进行存储）
// 2. 使用 BaseModel

#import <UIKit/UIKit.h>

@class FeatureConfigItem;

//功能组
@interface FeatureSectionItem : NSObject

@property(nonatomic, assign)kHomeSectionItem sectionId;/**< 和 title 对应的枚举 可以调用 C 接口 [getHomeSectionItemName(enum)]转换为 title*/
@property(nonatomic, strong)NSString *title;/**< 功能组的 title (eg: 工具箱、乐视品牌) */
@property(nonatomic, assign)BOOL visible;/**< 该功能组是否可见 (eg: 比如不同的角色可见的功能组不一样，或者用户自定义主页显示功能组) */
@property(nonatomic, strong)NSArray<FeatureConfigItem *>* features;/**< 功能组中包含的子功能项集合 */

/**
 *  obj -> json
 */
- (NSString*) jsonString;
/**
 *  json -> obj
 */
- (id) initWithJsonString:(NSString*)jsonString;

@end


//功能项
@interface FeatureConfigItem : NSObject
@property(nonatomic, assign)kHomeSectionItem featureSection;/**< 该功能项所属功能组 */
@property(nonatomic, assign)kHomePadFeatureItem itemId;/**< 和 itemText 对应的枚举 可以调用 C 接口 [getHomePadFeatureItemName(enum)]转换为 itemText*/
@property(nonatomic, strong)NSString *itemText;/**< 子功能名称 */
@property(nonatomic, strong)NSString *itemIcon;/**< iconPath */
@property(nonatomic, strong)NSString *itemBackgroundColorHex;/**< 背景色 */
@property(nonatomic, assign)BOOL visible;/**< 是否可见 */
/**
 *  obj -> json
 */
- (NSString*) jsonString;
/**
 *  json -> obj
 */
- (id) initWithJsonString:(NSString*)jsonString;
@end


@interface FeatureConfigureHelper : NSObject

// 单例申明和实现后期可以使用宏代替
+ (instancetype)sharedInstance;

/**
 *  根据本地存储的 role 信息配置功能项
 */
- (NSArray<FeatureSectionItem *>*) getDefualtFeatureItems;

/**
 *  重新保存功能配置项，在修改过配置项之后需要调用此方法进行持久化
 **/
- (void)resaveFeatureItems;

/**
 *  将本地存储的配置数据填充到 TableViewDataHandle 句柄中
 *
 *  @param sectionArray 配置数据
 *  @param onlyVisible  是否只整合可见的
 */
- (TableViewDataHandle*)convertToTableViewDataSourceModel:(NSArray<FeatureSectionItem *>*)sectionArray onlyVisible:(BOOL)onlyVisible;

@end
