//
//  CTTextField.m
//  SmallSecretary
//
//  Created by zhiqiangcao on 15/1/19.
//  Copyright (c) 2015年 pretang. All rights reserved.
//

#import "CTTextField.h"

@implementation CTTextField

+ (CTTextField *)textFieldForDefaultText:(NSString *)text placeHolder:(NSString *)placeHoleder unit:(NSString *)unit font:(UIFont *)font unitViewMode:(UITextFieldViewMode)viewMode
{
    UIImage *blackImage = [UIImage imageNamed:@"input_black"];
    blackImage = [blackImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeTile];

    CTTextField *inputTextField = [[CTTextField alloc] init];
    inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
    inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    inputTextField.text = text;
    inputTextField.textColor = kColorWhite;
    inputTextField.background = blackImage;
    inputTextField.font = font;
//    inputTextField.layer.borderWidth = 0.5;
//    inputTextField.layer.borderColor = [ksCellTextColor CGColor];
//    inputTextField.layer.cornerRadius = 3;
    if (unit)
    {
        inputTextField.rightViewMode = viewMode;
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.textColor = kColorDefaultGreen;
        rightLabel.text = unit;
        rightLabel.font = font;
        [rightLabel sizeToFit];
        inputTextField.rightView = rightLabel;
    }

    if (placeHoleder)
    {
        inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHoleder attributes:@{NSForegroundColorAttributeName:kColorDefaultGreen}];
    }
    return inputTextField;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    if (self.rightViewMode == UITextFieldViewModeNever)
    {
        return CGRectMake(5, 0, CGRectGetWidth(bounds) - 10, CGRectGetHeight(bounds));
    }
    else
    {
        return CGRectMake(5, 0, CGRectGetWidth(bounds) - 30, CGRectGetHeight(bounds));
    }

}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    if (self.rightViewMode == UITextFieldViewModeNever)
    {
        return CGRectMake(5, 0, CGRectGetWidth(bounds) - 10, CGRectGetHeight(bounds));
    }
    else
    {
        return CGRectMake(5, 0, CGRectGetWidth(bounds) - 30, CGRectGetHeight(bounds));
    }
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    if (self.rightViewMode == UITextFieldViewModeNever)
    {
        return CGRectMake(CGRectGetWidth(bounds) - 5, 0, 0, CGRectGetHeight(bounds));
    }
    else
    {
        return CGRectMake(CGRectGetWidth(bounds) - 25, 0, 20, CGRectGetHeight(bounds));
    }
}

@end
