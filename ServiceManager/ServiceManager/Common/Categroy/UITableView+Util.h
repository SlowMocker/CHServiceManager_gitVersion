//
//  UITableView+Util.h
//  HouseMarket
//
//  Created by wangzhi on 15-3-23.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Util)

- (void)hideExtraCellLine;


//relad tableview cell for showing
- (void)reloadTableViewCell:(UITableViewCell*)cell;

- (void)addTopHeaderSpace:(CGFloat)height;

//scroll to top
- (void)scrollSelfToTop;

//make section header view, no bottom line if height is 0
- (UIView*)makeHeaderViewWithSubLabel:(UILabel*)subLabel bottomLineHeight:(CGFloat)bottomLineHeight;
@end
