//
//  LabelEditCell.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-6.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "LabelEditCell.h"

@interface LabelEditCell ()<UITextFieldDelegate>

@end

@implementation LabelEditCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (nil != self) {
        [self customerContentView];

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)customerContentView
{
    CGRect frame = CGRectMake(16, 0, 80, 44);
    _leftLabel = [[UILabel alloc]initWithFrame:frame];
    [_leftLabel clearBackgroundColor];
    _leftLabel.font = kFontSizeCellTitle;
    _leftLabel.textColor = kColorBlack;
    [self.contentView addSubview:_leftLabel];

    frame.origin.x = CGRectGetMaxX(_leftLabel.frame);
    frame.size.width = 130;
    _middleTextField = [[UITextField alloc]initWithFrame:frame];
    [_middleTextField clearBackgroundColor];
    _middleTextField.font = SystemFont(14);
    _middleTextField.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:_middleTextField];
    
    frame.origin.x = CGRectGetMaxX(_middleTextField.frame)+ 5;
    frame.size.width = 100;
    _rightLabel = [[UILabel alloc]initWithFrame:frame];
    [_rightLabel clearBackgroundColor];
    _rightLabel.font = kFontSizeCellTitle;
    _rightLabel.textColor = kColorBlack;
    [self.contentView addSubview:_rightLabel];
}

+ (LabelEditCell*)makeLabelEditCell:(NSString*)title hint:(NSString*)hint keyBoardType:(UIKeyboardType)keyBoardType unit:(NSString *)unitString;
{
    LabelEditCell *cell = [[LabelEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.leftLabel.text = title;
    cell.middleTextField.placeholder = hint;
    cell.middleTextField.delegate = cell;
    cell.middleTextField.textColor = kColorDarkGray;
    cell.middleTextField.textAlignment = NSTextAlignmentLeft;

    CGRect frame = cell.middleTextField.frame;
    frame.size.width = ScreenWidth - CGRectGetMinX(cell.middleTextField.frame) - 16;
    cell.middleTextField.frame = frame;
    cell.middleTextField.keyboardType = keyBoardType;
    
    // 添加一个单位
    if (![Util isEmptyString:unitString])
    {
        [cell.rightLabel setHidden:NO];
        [cell.rightLabel setText:unitString];
    }
    else //没有单位时候,讲rightLabel置空
    {
        cell.rightLabel = nil;
    }

    [cell addBottomLine:kColorLightGray];

    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
