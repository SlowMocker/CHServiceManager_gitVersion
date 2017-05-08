//
//  LetvPerformOrderViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/5.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvPerformOrderViewController.h"
#import "TextViewCell.h"
#import "WZDatePickerView.h"
#import "ProductSelectCell.h"
#import "ButtonTableViewCell.h"
#import "TextSegmentTableViewCell.h"
#import "WZDateSelectCell.h"
#import "LetvProductModelSearchViewController.h"
#import "LetvApplySupportViewController.h"
#import "LetvPriceListViewController.h"
#import "IssueCodeFilterViewController.h"
#import "TextLabelCell.h"
#import "ScanGraphicCodeViewController.h"
#import "LetvSpecialPerformOrderViewController.h"

static NSInteger sHeaderLabelViewTag = 0x084230;

@interface LetvPerformOrderViewController ()<WZTableViewDelegate,WZSingleCheckViewControllerDelegate, UITextFieldDelegate, ProductSelectCellDelegate, ApplySupportViewControllerDelegate, PleaseSelectViewCellDelegate>
{
    CheckItemModel *_clientStreet;//提交时用value，接口只能取到VALUE，故key，value 相等
    KeyValueModel *_product_model;   //机型

    //选项数据
    NSArray *_warrantyItems; //质保期
    NSArray *_bearingWallItems; //承重墙类型
    NSArray *_rackFromLetvItems; //是否官方购买挂架
    NSArray *_installWayItems; //安装方式
    NSMutableArray *_isCompletedItems; //是否完工
    NSMutableArray *_isVipCardActiveItems; //是否激活卡

    NSArray *_networkTypes; //网络类型

    WZSingleCheckViewController *_streetCheckViewController;
    IssueCodeFilterViewController *_issueCodeFilterVc;
}

@property(atomic, assign)BOOL bFeeListSynching;//费用项正在同步中...
@property(nonatomic, assign)BOOL hasFeeItem;
@property(nonatomic, assign)BOOL isVipCardInactive;
@property(nonatomic, strong)CheckItemModel *selectIssueCodeModel;

@property(nonatomic, strong)LetvOrderContentDetails *orderDetails;

//custom sub views
@property(nonatomic, strong)ProductSelectCell *productCell; //产品信息
@property(nonatomic, strong)NormalSelectTableViewCell *machineModelSelCell;//机型
@property(nonatomic, strong)TextFieldTableViewCell *macAddressCell; //MAC地址
@property(nonatomic, strong)TextFieldTableViewCell *snNoCell;   //SN编号
@property(nonatomic, strong)WZDateSelectCell *purchaseDateCell; //购买日期
@property(nonatomic, strong)TextSegmentTableViewCell *warrantyCell;//质保期
@property(nonatomic, strong)TextSegmentTableViewCell *bearingWallCell;//承重墙类型
@property(nonatomic, strong)TextSegmentTableViewCell *rackFromLetvCell;//是否官方购买挂架
@property(nonatomic, strong)TextSegmentTableViewCell *installWayCell;//安装方式
@property(nonatomic, strong)PleaseSelectViewCell *networkSelCell;//家庭网络环境
@property(nonatomic, strong)TextFieldTableViewCell *receiptCell;   //发票
@property(nonatomic, strong)TextFieldTableViewCell *nameCell;   //姓名
@property(nonatomic, strong)TextLabelCell *addressCell;   //地址
@property(nonatomic, strong)TextFieldTableViewCell *detailAddressCell;  //详地址
@property(nonatomic, strong)TextFieldTableViewCell *telEditCell;    //电话
@property(nonatomic, strong)UITableViewCell *supportCell;//技术支持
@property(nonatomic, strong)UITableViewCell *feeMgrCell; //费用管理
@property(nonatomic, strong)UITableViewCell *smartSellCell; //智能销售管理
@property(nonatomic, strong)TextSegmentTableViewCell *isVipCardActiveCell;//会员卡是否激活
@property(nonatomic, strong)TextViewCell *cardInactiveReasonCell; //卡未激活原因
@property(nonatomic, strong)TextSegmentTableViewCell *isCompletedCell;//是否完工
@property(nonatomic, strong)TextViewCell *resolutionCell; //处理措施
@property(nonatomic, strong)PleaseSelectViewCell *level1StatusCell;//一级工单状态
@property(nonatomic, strong)PleaseSelectViewCell *level2StatusCell;//二级工单状态
@property(nonatomic, strong)TextViewCell *issueDesCell; //故障现象
@property(nonatomic, strong)TextViewCell *convertPartCell; //更换备件
@property(nonatomic, strong)TextViewCell *resolvedDesCell; //处理结果

//data model
@property(nonatomic, strong)TableViewDataHandle *sourceModel;

@end

@implementation LetvPerformOrderViewController

- (BOOL)isVipCardInactive{
    return (1 == self.isVipCardActiveCell.segment.selectedSegmentIndex);
}

- (TableViewDataHandle *)sourceModel{
    if (nil == _sourceModel) {
        _sourceModel = [[TableViewDataHandle alloc]init];
    }
    return _sourceModel;
}

#pragma mark - 视图创建

