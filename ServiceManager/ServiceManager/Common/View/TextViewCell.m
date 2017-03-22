//
//  TextViewCell.m
//  ServiceManager
//
//  Created by will.wang on 16/5/5.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "TextViewCell.h"

@implementation TextViewCell

- (instancetype)initWithFrame:(CGRect)frame maxWords:(NSInteger)maxWords
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        self.frame = frame;
        
        //create textview
        _textView = [[WZTextView alloc]initWithFrame:self.bounds maxWords:maxWords];
        _textView.layer.borderColor = ColorWithHex(@"#f1f1f1").CGColor;
        _textView.layer.borderWidth = 0.5;
        [self.contentView addSubview:_textView];
    }
    return self;
}

@end
