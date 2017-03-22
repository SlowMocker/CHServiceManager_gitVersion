//
//  SideBarInputView.h
//  SmallSecretary
//
//  Created by zhiqiangcao on 15/1/15.
//  Copyright (c) 2015年 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SideBarInputView;

typedef void(^InputConfirmBlock)(NSString * input);

@interface SideBarInputView : UIView

- (instancetype)initWithFrame:(CGRect)frame withInputPlaceHolder:(NSString *)placeHolder withConfirmBlock:(InputConfirmBlock)confirmBlock;

- (void)clearCurrentInput;

@end
