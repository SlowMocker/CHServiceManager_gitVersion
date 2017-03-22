//
//  PerformOrderViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/9/14.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "PerformOrderViewController.h"
#import "ProductSelectCell.h"
#import "TextFieldTableViewCell.h"
#import "WZTextView.h"
#import "SpecialPerformViewController.h"
#import "MachineComponEditCell.h"
#import "ScanGraphicCodeViewController.h"
#import "WZSingleCheckListPopView.h"
#import "WZSingleCheckViewController.h"
#import "ApplySupportViewController.h"
#import "AddComponentMaintainViewController.h"
#import "SystemPicture.h"
#import "WZDateSelectCell.h"
#import "ProductModelSearchViewController.h"
#import "WZTableViewSessionHeaderView.h"
#import "PriceListViewController.h"
#import "TextLabelCell.h"
#import "ButtonTableViewCell.h"
#import "SpecialFinishEntry.h"
#import "UploadPictureCell.h"
#import "WeixinCommentQrCodeViewController.h"

typedef NS_ENUM(NSInteger, kPerformOrderVerifyButtonOpertationType)
{
    kPerformOrderVerifyButtonOpertationTypeSearch = 0, //查询机型
    kPerformOrderVerifyButtonOpertationTypeVerfify     //校验机号
};

@interface PerformOrderViewController ()<WZTableViewDelegate,WZSingleCheckViewControllerDelegate, ApplySupportViewControllerDelegate, AddComponentMaintainDelegate, SystemPictureDelegate, UITextFieldDelegate, ProductSelectCellDelegate, PleaseSelectViewCellDelegate>
{
    BOOL _isExpired;    //是否保外
    BOOL _isBrandCHIQ; //启客品牌
    BOOL _isBrandCH; //长虹品牌
    BOOL _isBrandSanYo; //三洋品牌
    BOOL _isBrandYingYan; //西藏迎燕品牌

    BOOL _isJDOrder; //是否JD订单
    BOOL _needToAdjust; //是否需要校验(长虹和启客的彩电需要，其它则不需要)
    BOOL _isAdjusted;   //已校验
    BOOL _isSupported;  //已申请过技术支持了
    BOOL _isNewMachine; //是否新机安装
    BOOL _isExtentContract; //是否延保单
    BOOL _canFinish;
    NSString *_spareInfo;
    NSString *_mainCodeStr;
    NSString *_innerMachineCodeStr;
    NSString *_brandId;     //品牌
    NSString *_productId;   //产品大类
    NSString *_categroyId;  //品类
    
    SystemPicture *_loadPicMgr;

    ProductModelDes *_adjustedProductInfo; //校验后的数据
    CheckItemModel *_issueTypeItem;
    CheckItemModel *_issueSubTypeItem;
    NSString *_product_model;   //机型

    WZSingleCheckViewController *_streetCheckViewController;
    WZSingleCheckViewController *_issueTypeCheckViewController;
    WZSingleCheckViewController *_issueCodeCheckViewController;
    
    WZTableViewSessionHeaderViewManager *_sessionHeaderManager;
    
    BOOL _bFeeListSynching;  //费用项正在同步中...
    NSArray *_warrantyItems; //质保期
    NSString *_finishedNoteStr, *_unfinishNoteStr; //完工、未完工备注
}

//section title view
@property (nonatomic, strong)WZTableViewSessionHeaderView *checkInSecHeaderView; //上门签到
@property (nonatomic, strong)WZTableViewSessionHeaderView *productSecHeaderView; //产品确认
@property (nonatomic, strong)WZTableViewSessionHeaderView *infoSecHeaderView; //信息采集
@property (nonatomic, strong)WZTableViewSessionHeaderView *otherSecHeaderView; //其它信息
@property (nonatomic, strong)WZTableViewSessionHeaderView *weixinCommentSecHeaderView; //微信点评
@property (nonatomic, strong)UISwitch *weixinCommentSwitch;


@property(nonatomic, strong)OrderContentDetails *orderDetails;
@property(nonatomic, strong)ProductSelectCell *productCell; //产品信息

//京东工单
@property(nonatomic, strong)UIButton *jdIdentifyButton;
@property(nonatomic, strong)UITableViewCell *jdIdentifyCell;//鉴定
@property(nonatomic, strong)PleaseSelectViewCell *jdIdentifyResultCell; //鉴定结果
@property(nonatomic, strong)TextFieldTableViewCell *machineCodeCell;
@property(nonatomic, strong)TextFieldTableViewCell *innerMachineCodeCell;
@property(nonatomic, strong)WZDateSelectCell  *purchaseDateCell;
@property(nonatomic, strong)TextFieldTableViewCell *eOrderIdCell;//电商号

@property(nonatomic, strong)UIButton *verifyButton;
@property(nonatomic, strong)UITableViewCell *verifyButtonCell; //校验
@property(nonatomic, strong)TextSegmentTableViewCell *warrantyCell;//质保期

//section 信息采集
@property(nonatomic, strong)TextFieldTableViewCell *nameCell;
@property(nonatomic, strong)TextLabelCell *addressCell;
@property(nonatomic, strong)TextFieldTableViewCell *detailAddressCell;
@property(nonatomic, strong)TextFieldTableViewCell *telEditCell;

@property(nonatomic, strong)UIButton *supportButton;
@property(nonatomic, strong)UITableViewCell *supportCell; //技术支持

@property(nonatomic, strong)UIButton *deviceInfoButton;
@property(nonatomic, strong)UITableViewCell *deviceInfoCell; //备件信息

@property(nonatomic, strong)UIButton *feeMgrButton;
@property(nonatomic, strong)UITableViewCell *feeMgrCell; //费用管理
@property(nonatomic, strong)UIButton *smartSellButton;
@property(nonatomic, strong)UITableViewCell *smartSellCell; //智能销售管理
@property(nonatomic, strong)UISwitch *valueAddedServiceSwith;
@property(nonatomic, strong)UITableViewCell *valueAddedServiceCell;//增值业务
@property(nonatomic, strong)UISwitch *extendContractSwith;
@property(nonatomic, strong)UITableViewCell *extendContractCell; //延保合同
@property(nonatomic, strong)UIButton *solutionButton;
@property(nonatomic, strong)PleaseSelectViewCell *solutionCell; //处理措施
@property(nonatomic, strong)UISegmentedControl *isCompletedSegment;
@property(nonatomic, strong)UITableViewCell *isCompletedCell; //是否完工
@property(nonatomic, strong)PleaseSelectViewCell *unCompleteReasonCell;//未完工原因
@property(nonatomic, strong)TextViewCell *issueHandleWayCell; //故障处理方式描述
@property(nonatomic, strong)WZTextView *textView;
@property(nonatomic, strong)UITableViewCell *noteEditCell; //备注

//微信点评
@property(nonatomic, strong)UploadPictureCell *devicePicture1Cell;
@property(nonatomic, strong)UploadPictureCell *devicePicture2Cell;
@property(nonatomic, strong)UploadPictureCell *invoicePictureCell;
@property(nonatomic, strong)UISwitch *showTVFeaturesSwitch;
@property(nonatomic, strong)UITableViewCell *showTVFeaturesCell;
@property(nonatomic, strong)UISwitch *showACFeaturesSwitch;
@property(nonatomic, strong)UITableViewCell *showACFeaturesCell;

//其它信息
@property(nonatomic, strong)PleaseSelectViewCell *promotionCell;//活动选择
@property(nonatomic, strong)PleaseSelectViewCell *promotionSubCell;//活动内容
@property(nonatomic, strong)ButtonTableViewCell *promotionDesCell;//活动详情

//延保合同子项
@property(nonatomic, strong)TextFieldTableViewCell *contractNoCell;
@property(nonatomic, strong)PleaseSelectViewCell *contactTypeCell;
@property(nonatomic, strong)PleaseSelectViewCell *extendTimeCell;
@property(nonatomic, strong)TextFieldTableViewCell *machinePriceCell;
@property(nonatomic, strong)PleaseSelectViewCell *machinePriceRangeCell;
@property(nonatomic, strong)WZTextView *contractNote;
@property(nonatomic, strong)UITableViewCell *contractNoteCell; //合同备注

@property(nonatomic, strong)NSMutableArray *cellArray; //all cells
@property(nonatomic, strong)NSMutableDictionary *sectionTitleDic;

@property(nonatomic, strong)NSMutableArray *machineComponCellArray;//物料项CELL
@property(nonatomic, strong)NSMutableArray *contractItemCellArray;//合同项CELL

@property(nonatomic, assign)BOOL jd_commited;//JD鉴定单是否已上传
@property(nonatomic, assign)BOOL unfinished;//选择了未完工

@end

@implementation PerformOrderViewController

- (BOOL)unfinished{
    return (1 == self.isCompletedSegment.selectedSegmentIndex);
}

- (KeyValueModel*)maintanceTimeRangeItem:(kWarrantyRangeDate)rangeDate
{
    NSString *rangeDateStr = [NSString intStr:rangeDate];
    return [KeyValueModel modelWithValue:getWarrantyDateStrById(rangeDateStr) forKey:rangeDateStr];
}

- (NSMutableArray*)machineComponCellArray
{
    if (nil == _machineComponCellArray) {
        _machineComponCellArray = [[NSMutableArray alloc]init];
        
        //add a default
        MachineComponEditCell *defaultCell = [self makeMachineComponEditCell];
        defaultCell.showAddRemoveButtonsLine = YES;
        [_machineComponCellArray addObject:defaultCell];
    }
    return _machineComponCellArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"执行";
    
    _sessionHeaderManager = [WZTableViewSessionHeaderViewManager new];
    
    if ([self alertUpdateMainConfigInfoIfNeed]) {
        return;
    }
    
    [self makeSectionHeaderViews];

    //create all content views
    [self makeSectionHeaderViews];
    [self makeCustomCells];

    self.tableView.tableViewDelegate = self;
    [self.tableView refreshTableViewData];

    //clean fee list first
    [self deleteAllFeeOrderList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    self.disableRightPanBack = YES;
}

//能否返回到上一级
- (BOOL)couldBackViewController
{
#if 0
    NSString *status = self.orderDetails.status;
    
    BOOL bBack = YES;
    if (![Util isEmptyString:status]) {
        bBack = [status isEqualToString:@"SR45"] || [status isEqualToString:@"SR46"];
    }
    return bBack;
#endif
    return YES;
}

#pragma mark - Create content views

- (WZTableViewSessionHeaderView*)newSectionHeaderView:(NSString*)title
{
    WZTableViewSessionHeaderView *sectionHeaderView;
    sectionHeaderView = [[WZTableViewSessionHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 36)];
    sectionHeaderView.backgroundColor = kColorDefaultBackGround;
    sectionHeaderView.titleLabel.text = title;
    return sectionHeaderView;
}

- (void)makeSectionHeaderViews
{
    _checkInSecHeaderView = [self newSectionHeaderView:@"上门签到"];
    _productSecHeaderView = [self newSectionHeaderView:@"产品确认"];
    _infoSecHeaderView = [self newSectionHeaderView:@"信息采集"];
    _otherSecHeaderView = [self newSectionHeaderView:@"其它信息"];

    _weixinCommentSecHeaderView = [self newSectionHeaderView:@"微信点评"];
    _weixinCommentSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 40, 24)];
    _weixinCommentSwitch.onTintColor = kColorDefaultOrange;
    [_weixinCommentSwitch addTarget:self action:@selector(weixinCommentSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    _weixinCommentSwitch.on = NO;
    [_weixinCommentSecHeaderView addSubview:self.weixinCommentSwitch];
    [self.weixinCommentSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_weixinCommentSecHeaderView);
        make.right.equalTo(_weixinCommentSecHeaderView).with.offset(-kDefaultSpaceUnit);
    }];
}

