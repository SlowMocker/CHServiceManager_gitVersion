//
//  CustomButton.h
//  ServiceManager
//
//  Created by wangzhi on 15/6/11.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kCustomButtonLayout)
{
    kCustomButtonLayoutTopImageBottomText = 0,
};

@interface CustomButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame layout:(kCustomButtonLayout)layout;

@end
