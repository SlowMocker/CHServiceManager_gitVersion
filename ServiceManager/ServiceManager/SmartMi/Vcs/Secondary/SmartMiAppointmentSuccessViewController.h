//
//  SmartMiAppointmentViewController.h
//  ServiceManager
//
//  Created by Wu on 17/3/27.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

// 智米 预约成功、失败
// 改约时，先读取详情并设置到视图中以便修改

#import <UIKit/UIKit.h>

@interface SmartMiAppointmentSuccessViewController : ViewController

@property (nonatomic , assign)kAppointmentOperateType appointmentOperateType;/**< 预约、二次预约、改约 */
@property (nonatomic , strong)SmartMiOrderContentModel *smartMiOrderContent;/**< 智米订单 */

@end
