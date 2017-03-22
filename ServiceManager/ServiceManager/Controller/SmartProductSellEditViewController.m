//
//  AddRepairerViewController.m
//  ServiceManager
//
//  Created by mac on 15/10/5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "SmartProductSellEditViewController.h"
#import <UIAlertView+Blocks.h>
#import "ProductModelSearchViewController.h"

@interface SmartProductSellEditViewController ()<WZSingleCheckViewControllerDelegate>
{
    //产品代码
    WZSingleCheckViewController *_partTypeViewController;
    WZSingleCheckViewController *_partSubTypeViewController;
    NSArray *_checkTypes;
    CheckItemModel *_tempTypeItem; //temp分类
    CheckItemModel *_tempSubTypeItem;    //产品
}

@property(nonatomic, strong)NSMutableArray *cellArray;
@end

@implementation SmartProductSellEditViewController

- (void)setFeeInfos:(SellFeeListInfos *)feeInfos{
    super.feeInfos = feeInfos;

    //init type item & product item
    if (![Util isEmptyString:feeInfos.zzfld00005e]) {
        //type
        ConfigItemInfo *cfgInfo =
        [[ConfigInfoManager sharedInstance]findConfigItemInfoByType:MainConfigInfoTableType22 code:feeInfos.zzfld00005e];
        self.typeItem = [CheckItemModel modelWithValue:cfgInfo.value forKey:cfgInfo.code];
        self.typeItem.extData = self.typeItem.key;
        self.typeItem.isChecked = YES;
    }
    if (![Util isEmptyString:feeInfos.orderedProd]) {
        self.subTypeItem = [CheckItemModel modelWithValue:feeInfos.prodDescription forKey:feeInfos.orderedProd];
        self.subTypeItem.extData = self.subTypeItem.key;
        self.subTypeItem.isChecked = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _checkTypes = [[ConfigInfoManager sharedInstance]componentTypes];
    _checkTypes = [Util convertConfigItemInfoArrayToCheckItemModelArray:_checkTypes];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [UIView new];
    
    [self setNavBarRightButton:@"提交" clicked:@selector(commitButtonClicked:)];
    
    [self setupTableViewCells];
    [self updateTableViewCellsData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.priceCell addObserver:self forKeyPath:@"middleTextField.text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    [self.countCell addObserver:self forKeyPath:@"middleTextField.text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self.priceCell removeObserver:self forKeyPath:@"middleTextField.text"];
    [self.countCell removeObserver:self forKeyPath:@"middleTextField.text"];
}

- (PleaseSelectViewCell*)smartProductTypeCell{
    if (nil == _smartProductTypeCell) {
        NSArray *itemArray = [[ConfigInfoManager sharedInstance] smartProductTypes];
        itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
        CheckItemModel *defaultItem;
        if (itemArray.count > 0) {
            defaultItem = itemArray[0];
        }
        _smartProductTypeCell = [MiscHelper makeSelectItemCell:@"智能产品分类" checkItems:itemArray checkedItem:defaultItem];
    }
    return _smartProductTypeCell;
}

- (UITableViewCell*)productCodeCell{
    if (nil == _productCodeCell) {
        _productCodeCell = [MiscHelper makeCommonSelectCell:@"产品代码"];
    }
    return _productCodeCell;
}

- (LeftTextRightTextCell*)productDesCell{
    if (nil == _productDesCell) {
        _productDesCell = [[LeftTextRightTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_productDesCell clearBackgroundColor];
        _productDesCell.leftTextLabel.textColor = kColorBlack;
        _productDesCell.leftTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _productDesCell.rightTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _productDesCell.leftTextLabel.text = @"产品描述";
        _productDesCell.rightTextLabel.textAlignment = NSTextAlignmentRight;
        _productDesCell.backgroundView = nil;
        _productDesCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _productDesCell;
}

- (LabelEditCell*)countCell
{
    if (nil == _countCell) {
        _countCell = [LabelEditCell makeLabelEditCell:@"数量" hint:@"请输入数量" keyBoardType:UIKeyboardTypeNumberPad unit:nil];
        _countCell.middleTextField.textAlignment = NSTextAlignmentCenter;
    }
    return _countCell;
}

- (LabelEditCell*)priceCell
{
    if (nil == _priceCell) {
        _priceCell = [LabelEditCell makeLabelEditCell:@"单价 (元)" hint:@"请输入金额" keyBoardType:UIKeyboardTypeNumberPad unit:nil];
        _priceCell.middleTextField.textAlignment = NSTextAlignmentCenter;
        _priceCell.middleTextField.font = SystemFont(16);
        _priceCell.middleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _priceCell;
}

- (LabelEditCell*)totalPriceCell
{
    if (nil == _totalPriceCell) {
        _totalPriceCell = [LabelEditCell makeLabelEditCell:@"金额 (元)" hint:@"0.00" keyBoardType:UIKeyboardTypeNumberPad unit:nil];
        _totalPriceCell.middleTextField.textAlignment = NSTextAlignmentCenter;
        _totalPriceCell.middleTextField.textColor = kColorLightGray;
        _totalPriceCell.middleTextField.font = SystemFont(16);
        _totalPriceCell.middleTextField.enabled = NO;
    }
    return _totalPriceCell;
}

- (LabelEditCell*)receiptCell
{
    if (nil == _receiptCell) {
        _receiptCell = [LabelEditCell makeLabelEditCell:@"收据号" hint:@"请输入收据号" keyBoardType:UIKeyboardTypeASCIICapable unit:nil];
        _receiptCell.middleTextField.textAlignment = NSTextAlignmentCenter;
    }
    return _receiptCell;
}

- (NSMutableArray*)cellArray
{
    if (nil == _cellArray) {
        _cellArray = [[NSMutableArray alloc]init];
    }
    return _cellArray;
}

- (void)setupTableViewCells
{
//    [self.cellArray addObject:self.smartProductTypeCell];
    [self.cellArray addObject:self.productCodeCell];
    [self.cellArray addObject:self.productDesCell];
    [self.cellArray addObject:self.countCell];
    [self.cellArray addObject:self.priceCell];
    [self.cellArray addObject:self.totalPriceCell];
    [self.cellArray addObject:self.receiptCell];
}

- (void)updateTableViewCellsData
{
    //智能产品分类
    CheckItemModel *productType = self.smartProductTypeCell.checkedItem;
    for (CheckItemModel *model in self.smartProductTypeCell.checkItems) {
        if ([model.key isEqualToString:self.feeInfos.orderedProd]) {
            productType = model;
            break;
        }
    }
    self.smartProductTypeCell.checkedItem = productType;

    //产品代码
    self.productCodeCell.detailTextLabel.text = [Util defaultStr:@"请选择" ifStrEmpty:self.subTypeItem.key];

    //产品描述
    self.productDesCell.rightTextLabel.text = self.subTypeItem.value;

    //数量
    self.countCell.middleTextField.text = self.feeInfos.quantity.description;
    
    //单价
    self.priceCell.middleTextField.text = self.feeInfos.netValue.description;
    
    //总价
    [self calcAndSetTotalPrice];

    //收据号
    self.receiptCell.middleTextField.text = self.feeInfos.zzfld00002v;
}

- (void)calcAndSetTotalPrice
{
    self.totalPriceCell.middleTextField.text = [NSString stringWithFormat:@"%@", @([self calcTotalPriceValue])];
}

- (NSInteger)calcTotalPriceValue
{
    NSString *countStr = self.countCell.middleTextField.text;
    NSString *priceStr = self.priceCell.middleTextField.text;

    if ([countStr isPureNumber] && [priceStr isPureNumber]) {
        return [countStr integerValue] * [priceStr integerValue];
    }else {
        return 0;
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kDefaultSpaceUnit * 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = kTableViewCellDefaultHeight;
    UITableViewCell *cell = self.cellArray[indexPath.row];

    if (cell == self.productDesCell) {
        cellHeight = [self.productDesCell fitHeight];
    }
    return MAX(cellHeight, kTableViewCellDefaultHeight);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellArray[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = self.cellArray[indexPath.row];

    if (cell == self.productCodeCell){
        [self selectPartItem];
    }
}

-(void)commitButtonClicked:(UIButton*)regBtn
{
    NSString *inValidError;
    NSString *tempStr;
    
    do {
        if (nil == self.typeItem.key || nil == self.subTypeItem.key) {
            inValidError = @"请选择产品代码";
        }
        BreakIf(nil != inValidError);

        inValidError = [MiscHelper checkNumberInput:self.countCell.middleTextField.text name:@"数量" greaterThan:0];
        BreakIf(nil != inValidError);
        
        inValidError = [MiscHelper checkNumberInput:self.priceCell.middleTextField.text name:@"单价" greaterThan:0];
        BreakIf(nil != inValidError);

        //check receipt No.
        tempStr = self.receiptCell.middleTextField.text;
        if (self.user.isCreate) {
            if ([Util isEmptyString:tempStr]) {
                inValidError = @"请填写收据号";
                BreakIf(nil != inValidError);
            }
        }
        if (![Util isEmptyString:tempStr] && ![MiscHelper isValidReceiptNumber:tempStr]) {
            inValidError = @"请填写正确的收据号";
        }
        BreakIf(nil != inValidError);
    } while (0);
    
    if (nil != inValidError) {
        [Util showToast:inValidError];
    }else {
        EditFeeOrderInputParams *input = [EditFeeOrderInputParams new];
        input.expenseId = self.feeInfos.Id.description;
        input.objectId = self.orderObjectId.description;
        input.dispatchinfoId = self.orderKeyId;
        input.orderedProd = self.subTypeItem.key;
        input.prodDescription = self.subTypeItem.value;
        input.zzfld00005e = self.typeItem.key;
        input.itmType = @"ZPRV";
        input.quantity = self.countCell.middleTextField.text;
        input.netValue = self.priceCell.middleTextField.text;
        input.zzfld00002v = self.receiptCell.middleTextField.text;
        input.operate_type = (nil == self.feeInfos.Id) ? @"-2" : @"-3";
        [self editFeeOrder:input];
    }
}

#pragma mark - select product part item

- (void)selectPartItem
{
    _tempTypeItem = self.typeItem;
    _tempSubTypeItem = self.subTypeItem;

    _partTypeViewController = [MiscHelper pushToCheckListViewController:@"物料类别" checkItems:_checkTypes checkedItem:self.typeItem from:self delegate:self];
    _partTypeViewController.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)singleCheckViewController:(WZSingleCheckViewController*)viewController didChecked:(CheckItemModel*)checkedItem
{
    if (_partTypeViewController == viewController) {
        if (![self.typeItem.key isEqualToString:checkedItem.key]) {
            _tempTypeItem = checkedItem;
            _tempSubTypeItem = nil;
        }
        NSArray *subtypes = [[ConfigInfoManager sharedInstance]subcomponentTypesOfType:(NSString*)checkedItem.key];
        subtypes = [Util convertConfigItemInfoArrayToCheckItemModelArray:subtypes];
        _partSubTypeViewController = [MiscHelper pushToCheckListViewController:@"物料代码" checkItems:subtypes checkedItem:_tempSubTypeItem from:viewController delegate:self];
    }else if (_partSubTypeViewController == viewController){//物料子类
        self.typeItem = _tempTypeItem;
        self.subTypeItem = checkedItem;
        self.productCodeCell.detailTextLabel.text = checkedItem.key;
        self.productDesCell.rightTextLabel.text = checkedItem.value;
        [self.tableView reloadTableViewCell:self.productDesCell];

        [_partSubTypeViewController popTo:self];
    }
}

- (void)dismissKeyBoard
{
    [self.countCell.middleTextField resignFirstResponder];
    [self.priceCell.middleTextField resignFirstResponder];
    [self.totalPriceCell.middleTextField resignFirstResponder];
    [self.receiptCell.middleTextField resignFirstResponder];
}

#pragma mark - 单价或数量变化

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    
    if (object == self.countCell || object == self.priceCell) {
        [self calcAndSetTotalPrice];
    }
}


@end
