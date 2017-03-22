//
//  LetvPerformOrderViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/5.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvSpecialPerformOrderViewController.h"
#import "TextViewCell.h"
#import "ProductSelectCell.h"
#import "TextSegmentTableViewCell.h"
#import "WZDateSelectCell.h"
#import "IssueCodeFilterViewController.h"
#import "TextLabelCell.h"

static NSInteger sHeaderLabelViewTag = 0x084230;

@interface LetvSpecialPerformOrderViewController ()<WZTableViewDelegate,WZSingleCheckViewControllerDelegate, UITextFieldDelegate, ProductSelectCellDelegate, PleaseSelectViewCellDelegate>
{
    //选项数据
    NSArray *_warrantyItems; //质保期
    NSMutableArray *_isVipCardActiveItems; //是否激活卡
    IssueCodeFilterViewController *_issueCodeFilterVc;
}
@property(nonatomic, strong)LetvOrderContentDetails *orderDetails;

@property(nonatomic, assign)BOOL isVipCardInactive;
@property(nonatomic, strong)CheckItemModel *selectIssueCodeModel;

//custom sub views
@property(nonatomic, strong)ProductSelectCell *productCell; //产品信息
@property(nonatomic, strong)WZDateSelectCell *purchaseDateCell; //购买日期
@property(nonatomic, strong)TextSegmentTableViewCell *warrantyCell;//质保期
@property(nonatomic, strong)TextSegmentTableViewCell *isVipCardActiveCell;//会员卡是否激活
@property(nonatomic, strong)TextViewCell *cardInactiveReasonCell; //卡未激活原因
@property(nonatomic, strong)TextViewCell *resolutionCell; //处理措施
@property(nonatomic, strong)PleaseSelectViewCell *level1StatusCell;//一级工单状态
@property(nonatomic, strong)PleaseSelectViewCell *level2StatusCell;//二级工单状态
@property(nonatomic, strong)TextViewCell *issueDesCell; //故障现象
@property(nonatomic, strong)TextViewCell *resolvedDesCell; //处理结果

//data model
@property(nonatomic, strong)TableViewDataSourceModel *sourceModel;

@end

@implementation LetvSpecialPerformOrderViewController

- (BOOL)isVipCardInactive{
    return (1 == self.isVipCardActiveCell.segment.selectedSegmentIndex);
}

