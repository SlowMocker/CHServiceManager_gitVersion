//
//  OrderExtendEditViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/9/14.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "OrderExtendEditViewController.h"
#import "WZTableView.h"
#import "ProductSelectCell.h"
#import "TextFieldTableViewCell.h"
#import "WZTextView.h"
#import "WZSingleCheckListPopView.h"
#import "ScanGraphicCodeViewController.h"
#import "ExtendServiceProductCell.h"
#import "ExtendProductEditViewController.h"
#import "WZSingleCheckViewController.h"
#import "WZDatePickerView.h"
#import "AddressPickerView.h"
#import "WZDateSelectCell.h"
#import "ProductModelSearchViewController.h"
#import "WZModal.h"
#import "ExtendReceiveAccountQrCodeController.h"
#import "ExtendServiceListViewController.h"
#import "OrderListViewController.h"
#import "ExtendReceiveAccountStatusController.h"

static CGFloat kPerformOrderViewCellLineHeight = 40;

@interface OrderExtendEditViewController ()<UITableViewDataSource, UITableViewDelegate, WZSingleCheckViewControllerDelegate, PleaseSelectViewCellDelegate>
{
    BOOL _isAirConditioning; //是否是空调
    BOOL _isTv; //是否是彩电
    BOOL _isBrandCHIQ; //启客品牌
    BOOL _isBrandCH; //长虹品牌
    BOOL _isBrandOther; //其它品牌
    NSString *_brandId;
    NSString *_categroyId;  //品类
    NSArray *_streets;

    AddressPickerView *_addressPicker;

    CheckItemModel *_selectedProvince;
    CheckItemModel *_selectedCity;
    CheckItemModel *_selectedDistrict;
    CheckItemModel *_selectedStreet;

    ProductModelDes *_machineModelItem;
    ScanGraphicCodeViewController *_scanMoachineCodeBarVc;
}

@property(nonatomic, strong)UITableView *tableView;

//section 用户信息
@property(nonatomic, strong)TextFieldTableViewCell *nameCell;
@property(nonatomic, strong)TextFieldTableViewCell *telEditCell;
@property(nonatomic, strong)TextFieldTableViewCell *tel2EditCell;
@property(nonatomic, strong)UITableViewCell *addressCell;
@property(nonatomic, strong)UITableViewCell *streetCheckCell;
@property(nonatomic, strong)TextFieldTableViewCell *detailAddressCell;

//产品信息
@property(nonatomic, strong)PleaseSelectViewCell *brandSelCell; //品牌(选择)
@property(nonatomic, strong)TextFieldTableViewCell *brandEditCell;//品牌（编辑）
@property(nonatomic, strong)PleaseSelectViewCell *categroyCell; //品类
@property(nonatomic, strong)UITableViewCell *machineModelSelCell; //机型（选择）
@property(nonatomic, strong)TextFieldTableViewCell *machineModelEditCell; //机型（编辑）
@property(nonatomic, strong)TextFieldTableViewCell *machineCodeCell; //机号
@property(nonatomic, strong)WZDateSelectCell *purchaseDateCell;//购买日期
@property(nonatomic, strong)TextFieldTableViewCell *machinePriceCell;//购买价格
@property(nonatomic, strong)PleaseSelectViewCell *machinePriceRangeCell; //价格区间
@property(nonatomic, strong)TextFieldTableViewCell *purchaseShop;//购买门店

//延保项
@property(nonatomic, strong)UISegmentedControl *contractTypeSegment;//纸、电
@property(nonatomic, strong)TextFieldTableViewCell *contractNoCell; //合同号
@property(nonatomic, strong)PleaseSelectViewCell *tradeReasonCell;//成交原因
@property(nonatomic, strong)PleaseSelectViewCell *extendTimeCell;//延保时间
@property(nonatomic, strong)WZTextView *contractNote;//合同备注
@property(nonatomic, strong)UITableViewCell *contractNoteCell; //合同备注
@property(nonatomic, strong)WZDateSelectCell *signDateCell;//签字日期

//container
@property(nonatomic, strong)NSMutableArray *cellArray; //all cells
@property(nonatomic, strong)NSMutableDictionary *sectionTitleDic;
@property(nonatomic, strong)NSMutableArray *productCellArray;//产品列表
@property(nonatomic, copy)NSString *tempOrderNumber;
@end

@implementation OrderExtendEditViewController

- (NSString*)tempOrderNumber{
    if (nil == _tempOrderNumber) {
        _tempOrderNumber = [Util genrateUniqueStringCode];
    }
    return _tempOrderNumber;
}

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
    }
    return _tableView;
}

- (void)setOrderDetails:(OrderContentDetails *)orderDetails
{
    if (_orderDetails != orderDetails) {
        _orderDetails = orderDetails;
        [self parserAddressInfoFromOrderDetails:self.orderDetails];
    }
}

- (CheckItemModel*)getAddressModelByName:(NSString*)addr from:(NSArray*)configItemArray
{
    ReturnIf([Util isEmptyString:addr] || configItemArray.count <= 0)nil;

    for (ConfigItemInfo *cfgItem in configItemArray) {
        if ([cfgItem.value isEqualToString:addr]) {
            CheckItemModel *model = [CheckItemModel modelWithValue:addr forKey:cfgItem.code];
            model.extData = cfgItem.code;
            return model;
        }
    }
    return nil;
}

- (CheckItemModel*)getAddressModelById:(NSString*)addrId from:(NSArray*)configItemArray
{
    ReturnIf([Util isEmptyString:addrId] || configItemArray.count <= 0)nil;
    
    for (ConfigItemInfo *cfgItem in configItemArray) {
        if ([cfgItem.code isEqualToString:addrId]) {
            CheckItemModel *model = [CheckItemModel modelWithValue:cfgItem.value forKey:cfgItem.code];
            model.extData = cfgItem.code;
            return model;
        }
    }
    return nil;
}

