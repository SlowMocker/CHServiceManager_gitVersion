//
//  LetvAppointmentViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/5.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvAppointmentViewController.h"
#import "TextViewCell.h"
#import "WZDatePickerView.h"
#import "WZDateSelectCell.h"
#import "IssueCodeFilterViewController.h"
#import "NormalSelectTableViewCell.h"

static NSInteger sHeaderLabelViewTag = 0x084230;

@interface LetvAppointmentViewController ()<WZTableViewDelegate, WZSingleCheckViewControllerDelegate, PleaseSelectViewCellDelegate>

//custom sub views
@property(nonatomic, strong)PleaseSelectViewCell *level1StatusCell;//一级工单状态
@property(nonatomic, strong)PleaseSelectViewCell *level2StatusCell;//二级工单状态
@property(nonatomic, strong)NormalSelectTableViewCell *issueCodeCell;//故障代码
@property(nonatomic, strong)TextViewCell *issueDesCell; //故障现象
@property(nonatomic, strong)TextViewCell *resolvedDesCell; //处理结果
@property(nonatomic, strong)WZDateSelectCell *dateCell;  //上门服务时间

@property(nonatomic, strong)UIView *customFooterView;
@property(nonatomic, strong)UIButton *confirmButton;

//data model
@property(nonatomic, strong)TableViewDataHandle *sourceModel;
@property(nonatomic, strong)NSMutableDictionary *headerViewCache;
@property(nonatomic, strong)CheckItemModel *selectIssueCodeModel;

@end

@implementation LetvAppointmentViewController

- (NSMutableDictionary*)headerViewCache{
    if (nil == _headerViewCache) {
        _headerViewCache = [NSMutableDictionary new];
    }
    return _headerViewCache;
}

- (TableViewDataHandle *)sourceModel{
    if (nil == _sourceModel) {
        _sourceModel = [[TableViewDataHandle alloc]init];
    }
    return _sourceModel;
}

- (WZDateSelectCell*)dateCell
{
    if (nil == _dateCell) {
        _dateCell = [[WZDateSelectCell alloc]initWithDate:nil baseViewController:self];
        _dateCell.datePickerMode = UIDatePickerModeDateAndTime;
    }
    return _dateCell;
}

- (void)createCustomSubViews
{
    NSArray *checkItems;

    CGRect textviewFrame = CGRectMake(0, 0, ScreenWidth - kTableViewLeftPadding * 2, 80);

    self.level1StatusCell = [MiscHelper makePleaseSelectCell:@"一级工单状态"];
    checkItems = [self.configInfoMgr letv_orderLevel1Statuses];
    checkItems = [Util convertConfigItemInfoArrayToCheckItemModelArray:checkItems];
    self.level1StatusCell.checkItems = checkItems;
    self.level1StatusCell.delegate = self;
    
    self.level2StatusCell = [MiscHelper makePleaseSelectCell:@"二级工单状态"];

    self.issueCodeCell = [[NormalSelectTableViewCell alloc]initWithTitle:@"故障代码" reuseIdentifier:nil];

    self.issueDesCell = [[TextViewCell alloc]initWithFrame:textviewFrame maxWords:60];

    self.resolvedDesCell = [[TextViewCell alloc]initWithFrame:textviewFrame maxWords:350];

    self.confirmButton = [UIButton redButton:@"确定"];
    [self.confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.customFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 2 *kTableViewLeftPadding, kButtonDefaultHeight + 3* kDefaultSpaceUnit)];
    [self.customFooterView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.customFooterView);
        make.height.equalTo(@(kButtonDefaultHeight));
        make.center.equalTo(self.customFooterView);
    }];
}