- (TableViewDataSourceModel *)sourceModel{
    if (nil == _sourceModel) {
        _sourceModel = [[TableViewDataSourceModel alloc]init];
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

- (void)createCustomSubViews
{
    //产品信息
    _productCell = [[ProductSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _productCell.delegate = self;
    
    //购买日期
    _purchaseDateCell = [[WZDateSelectCell alloc]initWithDate:nil baseViewController:self];
    _purchaseDateCell.textLabel.text = @"购买日期";

    //质保期
    _warrantyCell = [self makeTextSegmentCellWithTitle:@"产品质保"];

    //会员卡是否激活
    _isVipCardActiveCell = [self makeTextSegmentCellWithTitle:@"会员卡是否激活"];
    
    _level1StatusCell = [MiscHelper makePleaseSelectCell:@"一级工单状态"];
    NSArray *checkItems = [self.configInfoMgr letv_orderLevel1Statuses];
    checkItems = [Util convertConfigItemInfoArrayToCheckItemModelArray:checkItems];
    self.level1StatusCell.checkItems = checkItems;
    self.level1StatusCell.delegate = self;
    
    _level2StatusCell = [MiscHelper makePleaseSelectCell:@"二级工单状态"];
    
    _issueDesCell = [self makeTextViewCell:@"请输入故障现象" maxWords:60];
    _resolvedDesCell = [self makeTextViewCell:@"请输入处理结果" maxWords:350];
    _cardInactiveReasonCell = [self makeTextViewCell:@"请输入会员卡未激活原因" maxWords:30];
    _resolutionCell = [self makeTextViewCell:@"请输入处理措施" maxWords:30];
}

- (TextViewCell*)makeTextViewCell:(NSString*)placeHolder maxWords:(NSInteger)maxWords
{
    CGRect textviewFrame = CGRectMake(0, 0, ScreenWidth - kTableViewLeftPadding * 2, 100);
    TextViewCell *textCell = [[TextViewCell alloc]initWithFrame:textviewFrame maxWords:maxWords];
    textCell.textView.placeholder = placeHolder;
    
    return textCell;
}

#pragma mark - 初始化视图数据

//初始化视图内容
- (void)setupInitDataToViews
{
    [self insertSegmentItems:_warrantyItems toSegment:self.warrantyCell segWidth:140];
    [self insertSegmentItems:_isVipCardActiveItems toSegment:self.isVipCardActiveCell segWidth:140];
}

//初始化变量值
- (void)setupInitVariables
{
    KeyValueModel *model;

    //质保期
    _warrantyItems = [self.configInfoMgr letv_warrantyItems];

    //是否激活卡
    _isVipCardActiveItems = [NSMutableArray new];
    model = [KeyValueModel modelWithValue:@"是" forKey:@"Y"];
    [_isVipCardActiveItems addObject:model];
    model = [KeyValueModel modelWithValue:@"否" forKey:@"N"];
    [_isVipCardActiveItems addObject:model];
}

- (NSString*)checkLetvFinishListInfos:(LetvSpecialFinishBillInputParams*)list
{
    //是否安装工单
    BOOL bInstallOrder = [list.serviceReqType isEqualToString:@"18"];
    //是否维修工单
    BOOL isRepairOrder = !bInstallOrder;
    
    //是否会员卡未激活
    BOOL isCardInactive = [list.vipCardActive isEqualToString:@"0"];
    
    do {
        ReturnIf([Util isEmptyString:list.category])@"请选择品类";
        ReturnIf([Util isEmptyString:list.buyDate])@"请选择购买日期";
        ReturnIf([self.purchaseDateCell.date isLaterThanDate:[NSDate date]])@"购机时间不能晚于当前时间";
        ReturnIf([Util isEmptyString:list.securityLabe])@"请选择产品质保";
        ReturnIf([Util isEmptyString:list.statusL1])@"请选择一级工单状态";
        ReturnIf([Util isEmptyString:list.statusL2])@"请选择二级工单状态";
        ReturnIf([Util isEmptyString:list.faultCode])@"请选择故障代码";
        ReturnIf([Util isEmptyString:list.faultDesc])@"请填写故障现象";
        ReturnIf([Util isEmptyString:list.handleResult])@"请填写处理结果";
        if (isCardInactive) {
            ReturnIf([Util isEmptyString:list.notActiveCause])@"请填写会员卡未激活原因";
        }
        if (bInstallOrder) {
            ReturnIf([Util isEmptyString:list.vipCardActive])@"请选择会员卡激活项";
        }
        if (isRepairOrder) {
            ReturnIf([Util isEmptyString:list.faultHandling])@"请填写处理措施";
        }
    } while (0);
    
    return nil;
}

- (LetvSpecialFinishBillInputParams*)readLetvFinishListInfos
{
    LetvSpecialFinishBillInputParams *list = [LetvSpecialFinishBillInputParams new];
    
    list.objectId = self.orderDetails.objectId.description;
    list.repairManId = self.user.userId;
    
    list.serviceReqType = self.orderDetails.serviceReqType;
    list.brand = self.productCell.brandItem.key;
    list.productType = self.productCell.productItem.key;
    list.category = self.productCell.typeItem.key;
    list.buyDate = [NSString dateStringWithDate:self.purchaseDateCell.date strFormat:WZDateStringFormat10];
    
    list.securityLabe = self.warrantyCell.selectedItemKey;
    list.vipCardActive = self.isVipCardActiveCell.selectedItemKey;
    list.notActiveCause = self.cardInactiveReasonCell.textView.text;
    list.faultHandling = self.resolutionCell.textView.text;
    list.statusL1 = self.level1StatusCell.checkedItemKey;
    list.statusL2 = self.level2StatusCell.checkedItemKey;
    list.faultCode = self.selectIssueCodeModel.key;
    list.faultDesc = self.issueDesCell.textView.text;
    list.handleResult = self.resolvedDesCell.textView.text;
    
    return list;
}

- (void)submitLetvFinishListInfos:(LetvSpecialFinishBillInputParams*)input
{
    [Util showWaitingDialog];
    [self.httpClient letv_specialRepairFinishBill:input response:^(NSError *error, HttpResponseData *responseData) {
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

- (void)confirmButtonClicked:(id)sender
{
    [self gotoSubmitLetvFinishListInfos];
}

- (void)gotoSubmitLetvFinishListInfos
{
    LetvSpecialFinishBillInputParams *list = [self readLetvFinishListInfos];
    NSString *invalid = [self checkLetvFinishListInfos:list];
    if (nil == invalid) {
        [self submitLetvFinishListInfos:list];
    }else {
        [Util showToast:invalid];
    }
}

- (void)setupTableDataSourceModel
{
    TableViewSectionHeaderData *headerData;
    NSInteger section, row;
    
    [self.sourceModel cleanDataSourceModel];

    //产品确认
    section = 0; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"产品确认"];
    [self.sourceModel setHeaderData:headerData forSection:section];
    
    [self addCell:self.productCell toSection:section row:row++];
    [self addCell:self.purchaseDateCell toSection:section row:row++];
    [self addCell:self.warrantyCell toSection:section row:row++];

    //用户信息
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"用户信息"];
    [self.sourceModel setHeaderData:headerData forSection:section];
    
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

    //处理结果
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"处理结果"];
    [self.sourceModel setHeaderData:headerData forSection:section];
    [self addCell:self.resolvedDesCell toSection:section row:row++];
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
    
    self.title = @"特殊完工";
    
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
}

- (void)navBarLeftButtonClicked:(UIButton *)defaultLeftButton
{
    [self popViewController];
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

    self.purchaseDateCell.date = [Util dateWithString:self.orderDetails.buyDate format:WZDateStringFormat10];
    
    NSInteger segmentIndex = NSNotFound;
    
    segmentIndex = [self getValuedSegmentIndex:_warrantyItems key:orderDetails.securityLabe];
    self.warrantyCell.segment.selectedSegmentIndex = segmentIndex;
    
    segmentIndex = [self getValuedSegmentIndex:_isVipCardActiveItems key:orderDetails.vipCardActive];
    self.isVipCardActiveCell.segment.selectedSegmentIndex = (NSNotFound == segmentIndex) ? 1 : segmentIndex;
    
    self.cardInactiveReasonCell.textView.text = [Util defaultStr:@"未上门" ifStrEmpty:orderDetails.notActiveCause];
    
    self.resolutionCell.textView.text = [Util defaultStr:@"" ifStrEmpty:orderDetails.faultHandling];
    
    self.level1StatusCell.checkedItemKey = @"1010";
    [self updateLevel2StatusItems];
    self.level2StatusCell.checkedItemKey = @"101001";
    self.resolvedDesCell.textView.text = @"";
    
    [self setIssueCodeToView:orderDetails.faultCode value:orderDetails.faultCodeVal];
    self.issueDesCell.textView.text = [Util defaultStr:@"" ifStrEmpty:orderDetails.faultDesc];
}

- (void)setIssueCodeToView:(NSString*)code value:(NSString*)value
{
    [super setIssueCodeToView:code value:value];

    self.selectIssueCodeModel = [CheckItemModel modelWithValue:value forKey:code];
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
    if ((UITableViewCell*)cellData.otherData == self.issueCodeCell) {
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
    
    if (cell == self.issueCodeCell) {
        [self gotoIssueCodesFilterPage];
    }
}

- (void)typeItemSelectValueChanged:(ProductSelectCell*)cell value:(KeyValueModel*)typeItem{
}

#pragma mark - PleaseSelectViewCellDelegate

- (void)selectViewDidChecked:(PleaseSelectViewCell*)cell
{
    if (cell == self.level1StatusCell) {
        [self updateLevel2StatusItems];
    }
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


+ (LetvSpecialPerformOrderViewController*)pushMeFrom:(ViewController*)fromVc orderListVc:(ViewController*)orderListVc orderId:(NSString*)orderId
{
    LetvSpecialPerformOrderViewController *specialPerformVc = [[LetvSpecialPerformOrderViewController alloc]init];
    specialPerformVc.orderListViewController = orderListVc;
    specialPerformVc.orderId = orderId;
    [fromVc pushViewController:specialPerformVc];
    return specialPerformVc;
}

#pragma mark - SingleCheckViewController

- (void)singleCheckViewController:(WZSingleCheckViewController*)viewController didChecked:(CheckItemModel*)checkedItem
{
    if (_issueCodeFilterVc == viewController){ //故障代码
        [self setIssueCodeToView:checkedItem.key value:checkedItem.value];
        [self.tableView.tableView reloadData];

        [viewController popViewController];
    }
}

@end
