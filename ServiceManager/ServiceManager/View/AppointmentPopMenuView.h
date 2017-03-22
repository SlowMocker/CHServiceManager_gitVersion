//
//  AppointmentPopMenuView.h
//  ServiceManager
//
//  Created by will.wang on 15/9/10.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZModal.h"

@class AppointmentPopMenuView;

@protocol AppointmentPopMenuViewDelegate <NSObject>
- (void)popMenuViewAppointSuccess:(AppointmentPopMenuView*)popView;
- (void)popMenuViewAppointFailure:(AppointmentPopMenuView*)popView;
@end

@interface AppointmentPopMenuView : NSObject
@property(nonatomic, copy)NSString *orderId;
@property(nonatomic, copy)NSString *customerTels;
@property(nonatomic, copy)NSString *customerName;

@property(nonatomic, strong)NSObject *userInfo;

@property(nonatomic, weak)ViewController *viewController;
@property(nonatomic, assign)kAppointmentOperateType appointmentOperateType;
@property(nonatomic, weak)id<AppointmentPopMenuViewDelegate>delegate;

- (void)popupAppointmentPopMenuView;

- (NSString*)getAppointmentOperateTypeKeyWord;

@end
