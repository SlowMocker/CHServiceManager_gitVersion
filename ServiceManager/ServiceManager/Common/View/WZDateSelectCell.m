//
//  WZDateSelectCell.m
//  ServiceManager
//
//  Created by will.wang on 10/19/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "WZDateSelectCell.h"
#import "WZModal.h"

static CGFloat kDatePickerViewDefaultHeight = 236;

@interface WZDateSelectCell()<WZDatePickerViewDelegate>
@end

@implementation WZDateSelectCell

- (instancetype)initWithDate:(NSDate*)date baseViewController:(ViewController*)viewController
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (self) {
        self.selected = NO;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.textLabel setFont:SystemFont(14)];
        [self.detailTextLabel setFont:SystemFont(14)];
        [self.textLabel setText:@"日期"];
        [self.detailTextLabel setText:@"请选择"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.datePickerMode = UIDatePickerModeDate;
//        self.date = date;
        [self addSingleTapEventWithTarget:self action:@selector(cellViewDidSelect:)];
    }
    return self;
}

- (void)setDate:(NSDate *)date{
    if (date != _date) {
        _date = date;
        [self setDetailTextLabelWithDate:_date];
    }
}

- (void)setDetailTextLabelWithDate:(NSDate*)date
{
    NSString *dateStrFormat = WZDateStringFormat5;

    switch (self.datePickerMode) {
        case UIDatePickerModeDateAndTime:
            dateStrFormat = WZDateStringFormat7;
            break;
        default:
            break;
    }
    self.detailTextLabel.text = [NSString dateStringWithDate:_date strFormat:dateStrFormat];
}

- (void)setTimeIntervalNumber:(NSNumber *)timeIntervalNumber
{
    if (_timeIntervalNumber != timeIntervalNumber && [timeIntervalNumber isKindOfClass:[NSNumber class]]) {
        _timeIntervalNumber = timeIntervalNumber;
        self.date = [NSDate dateWithTimeIntervalSince1970:[timeIntervalNumber doubleValue]/1000];
    }
}

- (void)cellViewDidSelect:(UIGestureRecognizer*)gesture
{
    [self popupDatePicker];
}

- (void)popupDatePicker
{
    CGRect frame = CGRectMake(0, ScreenHeight - 64 -kDatePickerViewDefaultHeight, ScreenWidth, kDatePickerViewDefaultHeight);
    WZDatePickerView *datePicker = [[WZDatePickerView alloc]initWithFrame:frame delegate:self];
    datePicker.datePicker.datePickerMode = self.datePickerMode;
    datePicker.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePicker.date = self.date ? self.date : [NSDate date];
    datePicker.datePicker.minimumDate = self.minimumDate;
    datePicker.datePicker.maximumDate = self.maximumDate;

    //show
    WZModal *modal = [WZModal sharedInstance];
    [modal showWithContentView:datePicker andAnimated:YES];
    modal.contentViewLocation = WZModalContentViewLocationBottom;
    modal.showCloseButton = NO;
    modal.tapOutsideToDismiss = YES;
    modal.onTapOutsideBlock = nil;
}

- (void)datePickerViewFinished:(WZDatePickerView*)view selected:(NSTimeInterval)secs
{
    [[WZModal sharedInstance]hideAnimated:YES];

    self.date = [NSDate dateWithTimeIntervalSince1970:secs];
    if (self.dateSelectedBlock) {
        self.dateSelectedBlock(self);
    }
}

- (void)datePickerViewCancel:(WZDatePickerView*)view
{
    [[WZModal sharedInstance]hideAnimated:YES];
}

@end
