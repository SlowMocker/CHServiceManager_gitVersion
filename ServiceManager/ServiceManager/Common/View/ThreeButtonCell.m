//
//  ThreeButtonCell.m
//  ServiceManager
//
//  Created by wangzhi on 15-5-26.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ThreeButtonCell.h"

@implementation ThreeButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self resetDefaultPropertyValue];
        [self addCustomSubViews];
        [self layoutCustomSubViews];
    }
    return self;
}

- (void)resetDefaultPropertyValue
{
}

- (UIButton*)makeButton
{
    UIButton *button = [[UIButton alloc]init];
    [button clearBackgroundColor];
    [button setTitleColor:kColorDarkGray forState:UIControlStateNormal];
    [button.titleLabel setFont:SystemFont(14)];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (void)buttonClicked:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(threeButtonCell:buttonClicked:)]) {
        [self.delegate threeButtonCell:self buttonClicked:button];
    }
}

- (void)addCustomSubViews
{
    _button1 = [self makeButton];
    [self.contentView addSubview:_button1];

    _button2 = [self makeButton];
    [self.contentView addSubview:_button2];

    _button3 = [self makeButton];
    [self.contentView addSubview:_button3];
}

- (void)layoutCustomSubViews
{
    CGFloat width = (ScreenWidth - kTableViewLeftPadding * 2) / 3;

    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.width.equalTo(@(width));
    }];

    [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_button1.mas_right);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.width.equalTo(_button1);
    }];

    [_button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_button2.mas_right);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-kTableViewLeftPadding);
    }];
}

- (ThreeButtonCell*)configureCellDatas:(NSArray*)textArray
{
    NSArray *btnArray = @[_button1, _button2, _button3];
    UIButton *titleBtn;
    for (NSInteger index = 0; index < MIN(textArray.count, btnArray.count); index++) {
        titleBtn = btnArray[index];
        [titleBtn setTitle:textArray[index] forState:UIControlStateNormal];
    }
    return self;
}

@end
