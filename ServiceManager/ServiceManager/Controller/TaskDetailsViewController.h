//
//  TaskDetailsViewController.h
//  ServiceManager
//
//  Created by will.wang on 9/24/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "ViewController.h"

/**
 * 技术支持人员任务单（工单），查看或确认
 */

@interface TaskDetailsViewController : ViewController
@property(nonatomic, strong)SupporterOrderContent *orderContent;
@property(nonatomic, assign)kSupporterOrderStatus orderStatus;
@property(nonatomic, assign)BOOL isConfirmMode; //技术人员确认

- (void)confirmTecSupportOrder:(NSString*)supportId response:(RequestCallBackBlock)requestCallBackBlock;
@end
