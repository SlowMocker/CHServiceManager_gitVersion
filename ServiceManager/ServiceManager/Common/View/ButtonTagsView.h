//
//  ButtonTagsView.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-28.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonTagsViewItem : NSObject
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *icon;
@end

@interface ButtonTagsView : UIView

//ITEM:ButtonTagsViewItem
@property(nonatomic, strong)NSArray *checkBoxItemArray;
@property(nonatomic, assign)NSInteger rowCount;   //行数
@property(nonatomic, assign)NSInteger columCount;   //列数
@property(nonatomic, assign)NSInteger rowHeight;   //行高

//ITEM:ButtonTagsViewItem,已选中的项
@property(nonatomic, strong, readonly)NSArray *selectedArray;

- (void)layoutCheckBoxViews;
@end