- (NSString*)checkUserAppointmentInfos
{
    NSString *apptDate = [NSString dateStringWithDate:self.dateCell.date strFormat:WZDateStringFormat9];

    if (self.bAppointmentSuccess) {
        if ([Util isEmptyString:apptDate]) {
            return @"请选择上门时间";
        }
        if ([self.dateCell.date isEarlierThanDate:[NSDate date]]) {
            return [NSString stringWithFormat:@"%@不能早于当前时间", self.dateCell.textLabel.text];
        }
    }
    if ([Util isEmptyString:self.level1StatusCell.checkedItemKey]) {
        return @"请选择一级工单状态";
    }
    
    if ([Util isEmptyString:self.level2StatusCell.checkedItemKey]) {
        return @"请选择二级工单状态";
    }
    
    if ([Util isEmptyString:self.selectIssueCodeModel.key]) {
        return @"请选择故障代码";
    }
    
    if ([Util isEmptyString:self.issueDesCell.textView.text]) {
        return @"请填写故障现象";
    }

    if ([Util isEmptyString:self.resolvedDesCell.textView.text]) {
        return @"请填写处理结果";
    }
    return nil;
}

- (void)confirmButtonClicked:(id)sender
{
    NSString *invalid = [self checkUserAppointmentInfos];
    if (nil == invalid) {
        [self appointmentClient];
    }else {
        [Util showToast:invalid];
    }
}

//服务商预约
- (void)facilitatorSubmitAppointmentClient:(RequestCallBackBlock)requestCallBackBlock
{
    LetvAppointmentOrderInputParams *appt = [[LetvAppointmentOrderInputParams alloc]init];
    NSString *apptDate = [NSString dateStringWithDate:self.dateCell.date strFormat:WZDateStringFormat9];
    
    appt.objectId = self.letvOrderContent.objectId.description;
    appt.flag = self.bAppointmentSuccess ? @"0" : @"1";
    appt.statusL1 = self.level1StatusCell.checkedItemKey;
    appt.statusL2 = self.level2StatusCell.checkedItemKey;
    appt.faultCode = self.selectIssueCodeModel.key;
    appt.faultDesc = self.issueDesCell.textView.text;
    appt.handleResult = self.resolvedDesCell.textView.text;
    appt.apptDate = apptDate;

    [self.httpClient letv_facilitator_appointmentOrder:appt response:requestCallBackBlock];
}

//服务商改约
- (void)facilitatorSubmitChangeAppointmentClient:(RequestCallBackBlock)requestCallBackBlock
{
    LetvChangeAppointmentOrderInputParams *appt = [[LetvChangeAppointmentOrderInputParams alloc]init];
    NSString *apptDate = [NSString dateStringWithDate:self.dateCell.date strFormat:WZDateStringFormat9];
    
    appt.objectId = self.letvOrderContent.objectId.description;
    appt.statusL1 = self.level1StatusCell.checkedItemKey;
    appt.statusL2 = self.level2StatusCell.checkedItemKey;
    appt.faultCode = self.selectIssueCodeModel.key;
    appt.faultDesc = self.issueDesCell.textView.text;
    appt.handleResult = self.resolvedDesCell.textView.text;
    appt.lastApptDate = apptDate;
    
    [self.httpClient letv_facilitator_changeAppointmentOrder:appt response:requestCallBackBlock];
}

//维修工预约
- (void)repairerSubmitAppointmentClient:(RequestCallBackBlock)requestCallBackBlock
{
    LetvRepairerAppointmentOrderInputParams *appt = [[LetvRepairerAppointmentOrderInputParams alloc]init];
    NSString *apptDate = [NSString dateStringWithDate:self.dateCell.date strFormat:WZDateStringFormat9];
    
    appt.objectId = self.letvOrderContent.objectId.description;
    appt.flag = self.bAppointmentSuccess ? @"0" : @"1";
    appt.statusL1 = self.level1StatusCell.checkedItemKey;
    appt.statusL2 = self.level2StatusCell.checkedItemKey;
    appt.faultCode = self.selectIssueCodeModel.key;
    appt.faultDesc = self.issueDesCell.textView.text;
    appt.handleResult = self.resolvedDesCell.textView.text;
    appt.apptDate = apptDate;

    [self.httpClient letv_repairer_appointmentOrder:appt response:requestCallBackBlock];
}

