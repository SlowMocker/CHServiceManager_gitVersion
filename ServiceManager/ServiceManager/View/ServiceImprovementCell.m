//
//  ServiceImprovementCell.m
//  ServiceManager
//
//  Created by will.wang on 15/9/7.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ServiceImprovementCell.h"

static CGFloat sServiceImprovementCellVerticalPadding = 6;
static CGFloat sServiceImprovementCellDefaultTextLabelHeitht = 24;

@implementation ServiceImprovementCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = kColorWhite;
        [self.contentView clearBackgroundColor];
        [self addLineTo:kFrameLocationBottom];
    }
    return self;
}

-(UILabel*)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel clearBackgroundColor];
        _titleLabel.font = SystemFont(15);
        _titleLabel.textColor = kColorDefaultBlue;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UILabel*)contentLabel
{
    if (nil == _contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        [_contentLabel clearBackgroundColor];
        _contentLabel.font = SystemFont(13);
        _contentLabel.textColor = kColorDefaultRed;
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UILabel*)addressLabel
{
    if (nil == _addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        [_addressLabel clearBackgroundColor];
        _addressLabel.font = SystemFont(15);
        _addressLabel.textColor = kColorDarkGray;
        _addressLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (void)layoutCustomSubViews
{
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(sServiceImprovementCellVerticalPadding);
        make.height.equalTo(@(sServiceImprovementCellDefaultTextLabelHeitht));
        make.bottom.equalTo(self.mas_centerY);
        make.left.equalTo(self).with.offset(kDefaultSpaceUnit);
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).with.offset(kDefaultSpaceUnit/2);
        make.height.equalTo(self.titleLabel);
    }];

    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY);
        make.height.equalTo(self.titleLabel);
        make.bottom.equalTo(self).with.offset(-sServiceImprovementCellVerticalPadding);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutCustomSubViews];
}

- (CGFloat)fitHeight
{
    return (sServiceImprovementCellDefaultTextLabelHeitht + sServiceImprovementCellVerticalPadding) * 2;
}

@end
