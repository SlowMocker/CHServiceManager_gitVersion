//
//  OrderFilterPopView.m
//  ServiceManager
//
//  Created by will.wang on 16/9/8.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "OrderFilterPopView.h"
#import "WZModal.h"
#import "FilterTableView.h"

#pragma mark - 筛选数据项

@interface OrderFilterItemsModel : NSObject
- (FilterTableViewDataModel*)makeDataModel;
@end

@implementation OrderFilterItemsModel

- (NSArray*)brands
{
    NSMutableArray *itemArray = [[NSMutableArray alloc]init];
    
    NSArray *valueItems = @[@"长虹", @"启客",@"三洋",@"西藏迎燕"];
    NSArray *keyItems = @[@"CH", @"CHIQ",@"SY",@"XZYY"];
    
    for (NSInteger index = 0; index < MIN(keyItems.count, valueItems.count);index++) {
        CheckItemModel *configItem = [CheckItemModel new];
        configItem.key = keyItems[index];
        configItem.value = valueItems[index];
        [itemArray addObject:configItem];
    }
    return itemArray;
}

- (NSArray*)productsType
{
    NSMutableArray *itemArray = [[NSMutableArray alloc]init];

    NSArray *valueItems = @[@"彩电", @"空调"];
    NSArray *keyItems = @[@"TV0010", @"KT0010"];

    for (NSInteger index = 0; index < MIN(keyItems.count, valueItems.count);index++) {
        CheckItemModel *configItem = [CheckItemModel new];
        configItem.key = keyItems[index];
        configItem.value = valueItems[index];
        [itemArray addObject:configItem];
    }
    return itemArray;
}

- (NSArray*)repairTypes{
    return [[ConfigInfoManager sharedInstance] orderRepairTypes];
}

- (FilterTableViewDataModel*)makeDataModel
{
    FilterTableViewDataModel *model = [[FilterTableViewDataModel alloc]init];
    
    NSInteger section = 0;
    
    //section 0, brand
    TableViewSectionHeaderData *headerData = [TableViewSectionHeaderData makeWithTitle:@"品牌"];
    [model setHeaderData:headerData forSection:section];
    [model setCellBtnItemsData:[self brands] forSection:section];

    
    //section 1, product type
    section++;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"产品大类"];
    [model setHeaderData:headerData forSection:section];
    [model setCellBtnItemsData:[self productsType] forSection:section];

    //section 2, repair type
    section++;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"维修类型"];
    [model setHeaderData:headerData forSection:section];
    [model setCellBtnItemsData:[self repairTypes] forSection:section];

    return model;
}

@end

@interface OrderFilterPopView ()
@property(nonatomic, strong)FilterTableView *filterGridView;
@property(nonatomic, strong)NSString *filterConditionValues;

@property(nonatomic, strong)UIButton *resetButton;
@property(nonatomic, strong)UIButton *okButton;
@end

@implementation OrderFilterPopView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, ScreenHeight)];
    if (self) {
        self.filterConditionValues = @"全部,全部,全部";
        [self makeCustomSubViews];
        [self layoutCustomSubViews];
    }
    return self;
}

- (void)makeCustomSubViews
{
    //set set color white
    self.backgroundColor = kColorWhite;
    
    //filter grid view
    _filterGridView = [[FilterTableView alloc]initWithCustomMode];
    _filterGridView.dataModel = [[OrderFilterItemsModel new]makeDataModel];
    _filterGridView.backgroundColor = kColorWhite;
    [self addSubview:_filterGridView];

    //reset and ok buttons
    _okButton = [UIButton textButton:@"确定" backColor:kColorDefaultRed target:self action:@selector(okButtonClicked:)];
    [self addSubview:_okButton];

    _resetButton = [UIButton textButton:@"重置" backColor:kColorLightGray     target:self action:@selector(resetButtonClicked:)];
    [self addSubview:_resetButton];
}

- (void)layoutCustomSubViews
{
    //filter grid view
    [self.filterGridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kDefaultSpaceUnit*2);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self.okButton.mas_top);
    }];
    
    //reset and ok buttons
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@(kButtonDefaultHeight));
        make.right.equalTo(self.mas_centerX);
    }];
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX);
        make.right.equalTo(self);
        make.bottom.equalTo(self.resetButton);
        make.height.equalTo(self.resetButton);
    }];
}

- (void)handleOrderFilterEvent
{
    NSString *filterStr = [self.filterGridView.dataModel getAllCheckedItemsValues];
    BOOL filterChanged = ![filterStr isEqualToString:self.filterConditionValues];
    //update it
    self.filterConditionValues = filterStr;

    if (filterChanged) {
        //update result
        self.filterCondition.brands = [self.filterGridView.dataModel getCheckedItemsKeysInSection:0];
        self.filterCondition.productTypes = [self.filterGridView.dataModel getCheckedItemsKeysInSection:1];
        self.filterCondition.orderTypes = [self.filterGridView.dataModel getCheckedItemsKeysInSection:2];
        
        if (nil != self.filterValueChangedBlock) {
            self.filterValueChangedBlock(self);
        }
    }
}

- (void)okButtonClicked:(UIButton*)button
{
    [self handleOrderFilterEvent];
    [self hide];
}

- (void)resetButtonClicked:(UIButton*)button
{
    [self.filterGridView.dataModel resetAllItemsUnchecked];
    [self.filterGridView reloadData];
}

- (void)show
{
    WZModal *modal = [WZModal sharedInstance];

    if (!modal.isShowing) {
        modal.showCloseButton = NO;
        modal.tapOutsideToDismiss = YES;
        modal.onTapOutsideBlock = ^(){
            [self handleOrderFilterEvent];
        };
        modal.contentViewLocation = WZModalContentViewLocationRight;
        [modal showWithContentView:self andAnimated:YES];
    }
}

- (void)hide
{
    [[WZModal sharedInstance]hide];
}

- (void)resetAllFilterConditions
{
    //reset ui
    [self.filterGridView.dataModel resetAllItemsUnchecked];
    [self.filterGridView reloadData];

    //handle chaing event
    [self handleOrderFilterEvent];
}

@end
