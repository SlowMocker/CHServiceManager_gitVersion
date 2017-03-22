//
//  EmployeeManageViewCodntroller.m
//  ServiceManager
//
//  Created by will.wang on 15/8/27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "PartTraceViewController.h"
#import "OrderTraceListViewDelegateIMP.h"

@interface PartTraceViewController ()
{
    OrderTraceListViewDelegateIMP *_tableViewDelegate;
}

@end

@implementation PartTraceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableViewDelegate = [[OrderTraceListViewDelegateIMP alloc]init];
    _tableViewDelegate.viewController = self;
    _tableViewDelegate.tableView = self.tableView;

    self.tableView.tableViewDelegate = _tableViewDelegate;

    [self.tableView refreshTableViewData];
}

@end
