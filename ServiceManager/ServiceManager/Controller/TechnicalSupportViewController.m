//
//  TechnicalSupportViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/4.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "TechnicalSupportViewController.h"

@interface TechnicalSupportViewController ()
@property(nonatomic, strong)TecSupportOrderListViewDelegateIMP *tableViewDelegate;
@end

@implementation TechnicalSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //create delegate and init
    self.tableViewDelegate = [self getOrderListViewDelegateIMP];
    self.tableViewDelegate.viewController = self;
    self.tableViewDelegate.tableView = self.tableView;

    //set delegate
    self.tableView.tableViewDelegate = self.tableViewDelegate;

    //refresh data
    [self.tableView refreshTableViewData];
}

- (TecSupportOrderListViewDelegateIMP*)getOrderListViewDelegateIMP
{
    TecSupportOrderListViewDelegateIMP *delegate = [[TecSupportOrderListViewDelegateIMP alloc]init];
    return delegate;
}

@end
