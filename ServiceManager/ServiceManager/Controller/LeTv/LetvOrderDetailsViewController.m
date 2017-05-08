//
//  LetvOrderDetailsViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/8/31.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "LetvOrderDetailsViewController.h"

@interface LetvOrderDetailsViewController ()
@property(nonatomic, strong)LetvOrderContentDetails *orderDetails;
@end

@implementation LetvOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView refreshTableViewData];
}

- (UIView*)getTableHeaderView
{
    UIView *headerView = [[UIView alloc]init];
    NSString *tempStr;
    NSInteger urgeTimes = self.orderContent.urgeTimes;    //催单次数
    NSInteger bUrgeMe = [self.orderContent.workerId isEqualToString:self.user.userId];     //是否在催我
    CGRect frame = CGRectMake(0, 0, ScreenWidth, kDefaultSpaceUnit);

    if ([self.orderContent.urgeFlag isEqualToString:@"X"] && urgeTimes > 0) {
        frame.size.height += kButtonDefaultHeight;
        [headerView addSubview:self.urgeButton];
        [self.urgeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(headerView);
            make.height.equalTo(@(kButtonDefaultHeight));
            make.centerX.equalTo(headerView);
            make.bottom.equalTo(headerView);
        }];
        
        if (urgeTimes > 0) {
            if (bUrgeMe) {
                tempStr = [NSString stringWithFormat:@"已催单 %@ 次，接受催单", @(urgeTimes)];
                self.urgeButton.userInteractionEnabled = YES;
            }else {
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

- (TableViewDataHandle*)makeDetailsDataToModel:(LetvOrderContentDetails*)orderDetail
{
    NSInteger section, row;
    TableViewSectionHeaderData *headerData;
    TableViewCellData *cellData;
    NSString *tempStr;
    
    TableViewDataHandle *sourceModel = [[TableViewDataHandle alloc]init];

    //工单信息
    section = 0, row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"工单信息"];
    headerData.subTitle = orderDetail.objectId;
    [sourceModel setHeaderData:headerData forSection:section];
    
    //乐视单号
    tempStr = self.orderDetails.letvOrderNum;
    cellData = [TableViewCellData makeWithTitle:@"乐视单号" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];

    //工单类型
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:[MiscHelper getOrderHandleTypeStrById:orderDetail.orderTypeVal]];
    cellData = [TableViewCellData makeWithTitle:@"工单类型" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    //状态
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:[MiscHelper getOrderProccessStatusStrById:orderDetail.status repairerHandle:orderDetail.isReceive]];
    cellData = [TableViewCellData makeWithTitle:@"状态" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    //紧急程度
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.priority];
    cellData = [TableViewCellData makeWithTitle:@"紧急程度" subTitle:tempStr];
    cellData.tag = kOrderDetailsItemPriorityTag;
    [sourceModel setCellData:cellData forSection:section row:row++];

    //服务请求类型
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.serviceReqTypeVal];
    cellData = [TableViewCellData makeWithTitle:@"服务请求类型" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];

    //服务项目
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.serviceItems];
    cellData = [TableViewCellData makeWithTitle:@"服务项目" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];

    //用户信息
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"用户信息"];
    [sourceModel setHeaderData:headerData forSection:section];
    
    //用户名
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.name];
    cellData = [TableViewCellData makeWithTitle:@"用户名" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    //电话
    tempStr = [MiscHelper thumbTelnumbers:self.orderDetails.phoneNum];
    cellData = [TableViewCellData makeWithTitle:@"电话" subTitle:tempStr];
    cellData.tag = kOrderDetailsItemTelTag;
    [sourceModel setCellData:cellData forSection:section row:row++];

    //地址
    cellData = [TableViewCellData makeWithTitle:@"地址" subTitle:[Util defaultStr:kUnknown ifStrEmpty:orderDetail.customerFullAddress]];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    //产品信息
    section++; row = 0;
    headerData = [TableViewSectionHeaderData makeWithTitle:@"产品信息"];
    [sourceModel setHeaderData:headerData forSection:section];
    
    //品牌
    tempStr = [NSString stringWithFormat:@"%@ | %@",orderDetail.productTypeVal, [Util defaultStr:@"品类未知" ifStrEmpty:orderDetail.categoryVal]];
    cellData = [TableViewCellData makeWithTitle:[Util defaultStr:@"品牌未知" ifStrEmpty:orderDetail.brandVal] subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];
    
    //产品质保
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.securityLabeVal];
    cellData = [TableViewCellData makeWithTitle:@"产品质保" subTitle:tempStr];
    [sourceModel setCellData:cellData forSection:section row:row++];

    //备注信息
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

//催单按钮被点击
- (void)urgeButtonClicked:(UIButton*)urgeBtn
{
    LetvAgreeUrgeInputParams *input = [[LetvAgreeUrgeInputParams alloc]init];
    input.objectId = [self.orderContent.objectId description];
    
    [Util showWaitingDialog];
    [self.httpClient letv_agreeOrderUrge:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            self.orderContent.urgeFlag = nil;
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
        ReturnIf([Util isEmptyString:self.orderDetails.phoneNum]);
        
        NSArray *telArray = [self.orderDetails.phoneNum componentsSeparatedByString:@","];
        [CallingHelper startCallings:telArray fromViewController:self];
    }else if (cellData.tag == kOrderDetailsItemNoteTag){
        [self popTextView:cellData.title];
    }
}

- (void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    LetvGetOrderDetailsInputParams *input = [LetvGetOrderDetailsInputParams new];
    input.objectId = [self.orderContent.objectId description];
    
    //response
    RequestCallBackBlock requestCallBack = ^(NSError *error, HttpResponseData *responseData) {
        if (kHttpReturnCodeSuccess == responseData.resultCode) {
            self.orderDetails = [[LetvOrderContentDetails alloc]initWithDictionary:responseData.resultData];
            self.detalsDataModel = [self makeDetailsDataToModel:self.orderDetails];
        }
        tableView.tableView.tableHeaderView = [self getTableHeaderView];
        [tableView didRequestTableViewListDatasWithCount:1 totalCount:1 page:pageInfo response:responseData error:error];
    };
    
    //request
    [self.httpClient letv_getOrderDetails:input response:requestCallBack];
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
        orderAttr.text = [Util defaultStr:@"" ifStrEmpty:self.orderContent.objectId];
        orderAttr.textColor = kColorDefaultOrange;
        headerLabel.attributedText = [NSString makeAttrString:@[titleAttr, orderAttr]];
    }else {
        headerLabel.text = headerData.title;
    }
}

@end
