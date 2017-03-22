//
//  WZTextView.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-13.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

@interface WZTextView : UIView
@property(nonatomic, assign)NSInteger maxWords; //字数限制
@property(nonatomic, copy)NSString *text;
@property(nonatomic, strong) NSString *placeholder;

@property(nonatomic, strong)UILabel *wordLimitLabel;
@property(nonatomic, strong)GCPlaceholderTextView *textView;

// it means no limitation if maxWords <= 0
- (instancetype)initWithFrame:(CGRect)frame maxWords:(NSInteger)maxWords;

@end
