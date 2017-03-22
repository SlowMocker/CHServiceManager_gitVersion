//
//  ApplySupportViewController.h
//  ServiceManager
//
//  Created by will.wang on 9/28/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "WZTableView.h"
#import "WZTableViewDelegateIMP.h"

@class ApplySupportViewController;

@protocol ApplySupportViewControllerDelegate <NSObject>
- (void)applySupportViewController:(ApplySupportViewController*)viewController select:(EmployeeInfo*)supporter;
@end

/**
 *  申请技术支持（技术人员列表）
 */

@interface ApplySupportViewController : ViewController
@property(nonatomic, weak)id<ApplySupportViewControllerDelegate>delegate;
@property(nonatomic, copy)NSString *orderId;

//requestCallBackBlock param 3 type must be EmployeeInfo array
//请求技术支持人员列表
- (void)querySupportersWithOrderId:(NSString*)orderId response:(RequestCallBackBlockV2)requestCallBackBlock;

//申请技术支持
- (void)applySupporter:(EmployeeInfo*)supporter response:(RequestCallBackBlock)requestCallBackBlock;
@end


