//
//  ServiceImproveViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/4.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "ServiceImproveViewController.h"
#import "ServiceImprovementListViewIMP.h"

@interface ServiceImproveViewController ()
@property(nonatomic, strong)ServiceImprovementListViewIMP *tableViewDelegate;
@end

@implementation ServiceImproveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //create delegate and init
    self.tableViewDelegate = [[ServiceImprovementListViewIMP alloc]init];
    self.tableViewDelegate.viewController = self;
    self.tableViewDelegate.tableView = self.tableView;

    //set delegate
    self.tableView.tableViewDelegate = self.tableViewDelegate;
    
    //refresh data
    [self.tableView refreshTableViewData];
}

@end
