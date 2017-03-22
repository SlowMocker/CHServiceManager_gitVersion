//
//  SpecialPerformViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/9/14.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "SpecialPerformViewController.h"
#import "ProductSelectCell.h"
#import "TextFieldTableViewCell.h"
#import "WZTextView.h"
#import "WZSingleCheckListPopView.h"
#import "WZSingleCheckViewController.h"
#import "SystemPicture.h"

@interface SpecialPerformViewController ()<WZTableViewDelegate,WZSingleCheckViewControllerDelegate, PleaseSelectViewCellDelegate,SystemPictureDelegate>
{
    BOOL _isJDOrder;
    BOOL _isErrorOrder; //是否错、重单
    BOOL _isExpired;    //是否保外
    BOOL _isNewMachine; //是否新机安装

    NSString *_productId;
    NSString *_brandId;

    CheckItemModel *_abandonReasonItem;
    SystemPicture *_loadPicMgr;
    
    NSArray *_warrantyItems; //质保期
}
@property(nonatomic, strong)ProductSelectCell *productCell; //产品信息

@property(nonatomic, strong)TextSegmentTableViewCell *warrantyCell;//质保期

@property(nonatomic, strong)TextViewCell *issueHandleWayCell; //故障处理方式描述
@property(nonatomic, strong)PleaseSelectViewCell *solutionCell; //处理措施
@property(nonatomic, strong)TextFieldTableViewCell *orderEditCell; //错重单
@property(nonatomic, strong)PleaseSelectViewCell *reasonCell; //飞单原因

@property(nonatomic, strong)WZTextView *textView;
@property(nonatomic, strong)UITableViewCell *noteEditCell; //备注

@property(nonatomic, strong)NSMutableArray *cellArray; //all cells
@property(nonatomic, strong)NSMutableDictionary *sectionTitleDic;
@property(nonatomic, assign)BOOL jd_commited;//JD鉴定单是否已上传

//京东工单
@property(nonatomic, strong)UIButton *jdIdentifyButton;
@property(nonatomic, strong)UITableViewCell *jdIdentifyCell;//鉴定
@property(nonatomic, strong)PleaseSelectViewCell *jdIdentifyResultCell; //鉴定结果
@end

@implementation SpecialPerformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"特殊完工";
    if ([self alertUpdateMainConfigInfoIfNeed]) {
        return;
    }

    if (self.isBrandXZYY) {
        KeyValueModel *extendItem = nil;
        for (KeyValueModel *model in self.maintanceTimeArray) {
            if (model.key == [NSString intStr:kWarrantyDateRangeExtend]) {
                extendItem = model;
            }
        }
        if (extendItem) {
            [self.maintanceTimeArray removeObject:extendItem];
        }
    }
    [self makeCustomCells];

    [self.tableView.tableView addTopHeaderSpace:16];
    self.tableView.tableViewDelegate = self;
    [self.tableView refreshTableViewData];
}

- (void)navBarLeftButtonClicked:(UIButton *)defaultLeftButton
{
    [self popViewController];
}

