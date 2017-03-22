//
//  LeftAttrRightAttrCell.m
//  ServiceManager
//
//  Created by wangzhi on 15/7/20.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "LeftAttrRightAttrCell.h"

@implementation LeftAttrRightAttrCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftAttrLabelWidth = 60;
        _rightAttrLabelWidth = 60;
        [self addCustomSubViews];
        [self layoutCustomSubViews];
    }
    return self;
}

-(UILabel*)createLabelWithColor:(UIColor*)color font:(UIFont*)font
{
    UILabel *label = [UILabel new];
    [label clearBackgroundColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = color;
    label.font = font;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;

    return label;
}

- (void)addCustomSubViews
{
    _leftAttrLabel = [self createLabelWithColor:kColorDarkGray font:SystemFont(14)];
    [self.contentView addSubview:_leftAttrLabel];

    _leftAttrValueLabel = [self createLabelWithColor:kColorDarkGray font:SystemFont(15)];
    [self.contentView addSubview:_leftAttrValueLabel];

    _rightAttrLabel = [self createLabelWithColor:kColorDarkGray font:SystemFont(14)];
    [self.contentView addSubview:_rightAttrLabel];

    _rightAttrValueLabel = [self createLabelWithColor:kColorDarkGray font:SystemFont(15)];
    [self.contentView addSubview:_rightAttrValueLabel];

}

- (void)layoutCustomSubViews
{
    [_leftAttrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(kTableViewLeftPadding);
        make.width.equalTo(@(self.leftAttrLabelWidth));
    }];

    [_leftAttrValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.leftAttrLabel.mas_right);
    }];

    [_rightAttrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_centerX).with.offset(kTableViewLeftPadding);
        make.width.equalTo(@(self.rightAttrLabelWidth));
    }];
    [_rightAttrValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.rightAttrLabel.mas_right);
    }];
}

@end
