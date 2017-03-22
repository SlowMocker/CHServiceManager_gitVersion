//
//  OrderExtendEditViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/9/14.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ExtendProductEditViewController.h"
#import "WZTableView.h"
#import "TextFieldTableViewCell.h"
#import "WZSingleCheckListPopView.h"
#import "ScanGraphicCodeViewController.h"
#import "WZDatePickerView.h"
#import "WZTextView.h"
#import "WZDateSelectCell.h"
#import "ProductModelSearchViewController.h"

@interface ExtendProductEditViewController ()<UITableViewDataSource, UITableViewDelegate, WZDatePickerViewDelegate, PleaseSelectViewCellDelegate>
{
    BOOL _isDatePickerShowing;
    NSTimeInterval _selectedTimeInterval;
    
    BOOL _isAirConditioning; //是否是空调
    BOOL _isTv; //是否是彩电
    BOOL _isBrandOther;
    BOOL _isBrandCHIQ; //启客品牌
    BOOL _isBrandCH; //长虹品牌

    NSString *_insideCodeStr;
    NSString *_brandId;
    NSString *_categroyId;  //品类
    
    ProductModelDes *_machineModelItem;
}

@property(nonatomic, strong)UITableView *tableView;

//产品信息
@property(nonatomic, strong)PleaseSelectViewCell *brandSelCell; //品牌(选择)
@property(nonatomic, strong)TextFieldTableViewCell *brandEditCell; //品牌（编辑）
@property(nonatomic, strong)PleaseSelectViewCell *productTypeCell; //品类
@property(nonatomic, strong)UITableViewCell *machineModelSelCell; //机型（选择）
@property(nonatomic, strong)TextFieldTableViewCell *machineModelEditCell; //机型（编辑）
@property(nonatomic, strong)WZTextView *machineModelDes;//机型描述
@property(nonatomic, strong)UITableViewCell *machineModelDesCell; //机型描述
@property(nonatomic, strong)TextFieldTableViewCell *machineCodeCell; //机号
@property(nonatomic, strong)TextFieldTableViewCell *invoicesCell; //发票号
@property(nonatomic, strong)WZDateSelectCell *purchaseDateCell;//购买日期
@property(nonatomic, strong)TextFieldTableViewCell *machinePriceCell;//购买价格
@property(nonatomic, strong)TextFieldTableViewCell *purchaseShop;//购买门店;
@property(nonatomic, strong)WZDateSelectCell *warrantyDateCell;//厂保结束日期
@property(nonatomic, strong)WZDateSelectCell *extendStartDateCell;//延保起始日期
@property(nonatomic, strong)WZDateSelectCell *extendEndDateCell;//延保结束日期


@property(nonatomic, strong)NSMutableArray *cellArray; //all cells

@end

@implementation ExtendProductEditViewController

- (UITableView*)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView clearBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView addTopHeaderSpace:kDefaultSpaceUnit * 2];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self alertUpdateMainConfigInfoIfNeed]) {
        return;
    }
    [self setNavBarRightButton:@"完成" clicked:@selector(finishButtonClicked:)];
    
    [self makeCustomCells];
    
    self.cellArray = [self groupTableViewCells];
    [self setTableViewCellCommonProperties];
    [self setDataToViews];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kTableViewLeftPadding, 0, kTableViewLeftPadding));
    }];
}