- (UploadPictureCell*)makeUploadPictureCell:(NSString*)title picType:(NSString*)picType picName:(NSString*)picName
{
    UploadPictureCell *cell = [[UploadPictureCell alloc]initWithViewController:self];
    cell.textLabel.text = title;
    [cell addLineTo:kFrameLocationBottom];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.pictureLoader.orderId = self.orderId;
    cell.pictureLoader.imageType = picType;
    cell.pictureLoader.imageName = picName;

    return cell;
}

- (void)makeCustomCells
{
    NSArray *itemArray;

    _productCell = [[ProductSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _productCell.delegate = self;
    [_productCell addLineTo:kFrameLocationBottom];

    _jdIdentifyButton = [UIButton transparentTextButton:@"上传京东检测单"];
    _jdIdentifyCell = [self makeButtonCell:_jdIdentifyButton action:@selector(jdIdentifyButtonClicked:)];

    itemArray = [self.configInfoMgr jdIdentifyResults];
    itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
    _jdIdentifyResultCell = [MiscHelper makeSelectItemCell:@"鉴定结果" checkItems:itemArray checkedItem: nil];

    _machineCodeCell = [self makeLeftEditRightBarCodeBtnCell:@selector(mainCodeButtonClicked:)];
    [_machineCodeCell addLineTo:kFrameLocationBottom];

    _innerMachineCodeCell = [self makeLeftEditRightBarCodeBtnCell:@selector(innerMachineCodeButtonClicked:)];
    [_innerMachineCodeCell addLineTo:kFrameLocationBottom];
    _innerMachineCodeCell.textField.placeholder = @"请输入空调内机号";

    _purchaseDateCell = [[WZDateSelectCell alloc]initWithDate:nil baseViewController:self];
    _purchaseDateCell.textLabel.text = @"购买日期";
    [_purchaseDateCell addLineTo:kFrameLocationBottom];

    _eOrderIdCell = [self makeTextFieldCell:@"电商订单号"];

    _verifyButton = [UIButton transparentTextButton:nil];
    _verifyButtonCell = [self makeButtonCell:_verifyButton action:@selector(verifyButtonCellClicked:)];

    //质保期
    _warrantyCell = [self makeTextSegmentCellWithTitle:@"产品质保"];
    [_warrantyCell.segment addTarget:self action:@selector(maintenancePeriodSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    _warrantyItems = [self.configInfoMgr warrantyItems];

    _nameCell = [self makeTextFieldCell:@"请输入用户姓名"];

    //地址
    _addressCell = [[TextLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _addressCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [_addressCell addLineTo:kFrameLocationBottom];

    _detailAddressCell = [self makeTextFieldCell:@"详细地址（栋,单元,号）"];
    [_detailAddressCell addLineTo:kFrameLocationBottom];
    
    _telEditCell = [self makeTextFieldCell:@"添加联系方式，用\",\"分隔"];

    _supportButton = [UIButton orangeButton:@"申请"];
    _supportCell = [self makeLeftTitleRightButtonCell:_supportButton action:@selector(supportButtonClicked:)];
    _supportCell.textLabel.text = @"技术支持";

    //备件维护
    _deviceInfoButton = [UIButton orangeButton:@"备件维护"];
    _deviceInfoCell = [self makeLeftTitleRightButtonCell:_deviceInfoButton action:@selector(deviceMaintainButtonClicked:)];
    _deviceInfoCell.textLabel.text = @"备件信息";
    
    //费用管理
    _feeMgrButton = [UIButton orangeButton:getPriceManageTypeStr(kPriceManageTypeService)];
    _feeMgrButton.tag = kPriceManageTypeService;
    _feeMgrCell = [self makeLeftTitleRightButtonCell:_feeMgrButton action:@selector(feeMgrButtonClicked:)];
    _feeMgrCell.textLabel.text = @"费用管理";
    
    //费用管理
    _smartSellButton = [UIButton orangeButton:getPriceManageTypeStr(kPriceManageTypeSells)];
    _smartSellButton.tag = kPriceManageTypeSells;
    _smartSellCell = [self makeLeftTitleRightButtonCell:_smartSellButton action:@selector(smartSellButtonClicked:)];
    _smartSellCell.textLabel.text = @"智能产品销售";

    _valueAddedServiceSwith = [[UISwitch alloc]init];
    _valueAddedServiceCell = [self makeLeftTitleRightSwitchCell:_valueAddedServiceSwith action:@selector(valueAddedServiceSwithChanged:)];
    _valueAddedServiceCell.textLabel.text = @"增值业务";

    _extendContractSwith = [[UISwitch alloc]init];
    _extendContractCell = [self makeLeftTitleRightSwitchCell:_extendContractSwith action:@selector(extendContractSwithChanged:)];
    _extendContractCell.textLabel.text = @"延保合同";

    itemArray = [self.configInfoMgr normalSolutionsOfProduct:_productId isNew:NO];
    itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
    _solutionCell = [MiscHelper makeSelectItemCell:@"处理措施" checkItems:itemArray checkedItem: nil];

    _isCompletedSegment = [[UISegmentedControl alloc]initWithItems:@[@"完工", @"未完工"]];
    _isCompletedSegment.selectedSegmentIndex = 1;
    _isCompletedSegment.tintColor = kColorDefaultOrange;
    [_isCompletedSegment addTarget:self action:@selector(isCompletedSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    _isCompletedSegment.frame = CGRectMake(0, 0, 180, 30);
    _isCompletedCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _isCompletedCell.accessoryView = _isCompletedSegment;
    [_isCompletedCell clearBackgroundColor];
    [_isCompletedCell.contentView clearBackgroundColor];
    _isCompletedCell.textLabel.text = @"是否完工";

    itemArray = [self.configInfoMgr unfinishedReasons];
    itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
    _unCompleteReasonCell = [MiscHelper makeSelectItemCell:@"未完工原因" checkItems:itemArray checkedItem: nil];

    _issueHandleWayCell = [self makeTextViewCell:@"故障处理方式描述" maxWords:60];
    [_issueHandleWayCell.contentView clearBackgroundColor];
    [_issueHandleWayCell clearBackgroundColor];
    [self.issueHandleWayCell.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.issueHandleWayCell.contentView).insets(UIEdgeInsetsMake(kDefaultSpaceUnit, 0, 0, 0));
    }];

    _textView = [[WZTextView alloc]initWithFrame:CGRectMake(0, kDefaultSpaceUnit, ScreenWidth - 2*kDefaultSpaceUnit, kNoteEditTextCellHeight) maxWords:300];
    _noteEditCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [_noteEditCell.contentView addSubview:self.textView];
    [_noteEditCell clearBackgroundColor];
    [_noteEditCell.contentView clearBackgroundColor];
    
    _devicePicture1Cell = [self makeUploadPictureCell:@"设备照片1" picType:@"1" picName:@"devicePicture1"];
    _devicePicture2Cell = [self makeUploadPictureCell:@"设备照片2" picType:@"1" picName:@"devicePicture2"];
    _invoicePictureCell = [self makeUploadPictureCell:@"发票照片" picType:@"2" picName:@"invoicePicture1"];
    _showTVFeaturesSwitch = [[UISwitch alloc]init];
    _showTVFeaturesCell = [self makeLeftTitleRightSwitchCell:_showTVFeaturesSwitch action:nil];
    _showTVFeaturesCell.textLabel.text = @"已演示电视网络功能";
    _showACFeaturesSwitch = [[UISwitch alloc]init];
    _showACFeaturesCell = [self makeLeftTitleRightSwitchCell:_showACFeaturesSwitch action:nil];
    _showACFeaturesCell.textLabel.text = @"已介绍清洗服务";

    itemArray = [self promotionalActivityCheckItems];
    _promotionCell = [MiscHelper makeSelectItemCell:@"销售活动" checkItems:itemArray checkedItem: nil];
    _promotionCell.delegate = self;

    _promotionSubCell = [MiscHelper makeSelectItemCell:@"活动内容" checkItems:nil checkedItem: nil];
    _promotionSubCell.delegate = self;
    
    _promotionDesCell = [[ButtonTableViewCell alloc]initWithButtonEdge:UIEdgeInsetsZero reuseIdentifier:nil];
    UIButton *detailButton = _promotionDesCell.button;
    [detailButton setTitle:@"查看活动详情" forState:UIControlStateNormal];
    [detailButton setImage:ImageNamed(@"about") forState:UIControlStateNormal];
    detailButton.titleLabel.font = SystemFont(14);
    [detailButton setTitleColor:kColorDarkGray forState:UIControlStateNormal];
    [detailButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [detailButton addTarget:self action:@selector(promotionActivityDetailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self makeContractItemCellsIfNeed];
}

- (NSArray*)promotionalActivityCheckItems
{
    NSMutableArray *checkItems = [NSMutableArray new];

    NSArray *tempItems = [self.configInfoMgr promotionalActivityNames];
    tempItems = [Util convertConfigItemInfoArrayToCheckItemModelArray:tempItems];
    if (tempItems.count > 0) {
        CheckItemModel *noneItem = [CheckItemModel modelWithValue:@"请选择" forKey:@""];
        [checkItems addObject:noneItem];
        [checkItems addObjectsFromArray:tempItems];
    }
    return checkItems;
}

- (NSArray*)promotionalActivityContentCheckItemsOf:(NSString*)activityCode
{
    NSMutableArray *checkItems = [NSMutableArray new];
    
    NSArray *tempItems = [self.configInfoMgr promotionalActivitySubNamesOf:activityCode];
    tempItems = [Util convertConfigItemInfoArrayToCheckItemModelArray:tempItems];
    if (tempItems.count > 0) {
        CheckItemModel *noneItem = [CheckItemModel modelWithValue:@"请选择" forKey:@""];
        [checkItems addObject:noneItem];
        [checkItems addObjectsFromArray:tempItems];
    }
    return checkItems;
}

- (void)makeContractItemCellsIfNeed
{
    if (!_contractItemCellArray || _contractItemCellArray.count <= 0) {
        NSArray *itemArray;

        _contractNoCell = [self makeTextFieldCell:@"书面合同号（限大写字母与数字）"];
        
        itemArray = [self.configInfoMgr transactionReasonsOfProduct:_productId];
        itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
        _contactTypeCell = [MiscHelper makeSelectItemCell:@"成交原因" checkItems: itemArray checkedItem: nil];

        itemArray = [self.configInfoMgr warrantyYearItems];
        _extendTimeCell = [MiscHelper makeSelectItemCell:@"延保时间" checkItems: itemArray checkedItem: nil];

        _machinePriceCell = [self makeTextFieldCell:@"购机价格"];

        itemArray = [self.configInfoMgr priceRangesOfProduct:_productId];
        itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
        _machinePriceRangeCell = [MiscHelper makeSelectItemCell:@"价格区间" checkItems: itemArray checkedItem: nil];

        _contractNote = [[WZTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 2*kTableViewLeftPadding, kPerformOrderViewCellLineHeight*3) maxWords:300];
        _contractNote.placeholder = @"合同备注（选填）";
        _contractNoteCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_contractNoteCell.contentView addSubview:_contractNote];
        [_contractNoteCell clearBackgroundColor];
        [_contractNoteCell.contentView clearBackgroundColor];
        
        //merge them to array
        _contractItemCellArray = [[NSMutableArray alloc]init];
        [_contractItemCellArray addObject:self.contractNoCell];
        [_contractItemCellArray addObject:self.contactTypeCell];
        [_contractItemCellArray addObject:self.extendTimeCell];
        [_contractItemCellArray addObject:self.machinePriceCell];
        [_contractItemCellArray addObject:self.machinePriceRangeCell];
        [_contractItemCellArray addObject:self.contractNoteCell];
    }
}

#pragma mark - Set Data To cells

- (void)setDataToViews
{
    KeyValueModel *item = [KeyValueModel new];
    item.key = [MiscHelper productBrandCodeByName: self.orderDetails.zzfld000000];
    item.value = self.orderDetails.zzfld000000;
    self.productCell.typeItemEditable = !_needToAdjust;;
    self.productCell.brandItem = item;

    item = [KeyValueModel new];
    item.key = [MiscHelper productTypeCodeByName: self.orderDetails.zzfld000003];
    item.value = self.orderDetails.zzfld000003;
    self.productCell.productItem = item;

    item = [KeyValueModel new];
    item.key = [MiscHelper subProductTypeCodeByName: self.orderDetails.zzfld000001];
    item.value = self.orderDetails.zzfld000001;
    [self.productCell setTypeItem:item defaultItem:NO];

    self.machineCodeCell.textField.text = self.orderDetails.machinemodel;
    self.innerMachineCodeCell.textField.text = self.orderDetails.machinemodel2;
    self.purchaseDateCell.date = [Util dateWithString:self.orderDetails.buytime format:WZDateStringFormat10];
    self.eOrderIdCell.textField.text = self.orderDetails.zzfld00000m;

    [self autoSetVerifyButtonOpertionType];

    //warranty segment
    NSInteger segmentIndex = [self getValuedSegmentIndex:_warrantyItems value:self.orderDetails.zzfld000002];
    NSArray *tempSegItems = _warrantyItems;
    CGFloat segmentWidth = 160;
    if ([self.productCell.brandItem.key isEqualToString:@"XZYY"]) {
        segmentIndex = (NSNotFound == segmentIndex) ? 0 : segmentIndex;
        KeyValueModel *selItem = _warrantyItems[segmentIndex];
        tempSegItems = @[selItem];
        segmentWidth = 80;
        segmentIndex = 0;
    }
    [self insertSegmentItems:tempSegItems toSegment:self.warrantyCell segWidth:segmentWidth];
    self.warrantyCell.segment.enabled = (tempSegItems.count > 1);
    self.warrantyCell.segment.selectedSegmentIndex = segmentIndex;

    //name
    self.nameCell.textField.text = self.orderDetails.custname;

    self.unCompleteReasonCell.checkedItemKey = self.orderDetails.failId;
    self.textView.text = self.orderDetails.unfinishedMemo;

    self.solutionCell.checkedItemKey = self.orderDetails.zzfld00002h;
    self.issueHandleWayCell.textView.text = [Util defaultStr:@"" ifStrEmpty:self.orderDetails.zzfld00005y];

    [self setStreetInfoToView:self.orderDetails.street key:self.orderDetails.street];

    self.detailAddressCell.textField.text = self.orderDetails.str_suppl1;
    self.telEditCell.textField.text = self.orderDetails.telnumber;

    self.promotionCell.checkedItemKey = self.orderDetails.zzfld0000;
    [self promotionActivityItemValueChanged:self.promotionCell];

    self.promotionSubCell.checkItems = [self promotionalActivityContentCheckItemsOf:self.orderDetails.zzfld0000];
    self.promotionSubCell.checkedItemKey = self.orderDetails.zzfld0001;

    NSString *supportTitle = _isSupported ? self.orderDetails.supporterName : @"申请";
    [self.supportButton setTitle:supportTitle forState:UIControlStateNormal];
    [self.supportButton setTitle:supportTitle forState:UIControlStateDisabled];
    self.supportButton.enabled = !_isSupported;

    //weixin comment
    NSString *imageUrl = [self parseImageUrlFromJson:self.orderDetails.deviceImgUrl imageName:self.devicePicture1Cell.pictureLoader.imageName];
    if (![Util isEmptyString:imageUrl]) {
        [self.devicePicture1Cell setQiniuImageUrl:imageUrl reload:YES];
    }
    imageUrl = [self parseImageUrlFromJson:self.orderDetails.deviceImgUrl imageName:self.devicePicture2Cell.pictureLoader.imageName];
    if (![Util isEmptyString:imageUrl]) {
        [self.devicePicture2Cell setQiniuImageUrl:imageUrl reload:YES];
    }
    imageUrl = [self parseImageUrlFromJson:self.orderDetails.invoiceImgUrl imageName:self.invoicePictureCell.pictureLoader.imageName];
    if (![Util isEmptyString:imageUrl]) {
        [self.invoicePictureCell setQiniuImageUrl:imageUrl reload:YES];
    }
    self.showTVFeaturesSwitch.on = (1 == [self.orderDetails.isDemonstrate integerValue]);
    self.showACFeaturesSwitch.on = (1 == [self.orderDetails.isIntroduce integerValue]);
}

-(NSString*)parseImageUrlFromJson:(NSString*)imagesJson imageName:(NSString*)imageName
{
    ReturnIf([Util isEmptyString:imagesJson] || [Util isEmptyString:imageName])nil;

    NSDictionary *retJsonDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithString:imagesJson] options:NSJSONReadingAllowFragments error:nil];
    return [retJsonDic objForKey:imageName];
}

- (MachineComponEditCell*)makeMachineComponEditCell
{
    MachineComponEditCell *cell = [[MachineComponEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.viewController = self;
    [cell.addBtn addTarget:self action:@selector(machineComponCellAddButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(machineComponCellDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (TextFieldTableViewCell*)makeLeftEditRightBarCodeBtnCell:(SEL)barCodeBtnClickAction
{
    TextFieldTableViewCell *barCodeCell = [[TextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIButton *barCodeButton = [UIButton imageButtonWithNorImg:@"dealer_erweima" selImg:@"dealer_erweima" size:CGSizeMake(kPerformOrderViewCellLineHeight, kPerformOrderViewCellLineHeight) target:self action:barCodeBtnClickAction];
    [barCodeButton addLineTo:kFrameLocationLeft];
    
    barCodeCell.accessoryView = barCodeButton;
    barCodeCell.textField.delegate = self;
    
    return barCodeCell;
}

- (UITableViewCell*)makeLeftTitleRightSwitchCell:(UISwitch*)switchView action:(SEL)action
{
    switchView.onTintColor = kColorDefaultOrange;
    [switchView addTarget:self action:action forControlEvents:UIControlEventValueChanged];

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryView = switchView;
    [cell clearBackgroundColor];
    [cell.contentView clearBackgroundColor];
    
    return cell;
}

//button top & bottom space : kDefaultSpaceUnit/2
- (UITableViewCell*)makeButtonCell:(UIButton*)button action:(SEL)action
{
    button.backgroundColor = kColorWhite;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell.contentView addSubview:button];
    [cell clearBackgroundColor];
    [cell.contentView clearBackgroundColor];

    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsMake(kDefaultSpaceUnit, 0, kDefaultSpaceUnit, 0));
    }];
    return cell;
}

- (void)mergeDataToLocalVariables
{
    //init some attributes
    _product_model = self.orderDetails.zzfld00000q;
    
    _brandId = [MiscHelper productBrandCodeForValue:self.orderDetails.zzfld000000];
    _productId = [MiscHelper productTypeCodeForValue:self.orderDetails.zzfld000003];
    _categroyId = [MiscHelper productCategoryCodeForValue:self.orderDetails.zzfld000001];
    _isBrandCH = [_brandId isEqualToString:@"CH"];
    _isBrandCHIQ = [_brandId isEqualToString:@"CHIQ"];
    _isBrandSanYo = [_brandId isEqualToString:@"SY"];
    _isBrandYingYan = [_brandId isEqualToString:@"XZYY"];

    _needToAdjust = (_isBrandCHIQ ||_isBrandCH)&& self.orderDetails.isTV;
    _isNewMachine = [self.orderDetails.process_type isEqualToString:@"ZRA1"];

    _isJDOrder = [self.orderDetails.jd_thj isEqualToString:@"X"];

    if (_isAdjusted) {
        _adjustedProductInfo = [self makeProductModelDesByContentDetails:self.orderDetails];
    }
    _isExtentContract = [self.orderDetails.isturnovercontract isEqualToString:@"1"];
    _isSupported = [self.orderDetails.isSupport isEqualToString:@"1"];

    _canFinish = YES;
    if (!_isNewMachine) {
        _canFinish = ![MiscHelper checkIsPartsAffectFinishOrder:self.orderDetails.tDispatchParts];
    }
    
    NSArray *itemArray = [self.configInfoMgr normalSolutionsOfProduct:_productId isNew:_isNewMachine];
    itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
    _solutionCell.checkItems = itemArray;
}

- (void)reloadTableView
{
    self.cellArray = [self groupTableViewCells];
    [self setTableViewCellCommonProperties];
    [self.tableView.tableView reloadData];
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
    NSInteger sectionIndex = 0;
    
    _sectionTitleDic = [NSMutableDictionary new];

    //section 上门签到
    rowArray = [[NSMutableArray alloc]init];
    [sectionArray addObject:rowArray];
    [self.sectionTitleDic setObj:self.checkInSecHeaderView forKey:@(sectionIndex++)];
    [rowArray addObject:self.locateCell];
    [rowArray addObject:self.signinButtonCell];

    //section 产品确认
    rowArray = [[NSMutableArray alloc]init];
    [sectionArray addObject:rowArray];
    [self.sectionTitleDic setObj:self.productSecHeaderView forKey:@(sectionIndex++)];
    [rowArray addObject:self.productCell];
    [rowArray addObject:self.machineCodeCell];
    if (self.orderDetails.isAirConditioning) {
        [rowArray addObject:self.innerMachineCodeCell];
        self.machineCodeCell.textField.placeholder = @"请输入空调外机号";
    }else {
        self.machineCodeCell.textField.placeholder = @"请输入机号";
    }
    [rowArray addObject:self.purchaseDateCell];
    if (_isNewMachine) {
        [rowArray addObject:self.eOrderIdCell];
    }
    if (_isJDOrder) {
        [rowArray addObject:self.jdIdentifyCell];
        [rowArray addObject:self.jdIdentifyResultCell];
    }
    [rowArray addObject:self.verifyButtonCell];
    [rowArray addObject:self.warrantyCell];

    //section 信息采集
    rowArray = [[NSMutableArray alloc]init];
    [sectionArray addObject:rowArray];
    [self.sectionTitleDic setObj:self.infoSecHeaderView forKey:@(sectionIndex++)];
    [rowArray addObject:self.nameCell];
    [rowArray addObject:self.addressCell];
    [rowArray addObject:self.detailAddressCell];
    [rowArray addObject:self.telEditCell];
    [rowArray addObject:self.isCompletedCell];

//    [rowArray addObject:self.valueAddedServiceCell];
//    if (self.valueAddedServiceSwith.isOn) {
//        [rowArray addObjectsFromArray:self.machineComponCellArray];
//    }

    //section 未完工/完工信息
    rowArray = [[NSMutableArray alloc]init];
    [sectionArray addObject:rowArray];
    [self.sectionTitleDic setObj:[NSNull null] forKey:@(sectionIndex++)];

    if (0 == _isCompletedSegment.selectedSegmentIndex) { //完工
        if (!_isNewMachine) {
            [rowArray addObject:self.issueCodeCell];
        }
        if ([self needToSetIssueHandleWay]) {
            [rowArray addObject:self.issueHandleWayCell];
        }
        self.textView.placeholder = @"请填写完工措施备注";
    }else {
        [rowArray addObject:self.unCompleteReasonCell];
        self.textView.placeholder = @"请填写未完工备注（必填）";
    }
    [rowArray addObject:self.solutionCell];
    [rowArray addObject:self.noteEditCell];

    //section 微信点评
    if (!self.unfinished) {
        rowArray = [[NSMutableArray alloc]init];
        [sectionArray addObject:rowArray];
        [self.sectionTitleDic setObj:self.weixinCommentSecHeaderView forKey:@(sectionIndex++)];
        if (self.weixinCommentSwitch.isOn) {
            [rowArray addObject:self.devicePicture1Cell];
            [rowArray addObject:self.devicePicture2Cell];
            [rowArray addObject:self.invoicePictureCell];
            if (self.orderDetails.isTV) {
                [rowArray addObject:self.showTVFeaturesCell];
            }else if (self.orderDetails.isAirConditioning){
                [rowArray addObject:self.showACFeaturesCell];
            }
        }
    }

    //secion 备件维护与费用管理
    rowArray = [[NSMutableArray alloc]init];
    [sectionArray addObject:rowArray];
    [self.sectionTitleDic setObj:[NSNull null] forKey:@(sectionIndex++)];
    if (!_isNewMachine) {
        [rowArray addObject:self.supportCell];
        [rowArray addObject:self.deviceInfoCell];
    }
    //费用管理，仅在完工、保外、上门维修时可用
    if (_isExpired && !self.unfinished && [self.orderDetails.process_type isEqualToString:@"ZR01"]) {
        [rowArray addObject:self.feeMgrCell];
    }
    //非新机安装时，才能进行智能销售管理
    if ([self canSupportSmartSellManage]) {
        [rowArray addObject:self.smartSellCell];
    }

    //section 其它信息
    rowArray = [[NSMutableArray alloc]init];
    [sectionArray addObject:rowArray];
    [self.sectionTitleDic setObj:self.otherSecHeaderView forKey:@(sectionIndex++)];
    [rowArray addObject:self.promotionCell];
    [rowArray addObject:self.promotionSubCell];
    [rowArray addObject:self.promotionDesCell];


    return sectionArray;
}

//迎燕的新机安装时,不支持智销售管理
- (BOOL)canSupportSmartSellManage
{
    return !(_isBrandYingYan && _isNewMachine);
}

- (BOOL)needToSetIssueHandleWay
{
    BOOL bMatchBrand = _isBrandCH || _isBrandCHIQ || _isBrandSanYo;
    BOOL bRepairOrder = !_isNewMachine;
    BOOL bTV = [_productId isEqualToString:@"TV0010"];

    return bMatchBrand && bRepairOrder && bTV;
}

#pragma mark - PleaseSelectViewCell Delegate

- (void)selectViewDidChecked:(PleaseSelectViewCell*)cell
{
    [self promotionActivityItemValueChanged:cell];
}

- (BOOL)selectMenuWillAppear:(PleaseSelectViewCell*)cell
{
    if (cell == self.promotionSubCell) {
        if ([Util isEmptyString:self.promotionCell.checkedItemKey]) {
            [Util showToast:@"请先选择销售活动"];
            return NO;
        }
    }
    return YES;
}


- (void)promotionActivityItemValueChanged:(PleaseSelectViewCell*)cell{
    if (cell == self.promotionCell) {
        if (![Util isEmptyString:self.promotionCell.checkedItemKey]) {
            self.promotionSubCell.checkItems = [self promotionalActivityContentCheckItemsOf:self.promotionCell.checkedItemKey];
        }else {
            self.promotionSubCell.checkItems = nil;
        }
        self.promotionSubCell.checkedItem = nil;
    }
}

- (void)requestPromontionActivityDetail:(NSString*)promotionContentCode response:(RequestCallBackBlock)requestCallBackBlock{
    
    QueryActivityContentDetailInputParams *input;
    input = [QueryActivityContentDetailInputParams new];
    input.zzfld0001 = promotionContentCode;

    [self.httpClient queryActivityContentDetail:input response:requestCallBackBlock];
}

#pragma mark - TableView Delegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    //request order details
    GetOrderDetailsInputParams *input = [GetOrderDetailsInputParams new];
    input.object_id = [self.orderId description];

    [self.httpClient getOrderDetails:input response:^(NSError *error, HttpResponseData *responseData) {

        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            NSDictionary *orderDic = responseData.resultData;
            self.orderDetails = [MiscHelper parserOrderContentDetails:orderDic];
            _isExpired = [self checkIfExpired:self.orderDetails];
            [self mergeDataToLocalVariables];
            [self setDataToViews];
            self.tableView.tableView.tableFooterView = self.customFooterView;
            [self reloadTableView];
            [self addSpecialPerformEntryIfNeed];
        }
        [tableView didRequestTableViewListDatasWithCount:1 totalCount:1 page:pageInfo response:responseData error:error];
    }];
}

- (void)addSpecialPerformEntryIfNeed
{
    [self setNavBarRightButton:@"特殊完工" clicked:@selector(specialPerformButtonClicked:)];
}

- (BOOL)checkIfExpired:(OrderContentDetails*)details{
    return [self.orderDetails.zzfld000002 isEqualToString:@"保外"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UIView *secHeaderView = [self.sectionTitleDic objForKey:@(section)];

    if ([secHeaderView isEqual:[NSNull null]] || nil == secHeaderView) {
        return kDefaultSpaceUnit;
    }else {
        return kButtonLargeHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WZTableViewSessionHeaderView *secHeaderView = [self.sectionTitleDic objForKey:@(section)];
    UILabel *headerLabel = secHeaderView.titleLabel;
    
    if (secHeaderView == self.productSecHeaderView) {//产品确认
        if (![Util isEmptyString:_product_model]) {
            AttributeStringAttrs *titleAttr = [AttributeStringAttrs new];
            titleAttr.text = [NSString stringWithFormat:@"%@ ",@"产品确认"];
            titleAttr.textColor = headerLabel.textColor;
            titleAttr.font = headerLabel.font;
            AttributeStringAttrs *orderAttr = [AttributeStringAttrs new];
            orderAttr.text = [NSString stringWithFormat:@"( %@ )", _product_model];
            orderAttr.textColor = kColorDefaultOrange;
            orderAttr.font = SystemFont(14);
            headerLabel.attributedText = [NSString makeAttrString:@[titleAttr, orderAttr]];
        }else {
            headerLabel.text = @"产品确认";
        }
    }else if ([secHeaderView isEqual:[NSNull null]]) {
        return nil;
    }
    return secHeaderView;
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

    if (cell == self.signinButtonCell){
        cellHeight = kPerformOrderViewCellLineHeight + 2 * kDefaultSpaceUnit;
    }else if (cell == self.verifyButtonCell){
        cellHeight = kPerformOrderViewCellLineHeight + 2 * kDefaultSpaceUnit;
    }else if (cell == self.noteEditCell){
        cellHeight = CGRectGetMaxY(self.textView.frame);
    }else if ([cell isKindOfClass:[MachineComponEditCell class]]){
        cellHeight = [cell fitHeight];
    }else if (cell == self.contractNoteCell){
        return  CGRectGetHeight(self.contractNote.frame) + kDefaultSpaceUnit;
    }else if (cell == self.addressCell) {
        cellHeight = [self.addressCell fitHeight];
    }else if (cell == self.issueHandleWayCell){
        cellHeight = 100 + kDefaultSpaceUnit;
    }else if (cell == self.issueCodeCell){
        cellHeight = [self.issueCodeCell fitHeight];
    }
    return MAX(kPerformOrderViewCellLineHeight, cellHeight);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellArray[indexPath.section][indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = self.cellArray[indexPath.section][indexPath.row];
    if (cell == self.locateCell) {
        [self startLocateCurrentAddress];
    }else if (cell == self.addressCell){
        if (_streets.count > 0) {
            [self pushToCheckListVcToSelectStreet];
        }else {
            [self requestStreetInfos];
        }
    }else if (cell == self.issueCodeCell){
        [self checkOutIssueCode];
    }
}

- (void)checkOutIssueCode
{
    NSArray *checkTypes = [[ConfigInfoManager sharedInstance] issueCategoriesOfProduct:_productId brandId:_brandId];
    checkTypes = [Util convertConfigItemInfoArrayToCheckItemModelArray:checkTypes];

    _issueTypeCheckViewController = [MiscHelper pushToCheckListViewController:@"故障类型" checkItems:checkTypes checkedItem:_issueTypeItem from:self delegate:self];
    _issueTypeCheckViewController.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)singleCheckViewController:(WZSingleCheckViewController*)viewController didChecked:(CheckItemModel*)checkedItem
{
    if (_issueTypeCheckViewController == viewController) {//选择故障类型
        if (_issueTypeItem != checkedItem) {
            _issueTypeItem = checkedItem;
            _issueSubTypeItem = nil;
        }

        NSArray *subtypes = [[ConfigInfoManager sharedInstance]issueCodesOfCategory:(NSString*)_issueTypeItem.extData brandId:_brandId];
        subtypes = [Util convertConfigItemInfoArrayToCheckItemModelArray:subtypes];
        _issueCodeCheckViewController = [MiscHelper pushToCheckListViewController:@"故障代码" checkItems:subtypes checkedItem:_issueSubTypeItem from:viewController delegate:self];
    }else if (_issueCodeCheckViewController == viewController){//选择故障代码
        _issueSubTypeItem = checkedItem;
        [self setIssueCodeToView:checkedItem.key value:checkedItem.value];
        [self.tableView.tableView reloadData];

        [viewController popTo:self];
    }else if (_streetCheckViewController == viewController){ //选择街道
        [self setStreetInfoToView:checkedItem.value key:checkedItem.key];
        [viewController popViewController];
    }
}

- (void)setStreetInfoToView:(NSString*)streetValue key:(NSString*)streetKey
{
    _clientStreet = [CheckItemModel modelWithValue:streetValue forKey:streetKey];

    NSString *streetAddr = [self.orderDetails.customerFullCountyAddress appendStr:[Util defaultStr:@"" ifStrEmpty:streetValue]];
    self.addressCell.textContentLabel.text = streetAddr;
}

- (void)addNewMachineComponEditCellToTail
{
    MachineComponEditCell *oldLastCell = [self.machineComponCellArray lastObject];
    oldLastCell.showAddRemoveButtonsLine = NO;

    MachineComponEditCell *newCell = [self makeMachineComponEditCell];
    newCell.showAddRemoveButtonsLine = YES;
    [self.machineComponCellArray addObject:newCell];
}

- (void)removeLastMachineComponEditCell
{
    [self.machineComponCellArray removeLastObject];
    
    if (self.machineComponCellArray.count > 0) {
        MachineComponEditCell *lastCell = [self.machineComponCellArray lastObject];
        lastCell.showAddRemoveButtonsLine = YES;
    }
}

- (void)repairSigninWithResponse:(RequestCallBackBlock)requestCallBackBlock
{
    RepairSignInInputParams *input = [[RepairSignInInputParams alloc]init];
    input.object_id = [self.orderDetails.object_id description];
    input.repairmanid = [self.user.userId description];
    input.la = [NSString stringWithFormat:@"%f", _latitude];
    input.lo = [NSString stringWithFormat:@"%f", _longitude];
    input.arrive_address = [_signinAddress truncatingTailWhenLengthGreaterThan:30];
    input.postype = [NSString intStr:0];
    
    [Util showWaitingDialog];
    [self.httpClient repairSignIn:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        requestCallBackBlock(error, responseData);
    }];
}

//删除当前的费用管理
-(void)deleteAllFeeOrderList{
    DeleteAllFeeOrderInputParams *input = [DeleteAllFeeOrderInputParams new];
    input.objectId = self.orderId;
    input.itmType = @"ZRVW";

    _bFeeListSynching = YES;
    [self.httpClient deleteAllFeeOrder:input response:^(NSError *error, HttpResponseData *responseData) {
        _bFeeListSynching = NO;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            DLog(@"delete all old fee bill list from server");
        }else{
            [Util confirmAlertView:nil
                           message:@"未能成功清除遗留的服务费用项，可联系管理员，或稍后重试"
                      confirmTitle:@"重试"
                     confirmAction:^{
                          [self deleteAllFeeOrderList];
                      } cancelTitle:@"退出执行"
                      cancelAction:^{
                          [self popViewController];
                      }];
        }
    }];
}

-(void)queryFeeOrderStatus:(RequestCallBackBlock)requestCallBackBlock{
    QueryFeeBillStatusInputParams *input = [QueryFeeBillStatusInputParams new];
    input.objectId = self.orderDetails.object_id;

    [self.httpClient queryFeeBillStatus:input response:requestCallBackBlock];
}

- (void)brandOrCategoryValueChanged{
    [self deleteAllFeeOrderList];
}

- (void)weixinCommentSwitchValueChanged:(id)sender
{
    [self reloadTableView];
}

//品牌和产品是否匹配，但长虹和启客间可以互换
- (NSString*)checkIfProductMatch:(ProductModelDes*)product
{
    //检查品牌
    if (![self.productCell.brandItem.key isEqualToString:product.zz0018]) {
        BOOL isChOrChiq = [self.productCell.brandItem.key isEqualOneInArray:@[@"CH",@"CHIQ"]]
        && [product.zz0018 isEqualOneInArray:@[@"CH",@"CHIQ"]];

        //长虹和启客间可以互换
        if (!isChOrChiq) {
            return @"品牌不匹配，请重试";
        }
    }
    //检查产品是否匹配
    if (![_productId isEqualToString:product.zzfld000003]) {
        return @"产品大类不匹配，请重试";
    }
    return nil;
}

- (BOOL)handlefindMachineModelResult:(ProductModelDes*)product
{
    NSString *errStr = [self checkIfProductMatch:product];
    
    if (![Util isEmptyString:errStr]) {
        [Util showToast:errStr];
        return NO;
    }

    _adjustedProductInfo = product;
    _brandId = product.zz0018;
    _categroyId = product.zz0017;
    _isBrandCH = [_brandId isEqualToString:@"CH"];
    _isBrandCHIQ = [_brandId isEqualToString:@"CHIQ"];
    _isBrandSanYo = [_brandId isEqualToString:@"SY"];
    _isBrandYingYan = [_brandId isEqualToString:@"XZYY"];
    _product_model = product.product_id;

    //update product info
    NSString *tempStr = [self.configInfoMgr getConfigItemValueByType:MainConfigInfoTableType1 code:product.zz0018];
    KeyValueModel *brand = [KeyValueModel modelWithValue:tempStr forKey:product.zz0018];
    
    tempStr = [self.configInfoMgr getConfigItemValueByType:MainConfigInfoTableType3 code:product.zz0017];
    KeyValueModel *productType = [KeyValueModel modelWithValue:tempStr forKey:product.zz0017];
    
    self.productCell.brandItem = brand;
    [self.productCell setTypeItem:productType defaultItem:NO];

    [self brandOrCategoryValueChanged];
    
    [self reloadTableView];
    
    return YES;
}

- (NSString*)handleVerifyResult:(ProductModelDes*)product
{
    _isAdjusted = YES;

    NSString *errStr = [self checkIfProductMatch:product];
    ReturnIf(![Util isEmptyString:errStr])errStr;

    _adjustedProductInfo = product;
    _brandId = product.zz0018;
    _categroyId = product.zz0017;
    _isBrandCH = [_brandId isEqualToString:@"CH"];
    _isBrandCHIQ = [_brandId isEqualToString:@"CHIQ"];
    _isBrandSanYo = [_brandId isEqualToString:@"SY"];
    _isBrandYingYan = [_brandId isEqualToString:@"XZYY"];
    _product_model = product.product_id;

    //update product info
    NSString *tempStr = [self.configInfoMgr getConfigItemValueByType:MainConfigInfoTableType1 code:product.zz0018];
    KeyValueModel *brand = [KeyValueModel modelWithValue:tempStr forKey:product.zz0018];
    
    tempStr = [self.configInfoMgr getConfigItemValueByType:MainConfigInfoTableType3 code:product.zz0017];
    KeyValueModel *productType = [KeyValueModel modelWithValue:tempStr forKey:product.zz0017];

    self.productCell.brandItem = brand;
    [self.productCell setTypeItem:productType defaultItem:NO];

    [self brandOrCategoryValueChanged];

    [self setVerifyButtonOperationType:kPerformOrderVerifyButtonOpertationTypeVerfify];
    
    [self reloadTableView];
    
    return nil;
}

//校验
- (void)adjustMachineInfo
{
    MachineCategoryInputParams *input = [[MachineCategoryInputParams alloc]init];
    input.machinemodel = [Util defaultStr:self.innerMachineCodeCell.textField.text ifStrEmpty:self.machineCodeCell.textField.text];
    input.product_flag = [NSString intStr:self.orderDetails.isAirConditioning ? 0 : 1];

    [Util showWaitingDialog];
    [self.httpClient getMachineCategory:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        NSString *errStr = [Util getErrorDescritpion:responseData otherError:error];
        if (!error) {
            BOOL bVerifyErr = NO;
            if (kHttpReturnCodeSuccess == responseData.resultCode) {
                ProductModelDes *product = [[ProductModelDes alloc]initWithDictionary:responseData.resultData];
                product.zz0018 = responseData.resultData[@"ZZ0018"];
                product.zz0017 = responseData.resultData[@"ZZ0017"];
                errStr = [self handleVerifyResult:product];
                bVerifyErr = ![Util isEmptyString:errStr];
            }else if (kHttpReturnCodeRecordNotExists == responseData.resultCode){
                bVerifyErr = YES;
            }
            if (bVerifyErr) { //校验失败(不匹配或不存在)，查询机型
                _product_model = nil;
                _isAdjusted = YES;
                [self setVerifyButtonOperationType:kPerformOrderVerifyButtonOpertationTypeSearch];
                [self reloadTableView];
            }
        }
        [Util showToast:errStr];
    }];
}

- (void)specialPerformButtonClicked:(UIButton*)button
{
    SpecialFinishEntry *specialFinish = [SpecialFinishEntry new];
    [specialFinish gotoSpecialPerformVCByOrderDetails:self.orderDetails orderListVc:self.orderListViewController fromVc:self];
}

- (void)jdIdentifyButtonClicked:(UIButton*)sender
{
    _loadPicMgr = [[SystemPicture alloc]initWithDelegate:self baseViewController:self];
    [_loadPicMgr startSelect];
}

- (NSString*)checkAdjustMachineInfos
{
    NSString *invalidStr;
    NSString *machineCode;
    
    do {
        if (self.orderDetails.isAirConditioning) {
            machineCode = [Util defaultStr:self.innerMachineCodeCell.textField.text ifStrEmpty:self.machineCodeCell.textField.text];
            if ([Util isEmptyString:machineCode]) {
                invalidStr = @"请输入空调机号";
                break;
            }
        }else {
            machineCode = self.machineCodeCell.textField.text;
            if ([Util isEmptyString:machineCode]) {
                invalidStr = @"请输入机号";
                break;
            }
        }
    } while (NO);

    return invalidStr;
}

//校验
- (void)verifyMachineModel
{
    NSString *invalidStr = [self checkAdjustMachineInfos];
    
    if ([Util isEmptyString:invalidStr]) {
        [self adjustMachineInfo];
    }else {
        [Util showToast:invalidStr];
    }
}

//模糊查询
- (void)findMachineModel
{
    ProductModelSearchViewController *modelSearchVc = [[ProductModelSearchViewController alloc]init];
    modelSearchVc.modelSelectedBlock = ^(ViewController* viewController, ProductModelDes *model){
        [self handlefindMachineModelResult:model];
        [viewController popViewController];
    };
    [self pushViewController:modelSearchVc];
}

- (void)verifyButtonCellClicked:(UIButton*)sender
{
    kPerformOrderVerifyButtonOpertationType type = (kPerformOrderVerifyButtonOpertationType)sender.tag;
    if (type == kPerformOrderVerifyButtonOpertationTypeVerfify) {
        [self verifyMachineModel];
    }else if(type == kPerformOrderVerifyButtonOpertationTypeSearch){
        [self findMachineModel];
    }
}

- (void)maintenancePeriodSegmentChanged:(UISegmentedControl*)segment
{
    _isExpired = [self.warrantyCell.selectedItemKey isEqualToString:@"20"];

    [self reloadTableView];
}

- (void)isCompletedSegmentChanged:(UISegmentedControl*)segment
{
    if (segment.selectedSegmentIndex == 0) { //完工
        BOOL orderUnfinfished = [self.orderDetails.status isEqualToString:@"SR45"];
        //如果之前做过未完工操作，现在去完工的话，则需要重新校验
        if (_needToAdjust && orderUnfinfished && !_isAdjusted) {
            _product_model = nil;
            [self setVerifyButtonOperationType:kPerformOrderVerifyButtonOpertationTypeVerfify];
        }
        _unfinishNoteStr = self.textView.text;
        self.textView.text = _finishedNoteStr;
    }else { //未完工
        _finishedNoteStr = self.textView.text;
        self.textView.text = _unfinishNoteStr;
    }

    [self reloadTableView];
}

- (void)manageFeeOrderList:(void (^)(BOOL manageFinished))manageBlock showWaiting:(BOOL)showWaiting
{
    BOOL bFinish = !self.unfinished; //是否完工操作
    BOOL bExpired = _isExpired; //是否保外
    BOOL bSelfCreate = self.user.isCreate; //是否自建
    
    if (showWaiting) {
        [Util showWaitingDialog];
    }
    [self queryFeeOrderStatus:^(NSError *error, HttpResponseData *responseData) {
        if (showWaiting) {
            [Util dismissWaitingDialog];
        }

        BOOL manageFinished = NO;

        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            NSInteger notSendToCrmCount = [[responseData.resultData objForKey:@"bwNotSendToCrmCount"]integerValue];
            NSInteger sendToCrmCount = [[responseData.resultData objForKey:@"bwSendToCrmCount"]integerValue];

            BOOL billSyncFinished = (0 == notSendToCrmCount);
            BOOL bHasBillItem = (notSendToCrmCount > 0 || sendToCrmCount > 0);

            if (bFinish) {
                if (bExpired) {
                    if (bSelfCreate) {
                        if (bHasBillItem) {
                            if (!billSyncFinished) {
                                //同步
                                [self confirmGoToFeeOrderListPage:@"费用管理中有未同步项，是否现在去同步?"];
                            }else {
                                manageFinished = YES;
                            }
                        }else {
                            [self confirmGoToFeeOrderListPage:@"完工时，需要添加费用项，是否现在去添加?"];
                        }
                    }else{
                        if (bHasBillItem) {
                            if (!billSyncFinished) {
                                [self confirmGoToFeeOrderListPage:@"费用管理中有未同步项，是否现在去同步?"];
                            }else {
                                manageFinished = YES;
                            }
                        }else {
                            manageFinished = YES;
                        }
                    }
                }else{
                    if (bHasBillItem) {
                        //确认并进入费用管理页面清除费用
                        [self confirmGoToFeeOrderListPage:@"非保外时，不允许添加费用项，是否现在去删除?"];
                    }else {
                        //执行完工
                        manageFinished = YES;
                    }
                }
            }else{
                if (bHasBillItem) {
                    //确认并进入费用管理页面清除费用
                    [self confirmGoToFeeOrderListPage:@"未完工时，不允许添加费用项，是否现在去删除?"];
                }else {
                    //执行未完工
                    manageFinished = YES;
                }
            }
        }else{
            [Util showErrorToastIfError:responseData otherError:error];
        }
        manageBlock(manageFinished);
    }];
}

- (void)confirmGoToFeeOrderListPage:(NSString*)message
{
    [Util confirmAlertView:nil message:message confirmTitle:@"现在" cancelTitle:@"稍后" confirmAction:^{
        [self gotoPriceListViewController:kPriceManageTypeService];
    }];
}

- (void)confirmButtonClicked:(id)sender
{
    FinishBillInputParams *input = [self readFinishBillInputParams];
    NSString *invalidDataStr = [self checkFinishBillInputParams:input];
    if (nil == invalidDataStr) {
        [self manageFeeOrderList:^(BOOL manageFinished) {
            if (manageFinished) {
                [self requestFinishBill:input];
            }
        } showWaiting:YES];
    }else {
        [Util showToast:invalidDataStr];
    }
}

- (void)mainCodeButtonClicked:(UIButton*)sender
{
    [ScanGraphicCodeViewController fastScanWithComplete:^(NSString *codeText) {
        _mainCodeStr = [codeText copy];
        self.machineCodeCell.textField.text = _mainCodeStr;
        _isAdjusted = NO;
        [self autoSetVerifyButtonOpertionType];
    } fromViewController:self];
}

- (void)innerMachineCodeButtonClicked:(UIButton*)sender
{
    [ScanGraphicCodeViewController fastScanWithComplete:^(NSString *codeText) {
        _innerMachineCodeStr = [codeText copy];
        self.innerMachineCodeCell.textField.text = _innerMachineCodeStr;
        _isAdjusted = NO;
        [self autoSetVerifyButtonOpertionType];
    } fromViewController:self];
}

- (void)supportButtonClicked:(UIButton*)sender
{
    ApplySupportViewController *supporterListVc = [[ApplySupportViewController alloc]init];
    supporterListVc.orderId = self.orderDetails.object_id.description;
    supporterListVc.title = @"申请技术支持";
    supporterListVc.delegate = self;
    
    [self pushViewController:supporterListVc];
}

- (ProductModelDes*)makeProductModelDesByContentDetails:(OrderContentDetails*)details
{
    ProductModelDes *product = [ProductModelDes new];
    product.product_id = details.zzfld00000q;
//    product.short_text = _adjustedProductInfo.short_text;
    product.zzfld000003 = [MiscHelper productTypeCodeForValue:self.orderDetails.zzfld000003];
    product.zz0018 = [MiscHelper productBrandCodeForValue:self.orderDetails.zzfld000000];
    product.zz0017 = [MiscHelper productCategoryCodeForValue:self.orderDetails.zzfld000001];

    return product;
}

- (void)feeMgrButtonClicked:(UIButton*)sender
{
    if ([Util isEmptyString:self.productCell.brandItem.key]
        || [Util isEmptyString:self.productCell.typeItem.key]) {
        [Util showToast:@"请先确定品牌和品类"];
    }else if (_bFeeListSynching){
        [Util showToast:@"数据同步中，请稍后再试"];
    }else {
        [self gotoPriceListViewController:(kPriceManageType)sender.tag];
    }
}

- (void)smartSellButtonClicked:(UIButton*)sender
{
    [self gotoPriceListViewController:(kPriceManageType)sender.tag];
}

- (void)gotoPriceListViewController:(kPriceManageType)type
{
    PriceListViewController *listVc = [[PriceListViewController alloc]init];
    listVc.orderObjectId = self.orderDetails.object_id.description;
    listVc.orderKeyId = self.orderDetails.Id.description;
    listVc.brandCode = self.productCell.brandItem.key;
    listVc.categoryCode = self.productCell.typeItem.key;
    listVc.feeManageType = type;
    listVc.title = getPriceManageTypeStr(type);
    
    [self pushViewController:listVc];
}

- (void)deviceMaintainButtonClicked:(UIButton*)sender
{
    ProductModelDes *product;
    NSString *invalidStr;

    do {
        product = [ProductModelDes new];
        product.product_id = _product_model;
        product.zz0018 = self.productCell.brandItem.key;
        product.zzfld000003 = self.productCell.productItem.key;
        product.zz0017 = self.productCell.typeItem.key;

        if ([Util isEmptyString:product.zz0018]) {
            invalidStr = @"品牌不能为空";
            break;
        }

        if ([Util isEmptyString:product.zz0017]) {
            invalidStr = @"品类不能为空";
            break;
        }

        if ([Util isEmptyString:product.product_id]) {
            invalidStr = @"请先校验机号或查询机型";
            break;
        }

        //push
        AddComponentMaintainViewController *maintainVc = [[AddComponentMaintainViewController alloc]init];
        maintainVc.title = @"备件维护";
        maintainVc.delegate = self;
        maintainVc.orderDetails = self.orderDetails;
        maintainVc.productInfo = product;
        maintainVc.components = self.orderDetails.tDispatchParts;
        [self pushViewController:maintainVc];
        return;
    } while (NO);

    if (![Util isEmptyString:invalidStr]) {
        [Util showToast:invalidStr];
    }
}



- (void)valueAddedServiceSwithChanged:(UISwitch*)switchView
{
    [self reloadTableView];
}

- (void)extendContractSwithChanged:(UISwitch*)switchView
{
    [self reloadTableView];
}

- (void)machineComponCellAddButtonClicked:(id)sender
{
    [self addNewMachineComponEditCellToTail];
    [self reloadTableView];
}

- (void)machineComponCellDeleteButtonClicked:(id)sender
{
    if (self.machineComponCellArray.count > 1) {
        [self removeLastMachineComponEditCell];
        [self reloadTableView];
    }else {
        [Util showToast:@"无法继续删除"];
    }
}

- (BOOL)checkIfNeedToAdjust
{
    return [self.orderDetails.zzfld000003 isEqualToString:@"彩电"];
}

- (FinishBillInputParams*)readFinishBillInputParams
{
    FinishBillInputParams *input = [FinishBillInputParams new];
    BOOL isMainMachineCodeScan = YES;
    BOOL isInnerMachineCodeScan = YES;  //空调内机号

    input.object_id = [self.orderDetails.object_id description];
    input.repairmanid = self.user.userId;
    if (self.unfinished) {
        input.failid = self.unCompleteReasonCell.checkedItem.key;
    }
    if (!_isNewMachine) {
        input.faultexpression = _issueSubTypeItem.key;
    }
    input.repairdescribe = self.solutionCell.checkedItem.key;
    input.machinemodel = [self.machineCodeCell.textField.text uppercaseString];
    input.machinemodel2 = [self.innerMachineCodeCell.textField.text uppercaseString];

    if (nil != input.machinemodel && ![input.machinemodel isEqualToString:[_mainCodeStr uppercaseString]]) {
        isMainMachineCodeScan = NO;
    }
    if (nil != input.machinemodel2 && ![input.machinemodel2 isEqualToString:[_innerMachineCodeStr uppercaseString]]) {
        isInnerMachineCodeScan = NO;
    }
    input.isscancode = [NSString intStr:(isInnerMachineCodeScan && isMainMachineCodeScan) ? 1 : 0];

    //set with 0
    input.isscancode = @"0";

    input.brand = self.productCell.brandItem.key;
    input.category = self.productCell.typeItem.key;
    input.buytime = [NSString dateStringWithDate:self.purchaseDateCell.date strFormat:WZDateStringFormat10];
    input.zzfld00000m = self.eOrderIdCell.textField.text;
    input.type = self.warrantyCell.selectedItemKey;
    input.name = self.nameCell.textField.text;
    input.user_phone = self.telEditCell.textField.text;
    input.street = _clientStreet.value;
    input.detailedaddress = self.detailAddressCell.textField.text;
    input.increasebusiness = [self readAdditionalBusinessItemsFromCell];
    input.sparepart = nil;//备件， 逗号分隔
    input.isturnovercontract = [NSString intStr:self.extendContractSwith.isOn ? 1 : 0];
    if (self.extendContractSwith.isOn) {
        input.contractno = self.contractNoCell.textField.text;
        input.turnoverreason = self.contactTypeCell.checkedItem.key;
        input.warrantytime = self.extendTimeCell.checkedItem.key;
        input.bugprice = self.machinePriceCell.textField.text;
        input.pricerange = self.machinePriceRangeCell.checkedItem.key;
        input.note = self.contractNote.text;
    }
    input.state = [NSString intStr:(0 == _isCompletedSegment.selectedSegmentIndex) ? 0 : 1];
    input.memo = self.textView.text;
    input.zzfld00002r = self.jdIdentifyResultCell.checkedItem.key;
    input.product_id = _product_model;
    input.zzfld00005y = self.issueHandleWayCell.textView.text;

    input.zzfld0000 = [Util defaultStr:nil ifStrEmpty:self.promotionCell.checkedItemKey];
    input.zzfld0001 = [Util defaultStr:nil ifStrEmpty:self.promotionSubCell.checkedItemKey];
    input.weChatVisit = (!self.unfinished && self.weixinCommentSwitch.isOn) ? @"1":@"0";
    if ([input.weChatVisit isEqualToString:@"1"]) {
        input.isDemonstrate = self.showTVFeaturesSwitch.isOn ? @"1" : @"0";
        input.isIntroduce = self.showACFeaturesSwitch.isOn ? @"1" : @"0";
    }
    return input;
}

- (NSString*)readAdditionalBusinessItemsFromCell
{
    ReturnIf(!self.valueAddedServiceSwith.isOn)nil;

    NSMutableArray *itemsArray = [NSMutableArray new];

    for (MachineComponEditCell *cell in self.machineComponCellArray) {
        ReturnIf(![Util isEmptyString:[cell checkInput]])nil;
        [itemsArray addObject:[NSDictionary dictionaryFromPropertyObject:cell.additonalItem]];
    }
    return [NSString jsonStringWithArray:itemsArray];
}

/**
 *  检查是否需要机号
 *  完工时：都需要机号
 *  未完工时：空调或长虹/启客的彩电需要，其它则选填
 *
 *  @param input 待提交的数据
 *
 *  @return bool
 */
- (BOOL)checkIfNeedMachineNo:(FinishBillInputParams*)input
{
    BOOL bFinishWork = [input.state isEqualToString:@"0"];
    
    if (bFinishWork) {
        return YES;
    }else{
        if (self.orderDetails.isAirConditioning || _needToAdjust) {
            return YES;
        }else{
            return NO;
        }
    }
}

/**
 * 检查机型是否必填，非三洋彩电完工时都必填，未完工时选填，三洋彩电完工则按以下规则判定：
 * 保外完工，处理措施为上门服务(Z080)、拉修服务(Z090)、移机(Z110)，必填；
 * 非保外完工，措施为上门调试(Z050)、上门服务(Z080)、拉修服务(Z090)和移机(Z110)必填
 *  @param input 待提交的数据
 *  @return 是否需要机型必填
 */
- (BOOL)checkIfNeedMachineModel:(FinishBillInputParams*)input
{
    BOOL bFinishWork = [input.state isEqualToString:@"0"];
    kProductType productType = [MiscHelper getProductTypeByBrand:self.productCell.brandItem.key product:self.productCell.productItem.key categroy:self.productCell.typeItem.key];
    
    if (bFinishWork) {
        if (kProductTypeSanYoTV == productType) {
            NSArray *solutions;
            if ([input.type isEqualToString:[NSString intStr:kWarrantyDateRangeExpired]]) { //保外
                solutions = @[@"Z080",@"Z090",@"Z110"];
            }else {
                solutions = @[@"Z050",@"Z080",@"Z090",@"Z110"];
            }
            return [input.repairdescribe isEqualOneInArray:solutions];
        }else {
            return YES;
        }
    }else {
        return NO;
    }
}

- (NSString*)checkFinishBillInputParams:(FinishBillInputParams*)input
{
    NSString *invalidStr;
    do {
        ReturnIf(!_isSignin)@"请先进行签到";
        ReturnIf(_isJDOrder && !_jd_commited)@"请先提交京东故障单";

        ReturnIf([Util isEmptyString:input.brand])@"请先确定品牌";
        ReturnIf([Util isEmptyString:input.category])@"请先确定品类";
        
        //机号必填时，或不必填但已输入机号时，则需要检查机号正确性
        if ([self checkIfNeedMachineNo:input]
            || ![Util isEmptyString:input.machinemodel]
            || ![Util isEmptyString:input.machinemodel2]) {
            invalidStr = [self isValidMachineCode:input];
            BreakIf(![Util isEmptyString:invalidStr]);
        }

        ReturnIf ([Util isEmptyString:input.buytime])@"请填写购机时间";
        ReturnIf([self.purchaseDateCell.date isLaterThanDate:[NSDate date]])@"购机时间不能晚于当前时间";

        //检查机型是否必填
        if ([self checkIfNeedMachineModel:input]) {
            if (_needToAdjust && !_isAdjusted) {
                return @"请先校验机号";
            }else {
                invalidStr = [NSString stringWithFormat:@"请先%@",[self.verifyButton titleForState:UIControlStateNormal]];
                ReturnIf([Util isEmptyString:input.product_id])invalidStr;
                invalidStr = nil;
            }
        }

        ReturnIf([Util isEmptyString:input.type])@"请选择产品质保";
        ReturnIf([Util isEmptyString:input.name])@"请输入用户名";
        ReturnIf([Util isEmptyString:input.user_phone])@"请输入用户电话";
        ReturnIf([Util isEmptyString:input.street])@"请选择街道";
        ReturnIf([Util isEmptyString:input.detailedaddress])@"请输入地址";
        if (0 == _isCompletedSegment.selectedSegmentIndex) { //完工
            ReturnIf([Util isEmptyString:input.repairdescribe])@"请选择处理措施";
            
            if ([self needToSetIssueHandleWay]) {
                ReturnIf([Util isEmptyString:input.zzfld00005y])@"请填写故障处理方式描述";
            }

            if (!_isNewMachine && [Util isEmptyString:input.faultexpression]) {
                return @"故障代码不能为空";
            }
            //weixin comment
            if ([input.weChatVisit isEqualToString:@"1"]) {
                //保内和延保：设备照片1，发票照片必填
                if ([input.type isEqualOneInArray:@[@"10", @"30"]]) {
                    ReturnIf([Util isEmptyString:self.devicePicture1Cell.pictureLoader.pictureUrlInQiniu])@"请上传设备照片1";
                    ReturnIf([Util isEmptyString:self.invoicePictureCell.pictureLoader.pictureUrlInQiniu])@"请上传发票照片";
                }else {
                    //保外：设备照片1必填
                    if ([input.type isEqualOneInArray:@[@"20"]]) {
                        ReturnIf([Util isEmptyString:self.devicePicture1Cell.pictureLoader.pictureUrlInQiniu])@"请上传设备照片1";
                    }
                }
            }
        }else{ //未完工
            ReturnIf([Util isEmptyString:input.failid])@"请选择未完工原因";
            if ([input.failid isEqualToString:@"Z070"]) {
                //未完工原因为备件时，必须要有备件
                if (nil == self.orderDetails.tDispatchParts || self.orderDetails.tDispatchParts.count <= 0) {
                    return @"未完工原因选择了“备件”，必须先维护备件";
                }
            }
            ReturnIf([Util isEmptyString:input.memo])@"请填写未完工备注";
        }
        ReturnIf((!_canFinish && !self.unfinished))@"备件维护未完成，不能提交";
    } while (0);
    return invalidStr;
}

- (void)pushToCheckListVcToSelectStreet
{
    _streetCheckViewController = [MiscHelper pushToCheckListViewController:@"选择乡、镇或街道" checkItems:_streets checkedItem:_clientStreet from:self delegate:self];
}

- (void)requestStreetInfos
{
    StreetListInputParams *input = [StreetListInputParams new];
    input.regiontxt = self.orderDetails.regiontxt;
    input.city1 = self.orderDetails.city1;
    input.city2 = self.orderDetails.city2;
    input.street = self.orderDetails.street;

    [Util showWaitingDialog];
    [self.httpClient getStreetInfos:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            _streets = [MiscHelper parserStreetItems:responseData.resultData];
            [self pushToCheckListVcToSelectStreet];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)requestFinishBill:(FinishBillInputParams*)input
{
    BOOL weixinComment = [input.state isEqualToString:@"0"] && [input.weChatVisit isEqualToString:@"1"];

    [Util showWaitingDialog];
    [self.httpClient repairFinishBill:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error) {
            NSString *promptStr = [Util getErrorDescritpion:responseData otherError:error];
            if (kHttpReturnCodeSuccess == responseData.resultCode) {
                promptStr = @"提交成功";
            }
            switch (responseData.resultCode) {
                case kHttpReturnCodeSuccess:
                case kHttpReturnCodeChangedAssign:
                    [self postNotification:NotificationOrderChanged];
                    if (weixinComment) {
                        [self pushToWexinCommentQrCodeViewController];
                    }else {
                        [self popViewController];
                    }
                    break;
                case kHttpReturnCodeSyncWeixinError:
                case kHttpReturnCodeRequestWeixinError:
                    if (weixinComment) {
                        [self postNotification:NotificationOrderChanged];
                        [Util showToast:responseData.resultInfo];
                        [MiscHelper popToLatestListViewController:self];
                    }
                    break;
                default:
                    break;
            }
            [Util showToast:promptStr];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)pushToWexinCommentQrCodeViewController
{
    WeixinCommentQrCodeViewController *commentVc;
    commentVc = [[WeixinCommentQrCodeViewController alloc]init];
    commentVc.orderId = self.orderId;
    [self pushViewController:commentVc];
}

- (void)applySupportViewController:(ApplySupportViewController*)viewController select:(EmployeeInfo*)supporter
{
    _isSupported = YES;

    [self.supportButton setTitle:supporter.supportman_name forState:UIControlStateNormal];
    self.supportButton.enabled = NO;
    [self.tableView.tableView reloadTableViewCell:self.supportCell];

    [viewController popViewController];
}

- (void)addComponentMaintainFinished:(AddComponentMaintainViewController*)viewController updated:(NSArray *)components
{
    self.orderDetails.tDispatchParts = [[NSMutableArray alloc]initWithArray:components];
    _canFinish = ![MiscHelper checkIsPartsAffectFinishOrder:components];
}

- (void)systemPicture:(SystemPicture*)object pickingImage:(UIImage*)image
{
    if ([Util isEmptyString:self.orderDetails.imageuploadpath]) {
        [Util showToast:@"未知上传路径"];
        return;
    }

    //上传鉴定图片
    [self.httpClient uploadImage:image toPath:self.orderDetails.imageuploadpath response:^(NSError *error, HttpResponseData *responseData) {
        BOOL bSuccess = !error && kHttpReturnCodeSuccess == responseData;
        [self commitJdIdentifyUploadimageStatus:bSuccess];
    }];
}

- (void)commitJdIdentifyUploadimageStatus:(BOOL)bUploaded
{
    //鉴定状态提交
    JdIdentifyImageUploadStatusInputParams *input = [JdIdentifyImageUploadStatusInputParams new];
    input.objectId = self.orderDetails.object_id;
    input.isupload = bUploaded ? @"1" : @"0";
    __weak PerformOrderViewController *weakSelf = self;
    [self.httpClient setJdIdentifyImageUploadStatus:input response:^(NSError *error, HttpResponseData *responseData) {
        weakSelf.jd_commited = (!error && kHttpReturnCodeSuccess == responseData);
        NSString *tempStr = [NSString stringWithFormat:@"京东故障单上传%@",weakSelf.jd_commited ? @"成功":@"失败"];
        [weakSelf.jdIdentifyButton setTitle:tempStr forState:UIControlStateNormal];
    }];
}

- (NSString *)isValidChangHongAirConditionCode:(NSString*)barCode
{
    NSString *invalidInfo;
    
    do {
        if ([Util isEmptyString:barCode]) {
            invalidInfo = @"不能为空";
            break;
        }
        // 1.空调类产品机号只有16位和24位
        if (!(barCode.length == 16 || barCode.length == 24)) {
            invalidInfo = @"位数不对";
            break;
        }

        // 2.空调类产品不能出现8个相同连续字符
        if ([self contain8orMoreSameCharactors:barCode]){
            invalidInfo = @"不能有8个连续的字符相同";
            break;
        }
        
        // 3.KYD开头的机号不做校验
        if (![barCode hasPrefix:@"KYD"]) {
            // 4.空调产品24位机号第二位产品线校验为：3
            if (barCode.length == 24
                && [barCode characterAtIndex:1] != '3') {
                invalidInfo = @"格式不正确";
                break;
            }
        }
    } while (0);

    return invalidInfo;
}

- (NSString*)isValidMachineCode:(FinishBillInputParams*)bill
{
    kProductType productType = [MiscHelper getProductTypeByBrand:self.productCell.brandItem.key product:self.productCell.productItem.key categroy:self.productCell.typeItem.key];

    switch (productType) {
        case kProductTypeChangHongTV: //长虹电视
        case kProductTypeChiqTV: //长虹启客电视
        case kProductTypeChangHongAirConditioning: //长虹空调
        case kProductTypeChiqAirConditioning: //长虹启客空调
            return [self checkIsValidChangHongMachineCode:bill];
        case kProductTypeSanYoTV: //三洋电视
            return [self checkIsValidSanYoTelevitionCode:bill];
        case kProductTypeYingYanAirConditioning: //迎燕空调
            return [self checkIsValidYingYanAirConditionCode:bill];
        case kProductTypeOther: //其它
            break;
        default:
            break;
    }
    return nil;
}

/**
 * 检查机号格式是否符合长虹(长虹、启客)品牌
 */
- (NSString*)checkIsValidChangHongMachineCode:(FinishBillInputParams*)bill
{
    NSString *invalidInfo;

    do {
        BreakIf(!_isBrandCH && !_isBrandCHIQ);

        if (self.orderDetails.isAirConditioning) {
            BOOL isFilledMainCode = ![Util isEmptyString:bill.machinemodel];
            BOOL isFilledInnerCode = ![Util isEmptyString:bill.machinemodel2];

            if (!isFilledMainCode && !isFilledInnerCode) {
                invalidInfo = @"请至少输入一个机号";
                break;
            }else {
                if (isFilledMainCode) {
                    invalidInfo = [self isValidChangHongAirConditionCode:bill.machinemodel];
                    if (![Util isEmptyString:invalidInfo]) {
                        invalidInfo = [NSString stringWithFormat:@"外机号%@",invalidInfo];
                        break;
                    }
                }
                if (isFilledInnerCode) {
                    invalidInfo = [self isValidChangHongAirConditionCode:bill.machinemodel2];
                    if (![Util isEmptyString:invalidInfo]) {
                        invalidInfo = [NSString stringWithFormat:@"内机号%@",invalidInfo];
                        break;
                    }
                }
            }
        }else if(self.orderDetails.isTV){
            invalidInfo = [MiscHelper isValidChangHongTelevitionCode:bill.machinemodel machineModel:self.productCell.typeItem.key];
        }
    } while (NO);
    return invalidInfo;
}

//三洋彩电
- (NSString*)checkIsValidSanYoTelevitionCode:(FinishBillInputParams*)bill
{
    BOOL isFilledMainCode = ![Util isEmptyString:bill.machinemodel];
    return (isFilledMainCode) ? nil : @"请输入机号";
}

//迎燕空调
- (NSString*)checkIsValidYingYanAirConditionCode:(FinishBillInputParams*)bill
{
    BOOL isFilledMainCode = ![Util isEmptyString:bill.machinemodel];
    BOOL isFilledExtCode = ![Util isEmptyString:bill.machinemodel2];

    return (isFilledExtCode || isFilledMainCode) ? nil : @"请至少输入一个机号";
}


// 判断机号是否有8个连续相同
- (BOOL)contain8orMoreSameCharactors:(NSString*)barCode
{
    unichar preCh, nextCh;
    NSUInteger linkCharCount = 0;
    for (NSInteger chIndex = 0; chIndex < barCode.length - 1; chIndex++) {
        preCh = [barCode characterAtIndex:chIndex];
        nextCh = [barCode characterAtIndex:chIndex + 1];
        linkCharCount = (preCh == nextCh) ? linkCharCount++ : 0;
        ReturnIf(linkCharCount >= 7) YES;
    }
    return NO;
}

- (void)autoSetVerifyButtonOpertionType
{
    if (_needToAdjust && ![Util isEmptyString:self.machineCodeCell.textField.text]) {
        [self setVerifyButtonOperationType:kPerformOrderVerifyButtonOpertationTypeVerfify];
    }else {
        [self setVerifyButtonOperationType:kPerformOrderVerifyButtonOpertationTypeSearch];
    }
}

- (void)setVerifyButtonOperationType:(kPerformOrderVerifyButtonOpertationType)type
{
    NSString *verfifyBtnTittle;
    BOOL enableBtn = YES;
    switch (type) {
        case kPerformOrderVerifyButtonOpertationTypeVerfify:
            verfifyBtnTittle = _isAdjusted ? @"机号已校验" : @"校验机号";
            enableBtn = !_isAdjusted;
            break;
        case kPerformOrderVerifyButtonOpertationTypeSearch:
            verfifyBtnTittle = @"查询机型";
//            _isAdjusted = NO;
            break;
        default:
            break;
    }
    [self.verifyButton setTitle:verfifyBtnTittle forState:UIControlStateNormal];
    self.verifyButton.tag = type;
    self.verifyButton.enabled = enableBtn;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    if (textField == self.machineCodeCell.textField
        && _needToAdjust){
        _isAdjusted = NO;
        [self autoSetVerifyButtonOpertionType];
    }
}

- (void)typeItemSelectValueChanged:(ProductSelectCell*)cell value:(KeyValueModel*)typeItem{
    //品类改变后，原来的机型就没用了

    _product_model = nil;
    [self reloadTableView];
    [self brandOrCategoryValueChanged];
}

- (void)promotionActivityDetailButtonClicked:(UIButton*)sender
{
    NSString *contentCode = self.promotionSubCell.checkedItem.key;
    if (![Util isEmptyString:contentCode]) {
        [self readPromontionActivityDetail:contentCode];
    }else {
        [Util showToast:@"请选择活动内容"];
    }
}

- (void)readPromontionActivityDetail:(NSString*)contentCode
{
    if (![Util isEmptyString:contentCode]) {
        [Util showWaitingDialog];
        [self requestPromontionActivityDetail:contentCode response:^(NSError *error, HttpResponseData *responseData) {
            [Util dismissWaitingDialog];
            
            NSString *contentDetail;
            if (nil == error && kHttpReturnCodeSuccess == responseData.resultCode) {
                contentDetail = [responseData.resultData objForKey:@"zzfld0001xq"];
                if (![Util isEmptyString:contentDetail]) {
                    [Util showAlertView:@"活动详情" message:contentDetail];
                }else {
                    [Util showToast:@"暂无活动详情"];
                }
            }else {
                [Util showErrorToastIfError:responseData otherError:error];
            }
        }];
    }
}

@end
