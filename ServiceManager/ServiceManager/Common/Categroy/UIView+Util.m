//
//  UIView+Util.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-6.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "UIView+Util.h"

#define kaddDefaultSepraterBottomLineTag    0x5793680
#define kTopErrorLabelViewTag               0x5793681

#define kMiddleTextPlaceHolderViewTag       0x5793682
#define kMiddleImagePlaceHolderViewTag      0x5793683
#define kPlaceHolderViewTag 0x5793687

#define kMiddleImageTextPlaceHolderViewTag  0x5793684
#define kMiddleImageTextPlaceHolderViewImageTag     0x5793685
#define kMiddleImageTextPlaceHolderViewTextTag      0x5793686

@implementation UIView (Util)


-(CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

-(CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

-(CGSize)size
{
    return self.frame.size;
}

-(void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;

    if (width != frame.size.width) {
        frame.size.width = width;
        self.frame = frame;
    }
}

-(void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;

    if (height != frame.size.height) {
        frame.size.height = height;
        self.frame = frame;
    }
}

-(void)setSize:(CGSize)size
{
    CGRect frame = self.frame;

    if (size.width != frame.size.width
        || size.height != frame.size.height) {
        frame.size = size;
        self.frame = frame;
    }
}

-(UIView*)clearBackgroundColor
{
    self.backgroundColor = [UIColor clearColor];

    return self;
}

- (void)circleView
{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
}

- (void)circleCornerWithRadius:(CGFloat)radius
{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

- (void)circleView:(CGFloat)borderWidth color:(UIColor*)color
{
    [self circleView];
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = color.CGColor;
}

-(UIView*)circleCorner:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor = [UIColor clearColor].CGColor;
    maskLayer.masksToBounds = YES;
    self.layer.mask = maskLayer;

    return self;
}

- (void)removeAllSubviews
{
    for (UIView *subView in self.subviews)
    {
        [subView removeFromSuperview];
    }
}

- (UIView *)addLineTo:(kFrameLocation)locate
{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kColorLightGray;
    line.alpha = 0.5;
    [self addSubview:line];
    [self bringSubviewToFront:line];

    CGFloat fineness = 0.5;

    switch (locate) {
        case kFrameLocationTop:
        case kFrameLocationBottom:
        {
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                if (kFrameLocationBottom == locate) {
                    make.bottom.equalTo(self);
                }else {
                    make.top.equalTo(self);
                }
                make.left.equalTo(self);
                make.right.equalTo(self);
                make.height.equalTo(@(fineness));
            }];
        }
            break;
        case kFrameLocationLeft:
        case kFrameLocationRight:
        {
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                if (kFrameLocationLeft == locate) {
                    make.left.equalTo(self);
                }else {
                    make.right.equalTo(self);
                }
                make.top.equalTo(self);
                make.bottom.equalTo(self);
                make.width.equalTo(@(fineness));
            }];
        }
            break;
        default:
            break;
    }
    return line;
}

- (UIView *)addBottomLine:(UIColor*)color
{
    UIView *line = [self viewWithTag:kaddDefaultSepraterBottomLineTag];
    if (nil == line) {
        CGFloat lineHeight = 0.5;

        CGRect frame =  CGRectMake(0, self.height - lineHeight, self.width, lineHeight);
        UIView *line = [[UIView alloc]initWithFrame:frame];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.5;
        line.tag = kaddDefaultSepraterBottomLineTag;
        line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:line];
    }
    [self bringSubviewToFront:line];

    return line;
}

- (UIView *)showTopErrorLabel:(NSString*)errorInfo
{
    UILabel *errorLabel = (UILabel*)[self viewWithTag:kTopErrorLabelViewTag];
    if (nil == errorLabel) {
        errorLabel = [[UILabel alloc]init];
        [errorLabel setFont:SystemFont(14)];
        errorLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
        errorLabel.numberOfLines = 0;
        errorLabel.lineBreakMode = NSLineBreakByCharWrapping;
        errorLabel.textAlignment = NSTextAlignmentCenter;
        errorLabel.textColor = kColorWhite;
        errorLabel.tag = kTopErrorLabelViewTag;
        [self addSubview:errorLabel];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];

    CGRect frame = CGRectMake(0, 0, self.width, 40);
    CGSize fitSize = [errorInfo wz_sizeWithFont:errorLabel.font constrainedToSize:CGSizeMake(errorLabel.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    frame.size.height = MAX(fitSize.height + 10, 40);

    errorLabel.frame = frame;
    [self bringSubviewToFront:errorLabel];
    [errorLabel setText:[Util defaultStr:@"未知错误" ifStrEmpty:errorInfo]];

    return errorLabel;
}

- (void)dismissTopErrorLabel
{
    UILabel *errorLabel = (UILabel*)[self viewWithTag:kTopErrorLabelViewTag];
    if (nil != errorLabel) {
        errorLabel.hidden = YES;
        [errorLabel removeFromSuperview];
    }
}

- (UITapGestureRecognizer*)addSingleTapEventWithTarget:(id)target action:(SEL)action
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:gesture];
    return gesture;
}

