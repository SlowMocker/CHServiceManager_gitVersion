//
//  WZTableSearchView.m
//  ServiceManager
//
//  Created by will.wang on 10/16/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "WZTableSearchView.h"

@interface WZTableSearchView()<UISearchDisplayDelegate>
@property(nonatomic, strong)UISearchDisplayController *searchController;
@end

@implementation WZTableSearchView

- (instancetype)initWithStyle:(UITableViewStyle)style delegate:(id<WZTableViewDelegate>)delegate
{
    self = [super initWithStyle:style delegate:delegate];
    if (self) {
        self.tableView.tableHeaderView = self.searchBar;
        _searchController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self.viewController];
        _searchController.delegate = self;
//        _searchController.searchResultsDataSource = self;
//        _searchController.searchResultsDelegate = self;
    }
    return self;
}

- (UISearchBar*)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]init];
    }
    return _searchBar;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *predicate = self.filterBlock(searchString);
    self.searchedItemDataArray = [self.itemDataArray filteredArrayUsingPredicate:predicate];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSPredicate *predicate = self.filterBlock(controller.searchBar.text);
    self.searchedItemDataArray = [self.itemDataArray filteredArrayUsingPredicate:predicate];
    return YES;
}

@end
