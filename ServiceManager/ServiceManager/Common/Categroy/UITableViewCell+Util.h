//
//  UITableViewCell+Util.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-13.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableViewCell (Util)
- (UIView*)addDefaultSepraterLine;

//add or remove custom seprate line
- (UIView*)addButtomLineWithLeft:(CGFloat)left right:(CGFloat)right color:(UIColor*)color;
- (void)removeDefaultSepraterLine;

- (void)updateConstraintsAndLayout;

- (CGFloat)fitHeight;
@end
