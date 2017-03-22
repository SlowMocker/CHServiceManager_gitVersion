//
//  WZSingleCheckListView.h
//  ServiceManager
//
//  Created by will.wang on 15/9/16.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WZSingleCheckListView;

@protocol WZSingleCheckListViewDelegate <NSObject>
@optional
- (void)checkListView:(WZSingleCheckListView*)checkListView didCheckAtIndex:(NSInteger)index;

//当需要自定义CELL的显示时，可以定义定来定制,否则显示左圆圈右文本
- (void)checkListView:(WZSingleCheckListView*)checkListView setCell:(UITableViewCell*)cell withData:(CheckItemModel*)cellModel;
@end

@interface WZSingleCheckListView : UIView<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;

- (instancetype)initWithCheckItems:(NSArray*)checkItems checkIndex:(NSInteger)checkIndex delegate:(id<WZSingleCheckListViewDelegate>)delegate;

@property (nonatomic) UITableViewCellAccessoryType accessoryType;

//read only
@property(nonatomic, strong)UITableViewCell *protypeCell;
@property(nonatomic, strong)NSArray *checkItemArray;//item:CheckItemModel
@property(nonatomic, assign)id<WZSingleCheckListViewDelegate>delegate;
@property(nonatomic, assign)NSInteger checkIndex;

//默认数据设置及显示方式， 当不定制CELL显示时候使用
- (UITableViewCell*)setCell:(UITableViewCell*)cell withData:(CheckItemModel*)cellModel;
@end
