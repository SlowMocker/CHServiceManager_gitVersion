//
//  YunDeviceInfoViewController.h
//  ServiceManager
//
//  Created by will.wang on 15/9/14.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ViewController.h"

/*
 * 显示除了空调外的设备信息，
 * 空调设备信息显示用 YunCHIQAirConditioningInfoViewController
 */

@interface YunDeviceInfoViewController : ViewController
@property(nonatomic, strong)OrderContentDetails *orderDetails;

@end
