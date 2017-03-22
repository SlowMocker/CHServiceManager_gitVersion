//
//  ButtonTagsView.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-28.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ButtonTagsView.h"

@implementation ButtonTagsViewItem
@end

@implementation ButtonTagsView

- (UIButton*)makeCheckBoxView:(ButtonTagsViewItem*)itemData frame:(CGRect)frame
{
    UIButton *button = [[UIButton alloc]init];
    if ([itemData.title isNotEmpty]) {
        [button setImage:[UIImage imageNamed:itemData.icon] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        button.titleLabel.font = SystemFont(15);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);

        [button setTitleForAllStatus:itemData.title];
        [button addTarget:self action:@selector(checkBoxViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];

    return button;
}

- (void)checkBoxViewClicked:(UIButton*)checkBoxView
{
    DLog(@"checkBoxViewClicked");
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
        ButtonTagsViewItem *item = self.checkBoxItemArray[index];
        rowIndex = index / self.columCount;
        columIndex = index % self.columCount;
        frame.origin = CGPointMake(columIndex * itemWidth, rowIndex *itemHeight);
        checkBoxView = [self makeCheckBoxView:item frame:frame];
        [self addSubview:checkBoxView];
    }
}

@end
