//
//  MutiGridCheckBox.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-28.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "MutiGridCheckBox.h"

@implementation MutiGridCheckBoxItem
@end

@implementation MutiGridCheckBox

- (UIButton*)makeCheckBoxView:(MutiGridCheckBoxItem*)itemData frame:(CGRect)frame
{
    UIButton *button = [[UIButton alloc]init];
    if ([itemData.title isNotEmpty]) {
        [button setImage:[UIImage imageNamed:@"btn_multiselect_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_multiselect_sel"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = SystemFont(14);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        button.contentMode = UIViewContentModeLeft;
        [button setTitleForAllStatus:itemData.title];
        [button addTarget:self action:@selector(checkBoxViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    button.selected = itemData.isChecked;
    button.tag = itemData.index;
    button.frame = frame;
    UIColor *borderColor = ColorWithRGBA(200, 200, 200, 0.3);
    button.layer.borderColor = borderColor.CGColor;
    button.layer.borderWidth = 0.5;
    button.backgroundColor = [UIColor clearColor];

    return button;
}

- (void)checkBoxViewClicked:(UIButton*)checkBoxView
{
    MutiGridCheckBoxItem *itemData = self.checkBoxItemArray[checkBoxView.tag];

    if (itemData != nil) {
        checkBoxView.selected = !checkBoxView.selected;
        itemData.isChecked = checkBoxView.selected;
    }
}

- (void)layoutCheckBoxViews
{
    NSInteger rowIndex = 0;
    NSInteger columIndex = 0;
    CGFloat itemWidth = CGRectGetWidth(self.frame)/self.columCount;
    CGFloat itemHeight = self.rowHeight;
    CGRect frame = CGRectMake(0, 0, itemWidth, itemHeight);
    UIButton *checkBoxView;

    //remove all old views
    [self removeAllSubviews];

    //insert new views
    for (NSInteger index = 0; index < self.checkBoxItemArray.count; index++) {
        MutiGridCheckBoxItem *item = self.checkBoxItemArray[index];
        rowIndex = index / self.columCount;
        columIndex = index % self.columCount;
        frame.origin = CGPointMake(columIndex * itemWidth, rowIndex *itemHeight);
        item.index = index;
        checkBoxView = [self makeCheckBoxView:item frame:frame];
        [self addSubview:checkBoxView];
    }
}

- (void)setCheckBoxItemArray:(NSArray *)checkBoxItemArray
{
    if (_checkBoxItemArray != checkBoxItemArray) {
        for (NSInteger index = 0; index < checkBoxItemArray.count; index++) {
            MutiGridCheckBoxItem *item = self.checkBoxItemArray[index];
            item.index = index;
        }
        _checkBoxItemArray = checkBoxItemArray;
    }
}

- (NSArray*)selectedArray
{
    NSMutableArray *array = [[NSMutableArray alloc]init];

    for (NSInteger index = 0; index < self.checkBoxItemArray.count; index++) {
        MutiGridCheckBoxItem *item = self.checkBoxItemArray[index];
        if (item.isChecked) {
            [array addObject:item];
        }
    }
    return array;
}

@end
