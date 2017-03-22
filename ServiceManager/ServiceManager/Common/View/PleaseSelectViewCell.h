//
//  PleaseSelectViewCell.h
//  ServiceManager
//
//  Created by will.wang on 15/9/18.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  1，显示一带箭头的CELL
 *  2，当选择时，在当前页下方弹出选择项，
 */

static CGFloat kCellTypeSingleCheck = 0x92843;

@class PleaseSelectViewCell;

@protocol PleaseSelectViewCellDelegate <NSObject>
@optional
//点击了Cell时就调用，此时选项菜单还未显示出，返回NO，不再弹出选项菜单
- (BOOL)selectMenuWillAppear:(PleaseSelectViewCell*)cell;

//选中了选项
- (void)selectViewDidChecked:(PleaseSelectViewCell*)cell;
@end

@interface PleaseSelectViewCell : UITableViewCell
@property(nonatomic, strong)NSString *checkedItemKey;
@property(nonatomic, strong)CheckItemModel *checkedItem;
@property(nonatomic, strong)NSArray *checkItems;
@property(nonatomic, copy)NSString *checkViewTitle;
@property(nonatomic, assign)id<PleaseSelectViewCellDelegate>delegate;
@end
