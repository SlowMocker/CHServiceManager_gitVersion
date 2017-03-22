//
//  FilterTableView.m
//  ServiceManager
//
//  Created by will.wang on 16/9/9.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "FilterTableView.h"

static NSInteger sHeaderLabelViewTag = 0x084267;

@interface FilterTableSectionHeaderView : NSObject
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)UILabel *titleView;
@property(nonatomic, strong)UILabel *subTitleView;
@end
@implementation FilterTableSectionHeaderView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeSubViews];
    }
    return self;
}

- (void)makeSubViews
{
    //make
    _contentView = [UIView new];
    _contentView.backgroundColor = kColorWhite;
    
    _titleView = [UILabel new];
    [_titleView clearBackgroundColor];
    _titleView.textColor = kColorDarkGray;
    _titleView.font = SystemBoldFont(15);
    [_contentView addSubview:_titleView];

    _subTitleView = [UILabel new];
    _subTitleView.textColor = kColorDefaultRed;
    _subTitleView.font = SystemFont(14);
    [_subTitleView clearBackgroundColor];
    [_contentView addSubview:_subTitleView];

    //layout
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView);
        make.left.equalTo(_contentView).with.offset(kDefaultSpaceUnit);
        make.bottom.equalTo(_contentView);
    }];
    [_subTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView);
        make.right.equalTo(_contentView).with.offset(-kDefaultSpaceUnit);
        make.bottom.equalTo(_contentView);
        make.width.lessThanOrEqualTo(@(200));
    }];
}
@end

#pragma mark - FilterTableViewDataModel

@interface FilterTableViewDataModel()
@end

@implementation FilterTableViewDataModel

-(void)setHeaderData:(TableViewSectionHeaderData*)data forSection:(NSInteger)section
{
    [super setHeaderData:data forSection:section];
}

-(void)setCellBtnItemsData:(NSArray*)btnItemModels forSection:(NSInteger)section
{
    NSInteger btnCountPerRow = 3;
    NSInteger rowCount = btnItemModels.count / btnCountPerRow;
    if (0 != btnItemModels.count % btnCountPerRow) {
        rowCount++;
    }

    for (NSInteger rowIndex = 0; rowIndex < rowCount; rowIndex++) {
        NSMutableArray *rowItems = [NSMutableArray new];
        NSInteger segmentIndex = rowIndex * btnCountPerRow;
        for (NSInteger itemIndex = 0; itemIndex < btnCountPerRow; itemIndex++) {
            if (btnItemModels.count > (segmentIndex + itemIndex)) {
                [rowItems addObject:btnItemModels[segmentIndex + itemIndex]];
            }else {
                break;
            }
        }
        
        TableViewCellData *cellData;
        cellData = [TableViewCellData makeWithOtherData:rowItems];
        [self setCellData:cellData forSection:section row:rowIndex];
    }
}

- (void)resetAllItemsUnchecked
{
    for (NSInteger sectionIndex = 0; sectionIndex < [self numberOfSections]; sectionIndex++) {
        for (CheckItemModel *model in [self getCheckedItemsInSection:sectionIndex]) {
            model.isChecked = NO;
        }
    }
}

- (NSString*)getAllCheckedItemsValues
{
    NSMutableArray *checkedValues = [NSMutableArray new];
    for (NSInteger sectionIndex = 0; sectionIndex < [self numberOfSections]; sectionIndex++) {
        NSString *subValues = [self getCheckedItemsValuesInSection:sectionIndex];
        if (![Util isEmptyString:subValues]) {
            [checkedValues addObject:subValues];
        }
    }
    if (checkedValues.count > 0) {
        return [checkedValues componentsJoinedByString:@","];
    }else {
        return @"全部";
    }
}

- (NSArray*)getAllItemsInSection:(NSInteger)section
{
    NSMutableArray *allItems = [NSMutableArray new];
    for (NSInteger rowIndex = 0; rowIndex < [self numberOfRowsInSection:section]; rowIndex++) {
        TableViewCellData *data = [self cellDataForSection:section row:rowIndex];
        [allItems addObjectsFromArray:(NSArray*)data.otherData];
    }
    return allItems;
}

