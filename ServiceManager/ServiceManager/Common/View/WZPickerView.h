//
//  WZPickerView.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-26.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZPickerView;

@protocol WZPickerViewDelegate <NSObject,UIPickerViewDataSource, UIPickerViewDelegate>
@optional
- (void)wzpickerDidCancelSelect:(WZPickerView *)wzpicker;
- (void)wzpickerDidFinishSelect:(WZPickerView *)wzpicker;
@end

@interface WZPickerView : UIView
@property (strong, nonatomic) UIPickerView *picker;
@property (assign, nonatomic) id<WZPickerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<WZPickerViewDelegate>)delegate;
@end
