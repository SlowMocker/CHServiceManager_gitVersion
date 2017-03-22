//
//  EditEmployeeViewController.h
//  ServiceManager
//
//  Created by will.wang on 15/9/11.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

/**
 *  员工维护
 */

@class EditEmployeeViewController;

@protocol EditEmployeeViewControllerDelegate <NSObject>
@optional
- (void)editEmployeeViewController:(EditEmployeeViewController*)viewController didDeleteRepair:(MyRepairerBaseInfo*)repairer;
- (void)editEmployeeViewController:(EditEmployeeViewController*)viewController didUpdateRepairInfo:(MyRepairerBaseInfo*)repairer;

@end

#import "ViewController.h"

@interface EditEmployeeViewController : ViewController
@property(nonatomic, strong)MyRepairerBaseInfo *repairer;
@property(nonatomic, assign)id<EditEmployeeViewControllerDelegate>delegate;
@end
