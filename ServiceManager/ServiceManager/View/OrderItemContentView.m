//
//  OrderItemContentView.m
//  ServiceManager
//
//  Created by will.wang on 15/8/28.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "OrderItemContentView.h"

static CGFloat kOrderItemContentViewVerticalPadding = 6;
static CGFloat kOrderItemDefaultTextLabelHeight = 26;
static CGFloat kOrderItemDefaultTagLabelSideLength = 20;

@interface OrderItemContentView()
@end

@implementation OrderItemContentView

+ (CGFloat)getFitHeightByType:(kOrderItemContentViewLayoutType)layoutType
{
    NSInteger nLine = 0;
    CGFloat cellHeight = kOrderItemContentViewVerticalPadding *2;
    
    switch (layoutType) {
        case kOrderItemContentViewLayoutType1:
            nLine = 3;
            break;
        case kOrderItemContentViewLayoutType5:
            nLine = 2;
            break;
        case kOrderItemContentViewLayoutType2:
        case kOrderItemContentViewLayoutType3:
        case kOrderItemContentViewLayoutType4:
        case kOrderItemContentViewLayoutType6:
            nLine = 3;
            break;
        default:
            break;
    }
    
    cellHeight += nLine * kOrderItemDefaultTextLabelHeight;
    
    return cellHeight;
}

- (void)updateConstraints
{
    [self layoutCustomSubViews];

    [super updateConstraints];
}

- (void)layoutCustomSubViews
{
    switch (self.layoutType) {
        case kOrderItemContentViewLayoutType1:
            [self layoutCustomSubViewsWithLayotType1];
            break;
        case kOrderItemContentViewLayoutType2:
            [self layoutCustomSubViewsWithLayotType2];
            break;
        case kOrderItemContentViewLayoutType3:
            [self layoutCustomSubViewsWithLayotType3];
            break;
        case kOrderItemContentViewLayoutType4:
            [self layoutCustomSubViewsWithLayotType4];
            break;
        case kOrderItemContentViewLayoutType5:
            [self layoutCustomSubViewsWithLayotType5];
            break;
        case kOrderItemContentViewLayoutType6:
            [self layoutCustomSubViewsWithLayotType6];
            break;
        default:
            break;
    }
}

#pragma mark - lazy loading views

-(UILabel*)orderIdLabel
{
    if (nil == _orderIdLabel) {
        _orderIdLabel = [[UILabel alloc]init];
        [_orderIdLabel clearBackgroundColor];
        _orderIdLabel.font = SystemFont(15);
        _orderIdLabel.textColor = kColorDefaultBlue;
        _orderIdLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_orderIdLabel];
    }
    return _orderIdLabel;
}