//get address items from order details
- (void)parserAddressInfoFromOrderDetails:(OrderContentDetails*)orderDetails
{
    CheckItemModel *provinceItemModel;
    CheckItemModel *cityItemModel;
    CheckItemModel *districtItemModel;
    CheckItemModel *streetItemModel;
    
    _selectedProvince = nil;
    _selectedCity = nil;
    _selectedDistrict = nil;
    _selectedStreet = nil;

    //get province id by name
    NSArray *provinces = [self.configInfoMgr provincesOfChina];
    provinceItemModel = [self getAddressModelByName:orderDetails.regiontxt from:provinces];
    _selectedProvince = provinceItemModel;
    ReturnIf(nil == provinceItemModel);

    //get city id by name
    NSArray *cityies = [self.configInfoMgr citiesOfProvince:(NSString*)provinceItemModel.extData];
    cityItemModel = [self getAddressModelByName:orderDetails.city1 from:cityies];
    _selectedCity = cityItemModel;
    ReturnIf(nil == cityItemModel);
    
    //get district by name
    NSArray *districts = [self.configInfoMgr districtsOfCity:(NSString*)cityItemModel.extData];
    districtItemModel = [self getAddressModelByName:orderDetails.city2 from:districts];
    _selectedDistrict = districtItemModel;
    ReturnIf(nil == districtItemModel);

    //get district
    if (![Util isEmptyString:orderDetails.streetCode]) {
        streetItemModel = [CheckItemModel modelWithValue:orderDetails.street forKey:orderDetails.streetCode];
        _selectedStreet = streetItemModel;
    }
}

//get address items from extend customer
- (void)parserAddressInfoFromExtendCustomer:(ExtendCustomerInfo*)customer
{
    CheckItemModel *provinceItemModel;
    CheckItemModel *cityItemModel;
    CheckItemModel *districtItemModel;
    CheckItemModel *streetItemModel;
    
    _selectedProvince = nil;
    _selectedCity = nil;
    _selectedDistrict = nil;
    _selectedStreet = nil;

    //get province id by id
    NSArray *provinces = [self.configInfoMgr provincesOfChina];
    provinceItemModel = [self getAddressModelById:customer.province from:provinces];
    _selectedProvince = provinceItemModel;
    ReturnIf(nil == provinceItemModel);

    //get city id by id
    NSArray *cityies = [self.configInfoMgr citiesOfProvince:(NSString*)provinceItemModel.extData];
    cityItemModel = [self getAddressModelById:customer.city from:cityies];
    _selectedCity = cityItemModel;
    ReturnIf(nil == cityItemModel);
    
    //get district by id
    NSArray *districts = [self.configInfoMgr districtsOfCity:(NSString*)cityItemModel.extData];
    districtItemModel = [self getAddressModelById:customer.town from:districts];
    _selectedDistrict = districtItemModel;
    ReturnIf(nil == districtItemModel);
    
    //get district
    if (![Util isEmptyString:customer.street]) {
        streetItemModel = [CheckItemModel modelWithValue:customer.streetValue forKey:customer.street];
        _selectedStreet = streetItemModel;
    }
}

- (void)setExtendOrder:(ExtendServiceOrderContent *)extendOrder
{
    if (_extendOrder != extendOrder) {
        _extendOrder = extendOrder;
        if (extendOrder.productInfoList.count > 0) {
            ExtendProductContent *product = self.extendOrder.productInfoList[0];
            [self resetLocalPropertiesByProduct:product];
        }
        [self parserAddressInfoFromExtendCustomer:extendOrder.customerInfo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = getExtendServiceTypeById(self.extendServiceType);

    if ([self alertUpdateMainConfigInfoIfNeed]) {
        return;
    }
    [self setNavBarRightButton:@"提交" clicked:@selector(commitExtendBillButtonClicked:)];

    //make cell views
    [self makeCustomCells];

    //set data to cell views
    [self setDataToViews];

    //layout cell views and show them
    self.cellArray = [self groupTableViewCells];
    [self setTableViewCellCommonProperties];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kTableViewLeftPadding, 0, kTableViewLeftPadding));
    }];
}

#pragma mark - Make Cells

