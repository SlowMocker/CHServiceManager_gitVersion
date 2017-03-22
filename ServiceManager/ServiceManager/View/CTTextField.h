//
//  CTTextField.h
//  SmallSecretary
//
//  Created by zhiqiangcao on 15/1/19.
//  Copyright (c) 2015年 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTTextField : UITextField

+ (CTTextField *)textFieldForDefaultText:(NSString *)text placeHolder:(NSString *)placeHoleder unit:(NSString *)unit font:(UIFont *)font unitViewMode:(UITextFieldViewMode)viewMode;

@end
