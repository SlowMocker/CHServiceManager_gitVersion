//
//  IssueCodeSelViewController.m
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "IssueCodeSelViewController.h"
#import "ConfigInfoManager.h"
#import "PleaseSelectViewCell.h"

@interface IssueCodeSelViewController ()<UITableViewDelegate, UITableViewDataSource, PleaseSelectViewCellDelegate>
{
    NSString *_productId;
    NSString *_brandId;
    NSString *_categroyId;
}

//content views
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *cellsArray;

@property(nonatomic, strong)PleaseSelectViewCell *typeCell;
@property(nonatomic, strong)PleaseSelectViewCell *subTypeCell;

@property(nonatomic, strong)UIView *customFooterView;
@property(nonatomic, strong)UIButton *confirmButton;
@end

@implementation IssueCodeSelViewController

- (UITableView*)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView clearBackgroundColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundView = nil;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = self.customFooterView;
    }
    return _tableView;
}

- (PleaseSelectViewCell*)typeCell
{
    if (nil == _typeCell) {
        NSArray *types = [[ConfigInfoManager sharedInstance] issueCategoriesOfProduct:_productId brandId:_brandId];
        types = [Util convertConfigItemInfoArrayToCheckItemModelArray:types];
        _typeCell = [MiscHelper makeSelectItemCell:@"故障大类" checkItems:types checkedItem:self.issueTypeItem];
        _typeCell.delegate = self;
    }
    return _typeCell;
}

- (NSArray*)makeOrUpdateSettingCells
{
    NSMutableArray *cells = [[NSMutableArray alloc]init];
    NSMutableArray *sectionCells;
    
    sectionCells = [[NSMutableArray alloc]init];
    [sectionCells addObject:self.typeCell];
    [cells addObject:sectionCells];
    
    if (self.typeCell.checkedItem) {
        sectionCells = [[NSMutableArray alloc]init];
        _categroyId = (NSString*)self.typeCell.checkedItem.extData;
        NSArray *subtypes = [[ConfigInfoManager sharedInstance]issueCodesOfCategory:_categroyId brandId:_brandId];
        subtypes = [Util convertConfigItemInfoArrayToCheckItemModelArray:subtypes];
        _subTypeCell = [MiscHelper makeSelectItemCell:@"故障代码" checkItems:subtypes checkedItem:self.issueSubTypeItem];
        [sectionCells addObject:self.subTypeCell];
        [cells addObject:sectionCells];
    }

    return cells;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _brandId = [MiscHelper productBrandCodeForValue:self.orderDetails.zzfld000000];
    _productId = [MiscHelper productTypeCodeForValue:self.orderDetails.zzfld000003];

    self.cellsArray = [self makeOrUpdateSettingCells];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kTableViewLeftPadding, 0, kTableViewLeftPadding));
    }];
    self.tableView.tableFooterView = self.customFooterView;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kDefaultSpaceUnit;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [UIView new];
    [sectionHeaderView clearBackgroundColor];
    return sectionHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rowArray = [self.cellsArray objectAtIndex:section];
    return rowArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kButtonDefaultHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rowArray = [self.cellsArray objectAtIndex:indexPath.section];
    return rowArray[indexPath.row];
}

- (UIView*)customFooterView
{
    if (nil == _customFooterView) {
        CGRect frame = CGRectMake(0, 0, ScreenWidth - kTableViewLeftPadding * 2, kButtonDefaultHeight + kDefaultSpaceUnit * 6);
        _customFooterView = [[UIView alloc]initWithFrame:frame];
        [_customFooterView clearBackgroundColor];
        
        //add confirm button
        frame.size.height = kButtonDefaultHeight;
        _confirmButton = [UIButton redButton:@"确定"];
        [_confirmButton setBackgroundColor:kColorLightGray forState:UIControlStateDisabled];
        _confirmButton.frame = frame;
        _confirmButton.center = _customFooterView.center;
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_customFooterView addSubview:_confirmButton];
    }
    return _customFooterView;
}

- (void)confirmButtonClicked:(UIButton*)sender
{
    self.issueTypeItem = self.typeCell.checkedItem;
    self.issueSubTypeItem = self.subTypeCell.checkedItem;

    //check selected item
    if (nil == self.issueTypeItem) {
        [Util showToast:@"请选择故障类型"];
        return;
    }else if(nil == self.issueSubTypeItem){
        [Util showToast:@"请选择故障代码"];
        return;
    }

    //end of select
    if ([self.delegate respondsToSelector:@selector(issueCodeSelViewControllerFillFinished:)]) {
        [self.delegate issueCodeSelViewControllerFillFinished:self];
    }
    [self popViewController];
}

- (void)selectViewDidChecked:(PleaseSelectViewCell *)cell
{
    if (cell == self.typeCell) {
        [self reloadTableViewItems];
    }
}

- (void)reloadTableViewItems
{
    self.cellsArray = [self makeOrUpdateSettingCells];
    [self.tableView reloadData];
}

@end
