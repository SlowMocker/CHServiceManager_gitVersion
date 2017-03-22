//
//  TextLabelCell.m
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-5-8.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//


#import "TextLabelCell.h"

@implementation TextLabelCell

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
    _textContentLabel = [UILabel new];
    [_textContentLabel clearBackgroundColor];
    _textContentLabel.textAlignment = NSTextAlignmentLeft;
    _textContentLabel.textColor = kColorDarkGray;
    _textContentLabel.font = SystemFont(15);
    _textContentLabel.numberOfLines = 0;
    _textContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_textContentLabel];
}

- (void)layoutCustomSubViews
{
    [_textContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets insets = UIEdgeInsetsMake(kDefaultSpaceUnit, kTableViewLeftPadding, kDefaultSpaceUnit, kTableViewLeftPadding);
        make.edges.equalTo(self.contentView).with.insets(insets);
    }];
}

- (CGFloat)fitHeight
{
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];

    [self setNeedsLayout];
    [self layoutIfNeeded];

    CGFloat leftLabelHeight = [self.textContentLabel sizeThatFits:CGSizeMake(self.textContentLabel.frame.size.width, MAXFLOAT)].height;

    DLog(@"%@,text content height:%@", NSStringFromClass([self class]),@(leftLabelHeight));

    return leftLabelHeight + kDefaultSpaceUnit*2;
}


@end