- (void)makeCustomCells
{
    NSArray *itemArray;
    
    itemArray = [self.configInfoMgr extendServiceBrands];
    itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
    _brandSelCell = [MiscHelper makeSelectItemCell:@"品牌" checkItems:itemArray checkedItem: nil];
    _brandSelCell.delegate = self;
    _brandEditCell = [MiscHelper makeTextFieldCell:@"请输入品牌"];
    
    itemArray = self.configInfoMgr.mutiExtendServiceProductTypes;
    itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
    _productTypeCell = [MiscHelper makeSelectItemCell:@"品类" checkItems:itemArray checkedItem: nil];
    _productTypeCell.delegate = self;

    _machineModelSelCell = [MiscHelper makeCommonSelectCell:@"机型"];
    [_machineModelSelCell addLineTo:kFrameLocationBottom];

    _machineModelEditCell = [MiscHelper makeTextFieldCell:@"请输入机型"];

    _machineModelDes = [[WZTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 2*kTableViewLeftPadding, 38*2) maxWords:40];
    _machineModelDes.placeholder = @"请输入机型描述";
    _machineModelDesCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [_machineModelDesCell.contentView addSubview:_machineModelDes];
    [_machineModelDesCell clearBackgroundColor];
    [_machineModelDesCell.contentView clearBackgroundColor];
    
    _machineCodeCell = [MiscHelper makeLeftEditRightBarCodeBtnCell:self action:@selector(machineCodeButtonClicked:)];
    [_machineCodeCell addLineTo:kFrameLocationBottom];
    
#ifdef DEBUG
//    _machineCodeCell.textField.text = @"D9B50013330028200900001W";
#endif
    
    _purchaseDateCell = [self makeDateSelectCell:@"购买日期" date:nil];
    _warrantyDateCell = [self makeDateSelectCell:@"厂保到期日期" date:nil];
    
    __weak typeof (&*self)weakSelf = self;
    _warrantyDateCell.dateSelectedBlock = ^(id obj){
        WZDateSelectCell *warrantyDateCell = (WZDateSelectCell*)obj;
        NSDate *extendStartDate;
        if ([warrantyDateCell.date isEarlierThanDate:[NSDate date]]) {
            extendStartDate = [NSDate dateTomorrow];
        }else {
            extendStartDate = [warrantyDateCell.date dateByAddingDays:1];
        }
        weakSelf.extendStartDateCell.date = extendStartDate;
        weakSelf.extendEndDateCell.date = [extendStartDate dateByAddingDays:365];
    };
    _extendStartDateCell = [self makeDateSelectCell:@"延保起始期日期" date:nil];
    _extendEndDateCell = [self makeDateSelectCell:@"延保截止日期" date:nil];

    _machinePriceCell = [MiscHelper makeTextFieldCell:@"购机价格"];
    _invoicesCell = [MiscHelper makeTextFieldCell:@"请输入发票号(选填)"];
    
    _purchaseShop = [MiscHelper makeTextFieldCell:@"购买门店"];
}

- (WZDateSelectCell *)makeDateSelectCell:(NSString*)title date:(NSDate*)date
{
    WZDateSelectCell *dateCell = [[WZDateSelectCell alloc]initWithDate:date baseViewController:self];
    dateCell.textLabel.text = title;
    [dateCell addLineTo:kFrameLocationBottom];
    
    return dateCell;
}

- (void)setProduct:(ExtendProductContent *)product
{
    if (_product != product) {
        _product = product;
        _isBrandOther = [product.zzfld000000 isEqualToString:@"QT"];
        _isTv = [product.zzfld000001 isEqualToString:@"Z01"];
        _isAirConditioning = [product.zzfld000001 isEqualToString:@"Z02"];
        _isBrandCHIQ = [product.zzfld000000 isEqualToString:@"CHIQ"];
        _isBrandCH = [product.zzfld000000 isEqualToString:@"CH"];
        _insideCodeStr = product.zzfld00000b;
        _brandId = product.zzfld000000;
        _categroyId = product.zzfld000001;

        _machineModelItem = [ProductModelDes new];
        _machineModelItem.product_id = product.zzfld00000q;
        _machineModelItem.short_text = product.zzfld00005j;
        _machineModelItem.zz0017 = product.zzfld000001;
        _machineModelItem.zz0018 = product.zzfld000000;
        if(_isBrandOther){
            _machineModelItem.zz0018 = product.zzfld000003v;
        }
    }
}

- (void)setDateValue:(NSObject*)dateValue toDateCell:(WZDateSelectCell*)dateCell
{
    dateCell.date = [Util dateWithString:(NSString*)dateValue format:WZDateStringFormat5];
}

