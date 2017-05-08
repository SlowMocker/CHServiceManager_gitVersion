//
//  SmartMiOrderDetailsViewController.h
//  ServiceManager
//
//  Created by Wu on 17/3/27.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

// 智米查看

#import "BaseOrderDetailsViewController.h"

@interface SmartMiOrderDetailsViewController : BaseOrderDetailsViewController

// SmartMiOrderContentDetails 相比 SmartMiOrderContentModel 增加了一些额外的字段
@property (nonatomic , strong) SmartMiOrderContentModel *orderContent;/**< 订单数据模型 */

@end