-(UILabel*)dateLabel
{
    if (nil == _dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.backgroundColor = kColorDefaultRed;
        _dateLabel.font = SystemFont(12);
        _dateLabel.textColor = kColorWhite;
        [_dateLabel circleCornerWithRadius:2.0];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

- (TQStarRatingView*)starView
{
    if (nil == _starView) {
        UIImage *starImg = ImageNamed(@"star_gray_16");
        CGRect frame = CGRectMake(0, 0, starImg.size.width * 5, starImg.size.height);
        _starView = [[TQStarRatingView alloc]initWithFrame:frame norStarIcon:@"star_gray_16" selStarIcon:@"star_red_16"];
        [self addSubview:_starView];
    }
    return _starView;
}

-(UILabel*)statusLabel
{
    if (nil == _statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        [_statusLabel clearBackgroundColor];
        _statusLabel.font = SystemFont(14);
        _statusLabel.textColor = kColorDefaultRed;
        _statusLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_statusLabel];
    }
    return _statusLabel;
}

-(UILabel*)contentLabel
{
    if (nil == _contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        [_contentLabel clearBackgroundColor];
        _contentLabel.font = SystemFont(13);
        _contentLabel.textColor = kColorDefaultRed;
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UILabel*)addressLabel
{
    if (nil == _addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        [_addressLabel clearBackgroundColor];
        _addressLabel.font = SystemFont(14);
        _addressLabel.textColor = kColorDarkGray;
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingHead;
        [self addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (void)showPrior:(BOOL)bPrior showUrgent:(BOOL)bUrgent
{
    if (bPrior) {
        [self setButtonAsJinji:self.label1Btn];
        if (bUrgent) {
            [self setButtonAsCui:self.label2Btn];
        }else {
            self.label2Btn.hidden = YES;
        }
    }else {
        if (bUrgent) {
            [self setButtonAsCui:self.label1Btn];
            self.label2Btn.hidden = YES;
        }else {
            self.label1Btn.hidden = YES;
            self.label2Btn.hidden = YES;
        }
    }
}

- (void)setButtonAsJinji:(UIButton*)button
{
    [button setBackgroundColor:kColorDefaultRed];
    [button setTitleForAllStatus:@"急"];
    button.hidden = NO;
}

- (void)setButtonAsCui:(UIButton*)button
{
    [button setBackgroundColor:kColorDefaultOrange];
    [button setTitleForAllStatus:@"催"];
    button.hidden = NO;
}

-(UIButton*)label1Btn
{
    if (nil == _label1Btn) {
        _label1Btn = [UIButton redButton:@"急"];
        [_label1Btn.titleLabel setFont:SystemFont(14)];
        [_label1Btn circleCornerWithRadius:kOrderItemDefaultTagLabelSideLength/2];
        [self addSubview:_label1Btn];
    }
    return _label1Btn;
}

-(UIButton*)label2Btn
{
    if (nil == _label2Btn) {
        _label2Btn = [UIButton orangeButton:@"催"];
        [_label2Btn.titleLabel setFont:SystemFont(14)];
        [_label2Btn circleCornerWithRadius:kOrderItemDefaultTagLabelSideLength/2];
        [self addSubview:_label2Btn];
    }
    return _label2Btn;
}

-(UIButton*)label3Btn
{
    if (nil == _label3Btn) {
        _label3Btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 47, 24)];
        [_label3Btn setTitleColor:kColorWhite forState:UIControlStateNormal];
        [_label3Btn circleCornerWithRadius:4];
        _label3Btn.titleLabel.font = SystemBoldFont(18);
        [self addSubview:_label3Btn];
    }
    return _label3Btn;
}

-(UILabel*)executeNameLabel
{
    if (nil == _executeNameLabel) {
        _executeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 47, 16)];
        _executeNameLabel.backgroundColor = kColorWhite;
        _executeNameLabel.font = SystemFont(13);
        _executeNameLabel.textColor = kColorDefaultBlue;
        _executeNameLabel.alpha = 0.8;
        _executeNameLabel.textAlignment = NSTextAlignmentCenter;
        [_executeNameLabel circleCornerWithRadius:4];
        _executeNameLabel.font = SystemBoldFont(13);
        _executeNameLabel.layer.borderWidth = 0.5;
        _executeNameLabel.layer.borderColor = kColorDefaultBlue.CGColor;
        [self addSubview:_executeNameLabel];
    }
    return _executeNameLabel;
}

- (void)layout1stLineCustomSubViews
{
    //order id
    [self.orderIdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(kOrderItemContentViewVerticalPadding);
        make.left.equalTo(self).with.offset(kDefaultSpaceUnit);
        make.height.equalTo(@(kOrderItemDefaultTextLabelHeight));
        make.bottom.equalTo(self.mas_centerY);
    }];

    //content
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderIdLabel.mas_right).with.offset(kDefaultSpaceUnit/2);
        make.centerY.equalTo(self.orderIdLabel);
    }];
    
    //cicle label
    NSArray *labelBtnArray = @[self.label1Btn, self.label2Btn];
    UIView *leftView = self.contentLabel;
    for (UIButton *labelBtn in labelBtnArray) {
        [labelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftView.mas_right).with.offset(kDefaultSpaceUnit/2);
            make.centerY.equalTo(self.orderIdLabel);
            make.size.mas_equalTo(CGSizeMake(kOrderItemDefaultTagLabelSideLength, kOrderItemDefaultTagLabelSideLength));
        }];
        leftView = labelBtn;
    }
    
    [self.label3Btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orderIdLabel);
        make.right.equalTo(self).with.offset(-kDefaultSpaceUnit);
        make.size.mas_equalTo(self.label3Btn.frame.size);
    }];
}