- (NSArray*)getCheckedItemsInSection:(NSInteger)section
{
    NSMutableArray *checkedItems = [NSMutableArray new];

    for (CheckItemModel *model in [self getAllItemsInSection:section]) {
        if (model.isChecked) {
            [checkedItems addObject:model];
        }
    }
    return checkedItems;
}

- (NSString*)getCheckedItemsValuesInSection:(NSInteger)section
{
    NSMutableArray *checkedValues = [NSMutableArray new];
    
    for (CheckItemModel *model in [self getAllItemsInSection:section]) {
        if (model.isChecked) {
            [checkedValues addObject:model.value];
        }
    }
    if (checkedValues.count > 0) {
        return [checkedValues componentsJoinedByString:@","];
    }else {
        return @"全部";
    }
}

- (NSString*)getCheckedItemsKeysInSection:(NSInteger)section
{
    NSMutableArray *checkedKeys = [NSMutableArray new];
    
    for (CheckItemModel *model in [self getAllItemsInSection:section]) {
        if (model.isChecked) {
            [checkedKeys addObject:model.key];
        }
    }
    if (checkedKeys.count > 0) {
        return [checkedKeys componentsJoinedByString:@","];
    }else {
        return nil;
    }
}
@end

@interface FilterTableView()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)NSMutableDictionary *headerViewCache;
@end

@implementation FilterTableView

- (instancetype)initWithCustomMode{
    self = [super initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (NSMutableDictionary*)headerViewCache{
    if (nil == _headerViewCache) {
        _headerViewCache = [NSMutableDictionary new];
    }
    return _headerViewCache;
}

#pragma mark - WZTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewCellDefaultHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FilterTableSectionHeaderView *headerView = [self getHeaderLabelViewInSection:section];
    
    TableViewSectionHeaderData *headerData = [self.dataModel headerDataOfSection:section];
    headerData.subTitle = [self.dataModel getCheckedItemsValuesInSection:section];
    headerView.titleView.text = headerData.title;
    headerView.subTitleView.text = headerData.subTitle;

    return headerView.contentView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [self.dataModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataModel numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellDefaultHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellData *cellData = [self.dataModel cellDataForSection:indexPath.section row:indexPath.row];
    FilterRowButtonCell *cell;
    static NSString *sFilterRowButtonCellId = @"FilterRowButtonCell";

    cell = [tableView dequeueReusableCellWithIdentifier:sFilterRowButtonCellId];
    if (nil == cell) {
        cell = [[FilterRowButtonCell alloc]initWithMaxButtonCount:3 reuseIdentifier:sFilterRowButtonCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.onCellItemButtonClicked = ^(id itemInfo){
            [self reloadHeaderInSection:indexPath.section tableView:tableView];
        };
    }
    
    cell.itemDatas = (NSArray*)cellData.otherData;

    return cell;
}

- (void)reloadHeaderInSection:(CGFloat)section tableView:(UITableView*)tableView
{
    [tableView reloadData];
}

- (FilterTableSectionHeaderView*)getHeaderLabelViewInSection:(NSInteger)section
{
    NSString *sectionKey = [NSString intStr:section];
    
    FilterTableSectionHeaderView *headerView;
    if ([self.headerViewCache containsKey:sectionKey]) {
        headerView = self.headerViewCache[sectionKey];
    }else {
        UILabel *headerLabel = [[UILabel alloc]init];
        headerLabel.tag = sHeaderLabelViewTag;
        headerLabel.textColor = kColorBlack;
        headerView = [[FilterTableSectionHeaderView alloc]init];
    }
    return headerView;
}

- (void)setDataToHeaderLabel:(UILabel*)headerLabel inSection:(NSInteger)section
{
    TableViewSectionHeaderData *headerData = [self.dataModel headerDataOfSection:section];
    headerLabel.text = headerData.title;
}

@end