- (void)setOrderProductInfoToViews:(ExtendProductContent*)product
{
    ReturnIf(product == nil);

    self.brandSelCell.checkedItemKey = product.zzfld000000;
    _brandId = self.brandSelCell.checkedItem.key;
    _isBrandCHIQ = [_brandId isEqualToString:@"CHIQ"];
    _isBrandCH = [_brandId isEqualToString:@"CH"];

    self.productTypeCell.checkedItemKey = product.zzfld000001;
    _isTv = [product.zzfld000001 isEqualToString:@"Z01"];
    _isAirConditioning = [product.zzfld000001 isEqualToString:@"Z02"];

    self.brandEditCell.textField.text = product.zzfld000003v;
    self.machineModelSelCell.detailTextLabel.text = [MiscHelper extendProductModelName:product];
    self.machineModelEditCell.textField.text = [MiscHelper extendProductModelName:product];
    self.machineModelDes.text = product.zzfld00005j;

    self.machineCodeCell.textField.text = product.zzfld00000b;
    self.invoicesCell.textField.text = product.invoiceNo;

    self.machinePriceCell.textField.text = product.buyprice;
    self.purchaseShop.textField.text = product.zzfld00000e;

    [self setDateValue:product.zzfld00002i toDateCell:self.purchaseDateCell];
    [self setDateValue:product.factoryWarrantyDue toDateCell:self.warrantyDateCell];
    [self setDateValue:product.extendprdBeginDue toDateCell:self.extendStartDateCell];
    [self setDateValue:product.extendprdEndDue toDateCell:self.extendEndDateCell];

    BOOL canEditDes = !((_isBrandCHIQ || _isBrandCH)&&_isTv);
    self.machineModelDes.textView.editable = canEditDes;
    self.machineModelDes.wordLimitLabel.hidden = !canEditDes;
}

- (void)setDataToViews
{
    [self setOrderProductInfoToViews:self.product];
}

- (void)reloadTableView
{
    self.cellArray = [self groupTableViewCells];
    
    [self.tableView reloadData];
}