- (void)makeCustomCells
{
    NSArray *itemArray;

    _jdIdentifyButton = [UIButton transparentTextButton:@"上传京东检测单"];
    _jdIdentifyCell = [self makeButtonCell:_jdIdentifyButton action:@selector(jdIdentifyButtonClicked:)];
    
    itemArray = [self.configInfoMgr jdIdentifyResults];
    itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
    _jdIdentifyResultCell = [MiscHelper makeSelectItemCell:@"鉴定结果" checkItems:itemArray checkedItem: nil];
    
    _productCell = [[ProductSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _productCell.typeItemEditable = YES;
    [_productCell addLineTo:kFrameLocationBottom];

    //质保期
    _warrantyCell = [self makeTextSegmentCellWithTitle:@"产品质保"];
    [_warrantyCell.segment addTarget:self action:@selector(maintenancePeriodSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    _warrantyItems = [self.configInfoMgr warrantyItems];

    itemArray = [self.configInfoMgr specialSolutionsOfProduct:_productId];
    itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
    _solutionCell = [MiscHelper makeSelectItemCell:@"处理措施" checkItems:itemArray checkedItem: nil];
    _solutionCell.delegate = self;
    _issueHandleWayCell = [self makeTextViewCell:@"故障处理方式描述" maxWords:60];
    [_issueHandleWayCell.contentView clearBackgroundColor];
    [_issueHandleWayCell clearBackgroundColor];
    [self.issueHandleWayCell.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.issueHandleWayCell.contentView).insets(UIEdgeInsetsMake(kDefaultSpaceUnit, 0, 0, 0));
    }];

    _orderEditCell = [self makeTextFieldCell:@"错单、重单编号"];
    _orderEditCell.textField.keyboardType = UIKeyboardTypeNumberPad;

    itemArray = [[ConfigInfoManager sharedInstance]abandonReasons];
    itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
    _reasonCell = [MiscHelper makeSelectItemCell:@"流失原因" checkItems:itemArray checkedItem: nil];

    _textView = [[WZTextView alloc]initWithFrame:CGRectMake(0, kDefaultSpaceUnit, ScreenWidth - 2*kDefaultSpaceUnit, kNoteEditTextCellHeight) maxWords:300];
    _textView.placeholder = @"添加备注";
    _noteEditCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [_noteEditCell.contentView addSubview:self.textView];
    [_noteEditCell clearBackgroundColor];
    [_noteEditCell.contentView clearBackgroundColor];
}

- (void)setDataToViews
{
    _isNewMachine = [self.orderDetails.process_type isEqualToString:@"ZRA1"];

    KeyValueModel *item = [KeyValueModel new];
    item.value = self.orderDetails.zzfld000000;
    item.key = [MiscHelper productBrandCodeByName:item.value];
    self.productCell.brandItem = item;
    
    item = [KeyValueModel new];
    item.value = self.orderDetails.zzfld000003;
    item.key = [MiscHelper productTypeCodeByName:item.value];
    self.productCell.productItem = item;
    
    item = [KeyValueModel new];
    item.value = self.orderDetails.zzfld000001;
    item.key = [MiscHelper subProductTypeCodeByName:item.value];
    [self.productCell setTypeItem:item defaultItem:NO];

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
    
    self.issueHandleWayCell.textView.text = [Util defaultStr:@"" ifStrEmpty:self.orderDetails.zzfld00005y];
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

- (void)reloadTableViewData
{
    _productId = [MiscHelper productTypeCodeForValue:self.orderDetails.zzfld000003];
    _brandId = [MiscHelper productBrandCodeForValue:self.orderDetails.zzfld000000];
    _isJDOrder = [self.orderDetails.jd_thj isEqualToString:@"X"];

    self.cellArray = [self groupTableViewCells];
    [self setTableViewCellCommonProperties];

    self.tableView.tableView.tableFooterView = self.customFooterView;
}

- (void)reloadTableView
{
    [self reloadTableViewData];
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
    
    _sectionTitleDic = [NSMutableDictionary new];

#if 0
    NSString *sectionTitle;
    //section
    sectionTitle = @"上门签到";
    rowArray = [NSMutableArray new];
    [rowArray addObject:self.locateCell];
    [rowArray addObject:self.signinButtonCell];
    [sectionArray addObject:rowArray];
    [_sectionTitleDic setObj:sectionTitle forKey:rowArray];
#endif

    //section
    if (_isJDOrder) {
        rowArray = [NSMutableArray new];
        [rowArray addObject:self.jdIdentifyCell];
        [rowArray addObject:self.jdIdentifyResultCell];
        [sectionArray addObject:rowArray];
    }

    //section
    rowArray = [NSMutableArray new];
    [rowArray addObject:self.productCell];
    [rowArray addObject:self.warrantyCell];
    if ([self needToSetIssueHandleWay]) {
        [rowArray addObject:self.issueHandleWayCell];
    }
    [rowArray addObject:self.solutionCell];
    if (_isErrorOrder) {
        [rowArray addObject:self.orderEditCell];
    }

    if (_isExpired) {
        [rowArray addObject:self.reasonCell];
    }
    [rowArray addObject:self.noteEditCell];
    [sectionArray addObject:rowArray];

    return sectionArray;
}

-(void)requestOrderDetails:(WZTableView*)tableView page:(PageInfo*)pageInfo
{
    //request order details
    GetOrderDetailsInputParams *input = [GetOrderDetailsInputParams new];
    input.object_id = [self.orderId description];

    [self.httpClient getOrderDetails:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            NSDictionary *orderDic = responseData.resultData;
            self.orderDetails = [MiscHelper parserOrderContentDetails:orderDic];
            _isExpired = [self checkIfExpired:self.orderDetails];
            [self setDataToViews];
            [self reloadTableView];
        }
        [tableView didRequestTableViewListDatasWithCount:1 totalCount:1 page:pageInfo response:responseData error:error];
    }];
}

- (BOOL)checkIfExpired:(OrderContentDetails*)details{
    return [self.orderDetails.zzfld000002 isEqualToString:@"保外"];
}

#pragma mark - TableView Delegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    if (self.orderDetails) {
        _isExpired = [self checkIfExpired:self.orderDetails];
        [self setDataToViews];
        [self reloadTableViewData];

        [tableView didRequestTableViewListDatasWithCount:1 totalCount:1 page:pageInfo response:nil error:nil];
    }else {
        [self requestOrderDetails:tableView page:pageInfo];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *sectionArray = self.cellArray[section];
    NSString *sectionTitle = [_sectionTitleDic objForKey:sectionArray];

    return ([Util isEmptyString:sectionTitle]) ? 1 : kButtonLargeHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *sectionArray = self.cellArray[section];
    NSString *sectionTitle = [_sectionTitleDic objForKey:sectionArray];
    
    UILabel *headerLabel = [[UILabel alloc]init];
    UIView *headerView = [tableView makeHeaderViewWithSubLabel:headerLabel bottomLineHeight:0];
    headerLabel.text = sectionTitle;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
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
    }else if (cell == self.noteEditCell){
        cellHeight = CGRectGetMaxY(self.textView.frame);
    }else if (cell == self.warrantyCell){
        cellHeight = 54;
    }else if (cell == self.jdIdentifyCell){
        cellHeight = kPerformOrderViewCellLineHeight + 2 * kDefaultSpaceUnit;
    }else if (cell == self.issueHandleWayCell){
        cellHeight = 100 + kDefaultSpaceUnit;
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
    if (cell == self.locateCell) {
        [self startLocateCurrentAddress];
    }
}

