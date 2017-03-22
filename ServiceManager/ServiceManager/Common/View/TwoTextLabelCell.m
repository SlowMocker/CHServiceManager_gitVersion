//
//  TwoTextLabelCell.m
//  ServiceManager
//
//  Created by will.wang on 1/7/16.
//  Copyright © 2016 wangzhi. All rights reserved.
//

#import "TwoTextLabelCell.h"

@interface TwoTextLabelCell()
@end

@implementation TwoTextLabelCell

- (instancetype)initWithLayoutType:(TwoTextLabelCellLayout)layout reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.estimatedCellWidth = ScreenWidth;
        [self addCustomSubViews];
        self.layoutType = layout;
    }
    return self;
}

- (void)setLayoutType:(TwoTextLabelCellLayout)layoutType{
    if (layoutType != _layoutType) {
        _layoutType = layoutType;
        [self layoutCustomSubViews];
    }
}

- (void)addCustomSubViews
{
    self.label1 = [UILabel new];
    [self.label1 clearBackgroundColor];
    self.label1.font = SystemFont(15);
    self.label1.textAlignment = NSTextAlignmentLeft;
    self.label1.textColor = kColorDarkGray;
    self.label1.numberOfLines = 0;
    self.label1.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:self.label1];
    
    self.label2 = [UILabel new];
    [self.label2 clearBackgroundColor];
    self.label2.font = SystemFont(15);
    self.label2.textAlignment = NSTextAlignmentLeft;
    self.label2.textColor = kColorDarkGray;
    self.label2.numberOfLines = 0;
    self.label2.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:self.label2];
}

- (void)layoutCustomSubViews
{
    switch (self.layoutType) {
        case TwoTextLabelCellLayoutLeftRight:
            [self layoutCustomSubViewsHorizontal];
            break;
        case TwoTextLabelCellLayoutTopBottom:
            [self layoutCustomSubViewsVertical];
            break;
        case TwoTextLabelCellLayoutOneLabel:
            [self layoutCustomSubViewsOneLabel];
            break;
        default:
            break;
    }
}

- (void)layoutCustomSubViewsHorizontal
{
    [self.label1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(kTableViewLeftPadding);
        make.right.lessThanOrEqualTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView).with.offset(kDefaultSpaceUnit);
        make.bottom.equalTo(self.contentView).with.offset(-kDefaultSpaceUnit);
    }];

    [self.label2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label1);
        make.left.greaterThanOrEqualTo(self.label1.mas_right).with.offset(kDefaultSpaceUnit);
        make.right.equalTo(self.contentView).with.offset(-kTableViewLeftPadding);
        make.bottom.equalTo(self.contentView).with.offset(-kDefaultSpaceUnit);
    }];
}

- (void)layoutCustomSubViewsVertical
{
    [self.label1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(kTableViewLeftPadding);
        make.right.equalTo(self.contentView).with.offset(-kTableViewLeftPadding);
        make.top.equalTo(self.contentView).with.offset(kDefaultSpaceUnit);
    }];
    [self.label2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label1);
        make.right.equalTo(self.label1);
        make.top.equalTo(self.label1.mas_bottom).with.offset(kDefaultSpaceUnit/2);
        make.bottom.equalTo(self.contentView).with.offset(-kDefaultSpaceUnit);
    }];
}

- (void)layoutCustomSubViewsOneLabel{
    [self.label1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(kDefaultSpaceUnit, kTableViewLeftPadding, kDefaultSpaceUnit, kTableViewLeftPadding));
    }];
}

- (CGFloat)fitHeight{
    CGFloat cellHeight = 0;

    switch (self.layoutType) {
        case TwoTextLabelCellLayoutLeftRight:
        {
            [self setNeedsUpdateConstraints];
            [self updateConstraintsIfNeeded];
            [self setNeedsLayout];
            [self layoutIfNeeded];

            CGFloat leftLabelHeight = [self.label1 sizeThatFits:CGSizeMake(self.label1.frame.size.width - 1, MAXFLOAT)].height;
            CGFloat rightLabelHeight = [self.label2 sizeThatFits:CGSizeMake(self.label2.frame.size.width - 1, MAXFLOAT)].height;
            cellHeight += kDefaultSpaceUnit;    //top space
            cellHeight += MAX(leftLabelHeight, rightLabelHeight); //label height
            cellHeight += kDefaultSpaceUnit;    //bottom sapce
            cellHeight += 1; //offset
        }
            break;
        case TwoTextLabelCellLayoutTopBottom:
        {
            cellHeight += kDefaultSpaceUnit;   //top space
            cellHeight += [self.label1 sizeThatFits:CGSizeMake(self.estimatedCellWidth - (kTableViewLeftPadding * 2), MAXFLOAT)].height;    //label1 height
            cellHeight += kDefaultSpaceUnit/2;  //space between label1 and label2
            cellHeight += [self.label2 sizeThatFits:CGSizeMake(self.estimatedCellWidth - (kTableViewLeftPadding * 2), MAXFLOAT)].height;    //label2 height
            cellHeight += kDefaultSpaceUnit; //bottom space
            cellHeight += 1; //offset
        }
            break;
        case TwoTextLabelCellLayoutOneLabel:
        {
            cellHeight += kDefaultSpaceUnit;   //top space
            cellHeight += [self.label1 sizeThatFits:CGSizeMake(self.estimatedCellWidth - (kTableViewLeftPadding * 2), MAXFLOAT)].height;    //label1 height
            cellHeight += kDefaultSpaceUnit; //bottom space
            cellHeight += 1; //offset
        }
            break;
        default:
            break;
    }
    return MAX(kTableViewCellDefaultHeight, cellHeight);
}

@end
