//
//  AssignEmployeeSearchController.m
//  ServiceManager
//
//  Created by will.wang on 16/8/8.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "AssignEmployeeSearchController.h"

@interface AssignEmployeeSearchController ()<UISearchBarDelegate>
@property(nonatomic, strong)UISearchBar *searchBar;
@end

@implementation AssignEmployeeSearchController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"搜索维修人员";
    
    self.searchBar = self.searchController.searchBar;

    self.searchController.displaysSearchBarInNavigationBar = NO;
    self.searchDisplayController.searchBar.placeholder = self.title;

    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;

    self.tableView.delegate = self.parentVc;
    self.tableView.dataSource = self.parentVc;
    self.searchBar.delegate = self;

    self.tableView.tableHeaderView = self.searchBar;

    //become first responder
    [self.searchDisplayController setActive: YES animated: YES];
    self.searchDisplayController.searchBar.hidden = NO;
    [self.searchDisplayController.searchBar becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchDisplayController.searchBar resignFirstResponder];
}

// pop view controller when cancel button clicked
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self popViewController];
}

@end
