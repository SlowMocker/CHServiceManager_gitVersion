//
//  EmployeeInfoCell.m
//  ServiceManager
//
//  Created by will.wang on 15/9/2.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "EmployeeInfoCell.h"

@implementation EmployeeInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addCustomSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return self;
}

- (UIView*)leftTagView
{
    if (_leftTagView == nil) {
        _leftTagView = [UIView new];
        _leftTagView.backgroundColor = kColorDefaultOrange;
        [self.contentView addSubview:_leftTagView];
        [_leftTagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.width.equalTo(@(kDefaultSpaceUnit/2));
        }];
    }
    return _leftTagView;
}

- (void)addCustomSubViews
{
    _leftNumIcon = [UIImageView new];
    [_leftNumIcon clearBackgroundColor];
    [self.contentView addSubview:_leftNumIcon];

    _leftNumLabel = [UILabel new];
    [_leftNumLabel clearBackgroundColor];
    _leftNumLabel.font = SystemFont(14);
    _leftNumLabel.textColor = kColorWhite;
    [self.contentView addSubview:_leftNumLabel];
    
    _nameLabel = [UILabel new];
    [_nameLabel clearBackgroundColor];
    _nameLabel.font = SystemFont(15);
    _nameLabel.textColor = kColorDarkGray;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_nameLabel];
    
    _mobileLabel = [UILabel new];
    [_mobileLabel clearBackgroundColor];
    _mobileLabel.font = SystemFont(14);
    _mobileLabel.textColor = kColorDefaultBlue;
    _mobileLabel.adjustsFontSizeToFitWidth = YES;
    _mobileLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_mobileLabel];
    
    _taskCountLabel = [UILabel new];
    [_taskCountLabel clearBackgroundColor];
    _taskCountLabel.textColor = kColorDefaultRed;
    _taskCountLabel.font = SystemFont(14);
    [self.contentView addSubview:_taskCountLabel];

    _infoLabel = [UILabel new];
    [_infoLabel clearBackgroundColor];
    _infoLabel.font = SystemFont(14);
    _infoLabel.textColor = kColorDefaultBlue;
    _infoLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_infoLabel];
    
    [self.contentView addLineTo:kFrameLocationBottom];
}

- (void)layoutCustomSubViews
{
    [self.leftNumIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(kDefaultSpaceUnit/2);
        make.bottom.equalTo(self.contentView);
        make.width.equalTo(@34);
    }];
    [self.leftNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.leftNumIcon);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.leftNumIcon.mas_right);
        make.height.equalTo(@30);
        make.right.equalTo(self.mobileLabel.mas_left).with.offset(-kDefaultSpaceUnit/2);
    }];
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel);
        make.bottom.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).with.offset(-kDefaultSpaceUnit);
        make.width.greaterThanOrEqualTo(@70);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.leftNumIcon.mas_right);
        make.bottom.equalTo(self.contentView).with.offset(-kDefaultSpaceUnit);
    }];
}

- (void)layoutCustomSubViews2
{
    self.leftNumIcon.hidden = YES;
    self.leftNumIcon = nil;

    self.leftNumLabel.hidden = YES;
    self.leftNumLabel = nil;

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(@(kTableViewLeftPadding));
        make.height.equalTo(@30);
        make.right.lessThanOrEqualTo(self.mobileLabel.mas_left).with.offset(-kDefaultSpaceUnit/2);
    }];
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel);
        make.bottom.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).with.offset(-kTableViewLeftPadding);
        make.width.greaterThanOrEqualTo(@70);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.nameLabel);
        make.bottom.equalTo(self.contentView).with.offset(-kDefaultSpaceUnit);
    }];
    [self.taskCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.infoLabel);
        make.right.equalTo(self.mobileLabel);
    }];
}

- (CGFloat)fitHeight
{
    return 64;
}

@end
