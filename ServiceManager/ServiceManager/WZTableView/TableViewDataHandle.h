//
//  TableViewDataHandle.h
//  ServiceManager
//
//  Created by will.wang on 16/5/3.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

// 已知: 是 HomeCollectionView 的数据源模型

#import <Foundation/Foundation.h>


// section header 数据模型
@interface TableViewSectionHeaderData : NSObject

@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *subTitle;
@property(nonatomic, strong)NSObject *otherData;

+ (TableViewSectionHeaderData*) makeWithTitle:(NSString*)title;

@end

// cell 数据模型
@interface TableViewCellData : NSObject

@property(nonatomic, assign)NSInteger tag;
@property(nonatomic, strong)NSString *image;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *subTitle;
@property(nonatomic, strong)NSObject *otherData;
@property(nonatomic, weak)VoidBlock_id didSelectBlock;

+ (TableViewCellData*) makeWithTag:(NSInteger)tag;
+ (TableViewCellData*) makeWithImage:(NSString*)image title:(NSString*)title;
+ (TableViewCellData*) makeWithTitle:(NSString*)title subTitle:(NSString*)subTitle;
+ (TableViewCellData*) makeWithOtherData:(NSObject*)otherData;

@end


// TableViewDataHandle 原名: TableViewDataSourceModel
@interface TableViewDataHandle : NSObject
/**
 *  清除所有的数据，以便重新设置
 */
- (void) cleanDataSourceModel;

/**
 *  设置每个 section header 数据
 *
 *  @note 无数据时也需要设置为 nil
 *
 *  @param data    数据
 *  @param section 目标段头 index
 */
- (void) setHeaderData:(TableViewSectionHeaderData*)data forSection:(NSInteger)section;

/**
 *  设置行数据
 *
 *  @param data    cell 数据
 *  @param section cell 所在段 index
 *  @param row     cell 所在行 index
 */
- (void) setCellData:(TableViewCellData*)data forSection:(NSInteger)section row:(NSInteger)row;

/**
 *  读取 section header 数据，为空时返回 nil
 *
 *  @param section 段头所在段 index
 *
 *  @return 段头数据
 */
- (TableViewSectionHeaderData*) headerDataOfSection:(NSInteger)section;

/**
 *  读取 cell 数据
 *
 *  @param section cell 所在段 index
 *  @param row     cell 所在行 index
 *
 *  @return cell 数据
 */
- (TableViewCellData*) cellDataForSection:(NSInteger)section row:(NSInteger)row;

/**
 *  所有段数
 */
- (NSInteger) numberOfSections;

/**
 *  读取某 section 中的 cell 数
 *
 *  @param section section
 */
- (NSInteger) numberOfRowsInSection:(NSInteger)section;
@end