- (void)repairSigninWithResponse:(RequestCallBackBlock)requestCallBackBlock
{
    RepairSignInInputParams *input = [[RepairSignInInputParams alloc]init];
    input.object_id = [self.orderId description];
    input.repairmanid = self.user.userId;
    input.la = [NSString stringWithFormat:@"%f", _latitude];
    input.lo = [NSString stringWithFormat:@"%f", _longitude];
    input.arrive_address = _signinAddress;
    input.postype = [NSString intStr:0];

    [Util showWaitingDialog];
    [self.httpClient repairSignIn:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        requestCallBackBlock(error, responseData);
    }];
}

- (void)confirmButtonClicked:(id)sender
{
    SpecialFinishBillInputParams *input = [self readFinishBillInputParams];
    NSString *invalidDataStr = [self checkFinishBillInputParams:input];
    if (nil == invalidDataStr) {
        [self requestSpecialFinishBill:input];
    }else {
        [Util showToast:invalidDataStr];
    }
}

- (BOOL)needToSetIssueHandleWay
{
    BOOL bMatchBrand = [_brandId isEqualOneInArray:@[@"CH",@"CHIQ",@"SY"]];
    BOOL bRepairOrder = !_isNewMachine;
    BOOL bTV = [_productId isEqualToString:@"TV0010"];

    return bMatchBrand && bRepairOrder && bTV;
}

