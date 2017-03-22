//
//  ProductModelSearchViewController.m
//  ServiceManager
//
//  Created by will.wang on 10/20/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "ProductModelSearchViewController.h"
#import "WZTableView.h"

static NSString *sProductModelCellIdentifile = @"sProductModelCellIdentifile";

@interface ProductModelSearchViewController()<WZTableViewDelegate, UISearchBarDelegate>
{
    NSString *_searchKeyWords;
}
@property(nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)NSArray *itemDataArray; // ProductModelDes
@property (nonatomic, strong)WZTableView *tableView;
@end

@implementation ProductModelSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"机型查询";

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
    _tableView.tableView.headerHidden = YES;
    _tableView.tableView.footerHidden = YES;
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
    if ([Util isEmptyString:_searchKeyWords]
        || ![_searchKeyWords isEqualToString:searchBar.text]) {
        [self.tableView refreshTableViewData];
        [searchBar resignFirstResponder];
    }
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sProductModelCellIdentifile];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:sProductModelCellIdentifile];
    }
    cell.textLabel.font = SystemFont(15);
    cell.textLabel.textColor = kColorDefaultBlue;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.font = SystemFont(14);
    cell.detailTextLabel.textColor = kColorDefaultOrange;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    ProductModelDes *model = self.itemDataArray[indexPath.row];
    
    cell.textLabel.text = [Util defaultStr:@"机型未知" ifStrEmpty:model.product_id];
    cell.detailTextLabel.text = model.short_text;

    return cell;
}

- (void)queryMachineModels:(NSString*)keyWords response:(RequestCallBackBlockV2)requestCallBackBlock
{
    FindMachineModelInputParams *input = [FindMachineModelInputParams new];
    input.machinetext = keyWords;
    
    [self.httpClient findMachineModel:input response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *modelArray;
        if(!error && kHttpReturnCodeSuccess == responseData.resultCode){
            modelArray = [MiscHelper parserObjectList:responseData.resultData objectClass:@"ProductModelDes"];
        }
        requestCallBackBlock(error, responseData, modelArray);
    }];
}

- (void)searchMachineModels:(WZTableView*)tableView withPage:(PageInfo*)pageInfo
{
    [self queryMachineModels:self.searchBar.text response:^(NSError *error, HttpResponseData *responseData, id extData) {
        if(!error && kHttpReturnCodeSuccess == responseData.resultCode){
            NSArray *models = (NSArray*)extData;
            self.itemDataArray = [NSArray arrayWithArray:models];
            _searchKeyWords = self.searchBar.text;
        }
        [tableView didRequestTableViewListDatasWithCount:self.itemDataArray.count totalCount:self.itemDataArray.count page:pageInfo response:responseData error:error];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModelDes *productModel = self.itemDataArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.modelSelectedBlock) {
        self.modelSelectedBlock(self, productModel);
    }
}

@end
