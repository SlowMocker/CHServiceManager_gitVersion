//
//  WZPickerView.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-26.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZPickerView.h"

@interface WZPickerView ()
{
    UIToolbar *inputToolbar;
}
@end

@implementation WZPickerView

- (id)initWithFrame:(CGRect)frame delegate:(id<WZPickerViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {

        _delegate = delegate;

        // 输入辅助
        inputToolbar = [self createInputAccessoryBar];

        [self addSubview:inputToolbar];

        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(inputToolbar.frame), frame.size.width, frame.size.height - CGRectGetMaxY(inputToolbar.frame))];
        self.picker.dataSource = delegate;
        self.picker.delegate = delegate;
        [self addSubview:self.picker];
    }
    return self;
}

- (void)setDelegate:(id<WZPickerViewDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        self.picker.delegate = _delegate;
        self.picker.dataSource = _delegate;
    }
}

#pragma mark - 输入辅助

- (UIToolbar *)createInputAccessoryBar
{
    UIToolbar *aInputToolbar = [[UIToolbar alloc] init];
    aInputToolbar.frame = CGRectMake(0, 0, ScreenWidth, 36);
    aInputToolbar.barStyle = UIBarStyleDefault;
    aInputToolbar.translucent = YES;
    NSDictionary *titleDict = nil;
    aInputToolbar.barTintColor = ColorWithHex(@"#244c65");

    titleDict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];

    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self action:@selector(cnacelBarButtonItemTapped:event:)];
    [nextItem setTitleTextAttributes:titleDict forState:UIControlStateNormal];
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:self
                                                                                       action:nil];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(finishBarButtonItemTapped:event:)];
    [finishItem setTitleTextAttributes:titleDict forState:UIControlStateNormal];
    NSArray *barButtons = [NSArray arrayWithObjects:nextItem, flexibleSpaceItem , finishItem , nil];
    aInputToolbar.items = barButtons;

    return aInputToolbar;
}

- (void)cnacelBarButtonItemTapped:(id)sender event:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector( wzpickerDidCancelSelect:)])
    {
        [self.delegate wzpickerDidCancelSelect:self];
    }

    [self removeFromSuperview];
}

- (void)finishBarButtonItemTapped:(id)sender event:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector( wzpickerDidFinishSelect:)])
    {
        [self.delegate wzpickerDidFinishSelect:self];
    }

    [self removeFromSuperview];
}

@end
