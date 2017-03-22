//
//  WZTableViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/4.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "WZTableViewController.h"

@interface WZTableViewController ()

@end

@implementation WZTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[WZTableView alloc]initWithStyle:UITableViewStylePlain delegate:nil];
    [self.view addSubview:_tableView];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
}

@end
