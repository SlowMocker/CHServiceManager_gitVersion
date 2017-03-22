//
//  WZDatePickerView.h
//  HouseMarket
//
//  Created by wangzhi on 15-3-2.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZDatePickerView;

@protocol WZDatePickerViewDelegate <NSObject>

//secs: s
- (void)datePickerViewFinished:(WZDatePickerView*)view selected:(NSTimeInterval)secs;
- (void)datePickerViewCancel:(WZDatePickerView*)view;
@end

@interface WZDatePickerView : UIView
@property(nonatomic, strong)id<WZDatePickerViewDelegate>delegate;
@property(nonatomic, strong)UIDatePicker *datePicker;
@property(nonatomic, assign, readonly)NSTimeInterval dateTimeMs;

- (id)initWithFrame:(CGRect)frame delegate:(id<WZDatePickerViewDelegate>)delegate;

- (id)initWithDelegate:(id<WZDatePickerViewDelegate>)delegate;

- (void)closeDatePicker;

- (void)showToBottom;
- (void)hide;
@end
