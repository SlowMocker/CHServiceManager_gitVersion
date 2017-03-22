//
//  LeftTextRightTextCell.m
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-5-6.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "LeftTextRightTextCell.h"

@implementation LeftTextRightTextModel
@end

@interface LeftTextRightTextCell()

@end

@implementation LeftTextRightTextCell

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
    _leftTextLabelLeft = kTableViewLeftPadding;
    _leftTextLabelWidth = 65;
}

- (void)addCustomSubViews
{
    _leftTextLabel = [UILabel new];
    [_leftTextLabel clearBackgroundColor];
    _leftTextLabel.font = SystemFont(15);
    _leftTextLabel.textAlignment = NSTextAlignmentLeft;
    _leftTextLabel.textColor = kColorDarkGray;
    _leftTextLabel.numberOfLines = 0;
    _leftTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_leftTextLabel];

    _rightTextLabel = [UILabel new];
    [_rightTextLabel clearBackgroundColor];
    _rightTextLabel.font = SystemFont(15);
    _rightTextLabel.textAlignment = NSTextAlignmentLeft;
    _rightTextLabel.textColor = kColorDarkGray;
    _rightTextLabel.numberOfLines = 0;
    _rightTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_rightTextLabel];
}

- (void)layoutCustomSubViews
{
    [_leftTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(kTableViewLeftPadding);
        make.top.equalTo(self.contentView).with.offset(kDefaultSpaceUnit/2);
        make.bottom.equalTo(self.contentView).with.offset(-kDefaultSpaceUnit/2);
        if (![Util isEmptyString:_rightTextLabel.text]) {
            make.right.lessThanOrEqualTo(self.contentView.mas_centerX);
        }
    }];

    [_rightTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftTextLabel);
        make.left.greaterThanOrEqualTo(_leftTextLabel.mas_right).with.offset(kDefaultSpaceUnit);
        make.right.equalTo(self.contentView).with.offset(-kTableViewLeftPadding);
        make.bottom.equalTo(self.contentView).with.offset(-kDefaultSpaceUnit/2);
    }];
}

- (CGFloat)fitHeight
{
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];

    [self setNeedsLayout];
    [self layoutIfNeeded];

    CGFloat leftLabelHeight = [self.leftTextLabel sizeThatFits:CGSizeMake(self.leftTextLabel.frame.size.width, MAXFLOAT)].height;
    CGFloat rightLabelHeight = [self.rightTextLabel sizeThatFits:CGSizeMake(self.rightTextLabel.frame.size.width, MAXFLOAT)].height;

    CGFloat cellHeight = 0;
    cellHeight += kDefaultSpaceUnit/2;    //top space
    cellHeight += MAX(leftLabelHeight, rightLabelHeight); //label height
    cellHeight += kDefaultSpaceUnit/2;    //bottom sapce

    return cellHeight;
}

- (void)setDataModel:(LeftTextRightTextModel *)model
{
    if (_dataModel != model) {
        _dataModel = model;

        //set data to views for showing
        self.leftTextLabel.text = model.leftText;
        self.rightTextLabel.text = model.rightText;
        if (nil != model.leftTextColor) {
            self.leftTextLabel.textColor = model.leftTextColor;
        }
        if (nil != model.rightTextFont) {
            self.rightTextLabel.font = model.rightTextFont;
        }
        if (nil != model.rightTextColor) {
            self.rightTextLabel.textColor = model.rightTextColor;
        }
        self.accessoryView = model.accessoryView;
    }
}


@end
