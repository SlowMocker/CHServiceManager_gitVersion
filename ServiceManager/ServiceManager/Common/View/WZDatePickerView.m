//
//  WZDatePickerView.m
//  HouseMarket
//
//  Created by wangzhi on 15-3-2.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZDatePickerView.h"
#import "WZModal.h"

static CGFloat kDatePickerViewDefaultHeight = 236;

@interface WZDatePickerView ()
{
    UIToolbar *inputToolbar;
}
@end

@implementation WZDatePickerView

- (id)initWithDelegate:(id<WZDatePickerViewDelegate>)delegate
{
    self = [self initWithFrame:CGRectMake(0, ScreenHeight - 64 -kDatePickerViewDefaultHeight, ScreenWidth, kDatePickerViewDefaultHeight) delegate:delegate];
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<WZDatePickerViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {

        _delegate = delegate;

        // 输入辅助
        inputToolbar = [self createInputAccessoryBar];

        [self addSubview:inputToolbar];

        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(inputToolbar.frame), frame.size.width, frame.size.height - CGRectGetMaxY(inputToolbar.frame))];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.date = [NSDate date];
        [self addSubview:_datePicker];
    }
    return self;
}

- (NSTimeInterval)dateTimeMs
{
    return [_datePicker.date timeIntervalSince1970]*1000;
}

#pragma mark - 输入辅助

- (UIToolbar *)createInputAccessoryBar
{
    UIToolbar *aInputToolbar = [[UIToolbar alloc] init];
    aInputToolbar.frame = CGRectMake(0, 0, ScreenWidth, 40);
    aInputToolbar.barStyle = UIBarStyleDefault;
    aInputToolbar.translucent = YES;
    NSDictionary *titleDict = nil;
    aInputToolbar.barTintColor = kColorDefaultBlue;

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
    if (self.delegate && [self.delegate respondsToSelector:@selector( datePickerViewCancel:)])
    {
        [self.delegate datePickerViewCancel:self];
    }

    [self hide];
}

- (void)finishBarButtonItemTapped:(id)sender event:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector( datePickerViewFinished:selected:)])
    {
        [self.delegate datePickerViewFinished:self selected:[_datePicker.date timeIntervalSince1970]];
    }
    [self hide];
}

- (void)closeDatePicker
{
    if (self.delegate && [self.delegate respondsToSelector:@selector( datePickerViewCancel:)])
    {
        [self.delegate datePickerViewCancel:self];
    }
    
    [self hide];
}

- (void)showToBottom
{
    WZModal *model = [WZModal sharedInstance];
    [[WZModal sharedInstance]hideAnimated:NO];
    model.showCloseButton = NO;
    model.onTapOutsideBlock = nil;
    model.contentViewLocation = WZModalContentViewLocationBottom;
    [model showWithContentView:self andAnimated:YES];
}

- (void)hide
{
    [[WZModal sharedInstance]hideAnimated:NO];
}

@end