- (void)makeCustomCells
{
    NSArray *itemArray;
    NSString *contractNoPlaceHolder = @"请输入合同号";
    NSArray *extendYearsArray;

    //用户信息
    _nameCell = [MiscHelper makeTextFieldCell:@"请输入用户姓名"];
    _addressCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _addressCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _addressCell.textLabel.text = @"请选择省市县";
    [_addressCell addLineTo:kFrameLocationBottom];

    _streetCheckCell = [MiscHelper makeCommonSelectCell:@"请选择街道"];
    _streetCheckCell.detailTextLabel.text = nil;
    [_streetCheckCell addLineTo:kFrameLocationBottom];

    _detailAddressCell = [MiscHelper makeTextFieldCell:@"详细地址（栋,单元,号）"];
    [_detailAddressCell addLineTo:kFrameLocationBottom];
    _telEditCell = [MiscHelper makeTextFieldCell:@"请输入联系方式1"];
    _telEditCell.textField.keyboardType = UIKeyboardTypePhonePad;

    _tel2EditCell = [MiscHelper makeTextFieldCell:@"请输入联系方式2(选填)"];
    _tel2EditCell.textField.keyboardType = UIKeyboardTypePhonePad;

    //产品信息
    if (kExtendServiceTypeSingle == self.extendServiceType) {
        itemArray = [self.configInfoMgr extendServiceBrands];
        itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
        _brandSelCell = [MiscHelper makeSelectItemCell:@"品牌" checkItems:itemArray checkedItem: nil];
        _brandSelCell.delegate = self;
        _brandEditCell = [MiscHelper makeTextFieldCell:@"请输入品牌"];

        //单延保只支持彩电
        itemArray = [self.configInfoMgr subProductsOfTV];
        itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
        _categroyCell = [MiscHelper makeSelectItemCell:@"品类" checkItems:nil checkedItem: nil];
        _categroyCell.delegate = self;
        _categroyCell.checkItems = itemArray;

        _machineModelSelCell = [MiscHelper makeCommonSelectCell:@"机型"];
        [_machineModelSelCell addLineTo:kFrameLocationBottom];

        _machineModelEditCell = [MiscHelper makeTextFieldCell:@"请输入机型"];

        _machineCodeCell = [MiscHelper makeLeftEditRightBarCodeBtnCell:self action:@selector(machineCodeButtonClicked:)];
        [_machineCodeCell addLineTo:kFrameLocationBottom];

        _purchaseDateCell = [[WZDateSelectCell alloc]initWithDate:nil baseViewController:self];
        _purchaseDateCell.textLabel.text = @"购买日期";
        [_purchaseDateCell addLineTo:kFrameLocationBottom];

        _machinePriceCell = [MiscHelper makeTextFieldCell:@"购机价格, 单位:元"];
        _machinePriceCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        _purchaseShop = [MiscHelper makeTextFieldCell:@"购机门店"];
        contractNoPlaceHolder = @"书面合同号（K + 11位数字）";
        
        extendYearsArray = [self.configInfoMgr warrantyYearItems];
    }else {
        self.productCellArray = [[NSMutableArray alloc]init];
        contractNoPlaceHolder = @"书面合同号（KAL + 9位数字）";

        extendYearsArray = [self.configInfoMgr mutiWarrantyYearItems];
    }

    //延保信息
    itemArray = [self.configInfoMgr transactionReasonsOfProduct:self.categroyCell.checkedItem.key];
    itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
    _tradeReasonCell = [MiscHelper makeSelectItemCell:@"成交原因" checkItems: itemArray checkedItem: nil];
    _contractNoCell = [MiscHelper makeTextFieldCell:contractNoPlaceHolder];
    _signDateCell = [[WZDateSelectCell alloc]initWithDate:nil baseViewController:self];
    _signDateCell.date = [NSDate date];
    _signDateCell.textLabel.text = @"签字日期";

    [_signDateCell addLineTo:kFrameLocationBottom];

    _extendTimeCell = [MiscHelper makeSelectItemCell:@"延保时间" checkItems: extendYearsArray checkedItem: nil];

    _contractNote = [[WZTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 2*kTableViewLeftPadding, kPerformOrderViewCellLineHeight*3) maxWords:300];
    _contractNote.placeholder = @"合同备注（选填）";
    _contractNoteCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [_contractNoteCell.contentView addSubview:_contractNote];
    [_contractNoteCell clearBackgroundColor];
    [_contractNoteCell.contentView clearBackgroundColor];
    itemArray = [self.configInfoMgr priceRangesOfProduct:nil];
    itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
    _machinePriceRangeCell = [MiscHelper makeSelectItemCell:@"价格区间" checkItems: itemArray checkedItem: nil];
    
    _contractTypeSegment = [[UISegmentedControl alloc]initWithItems:@[@"纸质合同",@"电子合同"]];
    [_contractTypeSegment addTarget:self action:@selector(contractTypeSegmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    _contractTypeSegment.tintColor = kColorDefaultOrange;
    _contractTypeSegment.selectedSegmentIndex = 0;
}

- (ExtendCustomerInfo*)readCustomerInfoFromOrderDetails:(OrderContentDetails*)orderDetails
{
    ExtendCustomerInfo *customer = [[ExtendCustomerInfo alloc]init];

    customer.cusName = orderDetails.custname;
    customer.province = orderDetails.city1;
    customer.city = orderDetails.city2;
    customer.town = orderDetails.regiontxt;
    customer.street = orderDetails.street;
    customer.detailAddress = orderDetails.str_suppl1;
    
    //不带入电话
//    customer.cusTelNumber = orderDetails.telnumber;
    customer.cusTelNumber = nil;
    customer.cusMobNumber = nil;

    return customer;
}

- (NSString*)getExtendBrandIdByName:(NSString*)brandName
{
    ConfigItemInfo *brandItem;
    brandItem = [self.configInfoMgr findConfigItemInfoByType:MainConfigInfoTableType1001 value:brandName];
    return [Util defaultStr:@"QT" ifStrEmpty:brandItem.code];
}

- (ExtendProductContent*)readProductInfoFromOrderDetails:(OrderContentDetails*)orderDetails
{
    ExtendProductContent *product = [[ExtendProductContent alloc]init];

    product.zzfld000000 = [self getExtendBrandIdByName:orderDetails.zzfld000000];
    if ([product.zzfld000000 isEqualToString:@"QT"]) {
        product.zzfld000003v = orderDetails.zzfld000000;
    }
    product.zzfld000001 = orderDetails.categroyIdStr;//品类(机器类型)
    product.zzfld00000q = orderDetails.zzfld00000q;//机型
    product.zzfld00000b = orderDetails.machinemodel;//机号(主机/内机条码)

    if (![Util isEmptyString:self.orderDetails.buytime]) {
        NSDate *buyDate = [Util dateWithString:self.orderDetails.buytime format:WZDateStringFormat10];
        product.zzfld00002i = [NSString dateStringWithDate:buyDate strFormat:WZDateStringFormat5];
    }
    product.zzfld00000e = orderDetails.zzfld00000e; //门店名称
    
    return product;
}

- (void)resetLocalPropertiesByProduct:(ExtendProductContent*)product
{
    //reset local properties
    _isBrandOther = [product.zzfld000000 isEqualToString:@"QT"];
    _isTv = [product.zzfld000001 isEqualToString:@"Z01"];
    _isAirConditioning = [product.zzfld000001 isEqualToString:@"Z02"];
    _isBrandCHIQ = [product.zzfld000000 isEqualToString:@"CHIQ"];
    _isBrandCH = [product.zzfld000000 isEqualToString:@"CH"];
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

- (void)setCustomerInfoToViews:(ExtendCustomerInfo*)customer
{
    self.nameCell.textField.text = customer.cusName;
    self.telEditCell.textField.text = customer.cusTelNumber;
    self.tel2EditCell.textField.text = customer.cusMobNumber;

    //address
    [self setAddrInfoToAddressCell];

    //street
    self.streetCheckCell.textLabel.text = [Util defaultStr:@"请选择街道" ifStrEmpty:_selectedStreet.value];

    self.detailAddressCell.textField.text = customer.detailAddress;

    if (kExtendOrderEditModeAppend == self.extendOrderEditMode) {
        self.nameCell.textField.userInteractionEnabled = NO;
        self.nameCell.textField.textColor = [UIColor grayColor];
        self.telEditCell.textField.textColor = [UIColor grayColor];
    }
}

- (void)setOrderProductInfoToViews:(ExtendProductContent*)product
{
    [self resetLocalPropertiesByProduct:product];

    self.brandSelCell.checkedItemKey = product.zzfld000000;
    self.categroyCell.checkedItemKey = product.zzfld000001;
    self.brandEditCell.textField.text = product.zzfld000003v;
    self.machineModelSelCell.detailTextLabel.text = [MiscHelper extendProductModelName:product];
    self.machineModelEditCell.textField.text = [MiscHelper extendProductModelName:product];

    self.machineCodeCell.textField.text = product.zzfld00000b;
    self.purchaseDateCell.date = [Util dateWithString:product.zzfld00002i format:WZDateStringFormat5];
    self.machinePriceCell.textField.text = product.buyprice;
    self.machinePriceRangeCell.checkedItemKey = product.pricerange;
    self.purchaseShop.textField.text = product.zzfld00000e;
}

- (void)setExtendContractInfoToViews:(ExtendServiceOrderContent*)extendOrder
{
    CheckItemModel *checkedItem;

    self.contractTypeSegment.selectedSegmentIndex = (1 == [extendOrder.econtract integerValue]) ? 1 : 0;
    self.contractTypeSegment.enabled = NO;

    self.contractNoCell.textField.text = extendOrder.contractNum;

    checkedItem = [Util findItem:extendOrder.reason FromCheckItemModelArray:self.tradeReasonCell.checkItems];
    self.tradeReasonCell.checkedItem = checkedItem;

    checkedItem = [Util findItem:extendOrder.extendLife FromCheckItemModelArray:self.extendTimeCell.checkItems];
    self.extendTimeCell.checkedItem = checkedItem;
    
    self.contractNote.text = extendOrder.Description;

    [self setDateValue:extendOrder.signDate toDateCell:self.signDateCell];
}

- (void)setDateValue:(NSObject*)dateValue toDateCell:(WZDateSelectCell*)dateCell
{
    NSDate *date;
    
    if ([dateValue isKindOfClass:[NSNumber class]]) {
        NSTimeInterval timeInt = [(NSNumber*)dateValue doubleValue];
        date = [NSDate dateWithTimeIntervalSince1970:timeInt/1000];
    }else if ([dateValue isKindOfClass:[NSString class]]){
        date = [Util dateWithString:(NSString*)dateValue format:WZDateStringFormat5];
    }
    dateCell.date = date;
}

- (void)setDataToViews
{
    switch (self.extendOrderEditMode) {
        case kExtendOrderEditModeAppend:
        {
            //customer
            ExtendCustomerInfo *customer = [self readCustomerInfoFromOrderDetails:self.orderDetails];
            [self setCustomerInfoToViews:customer];

            if (self.orderDetails.isTV) {
                //product
                ExtendProductContent *productContent = [self readProductInfoFromOrderDetails:self.orderDetails];
                [self setOrderProductInfoToViews:productContent];
            }

        }
            break;
        case kExtendOrderEditModeEdit:
        {
            //customer
            [self setCustomerInfoToViews:self.extendOrder.customerInfo];

            //product
            if (kExtendServiceTypeSingle ==  self.extendServiceType) {
                if (self.extendOrder.productInfoList.count > 0) {
                    [self setOrderProductInfoToViews:self.extendOrder.productInfoList[0]];
                }
            }else {
                for (ExtendProductContent *product in self.extendOrder.productInfoList) {
                    [self addNewExtendProductEditCellToTail:product];
                }
            }
            
            //extend info
            [self setExtendContractInfoToViews:self.extendOrder];
        }
            break;
        case kExtendOrderEditModeNew:
        default:
            break;
    }
}

- (UIView*)makeHeaderViewWithSubLabel:(UILabel*)subLabel
{
    UIView *headerView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), kPerformOrderViewCellLineHeight)];
    [headerView clearBackgroundColor];
    UIView *bgView = [[UIView alloc]initWithFrame:headerView.bounds];
    [headerView addSubview:bgView];
    bgView.backgroundColor = kColorDefaultBackGround;

    subLabel.font = SystemFont(16);
    subLabel.textColor = kColorDarkGray;
    [headerView addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView);
        make.right.equalTo(headerView);
        make.bottom.equalTo(headerView).with.offset(-kDefaultSpaceUnit);
    }];
    
    return headerView;
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