- (void)layoutCustomSubViewsWithLayotType1
{
    [self layout1stLineCustomSubViews];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderIdLabel.mas_bottom);
        make.left.equalTo(self.orderIdLabel);
        make.right.equalTo(self);
        make.height.equalTo(@(kOrderItemDefaultTextLabelHeight));
    }];

    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom);
        make.bottom.equalTo(self).with.offset(-kOrderItemContentViewVerticalPadding);
        make.height.equalTo(@(kOrderItemDefaultTextLabelHeight));
        make.left.equalTo(self.orderIdLabel);
        make.right.equalTo(self);
    }];
    
    //remove needless views
    [_executeNameLabel removeFromSuperview];
    _executeNameLabel.hidden = YES;
//    _executorView = nil;
    
    [_dateLabel removeFromSuperview];
    _dateLabel.hidden = YES;
//    _dateLabel = nil;
    
    [_starView removeFromSuperview];
    _starView.hidden = YES;
//    _starView = nil;
}

- (void)layoutCustomSubViewsWithLayotType2
{
    [self layout1stLineCustomSubViews];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderIdLabel.mas_bottom);
        make.left.equalTo(self.orderIdLabel);
        make.right.equalTo(self.executeNameLabel.mas_left);
        make.height.equalTo(@(kOrderItemDefaultTextLabelHeight));
    }];
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom);
        make.left.equalTo(self.statusLabel);
        make.right.equalTo(self.executeNameLabel.mas_left);
        make.bottom.equalTo(self).with.offset(-kOrderItemContentViewVerticalPadding);
        make.height.equalTo(@(kOrderItemDefaultTextLabelHeight));
    }];
    
    [self.executeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusLabel);
        make.size.mas_equalTo(self.executeNameLabel.frame.size);
        make.right.equalTo(@(-kDefaultSpaceUnit));
    }];

    //remove needless views
    [_dateLabel removeFromSuperview];
    _dateLabel.hidden = YES;
//    _dateLabel = nil;
    
    [_starView removeFromSuperview];
    _starView.hidden = YES;
//    _starView = nil;
}

- (void)layoutCustomSubViewsWithLayotType3
{
    [self layout1stLineCustomSubViews];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderIdLabel.mas_bottom);
        make.left.equalTo(self.orderIdLabel);
        make.height.equalTo(@(kOrderItemDefaultTextLabelHeight));
    }];

    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLabel.mas_right).with.offset(kDefaultSpaceUnit/2);
        make.centerY.equalTo(self.statusLabel);
    }];
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom);
        make.left.equalTo(self.statusLabel);
        make.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(-kOrderItemContentViewVerticalPadding);
        make.height.equalTo(@(kOrderItemDefaultTextLabelHeight));
    }];
    
    //remove needless views
    [_executeNameLabel removeFromSuperview];
    _executeNameLabel.hidden = YES;
//    _executorView = nil;
    
    [_starView removeFromSuperview];
    _starView.hidden = YES;
//    _starView = nil;
}

