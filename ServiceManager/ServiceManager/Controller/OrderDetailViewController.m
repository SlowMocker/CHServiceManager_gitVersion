//
//  OrderDetailViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/8/31.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ServiceImproveAlertView.h"
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

@interface OrderDetailViewController ()

@property(nonatomic, strong)OrderContentDetails *orderDetails;

@property(nonatomic, strong)UITableViewCell *smartYunCell;

//header view, only one
@property(nonatomic, strong)ServiceImproveAlertView *alertView;//服务改善
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView refreshTableViewData];
}

- (ServiceImproveAlertView*)alertView
{
    if (nil == _alertView) {
        _alertView = [[ServiceImproveAlertView alloc]initWithDefault];
    }
    return _alertView;
}

- (UITableViewCell *)smartYunCell
{
    if (nil == _smartYunCell) {
        _smartYunCell = [MiscHelper makeCommonSelectCell:@"智能云平台"];
        [_smartYunCell addSingleTapEventWithTarget:self action:@selector(smartYunCellTap:)];
        _smartYunCell.detailTextLabel.text = nil;
        _smartYunCell.backgroundColor = kColorWhite;
        _smartYunCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _smartYunCell.imageView.image = ImageNamed(@"cloud_blue");
        _smartYunCell.layer.borderWidth = 1.0;
        _smartYunCell.layer.borderColor = kColorLightGray.CGColor;
        _smartYunCell.layer.cornerRadius = 5.0;
    }
    return _smartYunCell;
}

- (UIView*)getTableHeaderView
{
    NSString *tempStr;
    UIView *headerView = [[UIView alloc]init];
    CGRect headerViewFrame = CGRectMake(0, 0, ScreenWidth, kButtonDefaultHeight + 2 * kDefaultSpaceUnit);
    [headerView clearBackgroundColor];

    kOrderDetailsHeaderViewType headerViewType;
    BOOL isSmartYun = [self.orderContent.zzfld000000 isEqualToString:@"启客"]
        && [self.orderDetails.process_type isEqualToString:@"ZR01"]
        && (![Util isEmptyString:self.orderDetails.machinemodel] || ![Util isEmptyString:self.orderDetails.machinemodel2]);

    if (self.isServiceImprovementOrder) {
        headerViewType = kOrderDetailsHeaderViewTypeService;
    }else if ([self.orderContent.urgeflag isEqualToString:@"X"] && self.orderContent.urgetimes > 0){
        if (isSmartYun) {
            headerViewType = kOrderDetailsHeaderViewTypeYunAndUrge;
        }else {
            headerViewType = kOrderDetailsHeaderViewTypeUrge;
        }
        if ([self.orderContent.wxg_isreceive isEqualToString:@"1"]&&[self.orderContent.partner_fwg isEqualToString:self.user.userId]) {
            tempStr = [NSString stringWithFormat:@"已催单 %@ 次，接受催单", @(self.orderContent.urgetimes)];
            self.urgeButton.userInteractionEnabled = YES;
        }else {
            tempStr = [NSString stringWithFormat:@"已催单 %@ 次", @(self.orderContent.urgetimes)];
            self.urgeButton.userInteractionEnabled = NO;
        }
        [self.urgeButton setTitle:tempStr forState:UIControlStateNormal];
    }else if (isSmartYun){
        headerViewType = kOrderDetailsHeaderViewTypeYun;
    }else {
        headerViewType = kOrderDetailsHeaderViewTypeNone;
    }

    switch (headerViewType) {
        case kOrderDetailsHeaderViewTypeService:
        {
            self.alertView.alertTitle.text = @"服务投诉";
            tempStr = [Util defaultStr:kUnknown ifStrEmpty:self.orderDetails.infosource];
            self.alertView.textLable1.text = [NSString stringWithFormat:@"信息来源 : %@", tempStr];
            
            tempStr = [Util defaultStr:kUnknown ifStrEmpty:self.orderDetails.improve];
            self.alertView.textLable2.text = [NSString stringWithFormat:@"服务改善原因 : %@", tempStr];
            headerViewFrame.size.height = CGRectGetHeight(self.alertView.frame)+kDefaultSpaceUnit*2;

            CGRect frame = self.alertView.frame;
            frame.origin.y = kDefaultSpaceUnit*2;
            self.alertView.frame = frame;
            [headerView addSubview:self.self.alertView];
        }
            break;
        case kOrderDetailsHeaderViewTypeYun:
        {
            [headerView addSubview:self.smartYunCell];
            [self.smartYunCell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(ScreenWidth - kTableViewLeftPadding*2, kButtonDefaultHeight));
                make.center.mas_equalTo(headerView.center);
            }];
        }
            break;
        case kOrderDetailsHeaderViewTypeUrge:
        {
            [headerView addSubview:self.urgeButton];
            [self.urgeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(ScreenWidth - kTableViewLeftPadding*2, kButtonDefaultHeight));
                make.center.mas_equalTo(headerView.center);
            }];
        }
            break;
        case kOrderDetailsHeaderViewTypeYunAndUrge:
        {
            headerViewFrame.size.height = kButtonDefaultHeight*2 + 3 * kDefaultSpaceUnit;

            [headerView addSubview:self.smartYunCell];
            [headerView addSubview:self.urgeButton];
            [self.smartYunCell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headerView).with.offset(kDefaultSpaceUnit);
                make.left.equalTo(headerView);
                make.right.equalTo(headerView);
                make.height.equalTo(@(kButtonDefaultHeight));
            }];
            [self.urgeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.smartYunCell.mas_bottom).with.offset(kDefaultSpaceUnit);
                make.left.equalTo(headerView);
                make.right.equalTo(headerView);
                make.height.equalTo(@(kButtonDefaultHeight));
            }];
        }
            break;
        case kOrderDetailsHeaderViewTypeNone:
        default:
            headerViewFrame = CGRectMake(0, 0, ScreenWidth, kDefaultSpaceUnit);
            break;
    }

    headerView.frame = headerViewFrame;

    return headerView;
}

