//
//  FilterTableView.h
//  ServiceManager
//
//  Created by will.wang on 16/9/9.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FilterRowButtonCell.h"

@class FilterTableView;

@interface FilterTableViewDataModel : TableViewDataHandle
-(void)setHeaderData:(TableViewSectionHeaderData*)data forSection:(NSInteger)section;

//btnItemModels : CheckItemModel
-(void)setCellBtnItemsData:(NSArray*)btnItemModels forSection:(NSInteger)section;

- (NSArray*)getCheckedItemsInSection:(NSInteger)section;

//seprate by ",";
- (NSString*)getCheckedItemsKeysInSection:(NSInteger)section;

//seprate by ",";
- (NSString*)getCheckedItemsValuesInSection:(NSInteger)section;

//
- (NSString*)getAllCheckedItemsValues;

//reset all items unchecked
- (void)resetAllItemsUnchecked;
@end

@protocol FilterTableViewDelegate <NSObject>
- (void)filterTableView:(FilterTableView*)tableView selected:(KeyValueModel*)selectedItem;
@end

@interface FilterTableView : UITableView
@property(nonatomic, strong)FilterTableViewDataModel *dataModel;

- (instancetype)initWithCustomMode;
@end