- (SpecialFinishBillInputParams*)readFinishBillInputParams
{
    SpecialFinishBillInputParams *input = [SpecialFinishBillInputParams new];

    input.objectid = [self.orderId description];
    input.brand = self.productCell.brandItem.key;
    input.category = self.productCell.typeItem.key;
    input.type = self.warrantyCell.selectedItemKey;
    input.repairdescribe = self.solutionCell.checkedItem.key;
    input.memo = self.textView.text;
    input.zzfld00004r = self.reasonCell.checkedItem.key;
    input.zzfld00005x = self.orderEditCell.textField.text;
    input.zzfld00002r = self.jdIdentifyResultCell.checkedItem.key;
    input.zzfld00005y = self.issueHandleWayCell.textView.text;

    return input;
}

- (NSString*)checkFinishBillInputParams:(SpecialFinishBillInputParams*)input
{
    NSString *invalidStr;
    do {
//        ReturnIf(!_isSignin)@"请先进行签到";
        ReturnIf([Util isEmptyString:input.category])@"请先确定品类";
        ReturnIf(_isJDOrder && !_jd_commited)@"请先提交京东故障单";
        ReturnIf([Util isEmptyString:input.type])@"请选择产品质保";
        ReturnIf([Util isEmptyString:input.repairdescribe])@"请选择处理措施";
        if ([self needToSetIssueHandleWay]) {
            ReturnIf([Util isEmptyString:input.zzfld00005y])@"请填写故障处理方式描述";
        }
#if 0
        ReturnIf([MiscHelper checkIsPartsAffectFinishOrder:self.orderDetails.tDispatchParts])@"备件维护未完成，不能提交";
#endif
        if (_isErrorOrder) {
            if ([Util isEmptyString:input.zzfld00005x]) {
                invalidStr = @"请输入错单或重单号";
                break;
            }
            if (input.zzfld00005x.length < 9 || input.zzfld00005x.length > 10){
                invalidStr = @"错单、重单编号位数不正确";
                break;
            }
        }
        if (_isExpired && self.user.isCreate) {
            if ([Util isEmptyString:input.zzfld00004r]) {
                invalidStr = @"请选择流失原因";
            }
        }
    } while (0);

    return invalidStr;
}

- (void)requestSpecialFinishBill:(SpecialFinishBillInputParams*)input
{
    [Util showWaitingDialog];
    [self.httpClient repairSpecialFinishBill:input response:^(NSError *error, HttpResponseData *responseData) {
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
                    [self popToTopOrderListViewController];
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

- (void)selectViewDidChecked:(PleaseSelectViewCell*)cell
{
    if (_solutionCell == cell) {
        BOOL bSelectErrorOrder = NO;
        if ([_solutionCell.checkedItem.value containsString:@"错单"]
            ||[self.solutionCell.checkedItem.value containsString:@"重单"]) {
            bSelectErrorOrder = YES;
        }
        if (_isErrorOrder != bSelectErrorOrder) {
            _isErrorOrder = bSelectErrorOrder;
            [self reloadTableView];
        }
    }
}

- (void)maintenancePeriodSegmentChanged:(UISegmentedControl*)segment
{
    _isExpired = [self.warrantyCell.selectedItemKey isEqualToString:@"20"];
    [self performSelector:@selector(reloadTableView) withObject:nil];
}

- (void)jdIdentifyButtonClicked:(UIButton*)sender
{
    _loadPicMgr = [[SystemPicture alloc]initWithDelegate:self baseViewController:self];
    [_loadPicMgr startSelect];
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
    __weak typeof(&*self)weakSelf = self;
    [self.httpClient setJdIdentifyImageUploadStatus:input response:^(NSError *error, HttpResponseData *responseData) {
        weakSelf.jd_commited = (!error && kHttpReturnCodeSuccess == responseData);
        NSString *tempStr = [NSString stringWithFormat:@"京东故障单上传%@",weakSelf.jd_commited ? @"成功":@"失败"];
        [weakSelf.jdIdentifyButton setTitle:tempStr forState:UIControlStateNormal];
    }];
}

@end
