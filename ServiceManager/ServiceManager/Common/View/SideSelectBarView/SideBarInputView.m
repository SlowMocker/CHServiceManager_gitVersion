//
//  SideBarInputView.m
//  SmallSecretary
//
//  Created by zhiqiangcao on 15/1/15.
//  Copyright (c) 2015年 pretang. All rights reserved.
//

#import "SideBarInputView.h"
#import "CTTextField.h"

#define SideBarInputGap (5)

@interface SideBarInputView()<UITextFieldDelegate>
@property (nonatomic, strong) CTTextField *inputTextField;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) InputConfirmBlock confirmBlock;
@end

@implementation SideBarInputView

- (instancetype)initWithFrame:(CGRect)frame withInputPlaceHolder:(NSString *)placeHolder withConfirmBlock:(InputConfirmBlock)confirmBlock
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.confirmBlock = [confirmBlock copy];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self addInputItemWithPlaceHoder:placeHolder];
    }
    return self;
}

- (void)addInputItemWithPlaceHoder:(NSString *)placeHolder
{
    self.inputTextField = [CTTextField textFieldForDefaultText:nil placeHolder:@"自定义利率" unit:@"%" font:SystemFont(17) unitViewMode:UITextFieldViewModeAlways];
    self.inputTextField.background = nil;
    self.inputTextField.backgroundColor = ColorWithHex(@"#faf8f9");
    UILabel *rightLabel = (UILabel *)self.inputTextField.rightView;
    rightLabel.textColor = kColorDefaultGreen;
    self.inputTextField.textColor = kColorDefaultGreen;
    self.inputTextField.delegate = self;
    self.inputTextField.layer.borderWidth = 0.5;
    self.inputTextField.layer.borderColor = [[UIColor grayColor] CGColor];
    self.inputTextField.layer.cornerRadius = 3;

    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.backgroundColor = ColorWithHex(@"#faf8f9");
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:kColorDefaultGreen forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = SystemFont(15);
    self.confirmButton.layer.cornerRadius = 3;
    self.confirmButton.layer.borderWidth = 0.5;
    self.confirmButton.layer.borderColor = [[UIColor grayColor] CGColor];
    self.confirmButton.bounds = CGRectMake(0, 0, 44, CGRectGetHeight(self.frame) - 2 * SideBarInputGap);
    self.confirmButton.center = CGPointMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.confirmButton.frame) / 2 - 8, CGRectGetHeight(self.frame) / 2);
    [self.confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    self.inputTextField.frame = CGRectMake(kItemLabelleftGap, SideBarInputGap, CGRectGetMinX(self.confirmButton.frame) - kItemLabelleftGap - SideBarInputGap, CGRectGetHeight(self.confirmButton.frame));

    [self addSubview:self.confirmButton];
    [self addSubview:self.inputTextField];
}

- (void)clearCurrentInput
{
    self.inputTextField.text = nil;
    [self.inputTextField resignFirstResponder];
}

- (void)clickConfirmButton:(UIButton *)sender
{
    if (self.confirmBlock)
    {
        self.confirmBlock(self.inputTextField.text);
    }
}
#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        NSString *replaceString = [textField.text stringByAppendingString:string];
        if (replaceString.floatValue > 100)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

@end
