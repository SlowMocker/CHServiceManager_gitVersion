//
//  IconLabelTextFiledView.m
//  ServiceManager
//
//  Created by will.wang on 2016/9/23.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "IconLabelTextFiledView.h"

static CGFloat sSpaceUnit = 6;

@implementation IconLabelTextFiledView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeCustomSubViews];
        [self layoutCustomSubViews];
    }
    return self;
}

- (void)makeCustomSubViews
{
    _icon = [UIImageView new];
    _icon.contentMode = UIViewContentModeCenter;
    [self addSubview:_icon];
    
    _label = [UILabel new];
    [self addSubview:_label];

    _textFiled = [UITextField new];
    [self addSubview:_textFiled];
}

- (void)layoutCustomSubViews
{
    NSArray *subViews = @[self.icon, self.label, self.textFiled];
    UIView *preView;
    [self.icon setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    for (UIView *subView in subViews) {
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (nil == preView) {
                make.left.equalTo(self).with.offset(sSpaceUnit);
            }else {
                make.left.equalTo(preView.mas_right).with.offset(sSpaceUnit);
            }
            make.centerY.equalTo(self);
        }];
        preView = subView;
    }
    [preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-sSpaceUnit);
    }];
}

-(instancetype)initWithFrame:(CGRect)frame icon:(NSString*)iconName label:(NSString*)labelText placeHolder:(NSString*)placeHolder
{
    self = [self initWithFrame:frame];
    if (self) {
        _textFiled.textColor = kColorWhite;
        _textFiled.textAlignment = NSTextAlignmentLeft;
        [_textFiled clearBackgroundColor];

        //set corner
        UIColor *borderColor = [[UIColor alloc]initWithRed:1 green:1 blue:1 alpha:0.4];
        [self circleCornerWithRadius:18.0];
        self.layer.borderColor = borderColor.CGColor;
        self.layer.borderWidth = 0.5;
        self.backgroundColor = kColorClear;

        _icon.image = ImageNamed(iconName);
        _icon.contentMode = UIViewContentModeLeft;
        [_icon sizeToFit];

        _label.text = labelText;
        _textFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName: kColorLightGray}];
    }
    return self;
}

@end
