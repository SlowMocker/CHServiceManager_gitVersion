//
//  FeatureConfigureHelper.h
//  ServiceManager
//
//  Created by will.wang on 2016/12/22.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

//功能组
@interface FeatureSectionItem : NSObject
@property(nonatomic, assign)kHomeSectionItem sectionId;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, assign)BOOL visible;
@property(nonatomic, strong)NSArray* features; //[FeatureConfigItem]

//将对象以JSON STRING 描述
- (NSString*)jsonString;
//用JSON STRING 初始化
- (id)initWithJsonString:(NSString*)jsonString;
@end

//功能项
@interface FeatureConfigItem : NSObject
@property(nonatomic, assign)kHomeSectionItem featureSection;
@property(nonatomic, assign)kHomePadFeatureItem itemId;
@property(nonatomic, strong)NSString *itemText;
@property(nonatomic, strong)NSString *itemIcon;
@property(nonatomic, strong)NSString *itemBackgroundColorHex;
@property(nonatomic, assign)BOOL visible;
//将对象以JSON STRING 描述
- (NSString*)jsonString;
//用JSON STRING 初始化
- (id)initWithJsonString:(NSString*)jsonString;
@end

@interface FeatureConfigureHelper : NSObject

+ (instancetype)sharedInstance;

/**
 *  配置功能项
 *  @return Array[FeatureSectionItem]
 */

-(NSArray*)getDefualtFeatureItems;

/**
 *  重新保存功能配置项，在修改过配置项之后需要调用此方法进行持久化
 **/
- (void)resaveFeatureItems;

/**
 *  将配置项整合为TableViewDataSourceModel
 *  sectionArray :Array[FeatureSectionItem]
 *  onlyVisible: 只整合可显示的
 *  @return TableViewDataSourceModel
 */
- (TableViewDataSourceModel*)convertToTableViewDataSourceModel:(NSArray*)sectionArray onlyVisible:(BOOL)onlyVisible;

@end
