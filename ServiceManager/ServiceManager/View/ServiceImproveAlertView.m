//
//  ServiceImproveAlertView.m
//  ServiceManager
//
//  Created by will.wang on 15/9/14.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ServiceImproveAlertView.h"

static CGFloat kServiceImproveAlertViewDefaultTextViewHeight = 24;
static CGFloat kServiceImproveAlertViewDefaultImageViewHeight = 28;

@implementation ServiceImproveAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addCustomSubViews];
        [self layoutCustomSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addCustomSubViews];
        [self layoutCustomSubViews];
        self.backgroundColor = kColorWhite;
        self.layer.borderColor = kColorLightGray.CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 5.0;
    }
    return self;
}

- (instancetype)initWithDefault
{
    return [self initWithFrame:CGRectMake(0, 0, ScreenWidth - kTableViewLeftPadding * 2, kServiceImproveAlertViewDefaultImageViewHeight + kServiceImproveAlertViewDefaultTextViewHeight *2 + kDefaultSpaceUnit)];
}

- (void)addCustomSubViews
{
    _alertIcon = [UIImageView new];
    [_alertIcon clearBackgroundColor];
    _alertIcon.contentMode = UIViewContentModeCenter;
    _alertIcon.image = ImageNamed(@"notice_warning_red");
    [self addSubview:_alertIcon];

    _alertTitle = [UILabel new];
    [_alertTitle clearBackgroundColor];
    _alertTitle.textColor = kColorDefaultRed;
    _alertTitle.font = SystemFont(15);
    [self addSubview:_alertTitle];
    
    _textLable1 = [UILabel new];
    [_textLable1 clearBackgroundColor];
    _textLable1.textColor = kColorDefaultRed;
    _textLable1.font = SystemFont(14);
    [self addSubview:_textLable1];
    
    _textLable2 = [UILabel new];
    [_textLable2 clearBackgroundColor];
    _textLable2.textColor = kColorDefaultRed;
    _textLable2.font = SystemFont(14);
    [self addSubview:_textLable2];
}

- (void)layoutCustomSubViews
{
    [_alertIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).with.offset(kDefaultSpaceUnit);
        make.height.equalTo(@(kServiceImproveAlertViewDefaultImageViewHeight));
    }];

    [_alertTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_alertIcon);
        make.left.equalTo(_alertIcon.mas_right).with.offset(kDefaultSpaceUnit);
        make.height.equalTo(@(kServiceImproveAlertViewDefaultImageViewHeight));
    }];

    [_textLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_alertIcon.mas_bottom);
        make.left.equalTo(_alertIcon);
        make.right.equalTo(self);
        make.height.equalTo(@(kServiceImproveAlertViewDefaultTextViewHeight));
    }];

    [_textLable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textLable1.mas_bottom);
        make.left.equalTo(_textLable1);
        make.right.equalTo(self);
        make.height.equalTo(_textLable1);
        make.bottom.equalTo(@(-kDefaultSpaceUnit));
    }];
    
}

@end