- (UILabel *)showPlaceHolderWithText:(NSString*)text
{
    UILabel *middleTextLabel = (UILabel*)[self viewWithTag:kMiddleTextPlaceHolderViewTag];

    if (nil == middleTextLabel) {
        middleTextLabel = [[UILabel alloc]init];
        middleTextLabel.backgroundColor = ColorWithHex(@"f1f3f7");
        middleTextLabel.font = SystemFont(16);
        middleTextLabel.textColor = kColorDarkGray;
        middleTextLabel.textAlignment = NSTextAlignmentCenter;
        middleTextLabel.numberOfLines = 0;
        middleTextLabel.tag = kMiddleTextPlaceHolderViewTag;
        [self addSubview:middleTextLabel];
        [middleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }else {
        [self bringSubviewToFront:middleTextLabel];
    }
    middleTextLabel.text = text;
    return middleTextLabel;
}

- (UIImageView *)showPlaceHolderWithImage:(UIImage*)image
{
    UIImageView *middleImage = (UIImageView*)[self viewWithTag:kMiddleImagePlaceHolderViewTag];

    if (nil == middleImage) {
        middleImage = [[UIImageView alloc]init];
        middleImage.backgroundColor = ColorWithHex(@"f1f3f7");
        middleImage.tag = kMiddleImagePlaceHolderViewTag;
        middleImage.contentMode = UIViewContentModeCenter;
        [self addSubview:middleImage];
        [middleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
    }
    middleImage.image = image;
    return middleImage;
}

- (UIView*)showPlaceHolderWithText:(NSString*)text image:(UIImage*)image
{
    UIView *placeHolderView = (UIView*)[self viewWithTag:kPlaceHolderViewTag];   //背景
    UIView *middleContentView;  //中间的IMAGE/TEXT背景
    UIImageView *imageView;     //IMAGE
    UILabel *textLabel;         //LABEL

    if (nil == placeHolderView) {
        placeHolderView = [[UIView alloc]init];
        placeHolderView.backgroundColor = ColorWithHex(@"f1f3f7");
        placeHolderView.tag = kPlaceHolderViewTag;
        [self addSubview:placeHolderView];
        [placeHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];

        middleContentView = [UIView new];
        middleContentView.tag = kMiddleImageTextPlaceHolderViewTag;
        [middleContentView clearBackgroundColor];
        [placeHolderView addSubview:middleContentView];
        [middleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(placeHolderView);
            make.left.greaterThanOrEqualTo(placeHolderView);
            make.right.lessThanOrEqualTo(placeHolderView);
            make.top.greaterThanOrEqualTo(placeHolderView);
            make.bottom.lessThanOrEqualTo(placeHolderView);
        }];

        imageView = [UIImageView new];
        imageView.tag = kMiddleImageTextPlaceHolderViewImageTag;
        [imageView clearBackgroundColor];
        imageView.contentMode = UIViewContentModeCenter;
        [middleContentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(middleContentView);
            make.left.equalTo(middleContentView);
            make.right.equalTo(middleContentView);
        }];

        textLabel = [UILabel new];
        [textLabel clearBackgroundColor];
        textLabel.tag = kMiddleImageTextPlaceHolderViewTextTag;
        textLabel.font = SystemFont(16);
        textLabel.textColor = kColorDarkGray;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 0;
        [middleContentView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom);
            make.left.equalTo(middleContentView);
            make.right.equalTo(middleContentView);
            make.bottom.equalTo(middleContentView);
        }];
    }else {
        middleContentView = [placeHolderView viewWithTag:kMiddleImageTextPlaceHolderViewTag];
        imageView = (UIImageView*)[middleContentView viewWithTag:kMiddleImageTextPlaceHolderViewImageTag];
        textLabel = (UILabel*)[middleContentView viewWithTag:kMiddleImageTextPlaceHolderViewTextTag];
    }

    imageView.image = image;
    textLabel.text = text;

    return placeHolderView;
}

- (UIView*)showPlaceHolderWithImage:(NSString*)image text:(NSString*)text frame:(CGRect)frame
{
    UIView *placeHolderView;

    if (nil == image && text != nil) {
        placeHolderView = [self showPlaceHolderWithText:text];
    }else if (nil != image && text == nil){
        placeHolderView = [self showPlaceHolderWithImage:ImageNamed(image)];
    }else if (nil != image && text != nil){
        placeHolderView = [self showPlaceHolderWithText:text image:ImageNamed(image)];
    }
    UIView *parentView = [placeHolderView superview];

    [placeHolderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parentView).with.offset(frame.origin.x);
        make.top.equalTo(parentView).with.offset(frame.origin.y);
        make.width.equalTo(@(frame.size.width));
        make.height.equalTo(@(frame.size.height));
    }];
    return placeHolderView;
}

- (void)removePlaceholderViews
{
    NSMutableArray *placeHolderViewsTag = [[NSMutableArray alloc]init];
    [placeHolderViewsTag addObject:@(kMiddleTextPlaceHolderViewTag)];
    [placeHolderViewsTag addObject:@(kMiddleImagePlaceHolderViewTag)];
    [placeHolderViewsTag addObject:@(kPlaceHolderViewTag)];

    UIView *placeHolderView;
    for (NSNumber *viewTag in placeHolderViewsTag) {
        NSInteger viewTagInt = [viewTag integerValue];
        placeHolderView = [self viewWithTag:viewTagInt];
        if (nil != placeHolderView) {
            [placeHolderView setHidden:YES];
            [placeHolderView removeFromSuperview];
        }
    }
}

@end
