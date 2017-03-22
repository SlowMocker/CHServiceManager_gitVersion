//
//  EmployeeManageViewCodntroller.h
//  ServiceManager
//
//  Created by will.wang on 15/8/27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "WZTableView.h"
#import "WZTableViewDelegateIMP.h"

//for employee list view
@interface ImpEmployeeManageTableViewDelegate :WZTableViewDelegateIMP  <WZTableViewDelegate>
@end

@interface EmployeeManageViewCodntroller : ViewController

@end