#pragma mark - Layout Cells

- (NSMutableArray*)groupTableViewCells
{
    NSMutableArray *sectionArray = [NSMutableArray new];
    NSMutableArray *rowArray;
    NSString *sectionTitle;

    _sectionTitleDic = [NSMutableDictionary new];

    //section
    sectionTitle = @"用户信息";
    rowArray = [NSMutableArray new];
    [rowArray addObject:self.nameCell];
    [rowArray addObject:self.telEditCell];
    [rowArray addObject:self.tel2EditCell];
    [rowArray addObject:self.addressCell];
    [rowArray addObject:self.streetCheckCell];
    [rowArray addObject:self.detailAddressCell];

    [sectionArray addObject:rowArray];
    [_sectionTitleDic setObj:sectionTitle forKey:rowArray];

    //section
    sectionTitle = @"产品信息";
    rowArray = [NSMutableArray new];
    if (kExtendServiceTypeSingle == self.extendServiceType) {
        [rowArray addObject:self.brandSelCell];

        if (!_isBrandOther) {
            [rowArray addObject:self.categroyCell];
            [rowArray addObject:self.machineModelSelCell];
        }else {
            [rowArray addObject:self.brandEditCell];
            [rowArray addObject:self.categroyCell];
            [rowArray addObject:self.machineModelEditCell];
        }

        [rowArray addObject:self.machineCodeCell];
        [_sectionTitleDic setObj:sectionTitle forKey:rowArray];

        [rowArray addObject:self.purchaseDateCell];
        [rowArray addObject:self.machinePriceCell];
        [rowArray addObject:self.machinePriceRangeCell];
        [rowArray addObject:self.purchaseShop];
    }else {
        [rowArray addObjectsFromArray:self.productCellArray];
    }
    [sectionArray addObject:rowArray];
    [_sectionTitleDic setObj:sectionTitle forKey:rowArray];

    //session 延保合同信息
    sectionTitle = @"延保信息";
    rowArray = [NSMutableArray new];
    if (0 == self.contractTypeSegment.selectedSegmentIndex) {
        [rowArray addObject:self.contractNoCell];
    }
    [rowArray addObject:self.tradeReasonCell];
    [rowArray addObject:self.signDateCell];
    [rowArray addObject:self.extendTimeCell];
    [rowArray addObject:self.contractNoteCell];
    [sectionArray addObject:rowArray];
    [_sectionTitleDic setObj:sectionTitle forKey:rowArray];

    return sectionArray;
}

