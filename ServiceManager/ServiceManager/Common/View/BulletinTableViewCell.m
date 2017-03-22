//
//  BulletinTableViewCell.m
//  ServiceManager
//
//  Created by will.wang on 2016/12/26.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "BulletinTableViewCell.h"

@implementation BulletinTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addCustomSubViews];
        [self layoutCustomSubViews];
    }
    return self;
}

- (void)addCustomSubViews
{
    _titleTextView = [UILabel new];
    [_titleTextView setFontSize:15 textColor:kColorDarkGray lineBreakMode:NSLineBreakByTruncatingTail lines:1];
    [self.contentView addSubview:_titleTextView];
    
    _summaryTextView = [UILabel new];
    [_summaryTextView setFontSize:14 textColor:[UIColor grayColor] lineBreakMode:NSLineBreakByTruncatingTail lines:2];
    [self.contentView addSubview:_summaryTextView];
    
    _dateTextView = [UILabel new];
    [_dateTextView setFontSize:13 textColor:kColorLightOrange lineBreakMode:NSLineBreakByWordWrapping lines:1];
    [_dateTextView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_dateTextView setContentCompressionResistancePriority: UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:_dateTextView];
}

-(void)layoutCustomSubViews
{
    [self.titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(kTableViewLeftPadding));
        make.right.equalTo(self.dateTextView.mas_left).with.offset(-10);
        make.height.equalTo(@(30));
    }];

    [self.summaryTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleTextView.mas_bottom).with.offset(0);
        make.left.equalTo(self.titleTextView);
        make.right.equalTo(@(-kTableViewLeftPadding));
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-5);
    }];

    [self.dateTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleTextView);
        make.right.equalTo(@(-kTableViewLeftPadding));
        make.height.equalTo(@(20));
    }];
}

- (CGFloat)fitHeight
{
    [self updateConstraintsAndLayout];

    CGSize fitSize = [self.summaryTextView sizeThatFits:CGSizeMake(CGRectGetWidth(self.summaryTextView.frame), MAXFLOAT)];
    CGFloat height = 0;
    height += CGRectGetMinY(self.summaryTextView.frame); //summary start y
    height += fitSize.height;   //summary height
    height += 5;    //bottom seprate
    height += 1;    //another 1 point
    return height;
}

@end