- (void)setTableViewCellCommonProperties
{
    for (NSArray *rowArray in self.cellArray) {
        for (UITableViewCell *cell in rowArray) {
            cell.textLabel.textColor = kColorDarkGray;
            cell.textLabel.font = SystemFont(14);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
}

- (NSMutableArray*)groupTableViewCells
{
    NSMutableArray *sectionArray = [NSMutableArray new];
    NSMutableArray *rowArray;

    //section
    rowArray = [NSMutableArray new];
    
    [rowArray addObject:self.brandSelCell];
    
    if (_isBrandOther) {
        [rowArray addObject:self.brandEditCell];
        [rowArray addObject:self.productTypeCell];
    }else {
        [rowArray addObject:self.productTypeCell];
    }
    
    //除长虹、启客彩电外，机型都手动输入
    if ((_isBrandCH || _isBrandCHIQ) && _isTv) {
        [rowArray addObject:self.machineModelSelCell];
        [rowArray addObject:self.machineModelDesCell];
        self.machineModelDes.textView.editable = NO;
        self.machineModelDes.placeholder = @"";
        self.machineModelDes.wordLimitLabel.hidden = YES;
    }else {
        [rowArray addObject:self.machineModelDesCell];
    }

    [rowArray addObject:self.machineCodeCell];
    [rowArray addObject:self.invoicesCell];
    [rowArray addObject:self.purchaseDateCell];
//    [rowArray addObject:self.machinePriceCell];
//    [rowArray addObject:self.purchaseShop];
    [rowArray addObject:self.warrantyDateCell];
    [rowArray addObject:self.extendStartDateCell];
    [rowArray addObject:self.extendEndDateCell];

    [sectionArray addObject:rowArray];
 
    return sectionArray;
}

#pragma mark - TableView Delegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    [tableView didRequestTableViewListDatasWithCount:1 totalCount:1 page:pageInfo response:nil error:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rowArray = self.cellArray[section];
    return rowArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.cellArray[indexPath.section][indexPath.row];
    CGFloat cellHeight = kTableViewCellDefaultHeight;
    
    if (cell == self.machineModelDesCell){
        return  CGRectGetHeight(self.machineModelDes.frame) + kDefaultSpaceUnit;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellArray[indexPath.section][indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = self.cellArray[indexPath.section][indexPath.row];
    if (cell == self.purchaseDateCell){
        [self popupDatePicker];
    }else if (cell == self.machineModelSelCell){
        ProductModelSearchViewController *modelSearchVc = [[ProductModelSearchViewController alloc]init];
        modelSearchVc.modelSelectedBlock = ^(ViewController* viewController, ProductModelDes *model){
            _machineModelItem = model;
            self.machineModelSelCell.detailTextLabel.text = _machineModelItem.product_id;
            self.machineModelDes.text = [Util defaultStr:kUnknown ifStrEmpty:_machineModelItem.short_text];
            [viewController popViewController];
        };
        [self pushViewController:modelSearchVc];
    }
}

- (void)popupDatePicker
{
    WZDatePickerView *datePicker = [[WZDatePickerView alloc]initWithDelegate:self];
    datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];

    NSDate *focusDate = [Util dateWithString:self.product.zzfld00002i format:WZDateStringFormat5];
    if (!focusDate) {
        focusDate = [NSDate date];
    }
    datePicker.datePicker.date = focusDate;

    [self.view addSubview:datePicker];
    
    _isDatePickerShowing = YES;
}

- (void)datePickerViewFinished:(WZDatePickerView*)view selected:(NSTimeInterval)secs
{
    _isDatePickerShowing = NO;
    _selectedTimeInterval = floor(secs / 60.0) * 60.0;
    NSString *dateTime = [NSString dateStringWithInterval:secs*1000 formatStr:WZDateStringFormat2];
    self.purchaseDateCell.detailTextLabel.text = dateTime;
}

- (void)datePickerViewCancel:(WZDatePickerView*)view
{
    _isDatePickerShowing = NO;
}

- (void)isChanghongProductSegmentChanged:(UISegmentedControl*)segment
{
    [self reloadTableView];
}

- (void)machineCodeButtonClicked:(UIButton*)sender
{
    [ScanGraphicCodeViewController fastScanWithComplete:^(NSString *codeText) {
        _insideCodeStr = [codeText copy];
        self.machineCodeCell.textField.text = _insideCodeStr;
    } fromViewController:self];
}

// 检查机号格式
- (NSString*)isValidMachineCode:(NSString*)machineModel
{
    NSString *invalidInfo;
    do {
        //check chang hong and chiq only
        BreakIf(!_isBrandCH && !_isBrandCHIQ);

        if (_isAirConditioning) {
            invalidInfo = [MiscHelper isValidChangHongAirConditionCode:machineModel];
        }else if(_isTv){
            invalidInfo = [MiscHelper isValidChangHongTelevitionCode:machineModel machineModel:_categroyId];
        }
    } while (NO);
    return invalidInfo;
}

- (ExtendProductContent*)readExtendProductContent
{
    ExtendProductContent *product = [ExtendProductContent new];

    if (_isBrandOther) {
        product.zzfld000003v = self.brandEditCell.textField.text;
    }
    product.zzfld000000 = self.brandSelCell.checkedItem.key;
    product.zzfld000001 = self.productTypeCell.checkedItem.key;
    product.zzfld00000q = _machineModelItem.product_id;//机型
    product.zzfld00005j= self.machineModelDes.text;
    product.zzfld00002i = [NSString dateStringWithDate:self.purchaseDateCell.date strFormat:WZDateStringFormat5];
    product.zzfld00000b = [self.machineCodeCell.textField.text uppercaseString];
    product.buyprice = self.machinePriceCell.textField.text;
    product.factoryWarrantyDue = [NSString dateStringWithDate:self.warrantyDateCell.date strFormat:WZDateStringFormat5];
    product.invoiceNo = self.invoicesCell.textField.text;
    product.extendprdBeginDue = [NSString dateStringWithDate:self.extendStartDateCell.date strFormat:WZDateStringFormat5];
    product.extendprdEndDue = [NSString dateStringWithDate:self.extendEndDateCell.date strFormat:WZDateStringFormat5];
    product.zzfld00000e = nil;

    return product;
}

- (NSString*)checkExtendProductContent:(ExtendProductContent*)product
{
    do {
        if (_isBrandOther) {
            ReturnIf([Util isEmptyString:product.zzfld000003v])@"请填写品牌";
            ReturnIf(product.zzfld000003v.length > 20)@"品牌输入最多20字符";
        }
        if((_isBrandCH || _isBrandCHIQ) && _isTv){
            ReturnIf([Util isEmptyString:product.zzfld00000q])@"请填写机型";
        }else {
            ReturnIf([Util isEmptyString:product.zzfld00005j])@"请填写机型";
            ReturnIf(product.zzfld00005j.length > 40)@"机型输入最多40个字符";
        }
        ReturnIf([Util isEmptyString:product.zzfld000000])@"请选择品牌";
        ReturnIf([Util isEmptyString:product.zzfld000001])@"请选择品类";
        ReturnIf(nil == product.zzfld00002i)@"请选择购买日期";
        ReturnIf([Util isEmptyString:product.zzfld00000b])@"请填写机号";

        NSString *invalidStr = [self isValidMachineCode:product.zzfld00000b];
        ReturnIf(![Util isEmptyString:invalidStr])invalidStr;

        ReturnIf([Util isEmptyString:(NSString*)product.factoryWarrantyDue])@"请填写厂保到期日期";
        ReturnIf([Util isEmptyString:(NSString*)product.extendprdBeginDue])@"请填写延保开始日期";
        ReturnIf([Util isEmptyString:(NSString*)product.extendprdEndDue])@"请填写延保结束日期";
        
        if ([self.extendStartDateCell.date isEarlierThanDate:self.warrantyDateCell.date]) {
            return @"延保日期不能早于厂保到期日期";
        }
        if ([self.extendEndDateCell.date isEarlierThanDate:self.extendStartDateCell.date]) {
            return @"延保结束日期不能早于开始时间";
        }
    } while (NO);
    return nil;
}

- (void)finishButtonClicked:(UIButton*)button
{
    ExtendProductContent *product = [self readExtendProductContent];
    NSString *invalidStr = [self checkExtendProductContent:product];
    if ([Util isEmptyString:invalidStr]) {
        if (self.editFinishedBlock) {
            self.editFinishedBlock(product);
        }
    }else {
        [Util showToast:invalidStr];
    }
}

- (void)selectViewDidChecked:(PleaseSelectViewCell*)cell
{
    if (cell == self.brandSelCell) { //选中品牌
        _brandId = self.brandSelCell.checkedItem.key;
        BOOL isOther = [_brandId isEqualToString:@"QT"];
        _isBrandCHIQ = [_brandId isEqualToString:@"CHIQ"];
        _isBrandCH = [_brandId isEqualToString:@"CH"];
        if (_isBrandOther != isOther) {
            _isBrandOther = isOther;
            [self reloadTableView];
        }

        //reset brand edit text
        self.brandEditCell.textField.text = nil;

        //reset product type
        self.productTypeCell.checkedItem = nil;

        //reset machine model datas
        _machineModelItem = nil;
        self.machineModelSelCell.detailTextLabel.text = @"请选择";
        self.machineModelEditCell.textField.text = nil;
        self.machineModelDes.text = nil;
    }else if (cell == self.productTypeCell){
        NSString *productCode = (NSString*)self.productTypeCell.checkedItem.extData;
        _isTv = [productCode isEqualToString:@"Z01"];
        _isAirConditioning = [productCode isEqualToString:@"Z02"];

        //reset machine model datas
        _machineModelItem = nil;
        self.machineModelSelCell.detailTextLabel.text = @"请选择";
        self.machineModelEditCell.textField.text = nil;
        self.machineModelDes.text = nil;
    }else if (cell == self.machineModelSelCell){
    }

    BOOL canEditDes = !((_isBrandCH || _isBrandCHIQ)&&_isTv);
    self.machineModelDes.textView.editable = canEditDes;
    self.machineModelDes.wordLimitLabel.hidden = !canEditDes;

    [self reloadTableView];
}

@end
