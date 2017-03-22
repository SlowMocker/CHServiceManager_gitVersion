//
//  UITableViewCell+Util.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-13.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "UITableViewCell+Util.h"

#define kaddDefaultSepraterLineTag 0x280437

@implementation UITableViewCell (Util)

- (UIView*)addDefaultSepraterLine
{
    UIView *line = [self viewWithTag:kaddDefaultSepraterLineTag];
    if (nil == line) {
        CGFloat lineLeftPadding = kTableViewLeftPadding;
        CGFloat lineHeight = 0.5;

        CGRect frame = CGRectMake(lineLeftPadding, CGRectGetHeight(self.contentView.frame)-lineHeight, CGRectGetWidth(self.contentView.frame) - lineLeftPadding, lineHeight);
        UIView *line = [[UIView alloc]initWithFrame:frame];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.5;
        line.tag = kaddDefaultSepraterLineTag;
        line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:line];
    }
    line.hidden = NO;
    [self bringSubviewToFront:line];
    return line;
}

- (UIView*)addButtomLineWithLeft:(CGFloat)left right:(CGFloat)right color:(UIColor*)color
{
    UIView *line = [self.contentView viewWithTag:kaddDefaultSepraterLineTag];
    if (nil == line) {
        UIView *line = [[UIView alloc]init];
        line.tag = kaddDefaultSepraterLineTag;
        [self.contentView addSubview:line];
    }
    line.hidden = NO;
    line.backgroundColor = color ? color : [UIColor lightGrayColor];
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(left);
        make.right.equalTo(self.contentView).with.offset(-right);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@(0.5));
    }];
    [self.contentView bringSubviewToFront:line];
    return line;
}

- (void)removeDefaultSepraterLine
{
    UIView *line = [self.contentView viewWithTag:kaddDefaultSepraterLineTag];
    if (nil != line) {
        line.hidden = YES;
        [line removeFromSuperview];
    }
}

- (void)updateConstraintsAndLayout
{
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGFloat)fitHeight
{
    [self updateConstraintsAndLayout];

    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;

    DLog(@"%@ height: %@", NSStringFromClass([self class]), @(height));
    return MAX(height, 44);
}

@end
