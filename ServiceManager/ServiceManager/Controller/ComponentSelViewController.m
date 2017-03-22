//
//  ComponentSelViewController.m
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ComponentSelViewController.h"
#import "ConfigInfoManager.h"
#import "PleaseSelectViewCell.h"

@interface ComponentSelViewController ()<UITableViewDelegate, UITableViewDataSource, PleaseSelectViewCellDelegate>

//content views
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *cellsArray;

@property(nonatomic, strong)PleaseSelectViewCell *typeCell;
@property(nonatomic, strong)PleaseSelectViewCell *subTypeCell;

@property(nonatomic, strong)UIView *customFooterView;
@property(nonatomic, strong)UIButton *confirmButton;
@end

@implementation ComponentSelViewController

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
        NSArray *types = [[ConfigInfoManager sharedInstance] componentTypes];
        types = [Util convertConfigItemInfoArrayToCheckItemModelArray:types];
        _typeCell = [MiscHelper makeSelectItemCell:@"物料类别" checkItems:types checkedItem:self.typeItem];
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

    sectionCells = [[NSMutableArray alloc]init];
    NSArray *subtypes = [[ConfigInfoManager sharedInstance]subcomponentTypesOfType:(NSString*)self.typeCell.checkedItem.extData];
    subtypes = [Util convertConfigItemInfoArrayToCheckItemModelArray:subtypes];
    _subTypeCell = [MiscHelper makeSelectItemCell:@"物料子类" checkItems:subtypes checkedItem:self.subTypeItem];
    [sectionCells addObject:self.subTypeCell];
    [cells addObject:sectionCells];

    return cells;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.typeItem = self.typeCell.checkedItem;
    self.subTypeItem = self.subTypeCell.checkedItem;

    if ([self.delegate respondsToSelector:@selector(componentSelViewControllerFillFinished:)]) {
        [self.delegate componentSelViewControllerFillFinished:self];
    }
    [self popViewController];
}

- (void)selectViewDidChecked:(PleaseSelectViewCell *)cell
{
    if (cell == self.typeCell) {
        self.subTypeItem = nil;
        [self reloadTableViewItems];
    }
}

- (void)reloadTableViewItems
{
    self.cellsArray = [self makeOrUpdateSettingCells];
    [self.tableView reloadData];
}

@end
