//
//  WZDateSelectCell.h
//  ServiceManager
//
//  Created by will.wang on 10/19/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "WZDatePickerView.h"

@interface WZDateSelectCell : UITableViewCell
@property(nonatomic, strong)NSNumber *timeIntervalNumber; //write only, ms
@property(nonatomic, assign)UIDatePickerMode datePickerMode;
@property(nonatomic, strong)NSDate *date;
@property(nonatomic, strong)NSDate *minimumDate;
@property(nonatomic, strong)NSDate *maximumDate;
@property(nonatomic, strong)ViewController *viewController;
@property(nonatomic, strong)VoidBlock_id dateSelectedBlock;
- (instancetype)initWithDate:(NSDate*)date baseViewController:(ViewController*)viewController;
@end