- (TableViewDataSourceModel*)makeDetailsDataToModel:(OrderContentDetails*)orderDetail
{
    NSInteger section, row;
    TableViewSectionHeaderData *headerData;
    TableViewCellData *cellData;
    NSString *tempStr;
    
    TableViewDataSourceModel *sourceModel = [[TableViewDataSourceModel alloc]init];
    
    //工单信息
    section = 0, row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"工单信息"];
    headerData.subTitle = orderDetail.object_id;
    [sourceModel setHeaderData:headerData forSection:section];

    //维修类型
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:[MiscHelper getOrderHandleTypeStrById:orderDetail.process_type]];
    cellData = [TableViewCellData makeWithTitle:@"维修类型" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    //状态
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:[MiscHelper getOrderProccessStatusStrById:orderDetail.status repairerHandle:orderDetail.wxg_isreceive]];
    cellData = [TableViewCellData makeWithTitle:@"状态" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    //紧急程度
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.priority];
    cellData = [TableViewCellData makeWithTitle:@"紧急程度" subTitle:tempStr];
    cellData.tag = kOrderDetailsItemPriorityTag;
    [sourceModel setCellData:cellData forSection:section row:row++];

    //信息来源
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.infosource];
    cellData = [TableViewCellData makeWithTitle:@"信息来源" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];

    //安装说明
    ConfigItemInfo *instTypeCfgItem;
    if (![Util isEmptyString:orderDetail.installExplain]) {
        instTypeCfgItem = [self.configInfoMgr findConfigItemInfoByType:MainConfigInfoTableType37 code:orderDetail.installExplain];
    }
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:instTypeCfgItem.value];
    cellData = [TableViewCellData makeWithTitle:@"安装说明" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];

    //用户信息
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"用户信息"];
    [sourceModel setHeaderData:headerData forSection:section];

    //用户名
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.custname];
    cellData = [TableViewCellData makeWithTitle:@"用户名" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    //电话
    tempStr = [MiscHelper thumbTelnumbers:self.orderDetails.telnumber];
    cellData = [TableViewCellData makeWithTitle:@"电话" subTitle:tempStr];
    cellData.tag = kOrderDetailsItemTelTag;
    [sourceModel setCellData:cellData forSection:section row:row++];

    //地址
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.customerFullAddress];
    cellData = [TableViewCellData makeWithTitle:@"地址" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    if ((kUserRoleTypeFacilitator == self.user.userRoleType
        || kUserRoleTypeRepairer == self.user.userRoleType)
        && [self.user.userId isEqualToString:orderDetail.partner_fwg]) {
        //为此用户添加单品延保
        cellData = [TableViewCellData makeWithTitle:@"为此用户添加单品延保" subTitle:nil];
        cellData.tag = kOrderExtendAddItemTag;
        [sourceModel setCellData:cellData forSection:section row:row++];
        //为此用户添加家多保
        cellData = [TableViewCellData makeWithTitle:@"为此用户添加家多保" subTitle:nil];
        cellData.tag = kOrderMutiExtendAddItemTag;
        [sourceModel setCellData:cellData forSection:section row:row++];
    }

    //产品信息
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"产品信息"];
    [sourceModel setHeaderData:headerData forSection:section];

    //品牌
    tempStr = [NSString stringWithFormat:@"%@ | %@",orderDetail.zzfld000003, orderDetail.zzfld000001];
    cellData = [TableViewCellData makeWithTitle:[Util defaultStr:@"品牌未知" ifStrEmpty:orderDetail.zzfld000000] subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];

    //机型
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.zzfld00000q];
    cellData = [TableViewCellData makeWithTitle:@"机型" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];

    //主机条码
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.machinemodel];
    cellData = [TableViewCellData makeWithTitle:@"主机条码" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];

    //附机条码
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.machinemodel2];
    cellData = [TableViewCellData makeWithTitle:@"附机条码" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    //维修信息
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"维修信息"];
    [sourceModel setHeaderData:headerData forSection:section];

    //故障现象
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.Description];
    cellData = [TableViewCellData makeWithTitle:@"故障现象" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    //故障处理
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.zzfld00002h];
    cellData = [TableViewCellData makeWithTitle:@"故障处理" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];

    //其它信息
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"其它信息"];
    [sourceModel setHeaderData:headerData forSection:section];
    
    ConfigItemInfo *cfgItem = [self.configInfoMgr promotionalActivityByCode:orderDetail.zzfld0000];
    tempStr = [Util defaultStr:kNone ifStrEmpty:cfgItem.value];
    cellData = [TableViewCellData makeWithTitle:@"销售活动" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    cfgItem = [self.configInfoMgr promotionalSubActivityByCode:orderDetail.zzfld0001];
    tempStr = [Util defaultStr:kNone ifStrEmpty:cfgItem.value];
    cellData = [TableViewCellData makeWithTitle:@"活动内容" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    tempStr = [Util defaultStr:kNone ifStrEmpty:orderDetail.zzfld0001xq];
    cellData = [TableViewCellData makeWithTitle:@"活动详情" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];

    //备件信息
    if (orderDetail.tDispatchParts.count > 0) {
        section++; row = 0;
        headerData = [TableViewSectionHeaderData makeWithTitle:@"备件信息"];
        [sourceModel setHeaderData:headerData forSection:section];
        for (PartMaintainContent *part in orderDetail.tDispatchParts) {
            tempStr = getOrderTraceStatusById(part.puton_status);
            cellData = [TableViewCellData makeWithTitle:part.part_text subTitle:tempStr];
            [sourceModel setCellData:cellData forSection:section row:row++];
        }
    }
    
    //预约情况或备注信息
    section++; row = 0;
    tempStr = self.isServiceImprovementOrder ? @"预约情况" : @"备注信息";
    headerData = [TableViewSectionHeaderData makeWithTitle:tempStr];
    [sourceModel setHeaderData:headerData forSection:section];
    
    NSMutableArray *itemArray = [[NSMutableArray alloc]init];
    
    if (self.isServiceImprovementOrder) { //预约备注
        if ([orderDetail.frequency isKindOfClass:[NSArray class]]) {
            NSArray *tmpArray = (NSArray*)orderDetail.frequency;
            NSString *itemStr;
            for (NSInteger index = 0; index < tmpArray.count; index++) {
                NSDictionary *dic = tmpArray[index];
                
                itemStr = [NSString stringWithFormat:@"第%@次预约", @(tmpArray.count - index)];
                
                //预约备注
                tempStr = nil;
                if ([dic containsKey:@"memo"]) {
                    tempStr = dic[@"memo"];
                }
                if (![Util isEmptyString:tempStr]) {
                    itemStr = [NSString stringWithFormat:@"%@ | %@", itemStr, tempStr];
                }
                
                //预约失败原因
                tempStr = nil;
                if ([dic containsKey:@"reason"]) {
                    tempStr = dic[@"reason"];
                }
                if (![Util isEmptyString:tempStr]) {
                    tempStr = [Util defaultStr:tempStr ifStrEmpty:[self.configInfoMgr getConfigItemValueByType:MainConfigInfoTableType6 code:tempStr]];
                    itemStr = [NSString stringWithFormat:@"%@ , %@", itemStr, tempStr];
                }
                [itemArray addObject:itemStr];
            }
        }
    }else { //工单备注
        if (![Util isEmptyString:orderDetail.memo]) {
            [itemArray addObjectsFromArray: [orderDetail.memo componentsSeparatedByString:@"\n\n"]];
        }
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

- (void)smartYunCellTap:(UIGestureRecognizer*)gesture
{
    ViewController *deviceInfoVc;

    BOOL isAirConditioning = [self.orderDetails.zzfld000003 isEqualToString:@"空调"];
    if (!isAirConditioning) {
        YunDeviceInfoViewController *yunDeviceInfo = [[YunDeviceInfoViewController alloc]init];
        yunDeviceInfo.orderDetails = self.orderDetails;
        deviceInfoVc = yunDeviceInfo;
    }else{
        YunCHIQAirConditioningInfoViewController *airConditionInfoVc = [[YunCHIQAirConditioningInfoViewController alloc]init];
        airConditionInfoVc.orderDetails = self.orderDetails;
        deviceInfoVc = airConditionInfoVc;
    }
    deviceInfoVc.title = [Util defaultStr:@"设备信息" ifStrEmpty:self.orderDetails.zzfld000003];
    [self pushViewController:deviceInfoVc];
}

#pragma mark - override methods

//催单按钮被点击
- (void)urgeButtonClicked:(UIButton*)urgeBtn
{
    AgreeUrgeInputParams *input = [[AgreeUrgeInputParams alloc]init];
    input.object_id = [self.orderContent.object_id description];
    
    [Util showWaitingDialog];
    [self.httpClient agreeOrderUrge:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            self.orderContent.urgeflag = nil;
            self.tableView.tableView.tableHeaderView = [self getTableHeaderView];
            [self.tableView.tableView reloadData];
            [self postNotification:NotificationOrderChanged];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

//设置数据到CELL
- (UITableViewCell*)setCell:(LeftTextRightTextCell*)cell withData:(TableViewCellData*)data
{
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

//CELL行被选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    TableViewCellData *cellData = [self.detalsDataModel cellDataForSection:indexPath.section row:indexPath.row];
    
    if (cellData.tag == kOrderDetailsItemTelTag) {
        ReturnIf([Util isEmptyString:self.orderDetails.telnumber]);

        NSArray *telArray = [self.orderDetails.telnumber componentsSeparatedByString:@","];
        [CallingHelper startCallings:telArray fromViewController:self];
    }else if (cellData.tag == kOrderExtendAddItemTag || kOrderMutiExtendAddItemTag == cellData.tag){
        OrderExtendEditViewController *extendEditVc = [[OrderExtendEditViewController alloc]init];
        extendEditVc.orderDetails = self.orderDetails;
        extendEditVc.extendOrderEditMode = kExtendOrderEditModeAppend;
        extendEditVc.extendServiceType = (cellData.tag == kOrderExtendAddItemTag)?kExtendServiceTypeSingle:kExtendServiceTypeMutiple;
        [self pushViewController:extendEditVc];
    }else if (cellData.tag == kOrderExtendOrderDetailsItemTag){
        ExtendOrderDetailsViewController *detailVc = [[ExtendOrderDetailsViewController alloc]init];
        detailVc.extendServiceOrderId = self.orderDetails.extendprdId.description;
        kExtendServiceType extendType = (kExtendServiceType)[self.orderDetails.extendprdType integerValue];
        detailVc.extendServiceType = extendType;
        [self pushViewController:detailVc];
    }else if (cellData.tag == kOrderDetailsItemNoteTag){
        [self popTextView:cellData.title];
    }
}

- (void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    GetOrderDetailsInputParams *input = [GetOrderDetailsInputParams new];
    input.object_id = [self.orderContent.object_id description];

    //response
    RequestCallBackBlock requestCallBack = ^(NSError *error, HttpResponseData *responseData) {
        if (kHttpReturnCodeSuccess == responseData.resultCode) {
            self.orderDetails = [MiscHelper parserOrderContentDetails:responseData.resultData];
            self.detalsDataModel = [self makeDetailsDataToModel:self.orderDetails];
        }
        tableView.tableView.tableHeaderView = [self getTableHeaderView];
        [tableView didRequestTableViewListDatasWithCount:1 totalCount:1 page:pageInfo response:responseData error:error];
    };
    
    //request
    if (!self.isServiceImprovementOrder) {
        [self.httpClient getOrderDetails:input response:requestCallBack];
    }else {
        [self.httpClient getServiceImproveDetails:input response:requestCallBack];
    }
}

//设置section 标题
- (void)setDataToHeaderLabel:(UILabel*)headerLabel inSection:(NSInteger)section
{
    TableViewSectionHeaderData *headerData = [self.detalsDataModel headerDataOfSection:section];

    if (0 == section) {
        AttributeStringAttrs *titleAttr = [AttributeStringAttrs new];
        titleAttr.text = [NSString stringWithFormat:@"%@\t",headerData.title];
        titleAttr.textColor = headerLabel.textColor;
        AttributeStringAttrs *orderAttr = [AttributeStringAttrs new];
        orderAttr.text = [Util defaultStr:@"" ifStrEmpty:self.orderContent.object_id];
        orderAttr.textColor = kColorDefaultOrange;
        headerLabel.attributedText = [NSString makeAttrString:@[titleAttr, orderAttr]];
    }else {
        headerLabel.text = headerData.title;
    }
}

@end
