//
//  NormalSelectTableViewCell.m
//  ServiceManager
//
//  Created by will.wang on 16/6/24.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "NormalSelectTableViewCell.h"

@interface NormalSelectTableViewCell()
@property(nonatomic, strong)UITapGestureRecognizer *singleTapGesture;
@end

@implementation NormalSelectTableViewCell

- (instancetype)initWithTitle:(NSString*)title reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.textLabel setFont:SystemFont(14)];
        [self.textLabel setText:title];

        [self.detailTextLabel setText:@"请选择"];
        [self.detailTextLabel setFont:SystemFont(14)];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setDidSelectHandleBlock:(VoidBlock_id)didSelectHandleBlock{
    if (_didSelectHandleBlock != didSelectHandleBlock) {
        _didSelectHandleBlock = didSelectHandleBlock;
    }
    if (nil != _didSelectHandleBlock) {
        if (nil == self.singleTapGesture) {
            self.singleTapGesture = [self addSingleTapEventWithTarget:self action:@selector(handleCellSelectEvent:)];
        }
    }else {
        if (nil != self.singleTapGesture) {
            [self removeGestureRecognizer:self.singleTapGesture];
            self.singleTapGesture = nil;
        }
    }
}

- (void)handleCellSelectEvent:(UITapGestureRecognizer*)singleTapGesture
{
    self.didSelectHandleBlock(self);
}

-(void)setSelectedItemValue:(NSString*)selectedItemValue
{
    self.detailTextLabel.text = [Util defaultStr:@"请选择" ifStrEmpty:selectedItemValue];
}

-(void)setSelectedItemValueWithAttrStr:(NSAttributedString*)selectedItemValue
{
    if ([Util isEmptyString:selectedItemValue.string]) {
        selectedItemValue = [[NSAttributedString alloc]initWithString:@"请选择"];
    }

    self.detailTextLabel.attributedText = selectedItemValue;
}

- (CGFloat)fitHeight
{
    [self setNeedsLayout];
    [self layoutIfNeeded];

    CGSize fitSize = [self.detailTextLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.detailTextLabel.frame), MAXFLOAT)];

    return MAX(kTableViewCellDefaultHeight, fitSize.height + kDefaultSpaceUnit*2);
}

@end
