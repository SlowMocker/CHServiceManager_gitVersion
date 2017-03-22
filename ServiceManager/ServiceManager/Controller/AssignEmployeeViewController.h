//
//  AssignEmployeeViewController.h
//  ServiceManager
//
//  Created by will.wang on 15/9/2.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "BMapKit.h"
#import "WZTableView.h"

/**
 *  派工或改派给服务商或维修工
 */

@interface AssignEmployeeViewController : ViewController
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *assignerId; //已派给哪个

//读取工人列表, responseBlock参数3中的id类型，须为RepairerInfo数组
- (void)requestRepairerListWithResponse:(RequestCallBackBlockV2)responseBlock;

//派工
- (void)assignOrderToRepairer:(RepairerInfo*)repairer response:(RequestCallBackBlock)responseBlock;

@end