- (void)appointmentClient
{
    __weak LetvAppointmentViewController *weakSelf = self;
    RequestCallBackBlock requestCallBackBlock = ^(NSError *error, HttpResponseData* responseData){
        [Util dismissWaitingDialog];
        
        if (!error) {
            NSString *promptStr = [Util getErrorDescritpion:responseData otherError:error];
            if (kHttpReturnCodeSuccess == responseData.resultCode) {
                promptStr = @"提交成功";
            }
            switch (responseData.resultCode) {
                case kHttpReturnCodeSuccess:
                case kHttpReturnCodeChangedAssign:
                    [weakSelf postNotification:NotificationOrderChanged];
                    [weakSelf popViewController];
                    break;
                default:
                    break;
            }
            [Util showToast:promptStr];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    };

    if (kUserRoleTypeFacilitator == self.user.userRoleType) {
        if (kAppointmentOperateType1stTime == self.appointmentOperateType) {
            [Util showWaitingDialog];
            [self facilitatorSubmitAppointmentClient:requestCallBackBlock];
        }else {
            [Util showWaitingDialog];
            [self facilitatorSubmitChangeAppointmentClient:requestCallBackBlock];
        }
    }else if (kUserRoleTypeRepairer == self.user.userRoleType){
        [Util showWaitingDialog];
        [self repairerSubmitAppointmentClient:requestCallBackBlock];
    }
}

- (void)setupTableDataSourceModel
{
    TableViewSectionHeaderData *headerData;
    NSInteger section, row;
    
    //工单内容
    section = 0; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"工单内容"];
    [self.sourceModel setHeaderData:headerData forSection:section];

    [self addCell:self.level1StatusCell toSection:section row:row++];
    [self addCell:self.level2StatusCell toSection:section row:row++];
    [self addCell:self.issueCodeCell toSection:section row:row++];
    
    //故障现象
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"故障现象"];
    [self.sourceModel setHeaderData:headerData forSection:section];

    [self addCell:self.issueDesCell toSection:section row:row++];
    
    //处理结果
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"处理结果"];
    [self.sourceModel setHeaderData:headerData forSection:section];

    [self addCell:self.resolvedDesCell toSection:section row:row++];
    
    if (self.bAppointmentSuccess) {
        //上门时间
        section++; row = 0;
        NSString *tempStr = getAppointmentOperateTypeStr(self.appointmentOperateType);
        tempStr = [tempStr appendStr:@"上门时间"];
        self.dateCell.textLabel.text = tempStr;
        headerData = [TableViewSectionHeaderData makeWithTitle:tempStr];
        [self.sourceModel setHeaderData:headerData forSection:section];

        [self addCell:self.dateCell toSection:section row:row++];
    }
}

- (TableViewCellData*)addCell:(UITableViewCell*)cell toSection:(NSInteger)section row:(NSInteger)row
{
    TableViewCellData *cellData = [[TableViewCellData alloc]init];
    cellData.otherData = cell;
    [self.sourceModel setCellData:cellData forSection:section row:row];

    //set height to tag
    if ([cell isKindOfClass:[TextViewCell class]]) {
        cellData.tag = 80;
    }else {
        cellData.tag = kTableViewCellDefaultHeight;
    }
    
    //set some cell's publich property
    cell.textLabel.textColor = kColorDefaultGray;

    return cellData;
}

- (void)updateLevel2StatusItems:(NSString*)level1Code
{
    NSArray *checkItems;
    if (![Util isEmptyString:level1Code]) {
        checkItems = [self.configInfoMgr letv_orderLevel2Statuses:level1Code];
        checkItems = [Util convertConfigItemInfoArrayToCheckItemModelArray:checkItems];
    }
    self.level2StatusCell.checkItems = checkItems;
    self.level2StatusCell.checkedItemKey = nil;
}

