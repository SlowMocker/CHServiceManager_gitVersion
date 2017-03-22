//
//  TextViewCell.h
//  ServiceManager
//
//  Created by will.wang on 16/5/5.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZTextView.h"

@interface TextViewCell : UITableViewCell
@property(nonatomic, strong)WZTextView *textView;

//请使用此方法初化
- (instancetype)initWithFrame:(CGRect)frame maxWords:(NSInteger)maxWords;
@end
