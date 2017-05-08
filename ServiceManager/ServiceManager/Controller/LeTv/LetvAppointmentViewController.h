//
//  LetvAppointmentViewController.h
//  ServiceManager
//
//  Created by will.wang on 16/5/5.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "WZTableViewController.h"

/**
 *  Letv 预约成功、失败
 *  改约时，先读取详情并设置到视图中以便修改
 */

@interface LetvAppointmentViewController : WZTableViewController
@property(nonatomic, assign)BOOL bAppointmentSuccess;//YES预约成功，NO预约失败
@property(nonatomic, assign)kAppointmentOperateType appointmentOperateType;
@property(nonatomic, strong)LetvOrderContentModel *letvOrderContent;
@end