- (void)layoutCustomSubViewsWithLayotType4
{
    [self layout1stLineCustomSubViews];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderIdLabel.mas_bottom);
        make.left.equalTo(self.orderIdLabel);
        make.right.equalTo(self.starView.mas_left);
        make.height.equalTo(@(kOrderItemDefaultTextLabelHeight));
    }];

    [self.starView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.starView.frame.size);
        make.centerY.equalTo(self.statusLabel);
        make.left.equalTo(self.mas_centerX);
    }];

    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom);
        make.left.equalTo(self.statusLabel);
        make.right.equalTo(self.executeNameLabel.mas_left).with.offset(-kDefaultSpaceUnit);
        make.bottom.equalTo(self).with.offset(-kOrderItemContentViewVerticalPadding);
        make.height.equalTo(@(kOrderItemDefaultTextLabelHeight));
    }];

    [self.executeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusLabel);
        make.size.mas_equalTo(self.executeNameLabel.frame.size);
        make.right.equalTo(@(-kDefaultSpaceUnit));
    }];

    //remove needless views
    [_dateLabel removeFromSuperview];
    _dateLabel.hidden = YES;
//    _dateLabel = nil;
}

- (void)layoutCustomSubViewsWithLayotType5
{
    [self layout1stLineCustomSubViews];

    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderIdLabel.mas_bottom);
        make.left.equalTo(self.orderIdLabel);
        make.right.equalTo(self.executeNameLabel.mas_left).with.offset(-kDefaultSpaceUnit);
        make.bottom.equalTo(self).with.offset(-kOrderItemContentViewVerticalPadding);
        make.height.equalTo(@(kOrderItemDefaultTextLabelHeight));
    }];

    [self.executeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.executeNameLabel.frame.size);
        make.right.equalTo(@(-kDefaultSpaceUnit));
        make.top.equalTo(self.label3Btn.mas_bottom).with.offset(4);
    }];
    
    [self.starView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.starView.frame.size);
        make.centerY.equalTo(self.orderIdLabel);
        make.right.equalTo(self.label3Btn.mas_left).with.offset(-kDefaultSpaceUnit/2);
    }];

    //remove needless views
    [_statusLabel removeFromSuperview];
    _statusLabel.hidden = YES;
//    _statusLabel = nil;

    [_dateLabel removeFromSuperview];
    _dateLabel.hidden = YES;
//    _dateLabel = nil;
    
    [_label1Btn removeFromSuperview];
    _label1Btn.hidden = YES;

    [_label2Btn removeFromSuperview];
    _label2Btn.hidden = YES;
}

- (void)layoutCustomSubViewsWithLayotType6
{
    [self layout1stLineCustomSubViews];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderIdLabel.mas_bottom);
        make.left.equalTo(self.orderIdLabel);
        make.height.equalTo(@(kOrderItemDefaultTextLabelHeight));
    }];

    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLabel.mas_right).with.offset(kDefaultSpaceUnit/2);
        make.centerY.equalTo(self.statusLabel);
    }];
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom);
        make.left.equalTo(self.statusLabel);
        make.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(-kOrderItemContentViewVerticalPadding);
        make.height.equalTo(@(kOrderItemDefaultTextLabelHeight));
    }];
    
    [self.executeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.executeNameLabel.frame.size);
        make.right.equalTo(@(-kDefaultSpaceUnit));
        make.top.equalTo(self.label3Btn.mas_bottom).with.offset(4);
    }];

    [_starView removeFromSuperview];
    _starView.hidden = YES;
    //    _starView = nil;
}

- (void)updateProductRepairTypeToViews:(NSString*)processType{

    if (![Util isEmptyString:processType]) {
        UIColor *buttonColor = ColorWithHex(@"#1a9bfc");
        NSString *buttonText = processType;
        if ([processType containsString:@"新"]) {
            buttonText = @"装";
        }else if([processType containsString:@"修"]) {
            buttonColor = ColorWithHex(@"#7f0f7e");
            buttonText = @"修";
        }
        self.label3Btn.hidden = NO;
        
        [self.label3Btn setBackgroundColor:buttonColor forState:UIControlStateNormal];
        [self.label3Btn setTitle:buttonText forState:UIControlStateNormal];
    }else {
        self.label3Btn.hidden = YES;
    }
}

@end
