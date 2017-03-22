//
//  AssignEmployeeSearchController.h
//  ServiceManager
//
//  Created by will.wang on 16/8/8.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
#import "AssignEmployeeViewController.h"

@interface AssignEmployeeSearchController : TableViewController
@property(nonnull, strong)id parentVc;
@property(nonnull, nonatomic, strong) UISearchDisplayController *searchController;
@end
