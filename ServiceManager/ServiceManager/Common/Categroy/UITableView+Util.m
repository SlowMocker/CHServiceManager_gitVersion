//
//  UITableView+Util.m
//  HouseMarket
//
//  Created by wangzhi on 15-3-23.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "UITableView+Util.h"

@implementation UITableView (Util)

- (void)hideExtraCellLine
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    self.tableFooterView = view;
}

- (void)reloadTableViewCell:(UITableViewCell*)cell
{
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    if (nil != indexPath) {
        [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)addTopHeaderSpace:(CGFloat)height
{
    ReturnIf(height <= 0);

    UIView *topSpace = [[[UIView alloc]init]clearBackgroundColor];
    topSpace.frame= CGRectMake(0, 0, ScreenWidth, height);
    self.tableHeaderView = topSpace;
}

- (void)scrollSelfToTop
{
    [self scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (UIView*)makeHeaderViewWithSubLabel:(UILabel*)subLabel bottomLineHeight:(CGFloat)bottomLineHeight
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kTableViewCellDefaultHeight);
    UIView *headerView = [[UIView alloc]initWithFrame:frame];
    headerView.backgroundColor = kColorDefaultBackGround;

    if (bottomLineHeight > 0) {
        UIView *bottomLine = [headerView addLineTo:kFrameLocationBottom];
        [bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(bottomLineHeight));
        }];
        bottomLine.backgroundColor = subLabel.textColor;
    }

    frame.origin.x += kTableViewLeftPadding;
    frame.size.width -= frame.origin.x;
    subLabel.font = SystemFont(16);
    subLabel.frame = frame;
    [headerView addSubview:subLabel];
    
    return headerView;
}

@end
