//
//  WZSingleCheckViewController.m
//  ServiceManager
//
//  Created by will.wang on 9/29/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "WZSingleCheckViewController.h"

static NSString *sCheckViewCellIdentifier = @"sCheckViewCellIdentifier";

@interface WZSingleCheckViewController ()<WZSingleCheckListViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>
@property(nonatomic, strong)WZSingleCheckListView *tableView;
@property(nonatomic, strong)UISearchDisplayController *searchController;
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)NSArray *searchedItemDataArray;
@end

@implementation WZSingleCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSInteger checkIndex = NSNotFound;
    if (self.checkItemArray.count > 0 && self.checkedItem) {
       checkIndex = [self.checkItemArray indexOfObject:self.checkedItem];
    }
    _tableView = [[WZSingleCheckListView alloc]initWithCheckItems:self.checkItemArray checkIndex:checkIndex delegate:self];
    _tableView.accessoryType = self.accessoryType;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    if (self.addHeaderSearchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _tableView.tableView.tableHeaderView = self.searchBar;
        _searchController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsDataSource = self;
        _searchController.searchResultsDelegate = self;
    }
}

#pragma mark - WZSingleCheckListView Delegate

- (void)checkListView:(WZSingleCheckListView*)checkListView didCheckAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(singleCheckViewController:didChecked:)]) {
        [self.delegate singleCheckViewController:self didChecked:self.checkItemArray[index]];
    }
}

- (void)checkListView:(WZSingleCheckListView*)checkListView setCell:(UITableViewCell*)cell withData:(CheckItemModel*)cellModel
{
    [self setCell:cell withData:cellModel];
}

- (NSArray*)filterOutItemsFrom:(NSArray*)items byString:(NSString*)searchString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.value CONTAINS %@", searchString];
    return [items filteredArrayUsingPredicate:predicate];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.searchedItemDataArray = [self filterOutItemsFrom:self.checkItemArray byString:searchString];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    self.searchedItemDataArray = [self filterOutItemsFrom:self.checkItemArray byString:controller.searchBar.text];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchedItemDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckItemModel *checkItem = self.searchedItemDataArray[indexPath.row];
    [self.tableView setCell:self.tableView.protypeCell withData:checkItem];
    return MAX([self.tableView.protypeCell fitHeight], kTableViewCellDefaultHeight);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckItemModel *checkItem = self.searchedItemDataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCheckViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCheckViewCellIdentifier];
    }
    return [self setCell:cell withData:checkItem];
}

- (UITableViewCell*)setCell:(UITableViewCell*)cell withData:(CheckItemModel *)cellModel
{
    return [self.tableView setCell:cell withData:cellModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *preChecked = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    [tableView reloadTableViewCell:preChecked];

    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    CheckItemModel *selItem = self.searchedItemDataArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(singleCheckViewController:didChecked:)]) {
        [self.delegate singleCheckViewController:self didChecked:selItem];
    }
}

@end
