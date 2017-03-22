//
//  TableViewDataSourceModel.h
//  ServiceManager
//
//  Created by will.wang on 16/5/3.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>


//header data
@interface TableViewSectionHeaderData : NSObject
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *subTitle;
@property(nonatomic, strong)NSObject *otherData;
+(TableViewSectionHeaderData*)makeWithTitle:(NSString*)title;
@end

//cell data
@interface TableViewCellData : NSObject
@property(nonatomic, assign)NSInteger tag;
@property(nonatomic, strong)NSString *image;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *subTitle;
@property(nonatomic, strong)NSObject *otherData;
@property(nonatomic, weak)VoidBlock_id didSelectBlock;

+(TableViewCellData*)makeWithTag:(NSInteger)tag;
+(TableViewCellData*)makeWithImage:(NSString*)image title:(NSString*)title;
+(TableViewCellData*)makeWithTitle:(NSString*)title subTitle:(NSString*)subTitle;
+(TableViewCellData*)makeWithOtherData:(NSObject*)otherData;
@end

@interface TableViewDataSourceModel : NSObject

//清除所有的数据，以便重新设置
- (void)cleanDataSourceModel;

//设置每个section header数据，无数据时也需要设置为nil
-(void)setHeaderData:(TableViewSectionHeaderData*)data forSection:(NSInteger)section;

//设置行数据
-(void)setCellData:(TableViewCellData*)data forSection:(NSInteger)section row:(NSInteger)row;

//读取section header数据，为空时返回nil
-(TableViewSectionHeaderData*)headerDataOfSection:(NSInteger)section;

//读取行数据
-(TableViewCellData*)cellDataForSection:(NSInteger)section row:(NSInteger)row;

//读取section 数
-(NSInteger)numberOfSections;

//读取某section中的行数
-(NSInteger)numberOfRowsInSection:(NSInteger)section;
@end
