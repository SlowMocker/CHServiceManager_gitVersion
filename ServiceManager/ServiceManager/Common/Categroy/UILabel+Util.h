//
//  UILable+Utile.h
//  ServiceManager
//
//  Created by wangzhi on 15/6/5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Util)

- (void)setTextWithHtml:(NSString*)htmlStr;

//set normal properties
- (UILabel*)setFontSize:(CGFloat)fontSize textColor:(UIColor*)textColor lineBreakMode:(NSLineBreakMode)lineBreakMode lines:(NSInteger)lines;

@end


@interface UILabel (Copy)

@property (nonatomic,assign) BOOL isCopyable;

@end
