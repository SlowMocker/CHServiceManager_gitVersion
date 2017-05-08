//
//  SmartMiOrderDetailsViewController.m
//  ServiceManager
//
//  Created by Wu on 17/3/27.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "SmartMiOrderDetailsViewController.h"

#import "YunDeviceInfoViewController.h"
#import "OrderExtendEditViewController.h"
#import "ExtendOrderDetailsViewController.h"
#import "YunCHIQAirConditioningInfoViewController.h"

typedef NS_ENUM(NSInteger, kOrderDetailsHeaderViewType)
{
    kOrderDetailsHeaderViewTypeNone = 0,
    kOrderDetailsHeaderViewTypeService, //服务改善
    kOrderDetailsHeaderViewTypeYun,     //云电视
    kOrderDetailsHeaderViewTypeUrge,    //催单
    kOrderDetailsHeaderViewTypeYunAndUrge   //云电视和催单
};


@interface SmartMiOrderDetailsViewController ()

@property(nonatomic , strong) SmartMiOrderContentDetails *orderDetails;/**< 订单详情 */

@end

@implementation SmartMiOrderDetailsViewController

#pragma mark
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView refreshTableViewData];
}

#pragma mark
#pragma mark override methods
// 催单按钮点击事件
- (void) urgeButtonClicked:(UIButton*)urgeBtn {
    SmartMiRepairerAgreeOrderUrgeInputParams *input = [[SmartMiRepairerAgreeOrderUrgeInputParams alloc]init];
    input.objectId = [self.orderContent.objectId description];
    
    [Util showWaitingDialog];
    [self.httpClient smartMi_repairer_agreeOrderUrge:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) { // 维修工接受催单成功
            self.orderContent.urgeFlag = nil;
            self.tableView.tableView.tableHeaderView = [self getTableHeaderView];
            [self.tableView.tableView reloadData];
            [self postNotification:NotificationOrderChanged];
        }
        else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

// 给 cell 设置数据
- (UITableViewCell *) setCell:(LeftTextRightTextCell*)cell withData:(TableViewCellData*)data {
    cell.leftTextLabel.text = data.title;
    cell.rightTextLabel.text = data.subTitle;
    cell.accessoryView = nil;
    cell.rightTextLabel.textColor = kColorDarkGray;
    
    if (data.tag == kOrderDetailsItemTelTag && ![data.subTitle isEqualToString:kUnknown]) {
        UIImageView *telImgView = [[UIImageView alloc]initWithImage:ImageNamed(@"phone-call-green")];
        cell.accessoryView = telImgView;
        cell.rightTextLabel.textColor = kColorDefaultGreen;
    }else if (data.tag == kOrderDetailsItemPriorityTag && [data.subTitle isEqualToString:@"紧急"]){
        cell.rightTextLabel.textColor = kColorDefaultRed;
    }else if (data.tag == kOrderExtendAddItemTag || data.tag == kOrderMutiExtendAddItemTag){
        cell.leftTextLabel.textColor = kColorDefaultGreen;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (data.tag == kOrderExtendOrderDetailsItemTag){
        cell.rightTextLabel.textColor = kColorDefaultOrange;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.leftTextLabel.textColor = kColorBlack;
        cell.rightTextLabel.textColor = kColorDefaultGray;
        cell.accessoryType = UITableViewCellSeparatorStyleNone;
    }
    //备注支持长按复制，或单击进入新视图进行选择、复制等操作
    cell.leftTextLabel.isCopyable = (data.tag == kOrderDetailsItemNoteTag);
    
    [cell layoutCustomSubViews];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TableViewCellData *cellData = [self.detalsDataModel cellDataForSection:indexPath.section row:indexPath.row];
    
    if (cellData.tag == kOrderDetailsItemTelTag) {
        ReturnIf([Util isEmptyString:self.orderDetails.phoneNum]);
        
        NSArray *telArray = [self.orderDetails.phoneNum componentsSeparatedByString:@","];
        [CallingHelper startCallings:telArray fromViewController:self];
    }
    else if (cellData.tag == kOrderExtendAddItemTag || kOrderMutiExtendAddItemTag == cellData.tag) { // 延保
//        OrderExtendEditViewController *extendEditVc = [[OrderExtendEditViewController alloc]init];
//        extendEditVc.orderDetails = self.orderDetails;
//        extendEditVc.orderDetails = nil;
//        extendEditVc.extendOrderEditMode = kExtendOrderEditModeAppend;
//        extendEditVc.extendServiceType = (cellData.tag == kOrderExtendAddItemTag)?kExtendServiceTypeSingle:kExtendServiceTypeMutiple;
//        [self pushViewController:extendEditVc];
    }
    else if (cellData.tag == kOrderExtendOrderDetailsItemTag) {
//        ExtendOrderDetailsViewController *detailVc = [[ExtendOrderDetailsViewController alloc]init];
//        detailVc.extendServiceOrderId = self.orderDetails.extendprdId.description;
//        kExtendServiceType extendType = (kExtendServiceType)[self.orderDetails.extendprdType integerValue];
//        detailVc.extendServiceType = extendType;
//        [self pushViewController:detailVc];
    }
    else if (cellData.tag == kOrderDetailsItemNoteTag) {
        [self popTextView:cellData.title];
    }
}

- (void) tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo {
    
    SmartMiGetOrderDetailsInputParams *input = [SmartMiGetOrderDetailsInputParams new];
    input.objectId = [self.orderContent.objectId description];
    
    //response
    RequestCallBackBlock requestCallBack = ^(NSError *error, HttpResponseData *responseData) {
        if (kHttpReturnCodeSuccess == responseData.resultCode) {
            self.orderDetails = [[SmartMiOrderContentDetails alloc]initWithDictionary:responseData.resultData];
            self.detalsDataModel = [self makeDetailsDataToModel:self.orderDetails];
        }
//        tableView.tableView.tableHeaderView = [self getTableHeaderView];
        [tableView didRequestTableViewListDatasWithCount:1 totalCount:1 page:pageInfo response:responseData error:error];
    };
    
    [self.httpClient smartMi_getOrderDetails:input response:requestCallBack];
}

// 设置 section 标题
- (void) setDataToHeaderLabel:(UILabel*)headerLabel inSection:(NSInteger)section {
    TableViewSectionHeaderData *headerData = [self.detalsDataModel headerDataOfSection:section]; // 获取 section 数据源
    
    if (0 == section) { // 工单信息
        AttributeStringAttrs *titleAttr = [AttributeStringAttrs new];
        titleAttr.text = [NSString stringWithFormat:@"%@\t",headerData.title];
        titleAttr.textColor = headerLabel.textColor;
        AttributeStringAttrs *orderAttr = [AttributeStringAttrs new];
        orderAttr.text = [Util defaultStr:@"" ifStrEmpty:self.orderContent.objectId];
        orderAttr.textColor = kColorDefaultOrange;
        headerLabel.attributedText = [NSString makeAttrString:@[titleAttr, orderAttr]];
    }
    else { // 其它 section header 信息
        headerLabel.text = headerData.title;
    }
}

#pragma mark
#pragma mark private methods
// tableView 的 headerView 实际就是一个催单按钮
- (UIView *) getTableHeaderView {
    UIView *headerView = [[UIView alloc]init];
    
    NSString *tempStr;
    NSInteger urgeTimes = self.orderContent.urgeTimes.integerValue; // 催单次数
    NSInteger bUrgeMe = [self.orderContent.workerId isEqualToString:self.user.userId]; // 是否在催我
    CGRect frame = CGRectMake(0, 0, ScreenWidth, kDefaultSpaceUnit);
    
    if ([self.orderContent.urgeFlag isEqualToString:@"X"] && urgeTimes > 0) { // 催单，显示催单按钮
        frame.size.height += kButtonDefaultHeight;
        [headerView addSubview:self.urgeButton];
        [self.urgeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(headerView);
            make.height.equalTo(@(kButtonDefaultHeight));
            make.centerX.equalTo(headerView);
            make.bottom.equalTo(headerView);
        }];
        
        if (urgeTimes > 0) {
            if (bUrgeMe) { // 向当前登录人员催单，可以接受催单
                tempStr = [NSString stringWithFormat:@"已催单 %@ 次，接受催单", @(urgeTimes)];
                self.urgeButton.userInteractionEnabled = YES;
            }
            else {
                tempStr = [NSString stringWithFormat:@"已催单 %@ 次", @(urgeTimes)];
                self.urgeButton.userInteractionEnabled = NO;
            }
            [self.urgeButton setTitle:tempStr forState:UIControlStateNormal];
        }
    }
    [headerView clearBackgroundColor];
    headerView.frame = frame;
    return headerView;
}

// 根据工单详情获取工单详情的总数据
- (TableViewDataHandle *) makeDetailsDataToModel:(SmartMiOrderContentDetails*)orderDetail {
    NSInteger section, row;
    TableViewSectionHeaderData *headerData;
    TableViewCellData *cellData;
    NSString *tempStr;

    TableViewDataHandle *sourceModel = [[TableViewDataHandle alloc]init];
    
    /*
    header: 工单信息
    
    智米订单号      170227000010
    状态           已派工
    服务类型        安装
    紧急程度        一般
    信息来源        京东（仅维修工单可见）
    CRM 收单时间    2017-03-13 13:50
    派工给服务商的时间 2017-03-14 13:50
     */
    // 工单信息 section
    section = 0, row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"工单信息"];
    headerData.subTitle = orderDetail.objectId;
    [sourceModel setHeaderData:headerData forSection:section];

    // 智米订单号
    cellData = [TableViewCellData makeWithTitle:@"智米订单号" subTitle:orderDetail.smartmiOrderNum];
    [sourceModel setCellData:cellData forSection:section row:row++];

    // 状态
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:[MiscHelper getOrderProccessStatusStrById:orderDetail.status repairerHandle:orderDetail.isReceive]];
    cellData = [TableViewCellData makeWithTitle:@"状态" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    // 服务类型
    cellData = [TableViewCellData makeWithTitle:@"服务类型" subTitle:orderDetail.orderTypeVal];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    // 紧急程度
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.priority];
    cellData = [TableViewCellData makeWithTitle:@"紧急程度" subTitle:tempStr];
    cellData.tag = kOrderDetailsItemPriorityTag;
    [sourceModel setCellData:cellData forSection:section row:row++];

    // 信息来源（仅维修工单可见）
    if (![orderDetail.orderTypeVal containsString:@"安装"]) {
        tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.sourceVal];
        cellData = [TableViewCellData makeWithTitle:@"信息来源" subTitle:tempStr];
        [sourceModel setCellData:cellData forSection:section row:row++];
    }
    
    // CRM 收单时间
    cellData = [TableViewCellData makeWithTitle:@"CRM 收单时间" subTitle:[Util ymdhmWithDate:[Util dateWithString:orderDetail.createTime format:WZDateStringFormat9]]];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    // 派工给服务商的时间
    cellData = [TableViewCellData makeWithTitle:@"派工给服务商的时间" subTitle:[Util ymdhmWithDate:[Util dateWithString:orderDetail.dispatchDate format:WZDateStringFormat9]]];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    /*
     header: 用户信息
     
     姓名             张三
     电话             13477495665[电话图标]（没有电话号码时，显示未知，不显示电话图标）
     地址             [省－市/区－县－街道 + 详细地址]
     楼层             15 楼
     希望上门时间       2017－03-15 13:50
     */
    // 用户信息
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"用户信息"];
    [sourceModel setHeaderData:headerData forSection:section];
    
    // 姓名
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.name];
    cellData = [TableViewCellData makeWithTitle:@"用户名" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];

    // 电话
    tempStr = [MiscHelper thumbTelnumbers:self.orderDetails.phoneNum];
    cellData = [TableViewCellData makeWithTitle:@"电话" subTitle:tempStr];
    cellData.tag = kOrderDetailsItemTelTag;
    [sourceModel setCellData:cellData forSection:section row:row++];

    // 地址
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.customerFullAddress];
    cellData = [TableViewCellData makeWithTitle:@"地址" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    // 楼层
    cellData = [TableViewCellData makeWithTitle:@"楼层" subTitle:orderDetail.floor];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    // 希望上门时间
    cellData = [TableViewCellData makeWithTitle:@"希望上门时间" subTitle:[Util ymdhmWithDate:[Util dateWithString:orderDetail.requestTime format:WZDateStringFormat9]]];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    /*
     header: 产品信息
     
     品牌             智米（仅维修工单可见）
     产品大类          空调
     品类             整机
     设备串号          123ABC－789DE－123F
     外机条码          A1234567890
     内机条码          B234567890
     购机日期          2017-03-12（仅维修工单可见）
     保修类型          保内（仅维修工单可见）
     是否官方购买支架    是
     故障现象           [具体故障现象]（仅维修工单可见）
     */
    // 产品信息
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"产品信息"];
    [sourceModel setHeaderData:headerData forSection:section];

    // 品牌
    cellData = [TableViewCellData makeWithTitle:@"品牌" subTitle:orderDetail.brandVal];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    // 产品大类
    cellData = [TableViewCellData makeWithTitle:@"产品大类" subTitle:orderDetail.productTypeVal];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    // 品类（仅维修工单可见）
    if (![orderDetail.orderTypeVal containsString:@"安装"]) {
        cellData = [TableViewCellData makeWithTitle:@"品类" subTitle:orderDetail.categoryVal];
        [sourceModel setCellData:cellData forSection:section row:row++];
    }
    
    // 设备串号
    cellData = [TableViewCellData makeWithTitle:@"设备串号" subTitle:orderDetail.snCode];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    // 外机条码
    cellData = [TableViewCellData makeWithTitle:@"外机条码" subTitle:orderDetail.externalBarCode];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    // 内机条码
    cellData = [TableViewCellData makeWithTitle:@"内机条码" subTitle:orderDetail.hostBarcode];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    // 购机日期（仅维修工单可见）
    if (![orderDetail.orderTypeVal containsString:@"安装"]) {
        cellData = [TableViewCellData makeWithTitle:@"购机日期" subTitle:[Util ymdhmWithDate:[Util dateWithString:orderDetail.buyDate format:WZDateStringFormat9]]];
        [sourceModel setCellData:cellData forSection:section row:row++];
    }
    
    // 保修类型（仅维修工单可见）
    if (![orderDetail.orderTypeVal containsString:@"安装"]) {
        cellData = [TableViewCellData makeWithTitle:@"保修类型" subTitle:orderDetail.securityLabeVal];
        [sourceModel setCellData:cellData forSection:section row:row++];
    }
    
    // 是否官方购买支架
    cellData = [TableViewCellData makeWithTitle:@"是否官方购买支架" subTitle:[orderDetail.isBuyRack isEqualToString:@"1"] ? @"是" : @"否"];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    // 故障现象（仅维修工单可见）
    if (![orderDetail.orderTypeVal containsString:@"安装"]) {
        cellData = [TableViewCellData makeWithTitle:@"故障现象 " subTitle:orderDetail.faultDesc];
        [sourceModel setCellData:cellData forSection:section row:row++];
    }
    /*
     header: 备注信息
     2015-07-22 13:25:23--WQB: 备注文本；上门地址: 四川省绵阳市园艺山公路街123号
     
     备注信息按流水倒序排序（即：最新的显示在最上面）。
     若没有备注信息时，显示“暂无”。
     其中，在 CRM 的“历史备注”后面附加手机服务器的工单处理日志，每条日志包括记录时间和一、二级工单状态信息。
     */
    // 备注信息
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"备注信息"];
    [sourceModel setHeaderData:headerData forSection:section];
    
    NSMutableArray *itemArray = [[NSMutableArray alloc]init];
    
    if (![Util isEmptyString:orderDetail.memo]) {
        [itemArray addObjectsFromArray: [orderDetail.memo componentsSeparatedByString:@"\n\n"]];
    }
    
    if (itemArray.count > 0) {
        for (NSString *desStr in itemArray) {
            if (![Util isEmptyString:desStr]) {
                cellData = [TableViewCellData makeWithTitle:desStr subTitle:nil];
                cellData.tag = kOrderDetailsItemNoteTag;
                [sourceModel setCellData:cellData forSection:section row:row++];
            }
        }
    }else{
        cellData = [TableViewCellData makeWithTitle:kNone subTitle:nil];
        [sourceModel setCellData:cellData forSection:section row:row++];
    }
    
    return sourceModel;
}

@end