- (void)setAppointDatasToViews:(LetvOrderContentDetails*)orderDetails
{
#if 0   //some items don't need to set old value
    self.level1StatusCell.checkedItemKey = orderDetails.statusL1;
    [self updateLevel2StatusItems:orderDetails.statusL1];
    self.level2StatusCell.checkedItemKey = orderDetails.statusL2;
    self.resolvedDesCell.textView.text = orderDetails.handleResult;

    NSString *apptDate = ![Util isEmptyString:orderDetails.lastApptDate] ? orderDetails.lastApptDate : orderDetails.firstApptDate;
    if (nil != apptDate) {
        self.dateCell.date = [Util dateWithString:apptDate format:WZDateStringFormat9];
    }
#endif

    [self setIssueCodeToView:orderDetails.faultCode value:orderDetails.faultCodeVal];
    self.issueDesCell.textView.text = [Util defaultStr:@"" ifStrEmpty:orderDetails.faultDesc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCustomSubViews];

    [self setupTableDataSourceModel];

    //set tableview
    self.tableView.tableViewDelegate = self;
    self.tableView.tableView.tableFooterView = self.customFooterView;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kTableViewLeftPadding, 0, kTableViewLeftPadding));
    }];
    self.tableView.tableView.headerHidden = YES;
    self.tableView.tableView.footerHidden = YES;
    self.tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableView.backgroundColor = kColorClear;
    self.tableView.tableView.backgroundView = nil;
    self.tableView.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    //get order details and set them to views
    [self getOrderAppointmentInfoAndSetThemToViews];
}

- (void)getOrderAppointmentInfoAndSetThemToViews
{
    [Util showWaitingDialog];
    [self requestOrderDetailsWithResponse:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            LetvOrderContentDetails *orderDetails = [[LetvOrderContentDetails alloc]initWithDictionary:responseData.resultData];
            [self setAppointDatasToViews:orderDetails];
            [self.tableView.tableView reloadData];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
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

- (void)gotoIssueCodesFilterPage
{
    IssueCodeFilterViewController *issueCodeFilterVc;
    issueCodeFilterVc = [[IssueCodeFilterViewController alloc]init];
    issueCodeFilterVc.checkedItem = self.selectIssueCodeModel;
    issueCodeFilterVc.delegate = self;
    issueCodeFilterVc.title = self.issueCodeCell.textLabel.text;
    [self pushViewController:issueCodeFilterVc];
}

- (void)requestOrderDetailsWithResponse:(RequestCallBackBlock)response
{
    LetvGetOrderDetailsInputParams *input = [LetvGetOrderDetailsInputParams new];
    input.objectId = [self.letvOrderContent.objectId description];
    [self.httpClient letv_getOrderDetails:input response:response];
}

#pragma mark - PleaseSelectViewCellDelegate

- (void)selectViewDidChecked:(PleaseSelectViewCell*)cell
{
    if (cell == self.level1StatusCell) {
        [self updateLevel2StatusItems:self.level1StatusCell.checkedItemKey];
    }
}

#pragma mark - issue code check 

- (void)singleCheckViewController:(WZSingleCheckViewController*)viewController didChecked:(CheckItemModel*)checkedItem
{
    [self setIssueCodeToView:checkedItem.key value:checkedItem.value];
    [self.tableView.tableView reloadData];

    [viewController popViewController];
}


#pragma mark - Tableview delegate & data source

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
    if (cellData.otherData == self.issueCodeCell) {
        return [self.issueCodeCell fitHeight];
    }
    return (CGFloat)cellData.tag;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewCellDefaultHeight;
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
    UITableViewCell *selCell = (UITableViewCell*)cellData.otherData;
    
    if (selCell == self.issueCodeCell) {
        [self gotoIssueCodesFilterPage];
    }
}

- (void)setIssueCodeToView:(NSString*)code value:(NSString*)value
{
    self.selectIssueCodeModel = [CheckItemModel modelWithValue:value forKey:code];

    if ([Util isEmptyString:code]) {
        [self.issueCodeCell setSelectedItemValue:nil];
    }else {
        AttributeStringAttrs *item1 = [AttributeStringAttrs new];
        item1.text = [NSString stringWithFormat:@"(%@)", code];
        item1.textColor = kColorDefaultOrange;
        item1.font = SystemFont(13);

        AttributeStringAttrs *item2 = [AttributeStringAttrs new];
        item2.text = value;
        item2.textColor = kColorBlack;
        item2.font = SystemFont(13);
        [self.issueCodeCell setSelectedItemValueWithAttrStr:[NSString makeAttrString:@[item1, item2]]];
    }
}

@end
