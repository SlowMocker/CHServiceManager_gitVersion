//
//  TextFieldTableViewCell.m
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-5-13.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "TextFieldTableViewCell.h"

@implementation TextFieldTableViewCell

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

- (void)addCustomSubViews
{
    _textField = [UITextField new];
    [_textField clearBackgroundColor];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.textColor = kColorDarkGray;
    _textField.font = SystemFont(15);
    _textField.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_textField];
}

- (void)layoutCustomSubViews
{
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0, kTableViewLeftPadding, 0, kTableViewLeftPadding);
        make.edges.equalTo(self.contentView).with.insets(insets);
    }];
}

- (CGFloat)fitHeight
{
    return kTableViewCellDefaultHeight;
}
@end
