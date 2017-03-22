//
//  MutiGridCheckBox.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-28.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MutiGridCheckBoxItem : NSObject
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *IdNum;
@property(nonatomic, assign)BOOL isChecked;
@property(nonatomic, assign)NSInteger index;
@end

@interface MutiGridCheckBox : UIView

//ITEM:MutiGridCheckBoxItem
@property(nonatomic, strong)NSArray *checkBoxItemArray;
@property(nonatomic, assign)NSInteger rowCount;   //行数
@property(nonatomic, assign)NSInteger columCount;   //列数
@property(nonatomic, assign)NSInteger rowHeight;   //行高

//ITEM:MutiGridCheckBoxItem,已选中的项
@property(nonatomic, strong, readonly)NSArray *selectedArray;

- (void)layoutCheckBoxViews;
@end
