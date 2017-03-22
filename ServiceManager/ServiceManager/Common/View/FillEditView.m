//
//  FillEditView.m
//  HouseMarket
//
//  Created by wangzhi on 15-3-18.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "FillEditView.h"

@interface FillEditView ()<UITextFieldDelegate>

@end

@implementation FillEditView

- (UILabel*)leftLabel
{
    if (nil == _leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.font = SystemFont(15);
        _leftLabel.textColor = kColorBlack;
        [self addSubview:_leftLabel];
    }
    return _leftLabel;
}

- (UILabel*)rightLabel
{
    if (nil == _rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.font = SystemFont(15);
        _rightLabel.textColor = kColorBlack;
        [_rightLabel clearBackgroundColor];
        [self addSubview:_rightLabel];
    }
    return _rightLabel;
}

- (UITextField*)middleFillEdit
{
    if (nil == _middleFillEdit) {
        _middleFillEdit = [[UITextField alloc]init];
        _middleFillEdit.delegate = self;
        _middleFillEdit.textColor = kColorDarkGray;
        _middleFillEdit.font = SystemFont(15);
        _middleFillEdit.textAlignment = NSTextAlignmentCenter;
        _middleFillEdit.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_middleFillEdit];
    }
    return _middleFillEdit;
}

-(void)addConstraintForLayout
{
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.centerY.equalTo(self);
    }];

    [self.middleFillEdit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel.mas_right).with.offset(0);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.centerY.equalTo(self);
        make.width.greaterThanOrEqualTo(@50);
    }];

    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleFillEdit.mas_right).with.offset(0);
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)layoutSubviews
{
    [self addConstraintForLayout];
    [super layoutSubviews];
}

@end