#pragma mark - TableView Delegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    [tableView didRequestTableViewListDatasWithCount:1 totalCount:1 page:pageInfo response:nil error:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *sectionArray = self.cellArray[section];
    NSString *sectionTitle = [_sectionTitleDic objForKey:sectionArray];
    
    return ([Util isEmptyString:sectionTitle]) ? kDefaultSpaceUnit : kButtonLargeHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *sectionArray = self.cellArray[section];
    NSString *sectionTitle = [_sectionTitleDic objForKey:sectionArray];
    
    UILabel *headerLabel = [[UILabel alloc]init];
    UIView *headerView = [self makeHeaderViewWithSubLabel:headerLabel];
    headerLabel.text = sectionTitle;
    NSInteger viewTag;

    //在产品信息右边添加【添加产品】按钮
    if (kExtendServiceTypeMutiple == self.extendServiceType
        && [headerLabel.text isEqualToString:@"产品信息"]) {
        viewTag = 0x28397;
        if (![headerView viewWithTag:viewTag]) {
            UIButton *addProduct = [UIButton transparentTextButton:@"添加产品"];
            [addProduct setTitleColor:kColorDefaultOrange forState:UIControlStateNormal];
            [addProduct addTarget:self action:@selector(addProductButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            addProduct.tag = viewTag;
            [headerView addSubview:addProduct];
            
            [addProduct mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerLabel);
                make.right.equalTo(headerView).with.offset(-kTableViewLeftPadding);
            }];
            headerView.userInteractionEnabled = YES;
        }
        headerLabel.text = [NSString stringWithFormat:@"产品信息 ( %@ 台 )", @(self.productCellArray.count)];
    }else if ([headerLabel.text isEqualToString:@"延保信息"]){
        if (![[self.contractTypeSegment superview] isEqual:headerView])
        {
            [headerView addSubview:self.contractTypeSegment];
            [self.contractTypeSegment mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerLabel);
                make.right.equalTo(headerView).with.offset(-kTableViewLeftPadding);
            }];
            headerView.userInteractionEnabled = YES;
        }
    }
    return headerView;
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
    CGFloat cellHeight = kPerformOrderViewCellLineHeight;

    if (cell == self.contractNoteCell){
        return  CGRectGetHeight(self.contractNote.frame) + kDefaultSpaceUnit;
    }else if ([cell isKindOfClass:[ExtendServiceProductCell class]]){
        cellHeight = [cell fitHeight];
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
    if (cell == self.addressCell){
        [self popupAddressSelectPicker];
    }else if (cell == self.streetCheckCell){
        [self requestStreetInfos];
    }else if ([cell isKindOfClass:[ExtendServiceProductCell class]]){
        ExtendServiceProductCell *editProductCell = (ExtendServiceProductCell*)cell;
        ExtendProductEditViewController *editVc = [[ExtendProductEditViewController alloc]init];
        editVc.title = @"编辑延保产品";
        editVc.product = editProductCell.product;
        __weak ExtendProductEditViewController *weakEditVc = editVc;
        editVc.editFinishedBlock = ^(id obj){
            //update edited product cell
            editProductCell.product = (ExtendProductContent*)obj;
            [tableView reloadTableViewCell:editProductCell];
            [weakEditVc popViewController];
        };
        [self pushViewController:editVc];
    }else if (cell == self.machineModelSelCell){
        ProductModelSearchViewController *modelSearchVc = [[ProductModelSearchViewController alloc]init];
        modelSearchVc.modelSelectedBlock = ^(ViewController* viewController, ProductModelDes *model){
            _machineModelItem = model;
            self.machineModelSelCell.detailTextLabel.text = _machineModelItem.product_id;
            [viewController popViewController];
        };
        [self pushViewController:modelSearchVc];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.cellArray[indexPath.section][indexPath.row];
    if ([cell isKindOfClass:[ExtendServiceProductCell class]]){
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.cellArray[indexPath.section][indexPath.row];
    if ([cell isKindOfClass:[ExtendServiceProductCell class]]){
        return UITableViewCellEditingStyleDelete;
    }else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.cellArray[indexPath.section][indexPath.row];

    //delete
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        if ([cell isKindOfClass:[ExtendServiceProductCell class]]){
            [self removeExtendProductEditCell:indexPath.row];
            [self reloadTableView];
        }
    }
}

- (ExtendServiceProductCell*)makeExtendServiceProductCell
{
    ExtendServiceProductCell *cell = [[ExtendServiceProductCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [cell addLineTo:kFrameLocationBottom];
    return cell;
}

- (void)addNewExtendProductEditCellToTail:(ExtendProductContent*)product
{
    ExtendServiceProductCell *newCell = [self makeExtendServiceProductCell];
    newCell.product = product;
    [self.productCellArray addObject:newCell];
}

- (void)isChanghongProductSegmentChanged:(UISegmentedControl*)segment
{
    [self reloadTableView];
}

- (void)contractTypeSegmentValueChanged:(UISegmentedControl*)segment
{
    [self reloadTableView];
}

- (void)commitExtendBillButtonClicked:(UIButton*)button
{
    NSObject *input = [self readExtendServiceBill];
    NSString *invalidDataStr = [self checkExtendOrderBill:input];
    if (nil == invalidDataStr) {
        [self commitExtendServiceOrder:input];
    }else {
        [Util showToast:invalidDataStr];
    }
}

- (NSObject*)readExtendServiceBill
{
    NSObject *extendBill;
    if (kExtendServiceTypeSingle == self.extendServiceType) {
        extendBill = [self readSingleExtendServiceBill];
    }else if (kExtendServiceTypeMutiple == self.extendServiceType){
        extendBill = [self readMutiExtendServiceBill];
    }
    return extendBill;
}

#pragma mark - Read User Bill Data

- (SingleExtendOrderEditInputParams *)readSingleExtendServiceBill
{
    SingleExtendOrderEditInputParams *input = [SingleExtendOrderEditInputParams new];
    
    //customer and contract info
    input.extendprdId = [self.extendOrder.Id description];//延保id
    input.customerId = [self.extendOrder.customerInfo.Id description];//	客户id
    input.userId = self.user.userId;//	维修工userid
    input.serverId = self.user.serverId;
    input.reason = self.tradeReasonCell.checkedItem.key;//	成交原因（代码）
    input.contractNum = [self.contractNoCell.textField.text uppercaseString];//	合同号
    input.signDate = [NSString dateStringWithDate:self.signDateCell.date strFormat:WZDateStringFormat5];//	签字日期yyyy-MM-dd
    input.extendLife = self.extendTimeCell.checkedItem.key;
    input.zzfld00000e = self.purchaseShop.textField.text;//购机门店
    input.priceRange = self.machinePriceRangeCell.checkedItem.key ;//	价格区间
    input.Description = self.contractNote.text;//	合同描述
    input.objectId = self.orderDetails.object_id;//	工单号
    input.sysContractNum = self.extendOrder.sysContractNum;//	订单号
    input.cusName = self.nameCell.textField.text;//	客户姓名
    input.cusTelNumber = self.telEditCell.textField.text;//	tel 1
    input.cusMobNumber = self.tel2EditCell.textField.text;//tel 2
    input.province = _selectedProvince.key;
    input.city = _selectedCity.key;
    input.town =  _selectedDistrict.key;
    input.street = _selectedStreet.key;
    input.detailAddress = self.detailAddressCell.textField.text;//	详细地址
    input.type = [NSString intStr:self.extendServiceType];
    
    //product info
    input.zzfld000000 = self.brandSelCell.checkedItem.key;//品牌
    input.zzfld000003v = self.brandEditCell.textField.text;//其它品牌
    input.zzfld000001 = self.categroyCell.checkedItem.key;//品类
    if (_isBrandOther) {
        input.zzfld00000q = self.machineModelEditCell.textField.text;
    }else {
        input.zzfld00000q = _machineModelItem.product_id;//机型
    }
    input.zzfld00002i = [NSString dateStringWithDate:self.purchaseDateCell.date strFormat:WZDateStringFormat5];//购买日期
    input.zzfld00000b = [self.machineCodeCell.textField.text uppercaseString];//机号(主机/内机条码)
    input.buyprice = self.machinePriceCell.textField.text;//购机价格
    input.factoryWarrantyDue = nil;//厂保到期日期
    input.status = self.extendOrder.status;

    if (kExtendOrderEditModeEdit == self.extendOrderEditMode) {
        input.econtract = [NSString stringWithFormat:@"%@",self.extendOrder.econtract];
        input.tempNum = self.extendOrder.tempNum;
        input.contractNum = self.extendOrder.contractNum;
    }else {
        BOOL isEContract = (1 == self.contractTypeSegment.selectedSegmentIndex);
        input.econtract = isEContract ? @"1" : @"0";
        input.tempNum = self.tempOrderNumber;
        input.contractNum = isEContract ? nil : input.contractNum;
    }
    return input;
}

- (MutiExtendOrderEditInputParams *)readMutiExtendServiceBill
{
    MutiExtendOrderEditInputParams *input = [MutiExtendOrderEditInputParams new];
    
    //customer and contract info
    input.extendprdId = [self.extendOrder.Id description];//延保id
    input.customerId = [self.extendOrder.customerInfo.Id description];//	客户id
    input.userId = self.user.userId;//	维修工userid
    input.serverId = self.user.serverId;
    input.reason = self.tradeReasonCell.checkedItem.key;//	成交原因（代码）
    input.contractNum = [self.contractNoCell.textField.text uppercaseString];//	合同号
    input.signDate = [NSString dateStringWithDate:self.signDateCell.date strFormat:WZDateStringFormat5];//	签字日期yyyy-MM-dd
    input.extendLife = self.extendTimeCell.checkedItem.key;
    input.Description = self.contractNote.text;//	合同描述
    input.objectId = self.orderDetails.object_id;//	工单号
    input.sysContractNum = self.extendOrder.sysContractNum;//	订单号
    input.cusName = self.nameCell.textField.text;//	客户姓名
    input.cusTelNumber = self.telEditCell.textField.text;//	tel 1
    input.cusMobNumber = self.tel2EditCell.textField.text;//tel 2
    input.province = _selectedProvince.key;
    input.city = _selectedCity.key;
    input.town =  _selectedDistrict.key;
    input.street = _selectedStreet.key;
    input.detailAddress = self.detailAddressCell.textField.text;
    input.type = [NSString intStr:self.extendServiceType];

    //product info
    NSMutableArray *products = [NSMutableArray new];
    for (ExtendServiceProductCell *cell in self.productCellArray) {
        if (cell.product) {
            [products addObject:[NSDictionary dictionaryFromPropertyObject:cell.product]];
        }
    }
    input.productCount = [NSString intStr:products.count];
    input.productInfos = [NSString jsonStringWithArray:products];
    input.status = self.extendOrder.status;

    if (kExtendOrderEditModeEdit == self.extendOrderEditMode) {
        input.econtract = [NSString stringWithFormat:@"%@",self.extendOrder.econtract];
        input.tempNum = self.extendOrder.tempNum;
        input.contractNum = self.extendOrder.contractNum;
    }else {
        BOOL isEContract = (1 == self.contractTypeSegment.selectedSegmentIndex);
        input.econtract = isEContract ? @"1" : @"0";
        input.tempNum = self.tempOrderNumber;
        input.contractNum = isEContract ? nil : input.contractNum;
    }

    return input;
}

#pragma mark - Check User Bill Data

- (NSString*)checkExtendOrderBill:(NSObject*)input
{
    NSString *invalidStr;
    
    if (kExtendServiceTypeSingle == self.extendServiceType) {
        invalidStr = [self checkSingleExtendServiceBill:(SingleExtendOrderEditInputParams*)input];
    }else if (kExtendServiceTypeMutiple == self.extendServiceType){
        invalidStr = [self checkMutiExtendServiceBill:(MutiExtendOrderEditInputParams*)input];
    }
    return invalidStr;
}

- (NSString*)checkSingleExtendServiceBill:(SingleExtendOrderEditInputParams*)input
{
    NSDate *date;
    BOOL isEContract = [input.econtract isEqualToString:@"1"];

    do {
        ReturnIf([Util isEmptyString:input.cusName])@"请输入客户姓名";
        ReturnIf([Util isEmptyString:input.cusTelNumber])@"请输入客户电话";
        ReturnIf(input.cusTelNumber.length > 30)@"客户电话最多30个字符";

        if (![Util isEmptyString:input.cusMobNumber]) {
            ReturnIf(input.cusMobNumber.length > 30)@"客户电话最多30个字符";
        }
        ReturnIf([Util isEmptyString:input.province])@"请填写地址";
        ReturnIf([Util isEmptyString:input.detailAddress])@"请输入详细地址";
        ReturnIf(input.detailAddress.length > 80)@"地址输入最多80个字符";

        if (!isEContract) {
            ReturnIf([Util isEmptyString:input.contractNum])@"请填写合同号";
            ReturnIf(![MiscHelper isValidExtendOrderContractNo:input.contractNum])@"合同号格式错误";
            ReturnIf(input.contractNum.length > 35)@"合同号输入最多35个字符";
        }

        ReturnIf([Util isEmptyString:input.reason])@"请填写成交原因";
        ReturnIf([Util isEmptyString:input.signDate])@"请选择签字日期";
        date = [Util dateWithString:input.signDate format:WZDateStringFormat5];
        if ([date isLaterThanDate:[NSDate date]]) {
            return @"签字日期不能晚于当前日期";
        }

        ReturnIf([Util isEmptyString:input.extendLife])@"请填写延保年限";
        ReturnIf([Util isEmptyString:input.zzfld00000e])@"请填写购机门店";
        ReturnIf(input.zzfld00000e.length > 50)@"购机门店最多50个字符";
        ReturnIf([Util isEmptyString:input.priceRange])@"请选择价格区间";
        ReturnIf(![Util isEmptyString:input.Description]
                 && input.Description.length > 100)@"合同描述最多100个字符";
        ReturnIf([Util isEmptyString:input.zzfld000000])@"请选择品牌";
        if(_isBrandOther){
            ReturnIf([Util isEmptyString:input.zzfld000003v])@"请填写品牌";
            ReturnIf(input.zzfld000003v.length > 20)@"品牌输入最多20个字符";
            ReturnIf(input.zzfld00000q.length > 40)@"机型输入最多40个字符";
        }
        ReturnIf([Util isEmptyString:input.zzfld000001])@"请选择品类";
        if((_isBrandCH || _isBrandCHIQ) && _isTv){
            ReturnIf([Util isEmptyString:input.zzfld00000q])@"请填写机型";
        }
        ReturnIf([Util isEmptyString:input.zzfld00002i])@"请填写购买日期";
        date = [Util dateWithString:input.zzfld00002i format:WZDateStringFormat5];
        if ([date isLaterThanDate:[NSDate date]]) {
            return @"购买日期不能晚于当前日期";
        }

        ReturnIf([Util isEmptyString:input.zzfld00000b])@"请填写机号";
        NSString *invalidStr = [self isValidMachineCode:input.zzfld00000b];
        ReturnIf(![Util isEmptyString:invalidStr])invalidStr;
        ReturnIf([Util isEmptyString:input.buyprice])@"请填写购机价格";
        ReturnIf(![input.buyprice isPureFloat]&&![input.buyprice isPureInt])@"请填写正确的购机价格";
    } while (NO);
    return nil;
}

- (NSString*)checkMutiExtendServiceBill:(MutiExtendOrderEditInputParams*)input
{
    BOOL isEContract = [input.econtract isEqualToString:@"1"];

    do {
        ReturnIf([Util isEmptyString:input.cusName])@"请输入客户姓名";
        ReturnIf([Util isEmptyString:input.cusTelNumber])@"请输入客户电话";
        ReturnIf(input.cusTelNumber.length > 30)@"客户电话最多30个字符";

        if (![Util isEmptyString:input.cusMobNumber]) {
            ReturnIf(input.cusMobNumber.length > 30)@"客户电话最多30个字符";
        }

        ReturnIf([Util isEmptyString:input.province])@"请填写地址";//	省
        ReturnIf([Util isEmptyString:input.detailAddress])@"请输入详细地址";
        ReturnIf(input.detailAddress.length > 80)@"地址输入最多80个字符";

        if (!isEContract) {
            ReturnIf([Util isEmptyString:input.contractNum])@"请填写合同号";
            ReturnIf(input.contractNum.length > 35)@"合同号输入最多35个字符";
            ReturnIf(![MiscHelper isValidMutiExtendOrderContractNo:input.contractNum])@"合同号格式错误";
        }
        ReturnIf([Util isEmptyString:input.reason])@"请填写成交原因";
        ReturnIf([Util isEmptyString:input.signDate])@"请选择签字日期";
        ReturnIf([Util isEmptyString:input.extendLife])@"请填写延保年限";
        ReturnIf(![Util isEmptyString:input.Description]
                 && input.Description.length > 100)@"合同描述最多100个字符";
        ReturnIf([Util isEmptyString:input.productInfos])@"请添加产品";
        ReturnIf([input.productCount integerValue]<2)@"至少添加2件产品";
        ReturnIf([input.productCount integerValue]>8)@"最多添加8件产品";
    } while (NO);
    return nil;
}

// 检查机号格式
- (NSString*)isValidMachineCode:(NSString*)machineModel
{
    NSString *invalidInfo;
    
    do {
        BreakIf(!_isBrandCH && !_isBrandCHIQ);

        if (_isAirConditioning) {
            invalidInfo = [MiscHelper isValidChangHongAirConditionCode:machineModel];
            BreakIf(![Util isEmptyString:invalidInfo]);
        }else if(_isTv){
            invalidInfo = [MiscHelper isValidChangHongTelevitionCode:machineModel machineModel:_categroyId];
            BreakIf(![Util isEmptyString:invalidInfo]);
        }
    } while (NO);
    return invalidInfo;
}

#pragma mark - Event Handle

- (void)machineCodeButtonClicked:(UIButton*)sender
{
    _scanMoachineCodeBarVc = [ScanGraphicCodeViewController fastScanWithComplete:^(NSString *codeText) {
        self.machineCodeCell.textField.text = [codeText copy];
    } fromViewController:self];
}

- (void)addProductButtonClicked:(UIButton*)sender
{
    if (self.productCellArray.count >= 8) {
        [Util showToast:@"最多添加8件延保产品"];
    }else {
        ExtendProductEditViewController *editVc = [[ExtendProductEditViewController alloc]init];
        editVc.title = @"添加延保产品";
        __weak ExtendProductEditViewController *weakEditVc = editVc;
        editVc.editFinishedBlock = ^(id obj){
            [self addNewExtendProductEditCellToTail:(ExtendProductContent*)obj];
            [self reloadTableView];
            [weakEditVc popViewController];
        };
        [self pushViewController:editVc];
    }
}

- (void)removeExtendProductEditCell:(NSInteger)index
{
    if (self.productCellArray.count > index) {
        [self.productCellArray removeObjectAtIndex:index];
    }
}

- (void)pushToCheckListVcToSelectStreet
{
    [MiscHelper pushToCheckListViewController:self.addressCell.textLabel.text checkItems:_streets checkedItem:_selectedStreet from:self delegate:self];
}

- (void)requestStreetInfos
{
    if ([Util isEmptyString:_selectedProvince.key]
        ||[Util isEmptyString:_selectedCity.key]
        ||[Util isEmptyString:_selectedDistrict.key]) {
        [Util showToast:@"请先选择用户所在的省市县"];
        return;
    }

    StreetListInputParams *input = [StreetListInputParams new];
    input.regiontxt = _selectedProvince.key;
    input.city1 = _selectedCity.key;
    input.city2 = _selectedDistrict.key;

    [Util showWaitingDialog];
    [self.httpClient getStreetsOfDistrict:_selectedDistrict.key response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            _streets = [MiscHelper parserStreetItems:responseData.resultData];
            [self pushToCheckListVcToSelectStreet];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)commitExtendServiceOrder:(NSObject*)input
{
    [Util showWaitingDialog];
    
    BOOL isEContract = (1 == self.contractTypeSegment.selectedSegmentIndex);

    RequestCallBackBlock commitResponseBlock = ^(NSError *error, HttpResponseData* responseData){
        [Util dismissWaitingDialog];
        if (!error) {
            if (isEContract) {
                switch (responseData.resultCode) {
                    case kHttpReturnCodeSuccess:
                        [self postNotification:NotificationExtendOrderChanged];
                        [self pushToExtendReceiveAccountQrCodeController];
                        break;
                    case kHttpReturnCodeSyncWeixinError:
                    case kHttpReturnCodeRequestWeixinError:
                        [Util showToast:responseData.resultInfo];
                        [self postNotification:NotificationExtendOrderChanged];
                        break;
                    case kHttpReturnCodePaymentSuccess:
                        [self postNotification:NotificationExtendOrderChanged];
                        [self pushToWeixinPaymentResultViewController];
                        break;
                    default:
                        [Util showErrorToastIfError:responseData otherError:error];
                        break;
                }
            }else {
                switch (responseData.resultCode) {
                    case kHttpReturnCodeSuccess:
                        [Util showToast:@"提交成功"];
                        [self postNotification:NotificationExtendOrderChanged];
                        [self popToTopListViewController];
                        break;
                    default:
                        [Util showErrorToastIfError:responseData otherError:error];
                        break;
                }
            }
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    };

    if (kExtendServiceTypeSingle == self.extendServiceType) {
        [self.httpClient editSingleExtendServiceOrder:(SingleExtendOrderEditInputParams*)input response:commitResponseBlock];
    }else if (kExtendServiceTypeMutiple == self.extendServiceType){
        [self.httpClient editMutiExtendServiceOrder:(MutiExtendOrderEditInputParams*)input response:commitResponseBlock];
    }
}

- (void)pushToWeixinPaymentResultViewController
{
    ExtendReceiveAccountStatusController *vc = [[ExtendReceiveAccountStatusController alloc]init];
    vc.title = @"延保收款";
    vc.statusImageView.image = ImageNamed(@"circle_green_success");
    vc.statusLabelView.text = @"您已收款成功，请关闭本页面。";
    [self pushViewController:vc];
}

- (void)popToTopListViewController
{
    [MiscHelper popToLatestListViewController:self];
}

- (void)pushToExtendReceiveAccountQrCodeController
{
    NSString *orderTempNo = [Util isEmptyString:self.extendOrder.tempNum] ? self.tempOrderNumber : self.extendOrder.tempNum;

    ExtendReceiveAccountQrCodeController *vc = [[ExtendReceiveAccountQrCodeController alloc]init];
    vc.extendOrderTempNumber = orderTempNo;
    [self pushViewController:vc];
}

- (void)singleCheckViewController:(WZSingleCheckViewController *)viewController didChecked:(CheckItemModel *)checkedItem
{
    _selectedStreet = checkedItem;
    self.streetCheckCell.textLabel.text = _selectedStreet.value;
    [viewController popViewController];
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
        self.categroyCell.checkedItem = nil;
        
        //reset machine model datas
        _machineModelItem = nil;
        self.machineModelSelCell.detailTextLabel.text = @"请选择";
        self.machineModelEditCell.textField.text = nil;
    }else if (cell == self.categroyCell){
        NSString *productCode = (NSString*)self.categroyCell.checkedItem.extData;
        _isTv = [[self.configInfoMgr productCodeOfSubProduct:productCode] isEqualToString:@"TV0010"];

        //reset machine model datas
        _machineModelItem = nil;
        self.machineModelSelCell.detailTextLabel.text = @"请选择";
        self.machineModelEditCell.textField.text = nil;
    }
}

- (void)popupAddressSelectPicker
{
    _addressPicker = [[AddressPickerView alloc]init];
    _addressPicker.columns = 3; //省、市、省三列
    __weak OrderExtendEditViewController *weakSelf = self;
    _addressPicker.didSelectBlock = ^(id obj){
        _selectedProvince = _addressPicker.selectedProvince;
        _selectedCity = _addressPicker.selectedCity;
        _selectedDistrict = _addressPicker.selectedDistrict;
//        _selectedStreet = _addressPicker.selectedStreet;
        [weakSelf setAddrInfoToAddressCell];
        [[WZModal sharedInstance]hideAnimated:NO];
    };
    _addressPicker.didCancelBlock = ^(id obj){
        [[WZModal sharedInstance]hideAnimated:NO];
    };
    _addressPicker.selectedProvince = _selectedProvince;
    _addressPicker.selectedCity = _selectedCity;
    _addressPicker.selectedDistrict = _selectedDistrict;
//    _addressPicker.selectedStreet = _selectedStreet;

    [WZModal sharedInstance].showCloseButton = NO;
    [WZModal sharedInstance].onTapOutsideBlock = nil;
    [WZModal sharedInstance].contentViewLocation = WZModalContentViewLocationBottom;
    [[WZModal sharedInstance]showWithContentView:_addressPicker andAnimated:YES];
}

- (void)setAddrInfoToAddressCell
{
    NSString *province = [Util defaultStr:@"地址" ifStrEmpty:_selectedProvince.value];
    NSString *address = [NSString jointStringWithSeparator:@"" strings
                         : province
                         , _selectedCity.value
                         , _selectedDistrict.value
//                         , _selectedStreet.value
                         , nil];
    self.addressCell.textLabel.text = [Util defaultStr:@"请选择省市县" ifStrEmpty:address];
}

- (void)wzpickerDidCancelSelect:(WZPickerView *)wzpicker
{
}

- (void)wzpickerDidFinishSelect:(WZPickerView *)wzpicker
{
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@"
                         , _addressPicker.selectedProvince.value
                         , _addressPicker.selectedCity.value
                         , _addressPicker.selectedDistrict
                         , _addressPicker.selectedStreet];
    self.addressCell.textLabel.text = address;
}

@end
