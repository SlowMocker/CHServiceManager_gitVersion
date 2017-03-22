//
//  PartsSearchViewController.m
//  ServiceManager
//
//  Created by will.wang on 10/30/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "PartsSearchViewController.h"
#import "WZTableView.h"

static NSString *sPartContentCellIdentifile = @"sPartContentCellIdentifile";

@interface PartsSearchViewController()<WZTableViewDelegate, UISearchBarDelegate>
@property(nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)NSMutableArray *itemDataArray; // PartsContentInfo
@property (nonatomic, strong)WZTableView *tableView;
@end

@implementation PartsSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"备件查询";
    
    //top searchBar
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kButtonLargeHeight)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入查询关键字";
    [self.view addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(kButtonLargeHeight));
    }];
    
    //tableView
    _tableView = [[WZTableView alloc]initWithStyle:UITableViewStylePlain delegate:self];
    _tableView.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableView.tableView hideExtraCellLine];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).with.offset(kDefaultSpaceUnit);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.searchBar becomeFirstResponder];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.tableView refreshTableViewData];
    [searchBar resignFirstResponder];
}

#pragma mark - data source & delegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    [self searchMachineModels:tableView withPage:pageInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.itemDataArray.count > 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self.itemDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellDefaultHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sPartContentCellIdentifile];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:sPartContentCellIdentifile];
        cell.textLabel.font = SystemFont(15);
        cell.textLabel.textColor = kColorDefaultBlue;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.font = SystemFont(14);
        cell.detailTextLabel.textColor = kColorDefaultOrange;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    PartsContentInfo *model = self.itemDataArray[indexPath.row];

    cell.textLabel.text = [Util defaultStr:@"未知备件" ifStrEmpty:model.short_text];

    return cell;
}

- (void)searchMachineModels:(WZTableView*)tableView withPage:(PageInfo*)pageInfo
{
    RepairerPartGetInputParams *input = [RepairerPartGetInputParams new];
    input.mac_product_id = self.productInfo.product_id;
    input.part_product_id = self.searchBar.text;

    [[HttpClientManager sharedInstance]repairer_partFindInfo:input response:^(NSError *error, HttpResponseData *responseData) {

        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            NSArray *array = responseData.resultData;
            [self.itemDataArray removeAllObjects];
            if (array.count > 0) {
                self.itemDataArray = [MiscHelper parserObjectList:array objectClass:@"PartsContentInfo"];
            }
        }
        [tableView didRequestTableViewListDatasWithCount:self.itemDataArray.count totalCount:self.itemDataArray.count page:pageInfo response:responseData error:error];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PartsContentInfo *partContent = self.itemDataArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.modelSelectedBlock) {
        self.modelSelectedBlock(self, partContent);
    }
}

@end