- (TextSegmentTableViewCell*)makeTextSegmentCellWithTitle:(NSString *)title
{
    TextSegmentTableViewCell *segCell = [super makeTextSegmentCellWithTitle:title];
    [segCell.segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    return segCell;
}

- (TextFieldTableViewCell*)makeLeftEditRightBarCodeBtnCell:(SEL)barCodeBtnClickAction hint:(NSString*)hintStr
{
    TextFieldTableViewCell *barCodeCell = [[TextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIButton *barCodeButton = [UIButton imageButtonWithNorImg:@"dealer_erweima" selImg:@"dealer_erweima" size:CGSizeMake(kPerformOrderViewCellLineHeight, kPerformOrderViewCellLineHeight) target:self action:barCodeBtnClickAction];
    [barCodeButton addLineTo:kFrameLocationLeft];
    
    barCodeCell.accessoryView = barCodeButton;
    barCodeCell.textField.placeholder = hintStr;
    
    return barCodeCell;
}

- (void)macAddressButtonClicked:(UIButton*)sender
{
    [ScanGraphicCodeViewController fastScanWithComplete:^(NSString *codeText) {
        self.macAddressCell.textField.text = codeText;
    } fromViewController:self];
}

- (void)snNoButtonClicked:(UIButton*)sender
{
    [ScanGraphicCodeViewController fastScanWithComplete:^(NSString *codeText) {
        self.snNoCell.textField.text = codeText;
    } fromViewController:self];
}

- (void)createCustomSubViews
{
    //产品信息
    _productCell = [[ProductSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _productCell.delegate = self;

    //机型
    _machineModelSelCell = [[NormalSelectTableViewCell alloc]initWithTitle:@"机型" reuseIdentifier:nil];
    [_machineModelSelCell addLineTo:kFrameLocationBottom];

    //MAC地址
    _macAddressCell = [self makeLeftEditRightBarCodeBtnCell:@selector(macAddressButtonClicked:) hint: @"MAC 地址（12 位）"];

    //SN编号
    _snNoCell = [self makeLeftEditRightBarCodeBtnCell:@selector(snNoButtonClicked:) hint: @"SN 编码 （19 位）"];

    //购买日期
    _purchaseDateCell = [[WZDateSelectCell alloc]initWithDate:nil baseViewController:self];
    _purchaseDateCell.textLabel.text = @"购买日期";

    //质保期
    _warrantyCell = [self makeTextSegmentCellWithTitle:@"产品质保"];
    
    //承重墙类型
    _bearingWallCell = [self makeTextSegmentCellWithTitle:@"是否承重墙"];
    
    //是否官方购买挂架
    _rackFromLetvCell = [self makeTextSegmentCellWithTitle:@"是否官方购买挂架"];
    
    //安装方式
    _installWayCell = [self makeTextSegmentCellWithTitle:@"安装方式"];
    
    //家庭网络环境
    _networkSelCell = [MiscHelper makePleaseSelectCell:@"家庭网络环境"];

    //发票
    _receiptCell = [self makeTextFieldCell:@"请输入发票号"];

    //姓名
    _nameCell = [self makeTextFieldCell:@""];
    _nameCell.textField.enabled = NO;
    _nameCell.textField.textColor = kColorLightGray;


    //地址
    _addressCell = [[TextLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _addressCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //详细地址
    _detailAddressCell = [self makeTextFieldCell:@"详细地址（栋,单元,号）"];

    //联系方式
    _telEditCell = [self makeTextFieldCell:@""];
    _telEditCell.textField.enabled = NO;
    _telEditCell.textField.textColor = kColorLightGray;

    //技术支持
    _supportCell = [self makeLeftTitleRightButtonCell:[UIButton orangeButton:@"申请"] action:@selector(supportButtonClicked:)];
    _supportCell.textLabel.text = @"技术支持";
    
    //费用管理
    _feeMgrCell = [self makeLeftTitleRightButtonCell:[UIButton orangeButton:@"费用管理"] action:@selector(feeMgrButtonClicked:)];
    _feeMgrCell.accessoryView.tag = kPriceManageTypeService;

    _feeMgrCell.textLabel.text = @"服务费用";
    
    //智能产品销售
    _smartSellCell = [self makeLeftTitleRightButtonCell:[UIButton orangeButton:@"销售费用管理"] action:@selector(smartSellButtonClicked:)];
    _smartSellCell.accessoryView.tag = kPriceManageTypeSells;
    _smartSellCell.textLabel.text = @"智能产品销售";

    //是否完工
    _isCompletedCell = [self makeTextSegmentCellWithTitle:@"是否完工"];
    
    //会员卡是否激活
    _isVipCardActiveCell = [self makeTextSegmentCellWithTitle:@"会员卡是否激活"];

    _level1StatusCell = [MiscHelper makePleaseSelectCell:@"一级工单状态"];
    NSArray *checkItems = [self.configInfoMgr letv_orderLevel1Statuses];
    checkItems = [Util convertConfigItemInfoArrayToCheckItemModelArray:checkItems];
    self.level1StatusCell.checkItems = checkItems;
    self.level1StatusCell.delegate = self;

    _level2StatusCell = [MiscHelper makePleaseSelectCell:@"二级工单状态"];
    self.level2StatusCell.delegate = self;

    _issueDesCell = [self makeTextViewCell:@"请输入故障现象" maxWords:60];
    _resolvedDesCell = [self makeTextViewCell:@"请输入处理结果" maxWords:350];
    _cardInactiveReasonCell = [self makeTextViewCell:@"请输入会员卡未激活原因" maxWords:30];
    _resolutionCell = [self makeTextViewCell:@"请输入处理措施" maxWords:30];
    _convertPartCell = [self makeTextViewCell:@"请输入更换备件名称" maxWords:20];
}

#pragma mark - 初始化视图数据

//初始化视图内容
- (void)setupInitDataToViews
{
    [self insertSegmentItems:_warrantyItems toSegment:self.warrantyCell segWidth:160];
    [self insertSegmentItems:_bearingWallItems toSegment:self.bearingWallCell segWidth:180];
    [self insertSegmentItems:_rackFromLetvItems toSegment:self.rackFromLetvCell segWidth:150];
    [self insertSegmentItems:_installWayItems toSegment:self.installWayCell segWidth:190];
    [self insertSegmentItems:_isCompletedItems toSegment:self.isCompletedCell segWidth:160];
    [self insertSegmentItems:_isVipCardActiveItems toSegment:self.isVipCardActiveCell segWidth:160];
    
    self.networkSelCell.checkItems = _networkTypes;
}

//初始化变量值
- (void)setupInitVariables
{
    KeyValueModel *model;
    NSArray *configItems;

    //质保期
    _warrantyItems = [self.configInfoMgr letv_warrantyItems];

    //承重墙类型
    _bearingWallItems = [self.configInfoMgr letv_bearingWallItems];

    //是否官方购买挂架
    _rackFromLetvItems = [self.configInfoMgr letv_rackFromLetvItems];

    //安装方式
    _installWayItems = [self.configInfoMgr letv_installWayItems];

    //是否完工,
    _isCompletedItems = [NSMutableArray new];
    model = [KeyValueModel modelWithValue:@"完工" forKey:@"0"];
    [_isCompletedItems addObject:model];
    model = [KeyValueModel modelWithValue:@"未完工" forKey:@"1"];
    [_isCompletedItems addObject:model];

    //是否激活卡
    _isVipCardActiveItems = [NSMutableArray new];
    model = [KeyValueModel modelWithValue:@"是" forKey:@"Y"];
    [_isVipCardActiveItems addObject:model];
    model = [KeyValueModel modelWithValue:@"否" forKey:@"N"];
    [_isVipCardActiveItems addObject:model];

    //网络类型
    configItems = [self.configInfoMgr letv_networkTypes];
    _networkTypes = [Util convertConfigItemInfoArrayToCheckItemModelArray:configItems];
}

- (NSString*)checkLetvFinishListInfos:(LetvFinishBillInputParams*)list
{
    BOOL isFinishOperation = [list.whetherCmpl isEqualToString:@"0"];

    //是否挂架安装
    BOOL bInstallWithPylons = [list.installWay isEqualToString:@"20"];

    //是否安装工单
    BOOL bInstallOrder = [list.serviceReqType isEqualToString:@"18"];

    //是否维修工单
    BOOL isRepairOrder = !bInstallOrder;

    //是否会员卡未激活
    BOOL isCardInactive = [list.vipCardActive isEqualToString:@"0"];

    do {
        ReturnIf(!_isSignin)@"请先进行签到";
        ReturnIf([Util isEmptyString:list.model])@"请选择机型";
        ReturnIf([Util isEmptyString:list.buyDate])@"请选择购买日期";
        ReturnIf([self.purchaseDateCell.date isLaterThanDate:[NSDate date]])@"购机时间不能晚于当前时间";
        ReturnIf(list.invoiceNum.length > 40)@"发票号不能大于40个字符";
        ReturnIf([Util isEmptyString:list.name])@"请填写用户姓名";
        ReturnIf([Util isEmptyString:list.phoneNum])@"请填写用户电话";
        ReturnIf(list.detailAddr.length > 80)@"详细地址不能大于80个字符";
        ReturnIf([Util isEmptyString:list.whetherCmpl])@"请选择是否完工项";
        ReturnIf([Util isEmptyString:list.statusL1])@"请选择一级工单状态";
        ReturnIf([Util isEmptyString:list.statusL2])@"请选择二级工单状态";
        ReturnIf([Util isEmptyString:list.faultCode])@"请选择故障代码";
        ReturnIf([Util isEmptyString:list.faultDesc])@"请填写故障现象";
        ReturnIf([Util isEmptyString:list.handleResult])@"请填写处理结果";
        if (bInstallWithPylons) {
            ReturnIf([Util isEmptyString:list.isBearingWall])@"请选择是否承重墙";
            ReturnIf([Util isEmptyString:list.isBuyRack])@"请选择是否官方购买挂架";
        }
        if (isCardInactive) {
            ReturnIf([Util isEmptyString:list.notActiveCause])@"请填写会员卡未激活原因";
        }
        if (![Util isEmptyString:list.macAddress]) {
            ReturnIf(list.macAddress.length != 12)@"请填写12位MAC编号";
        }
        if (![Util isEmptyString:list.snCode]) {
            ReturnIf(list.snCode.length != 19)@"请填写19位SN编码";
        }
        if (isFinishOperation) { //完工
            if (self.hasFeeItem) { //有费用项
                ReturnIf([Util isEmptyString:list.category])@"请选择品类";
                ReturnIf([Util isEmptyString:list.securityLabe])@"请选择产品质保";
                ReturnIf([Util isEmptyString:list.installWay])@"请选择安装方式";
                ReturnIf([Util isEmptyString:list.isBearingWall])@"请选择是否承重墙";
                ReturnIf([Util isEmptyString:list.isBuyRack])@"请选择是否官方购买挂架";
            }
            ReturnIf([Util isEmptyString:list.macAddress])@"请填写MAC编号";
            ReturnIf([Util isEmptyString:list.snCode])@"请填写SN编码";
            if (bInstallOrder) {
                ReturnIf([Util isEmptyString:list.vipCardActive])@"请选择会员卡激活项";
            }
            if (isRepairOrder) {
                ReturnIf([Util isEmptyString:list.faultHandling])@"请填写处理措施";
            }
        }
    } while (0);
    
    return nil;
}

- (LetvFinishBillInputParams*)readLetvFinishListInfos
{
    LetvFinishBillInputParams *list = [LetvFinishBillInputParams new];
    
    list.objectId = self.orderDetails.objectId.description;
    list.repairManId = self.user.userId;
    
    list.serviceReqType = self.orderDetails.serviceReqType;
    list.brand = self.productCell.brandItem.key;
    list.productType = self.productCell.productItem.key;
    list.category = self.productCell.typeItem.key;
    list.model = _product_model.key;
    list.macAddress = self.macAddressCell.textField.text;
    list.snCode = self.snNoCell.textField.text;
    list.buyDate = [NSString dateStringWithDate:self.purchaseDateCell.date strFormat:WZDateStringFormat10];

    list.securityLabe = self.warrantyCell.selectedItemKey;
    list.installWay = self.installWayCell.selectedItemKey;
    list.isBearingWall = self.bearingWallCell.selectedItemKey;
    list.isBuyRack = self.rackFromLetvCell.selectedItemKey;
    list.network = self.networkSelCell.checkedItemKey;
    list.invoiceNum = self.receiptCell.textField.text;
    list.name = self.nameCell.textField.text;
    list.street = _clientStreet.value;
    list.detailAddr = self.detailAddressCell.textField.text;
    list.phoneNum = self.telEditCell.textField.text;
    list.vipCardActive = self.isVipCardActiveCell.selectedItemKey;
    list.notActiveCause = self.cardInactiveReasonCell.textView.text;
    list.whetherCmpl = self.isCompletedCell.selectedItemKey;
    list.faultHandling = self.resolutionCell.textView.text;
    list.statusL1 = self.level1StatusCell.checkedItemKey;
    list.statusL2 = self.level2StatusCell.checkedItemKey;
    list.faultCode = self.selectIssueCodeModel.key;
    list.faultDesc = self.issueDesCell.textView.text;
    list.replPartsName = self.convertPartCell.textView.text;
    list.handleResult = self.resolvedDesCell.textView.text;
    
    return list;
}

- (void)submitLetvFinishListInfos:(LetvFinishBillInputParams*)input
{
    [Util showWaitingDialog];
    [self.httpClient letv_repairFinishBill:input response:^(NSError *error, HttpResponseData *responseData) {
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
                    [self popViewController];
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

//requestCallBackBlock param 3 type NSNumber* (total fee item count)
- (void)getFeeItemCountWithResponse:(RequestCallBackBlockV2)requestCallBackBlock
{
    LetvGetFeeItemCountInputParams *input = [LetvGetFeeItemCountInputParams new];
    input.objectId = self.orderId;
    [self.httpClient letv_getFeeItemCount:input response:^(NSError *error, HttpResponseData *responseData) {
        NSInteger totalFeeItemCount = 0;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            NSInteger fwNotSendToCrmCount = [[responseData.resultData objForKey:@"fwNotSendToCrmCount"]integerValue];
            NSInteger fwSendToCrmCount = [[responseData.resultData objForKey:@"fwSendToCrmCount"]integerValue];
            totalFeeItemCount = fwNotSendToCrmCount + fwSendToCrmCount;
        }
        requestCallBackBlock(error, responseData, @(totalFeeItemCount));
    }];
}

- (void)confirmButtonClicked:(id)sender
{
    //get fee item count before going to submit order list

    [Util showWaitingDialog];
    [self getFeeItemCountWithResponse:^(NSError *error, HttpResponseData *responseData, id extData) {
        [Util dismissWaitingDialog];

        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            NSNumber *totalFeeItemCount = (NSNumber*)extData;
            self.hasFeeItem = [totalFeeItemCount integerValue] > 0;
            [self gotoSubmitLetvFinishListInfos];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)gotoSubmitLetvFinishListInfos
{
    LetvFinishBillInputParams *list = [self readLetvFinishListInfos];
    NSString *invalid = [self checkLetvFinishListInfos:list];
    if (nil == invalid) {
        BOOL isFinishOp = [list.whetherCmpl isEqualToString:@"0"];
        if (isFinishOp && self.hasFeeItem <= 0) {
            [Util confirmAlertView:nil message:@"您还没有维护服务费用，是否提交？" confirmTitle:@"提交" cancelTitle:@"取消" confirmAction:^{
                [self submitLetvFinishListInfos:list];
            }];
        }else {
            [self submitLetvFinishListInfos:list];
        }
    }else {
        [Util showToast:invalid];
    }
}

- (void)setupTableDataSourceModel
{
    TableViewSectionHeaderData *headerData;
    TableViewCellData *cellData;
    NSInteger section, row;
    BOOL isComplete = (0 == self.isCompletedCell.segment.selectedSegmentIndex);

    [self.sourceModel cleanDataSourceModel];
    
    //上门签到
    section = 0; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"上门签到"];
    [self.sourceModel setHeaderData:headerData forSection:section];
    
    [self addCell:self.locateCell toSection:section row:row++];
    cellData = [self addCell:self.signinButtonCell toSection:section row:row++];
    cellData.tag = kTableViewCellDefaultHeight + kDefaultSpaceUnit * 2;

    //产品确认
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"产品确认"];
    [self.sourceModel setHeaderData:headerData forSection:section];
    
    [self addCell:self.productCell toSection:section row:row++];
    [self addCell:self.machineModelSelCell toSection:section row:row++];
    [self addCell:self.macAddressCell toSection:section row:row++];
    [self addCell:self.snNoCell toSection:section row:row++];
    [self addCell:self.purchaseDateCell toSection:section row:row++];
    [self addCell:self.warrantyCell toSection:section row:row++];
    [self addCell:self.installWayCell toSection:section row:row++];
    [self addCell:self.bearingWallCell toSection:section row:row++];
    [self addCell:self.rackFromLetvCell toSection:section row:row++];
    [self addCell:self.networkSelCell toSection:section row:row++];
    [self addCell:self.receiptCell toSection:section row:row++];

    //用户信息
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"用户信息"];
    [self.sourceModel setHeaderData:headerData forSection:section];

    [self addCell:self.nameCell toSection:section row:row++];
    [self addCell:self.addressCell toSection:section row:row++];
    [self addCell:self.detailAddressCell toSection:section row:row++];
    [self addCell:self.telEditCell toSection:section row:row++];
    [self addCell:self.isVipCardActiveCell toSection:section row:row++];
    if (self.isVipCardInactive) {
        //未激活原因
        section++; row = 0;
        headerData = [TableViewSectionHeaderData makeWithTitle:@"未激活原因"];
        [self.sourceModel setHeaderData:headerData forSection:section];
        [self addCell:self.cardInactiveReasonCell toSection:section row:row++];
    }

    //工单内容
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"工单内容"];
    [self.sourceModel setHeaderData:headerData forSection:section];
    [self addCell:self.isCompletedCell toSection:section row:row++];
    [self addCell:self.level1StatusCell toSection:section row:row++];
    [self addCell:self.level2StatusCell toSection:section row:row++];
    [self addCell:self.issueCodeCell toSection:section row:row++];

    //故障现象
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"故障现象"];
    [self.sourceModel setHeaderData:headerData forSection:section];
    [self addCell:self.issueDesCell toSection:section row:row++];

    //处理措施
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"处理措施"];
    [self.sourceModel setHeaderData:headerData forSection:section];
    [self addCell:self.resolutionCell toSection:section row:row++];
    
    //更换备件名称
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"更换备件名称"];
    [self.sourceModel setHeaderData:headerData forSection:section];
    [self addCell:self.convertPartCell toSection:section row:row++];

    //处理结果
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"处理结果"];
    [self.sourceModel setHeaderData:headerData forSection:section];
    [self addCell:self.resolvedDesCell toSection:section row:row++];

#ifdef Module_TecSupport
    [self addCell:self.supportCell toSection:section row:row++];
#endif

    if (isComplete) {
        [self addCell:self.feeMgrCell toSection:section row:row++];
    }

#ifdef Module_SmartSells
    [self addCell:self.smartSellCell toSection:section row:row++];
#endif

}

- (TableViewCellData*)addCell:(UITableViewCell*)cell toSection:(NSInteger)section row:(NSInteger)row
{
    TableViewCellData *cellData = [[TableViewCellData alloc]init];
    cellData.otherData = cell;
    [self.sourceModel setCellData:cellData forSection:section row:row];
    
    //set height to tag
    if ([cell isKindOfClass:[TextViewCell class]]) {
        TextViewCell *editCell = (TextViewCell*)cell;
        cellData.tag = CGRectGetHeight(editCell.textView.frame);
    }else {
        cellData.tag = kTableViewCellDefaultHeight;
    }

    //set some cell's publich property
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = SystemFont(15);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addLineTo:kFrameLocationBottom];
    
    return cellData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"执行";
    
    if ([self alertUpdateMainConfigInfoIfNeed]) {
        return;
    }

    [self setupInitVariables];
    [self createCustomSubViews];
    [self setupInitDataToViews];

    [self setupTableDataSourceModel];

    //set tableview
    self.tableView.tableViewDelegate = self;
    self.tableView.tableView.tableFooterView = self.customFooterView;
    
    [self.tableView refreshTableViewData];
    
    //delete old fee list 1st
    [self deleteAllFeeOrderList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    self.disableRightPanBack = YES;
}

- (void)addSpecialPerformEntryIfNeed
{
    BOOL enableSpecialFinish = YES;

    if (enableSpecialFinish) {
        [self setNavBarRightButton:@"特殊完工" clicked:@selector(specialPerformButtonClicked:)];
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)specialPerformButtonClicked:(UIButton*)button
{
    [LetvSpecialPerformOrderViewController pushMeFrom:self orderListVc:self.orderListViewController orderId:self.orderId];
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

-(void)deleteAllFeeOrderList
{
    self.bFeeListSynching = YES;
    [self deleteAllFeeItemsWithResponse:^(NSError *error, HttpResponseData *responseData) {
        self.bFeeListSynching = NO;
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

- (void)refreshTableViewCells
{
    [self setupTableDataSourceModel];
    [self.tableView.tableView reloadData];
}

- (void)segmentValueChanged:(UISegmentedControl*)segment
{
    if (segment == self.isVipCardActiveCell.segment) {
        [self refreshTableViewCells];
    }else if(segment == self.isCompletedCell.segment){
        BOOL isComplete = (0 == segment.selectedSegmentIndex);
        if (isComplete) {
            //完工时，默认设置为已解决
            self.level1StatusCell.checkedItemKey = @"1010";
            [self updateLevel2StatusItems];
            self.level2StatusCell.checkedItemKey = @"101001";
        }else {
            self.level1StatusCell.checkedItemKey = nil;
            self.level2StatusCell.checkedItemKey = nil;
        }
        [self refreshTableViewCells];
    }
}

- (UIView*)getHeaderLabelViewInSection:(NSInteger)section
{
    NSString *sectionKey = [NSString intStr:section];
    
    UIView *headerView;
    if ([self.headerViewCache containsKey:sectionKey]) {
        headerView = self.headerViewCache[sectionKey];
    }else {
        UILabel *headerLabel = [[UILabel alloc]init];
        headerLabel.tag = sHeaderLabelViewTag;
        headerLabel.textColor = kColorBlack;
        headerView = [self.tableView.tableView makeHeaderViewWithSubLabel:headerLabel bottomLineHeight:0];
    }
    return headerView;
}

//模糊查询
- (void)findMachineModel
{
    LetvProductModelSearchViewController *modelSearchVc = [[LetvProductModelSearchViewController alloc]init];
    modelSearchVc.modelSelectedBlock = ^(ViewController* viewController, ProductModelDes *model){
        [self handlefindMachineModelResult:model];
        [viewController popViewController];
    };
    modelSearchVc.productBrand = self.orderDetails.brand;
    [self pushViewController:modelSearchVc];
}

//品牌和产品是否匹配，但长虹和启客间可以互换
- (NSString*)checkIfProductMatch:(ProductModelDes*)product
{
    //检查品牌是否匹配
    if (![self.orderDetails.brand isEqualToString:product.zz0018]) {
        return @"品牌不匹配，请重试";
    }
    
    //乐视的机型和产品及品类没直接关系，所以不检查

    return nil;
}

- (void)deleteAllFeeItemsWithResponse:(RequestCallBackBlock)requestCallBackBlock
{
    LetvDeleteAllFeeOrderInputParams *input = [LetvDeleteAllFeeOrderInputParams new];
    input.objectId = self.orderId;
    input.itmType = @"ZRV1";
    [self.httpClient letv_deleteAllFeeOrder:input response:requestCallBackBlock];
}

- (void)handlefindMachineModelResult:(ProductModelDes*)productModel
{
    NSString *errStr = [self checkIfProductMatch:productModel];

    if (![Util isEmptyString:errStr]) {
        [Util showToast:errStr];
        return;
    }

    BOOL isModelChanged = ![_product_model.key isEqualToString:productModel.product_id];
    if (isModelChanged) {
        [Util showWaitingDialog];
        [self getFeeItemCountWithResponse:^(NSError *error, HttpResponseData *responseData, id extData) {
            [Util dismissWaitingDialog];
            if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
                NSNumber *totalFeeItemCount = (NSNumber*)extData;
                if ([totalFeeItemCount integerValue] > 0) {
                    [Util confirmAlertView:nil message:@"改变机型，将删除原有的费用项，是否继续?" confirmTitle:@"是" confirmAction:^{
                        self.bFeeListSynching = YES;
                        [Util showWaitingDialog];
                        [self deleteAllFeeItemsWithResponse:^(NSError *error, HttpResponseData *responseData) {
                            [Util dismissWaitingDialog];
                            self.bFeeListSynching = NO;

                            if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
                                [self updateProductModel:productModel.short_text key:productModel.product_id refreshTableView:YES] ;
                            }else {
                                [Util showErrorToastIfError:responseData otherError:error];
                            }
                        }];
                    } cancelTitle:@"否" cancelAction:nil];
                }else {
                    [self updateProductModel:productModel.short_text key:productModel.product_id refreshTableView:YES];
                }
            }else {
                [Util showErrorToastIfError:responseData otherError:error];
            }
        }];
    }
}

- (void)updateProductModel:(NSString*)modelValue key:(NSString*)modelKey refreshTableView:(BOOL)bRefresh
{
    _product_model = [KeyValueModel modelWithValue:modelValue forKey:modelKey];
    [self setMachineModelToView:modelKey value:modelValue];

    if (bRefresh) {
        [self refreshTableViewCells];
    }
}

- (void)setStreetInfoToView:(NSString*)streetValue key:(NSString*)streetKey
{
    _clientStreet = [CheckItemModel modelWithValue:streetValue forKey:streetKey];

    NSString *streetAddr = [self.orderDetails.customerFullCountyAddress appendStr:[Util defaultStr:@"" ifStrEmpty:streetValue]];
    self.addressCell.textContentLabel.text = streetAddr;
    
}

#pragma mark - 用工单详情内容设置视图显示

- (void)setOrderDetailsToViews:(LetvOrderContentDetails*)orderDetails
{
    self.productCell.typeItemEditable = YES;
    self.productCell.brandItem = [KeyValueModel modelWithValue:orderDetails.brandVal forKey:orderDetails.brand];
    self.productCell.productItem = [KeyValueModel modelWithValue:orderDetails.productTypeVal forKey:orderDetails.productType];

    KeyValueModel *typeModel;
    if (![Util isEmptyString:orderDetails.category]) {
        typeModel = [KeyValueModel modelWithValue:orderDetails.categoryVal forKey:orderDetails.category];
    }else {
        typeModel = [KeyValueModel modelWithValue:@"智能液晶电视" forKey:@"TV30"];
    }
    [self.productCell setTypeItem:typeModel defaultItem:NO];

    [self updateProductModel:orderDetails.modelVal key:orderDetails.model refreshTableView:NO];
    self.macAddressCell.textField.text = orderDetails.macAddress;
    self.snNoCell.textField.text = orderDetails.snCode;
    self.purchaseDateCell.date = [Util dateWithString:self.orderDetails.buyDate format:WZDateStringFormat10];
    
    NSInteger segmentIndex = NSNotFound;
    
    segmentIndex = [self getValuedSegmentIndex:_warrantyItems key:orderDetails.securityLabe];
    self.warrantyCell.segment.selectedSegmentIndex = segmentIndex;
    
    segmentIndex = [self getValuedSegmentIndex:_installWayItems key:orderDetails.installWay];
    self.installWayCell.segment.selectedSegmentIndex = segmentIndex;
    
    segmentIndex = [self getValuedSegmentIndex:_bearingWallItems key:orderDetails.isBearingWall];
    self.bearingWallCell.segment.selectedSegmentIndex = segmentIndex;
    
    segmentIndex = [self getValuedSegmentIndex:_rackFromLetvItems key:orderDetails.isBuyRack];
    self.rackFromLetvCell.segment.selectedSegmentIndex = segmentIndex;
    
    self.networkSelCell.checkedItemKey = orderDetails.network;
    self.receiptCell.textField.text = [Util defaultStr:@"" ifStrEmpty:orderDetails.invoiceNum];
    self.nameCell.textField.text = orderDetails.name;

    [self setStreetInfoToView:orderDetails.street key:orderDetails.street];
    self.detailAddressCell.textField.text = [Util defaultStr:@"" ifStrEmpty:orderDetails.detailAddr];
    self.telEditCell.textField.text = [Util defaultStr:@"" ifStrEmpty:orderDetails.phoneNum];
    
    segmentIndex = [self getValuedSegmentIndex:_isVipCardActiveItems key:orderDetails.vipCardActive];
    self.isVipCardActiveCell.segment.selectedSegmentIndex = segmentIndex;
    
    self.cardInactiveReasonCell.textView.text = [Util defaultStr:nil ifStrEmpty:orderDetails.notActiveCause];
    
    //default value is not complete
    segmentIndex = [self getValuedSegmentIndex:_isCompletedItems key:@"1"];
    self.isCompletedCell.segment.selectedSegmentIndex = segmentIndex;

    self.resolutionCell.textView.text = [Util defaultStr:@"" ifStrEmpty:orderDetails.faultHandling];

    //don't set old value , user need to select again
    self.level1StatusCell.checkedItemKey = nil;
    [self updateLevel2StatusItems];
    self.resolvedDesCell.textView.text = @"";

    [self setIssueCodeToView:orderDetails.faultCode value:orderDetails.faultCodeVal];
    self.issueDesCell.textView.text = [Util defaultStr:@"" ifStrEmpty:orderDetails.faultDesc];
    self.convertPartCell.textView.text = [Util defaultStr:@"" ifStrEmpty:orderDetails.replPartsName];
    
    [self setupSupporer:[self findSupporterInfo:orderDetails]];
}

- (void)setMachineModelToView:(NSString*)code value:(NSString*)value
{
    if ([Util isEmptyString:code]) {
        [self.machineModelSelCell setSelectedItemValue:nil];
    }else {
        AttributeStringAttrs *item1 = [AttributeStringAttrs new];
        item1.text = [NSString stringWithFormat:@"(%@)", code];
        item1.textColor = kColorDefaultOrange;
        item1.font = SystemFont(13);
        
        AttributeStringAttrs *item2 = [AttributeStringAttrs new];
        item2.text = value;
        item2.textColor = kColorBlack;
        item2.font = SystemFont(13);
        [self.machineModelSelCell setSelectedItemValueWithAttrStr:[NSString makeAttrString:@[item1, item2]]];
    }
}

- (void)setIssueCodeToView:(NSString*)code value:(NSString*)value
{
    [super setIssueCodeToView:code value:value];

    self.selectIssueCodeModel = [CheckItemModel modelWithValue:value forKey:code];
}

- (EmployeeInfo*)findSupporterInfo:(LetvOrderContentDetails*)orderDetails
{
    EmployeeInfo *supporter = [[EmployeeInfo alloc]init];
    
    supporter.supportman_id = orderDetails.supporterId;
    supporter.supportman_name = orderDetails.supporterName;
    supporter.supportman_phone = orderDetails.supporterPhone;
    
    return supporter;
}

- (void)setupSupporer:(EmployeeInfo*)supporter
{
    BOOL haveSupporter = ![Util isEmptyString:supporter.supportman_id];
    
    UIButton *supportButton = (UIButton*)self.supportCell.accessoryView;
    if (haveSupporter) {
        [supportButton setTitle:supporter.supportman_name forState:UIControlStateDisabled];
    }
    supportButton.enabled = !haveSupporter;
}

- (void)gotoIssueCodesFilterPage
{
    _issueCodeFilterVc = [[IssueCodeFilterViewController alloc]init];
    _issueCodeFilterVc.checkedItem = self.selectIssueCodeModel;
    _issueCodeFilterVc.delegate = self;
    _issueCodeFilterVc.title = self.issueCodeCell.textLabel.text;
    [self pushViewController:_issueCodeFilterVc];
}

#pragma mark - Tableview delegate & data source

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    LetvGetOrderDetailsInputParams *input = [LetvGetOrderDetailsInputParams new];
    input.objectId = self.orderId;
    [self.httpClient letv_getOrderDetails:input response:^(NSError *error, HttpResponseData *responseData) {
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            self.orderDetails = [[LetvOrderContentDetails alloc]initWithDictionary:responseData.resultData];
            [self addSpecialPerformEntryIfNeed];
            [self setOrderDetailsToViews:self.orderDetails];
            [self refreshTableViewCells];
        }

        [tableView didRequestTableViewListDatasWithCount:1 totalCount:1 page:pageInfo response:responseData error:error];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sourceModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sourceModel numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellData *cellData = [self.sourceModel cellDataForSection:indexPath.section row:indexPath.row];
    CGFloat height = (CGFloat)cellData.tag;
    if (cellData.otherData == self.addressCell) {
        height = [self.addressCell fitHeight];
    }else if (cellData.otherData == self.machineModelSelCell) {
        height = [self.machineModelSelCell fitHeight];
    }else if (cellData.otherData == self.issueCodeCell) {
        height = [self.issueCodeCell fitHeight];
    }
    return MAX(kTableViewCellDefaultHeight, height);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewCellDefaultHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    TableViewSectionHeaderData *headerData = [self.sourceModel headerDataOfSection:section];
    return headerData.title;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [self getHeaderLabelViewInSection:section];
    UILabel *headerLabel = (UILabel*)[headerView viewWithTag:sHeaderLabelViewTag];
    
    TableViewSectionHeaderData *headerData = [self.sourceModel headerDataOfSection:section];
    headerLabel.text = headerData.title;
    
    return headerView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellData *cellData = [self.sourceModel cellDataForSection:indexPath.section row:indexPath.row];

    return (UITableViewCell*)cellData.otherData;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView*)view;
        headerView.textLabel.font = SystemBoldFont(15);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TableViewCellData *cellData = [self.sourceModel cellDataForSection:indexPath.section row:indexPath.row];
    UITableViewCell *cell = (UITableViewCell*)cellData.otherData;

    if (cell == self.locateCell) {
        [self startLocateCurrentAddress];
    }else if (cell == self.addressCell){
        if (_streets.count > 0) {
            [self pushToCheckListVcToSelectStreet];
        }else {
            [self requestStreetInfos];
        }
    }else if (cell == self.machineModelSelCell){
        [self findMachineModel];
    }else if (cell == self.issueCodeCell) {
        [self gotoIssueCodesFilterPage];
    }
}

- (void)requestStreetInfos
{
    StreetListInputParams *input = [StreetListInputParams new];
    input.regiontxt = self.orderDetails.province;
    input.city1 = self.orderDetails.city;
    input.city2 = self.orderDetails.county;
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

- (void)pushToCheckListVcToSelectStreet
{
    _streetCheckViewController = [MiscHelper pushToCheckListViewController:@"选择乡、镇或街道" checkItems:_streets checkedItem:_clientStreet from:self delegate:self];
}

- (void)typeItemSelectValueChanged:(ProductSelectCell*)cell value:(KeyValueModel*)typeItem{
}

- (void)supportButtonClicked:(UIButton*)sender
{
    LetvApplySupportViewController *supporterListVc = [[LetvApplySupportViewController alloc]init];
    supporterListVc.orderId = [self.orderDetails.objectId description];
    supporterListVc.title = @"申请技术支持";
    supporterListVc.delegate = self;
    
    [self pushViewController:supporterListVc];
}

- (void)feeMgrButtonClicked:(UIButton*)sender
{
    if ([Util isEmptyString:_product_model.key]) {
        [Util showToast:@"请先选择机型"];
    }else if (self.bFeeListSynching){
        [Util showToast:@"费用数据正在同步中，请稍后再试"];
    }else{
        [self gotoPriceListViewController:(kPriceManageType)sender.tag];
    }
}

- (void)smartSellButtonClicked:(UIButton*)sender
{
    [self gotoPriceListViewController:(kPriceManageType)sender.tag];
}

- (void)gotoPriceListViewController:(kPriceManageType)type
{
    LetvPriceListViewController *listVc = [[LetvPriceListViewController alloc]init];
    listVc.orderObjectId = self.orderDetails.objectId.description;
    listVc.orderKeyId = self.orderDetails.Id.description;
    listVc.brandCode = self.productCell.brandItem.key;
    listVc.categoryCode = self.productCell.typeItem.key;
    listVc.feeManageType = type;
    listVc.machineModelCode = _product_model.key;
    listVc.title = getPriceManageTypeStr(type);
    
    [self pushViewController:listVc];
}

#pragma mark - PleaseSelectViewCellDelegate

- (void)selectViewDidChecked:(PleaseSelectViewCell*)cell
{
    if (cell == self.level1StatusCell) {
        [self updateLevel2StatusItems];
    }
}

- (BOOL)selectMenuWillAppear:(PleaseSelectViewCell*)cell{
    if (cell == self.level2StatusCell) {
        NSString *level1Code = self.level1StatusCell.checkedItemKey;
        if ([Util isEmptyString:level1Code]) {
            [Util showToast:@"请先选择一级工单状态"];
            return NO;
        }
    }
    return YES;
}

- (void)updateLevel2StatusItems
{
    NSArray *checkItems;
    NSString *level1Code = self.level1StatusCell.checkedItemKey;
    if (![Util isEmptyString:level1Code]) {
        checkItems = [self.configInfoMgr letv_orderLevel2Statuses:level1Code];
        checkItems = [Util convertConfigItemInfoArrayToCheckItemModelArray:checkItems];
    }
    self.level2StatusCell.checkItems = checkItems;
    self.level2StatusCell.checkedItemKey = nil;
}

#pragma mark - override super methods

- (void)repairSigninWithResponse:(RequestCallBackBlock)requestCallBackBlock
{
    LetvRepairSignInInputParams *input = [[LetvRepairSignInInputParams alloc]init];
    input.objectId = [self.orderId description];
    input.repairManId = self.user.userId;
    input.latitude = [NSString stringWithFormat:@"%f", _latitude];
    input.longitude = [NSString stringWithFormat:@"%f", _longitude];
    input.arriveAddress = [_signinAddress truncatingTailWhenLengthGreaterThan:30];
    input.posType = [NSString intStr:0];
    [Util showWaitingDialog];
    [self.httpClient letv_repairSignIn:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        requestCallBackBlock(error, responseData);
    }];
}

#pragma mark - SingleCheckViewController

- (void)singleCheckViewController:(WZSingleCheckViewController*)viewController didChecked:(CheckItemModel*)checkedItem
{
    if (_streetCheckViewController == viewController){ //选择街道
        [self setStreetInfoToView:checkedItem.value key:checkedItem.key];
        [viewController popViewController];
    }else if (_issueCodeFilterVc == viewController){ //故障代码
        [self setIssueCodeToView:checkedItem.key value:checkedItem.value];
        [self.tableView.tableView reloadData];

        [viewController popViewController];
    }
}

#pragma mark - applySupportViewController

- (void)applySupportViewController:(ApplySupportViewController*)viewController select:(EmployeeInfo*)supporter
{
    [self setupSupporer:supporter];
    [self.tableView.tableView reloadTableViewCell:self.supportCell];

    [viewController popViewController];
}

@end
