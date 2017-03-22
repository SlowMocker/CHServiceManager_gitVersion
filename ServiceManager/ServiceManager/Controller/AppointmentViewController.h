//
//  AppointmentViewController.h
//  ServiceManager
//
//  Created by will.wang on 15/9/5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "WZTableView.h"
#import "WZTextView.h"

@interface AppointmentViewController : ViewController
@property(nonatomic, assign)kAppointmentOperateType appointmentOperateType;
@property(nonatomic, strong)OrderContentModel *orderContent;
@end
