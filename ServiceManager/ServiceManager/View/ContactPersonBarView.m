//
//  ContactPersonBarView.m
//  HouseMarket
//
//  Created by wangzhi on 15-3-12.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

//用于详情下的联系人栏

#import "ContactPersonBarView.h"

@interface ContactPersonBarView ()

@end

@implementation ContactPersonBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColorBlack;
        self.alpha = 0.8;
        [self layoutViews];
    }
    return self;
}

- (UIImageView*)avatar
{
    if (nil == _avatar) {
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 38, 38)];
        [_avatar clearBackgroundColor];
        _avatar.contentMode = UIViewContentModeScaleToFill;
        [_avatar circleView];
        _avatar.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:_avatar];
    }
    return _avatar;
}

- (UILabel*)nameLabel
{
    if (nil == _nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        [_nameLabel clearBackgroundColor];
        [_nameLabel setFont:SystemFont(14)];
        [_nameLabel setTextColor:kColorWhite];
         [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UIButton*)avatarButton
{
    if (nil ==_avatarButton) {
        _avatarButton = [[UIButton alloc]init];
        [_avatarButton clearBackgroundColor];
        [self addSubview:_avatarButton];
    }
    return _avatarButton;
}

- (UIButton *)callBtn
{
    if (nil == _callBtn) {
        _callBtn = [[UIButton alloc]init];
        [_callBtn setImage:ImageNamed(@"detail_phone_nor") forState:UIControlStateNormal];
        [_callBtn setImage:ImageNamed(@"detail_phone_sel") forState:UIControlStateHighlighted];
         [self addSubview:_callBtn];
    }
    return _callBtn;
}

- (UIButton *)chatBtn
{
    if (nil == _chatBtn) {
        _chatBtn = [[UIButton alloc]init];
        [_chatBtn setImage:ImageNamed(@"detail_messge_nor") forState:UIControlStateNormal];
        [_chatBtn setImage:ImageNamed(@"detail_messge_sel") forState:UIControlStateHighlighted];
        [self addSubview:_chatBtn];
    }
    return _chatBtn;
}

- (void)layoutViews
{
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@kTableViewLeftPadding);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@38);
        make.height.equalTo(@38);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).with.offset(10);
        make.centerY.equalTo(self.avatar);
    }];

    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self.nameLabel);
    }];

    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatar);
        make.right.equalTo(@(- 2*kDefaultSpaceUnit));
        make.width.equalTo(self.mas_height);
        make.height.equalTo(self.chatBtn.mas_width);
    }];

    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatar);
        make.right.equalTo(self.chatBtn.mas_left).with.offset(-2*kDefaultSpaceUnit);
        make.width.equalTo(self.chatBtn);
        make.height.equalTo(self.chatBtn);
    }];
}

@end
