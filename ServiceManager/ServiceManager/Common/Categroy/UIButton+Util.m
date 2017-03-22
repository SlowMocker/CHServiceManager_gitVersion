//
//  UIButton_Util.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "UIButton+Util.h"
#import <AFNetworking/UIButton+AFNetworking.h>

@implementation UIButton (Util)

+ (instancetype)imageButtonWithNorImg:(NSString*)norImgName selImg:(NSString*)selImgName
{
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundColor:[UIColor clearColor]];

    if (norImgName) {
        [button setImage:ImageNamed(norImgName) forState:UIControlStateNormal];
    }

    if (selImgName) {
        [button setImage:ImageNamed(selImgName) forState:UIControlStateSelected];
        [button setImage:ImageNamed(selImgName) forState:UIControlStateHighlighted];
    }
    return button;
}

+ (instancetype)imageButtonWithNorImg:(NSString*)norImgName selImg:(NSString*)selImgName size:(CGSize)size target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [button setBackgroundColor:[UIColor clearColor]];

    if (norImgName) {
        [button setImage:ImageNamed(norImgName) forState:UIControlStateNormal];
    }

    if (selImgName) {
        [button setImage:ImageNamed(selImgName) forState:UIControlStateSelected];
        [button setImage:ImageNamed(selImgName) forState:UIControlStateHighlighted];
    }

    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

+(instancetype)whiteButton:(NSString*)title
{
    UIButton *button = [[UIButton alloc]init];

    [button setBackgroundColor:[UIColor whiteColor]];
    button.titleLabel.font = kFontSizeTextButton;
    [button setTitleColor:kColorDefaultOrange forState:UIControlStateNormal];
    [button setTitleForAllStatus:title];
    [button circleCornerWithRadius:3.0];
    return button;
}

+(instancetype)orangeButton:(NSString*)title
{
    UIButton *button = [[UIButton alloc]init];

    [button setBackgroundColor:kColorDefaultOrange];
    button.titleLabel.font = kFontSizeTextButton;
    [button setTitleColor:kColorWhite forState:UIControlStateNormal];
    [button setTitleForAllStatus:title];
    [button circleCornerWithRadius:3.0];
    return button;
}

+ (instancetype)greenButton:(NSString*)title
{
    UIButton *button = [[UIButton alloc]init];

    [button setBackgroundColor:kColorLightGreen];
    button.titleLabel.font = kFontSizeTextButton;
    [button setTitleColor:kColorWhite forState:UIControlStateNormal];
    [button setTitleForAllStatus:title];
    [button circleCornerWithRadius:3.0];
    return button;
}

+ (instancetype)redButton:(NSString*)title
{
    UIButton *button = [[UIButton alloc]init];

    [button setBackgroundColor:kColorDefaultRed];
    button.titleLabel.font = kFontSizeTextButton;
    [button setTitleColor:kColorWhite forState:UIControlStateNormal];
    [button setTitleForAllStatus:title];
    [button circleCornerWithRadius:3.0];
    return button;
}

+ (instancetype)transparentTextButton:(NSString*)text
{
    UIButton *button = [[UIButton alloc]init];

    [button clearBackgroundColor];
    button.titleLabel.font = SystemFont(15);
    [button setTitleColor:kColorBlack forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    [button circleCornerWithRadius:3.0];
    return button;
}

+ (UIButton*)borderTextButton:(NSString*)text color:(UIColor*)color
{
    UIButton *button = [[UIButton alloc]init];

    [button clearBackgroundColor];
    button.titleLabel.font = SystemFont(14);
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    [button circleCornerWithRadius:3.0];
    button.layer.borderWidth = 0.5f;
    button.layer.borderColor = color.CGColor;
    return button;
}

+ (instancetype)blackAlphaTextButton:(NSString *)text;
{
    UIButton *button = [[UIButton alloc]init];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:kColorWhite forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    [button circleCornerWithRadius:3.0];
    return button;
}

- (void)setTitleForAllStatus:(NSString*)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateDisabled];
    [self setTitle:title forState:UIControlStateSelected];
}

- (void)setBgImageForAllStatus:(NSString*)imageName
{
    [self setBackgroundImage:ImageNamed(imageName) forState:UIControlStateNormal];
    [self setBackgroundImage:ImageNamed(imageName) forState:UIControlStateHighlighted];
    [self setBackgroundImage:ImageNamed(imageName) forState:UIControlStateDisabled];
    [self setBackgroundImage:ImageNamed(imageName) forState:UIControlStateSelected];
}

+ (UIButton*)buttonWithUnderlineText:(NSString*)title
{
    UIButton *button = [[UIButton alloc]init];
    [button clearBackgroundColor];

    [button setTitleColor:kColorDarkGray forState:UIControlStateNormal];

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [button setAttributedTitle:str forState:UIControlStateNormal];

    return button;
}

- (UIButton*)addBottomRightTriangleIcon
{
    UIImage *bgImg = ImageNamed(@"tab_triangle");
    bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, bgImg.size.height - 2, bgImg.size.width - 2)];
    [self setBackgroundImage:bgImg forState:UIControlStateNormal];
    return self;
}

- (UIButton *)layoutLeftTextRightImageButton
{
    UIEdgeInsets imageInsets;
    UIEdgeInsets textInsets;

    imageInsets = UIEdgeInsetsMake(0, CGRectGetWidth(self.frame) - self.imageView.image.size.width - 10, 0, 0);
    textInsets = UIEdgeInsetsMake(0, 0, 0, self.imageView.image.size.width);

    self.titleEdgeInsets = textInsets;
    self.imageEdgeInsets = imageInsets;

    return self;
}

- (UIButton *)layoutTopImageBottomTextButton
{
    CGFloat spacing = 5.0;

    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;

    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);

    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);

    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);

    return self;
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 5)];
    colorView.backgroundColor = color;
    UIImage *backgroundImage = [UIImage imageWithView:colorView];
    [self setBackgroundImage:backgroundImage forState:state];
}

+ (UIButton*)textButton:(NSString*)title backColor:(UIColor*)backgroundColor target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor = backgroundColor;
    button.titleLabel.font = SystemFont(14);
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    return button;
}

+ (UIButton*)textButton:(NSString*)title textColor:(UIColor*)textColor target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor = kColorClear;
    button.titleLabel.font = SystemFont(14);
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;

    return button;
}

- (void)verticalImageAndTitle:(CGFloat)spacing
{
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.imageView.backgroundColor = [UIColor clearColor];
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

@end
