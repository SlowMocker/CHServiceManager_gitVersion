//
//  ExtendOrderDetailsViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/8/31.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

static NSInteger kOrderDetailsItemTelTag = 0x879;

#import "ExtendOrderDetailsViewController.h"
#import "WZTableView.h"
#import "LeftTextRightTextCell.h"
#import "OrderExtendEditViewController.h"
#import "MutiExtendDetailListViewController.h"

static NSString *sOrderDetatilItemCellId = @"sOrderDetatilItemCellId";

@interface ExtendOrderDetailsViewController ()<WZTableViewDelegate>
@property(nonatomic, strong)WZTableView *tableView;
@property(nonatomic, strong)LeftTextRightTextCell *protypeCell;

//ITEM: NSArray(item: LeftTextRightTextModel)
@property(nonatomic, strong)NSMutableArray *detailItemArray;

@property(nonatomic, strong)UILabel *extendOrderStatusLabel;
@end

@implementation ExtendOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"延保单详情";

    if ([self alertUpdateMainConfigInfoIfNeed]) {
        return;
    }
    _tableView = [[WZTableView alloc]initWithStyle:UITableViewStyleGrouped delegate:self];
    _tableView.tableView.footerHidden = YES;
//    _tableView.tableView.headerHidden = (nil != self.extendOrder);
    [_tableView clearBackgroundColor];
    [_tableView.tableView clearBackgroundColor];
    _tableView.tableView.backgroundView = nil;
    _tableView.tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableView.tableHeaderView = [self getTableHeaderView];

    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(kDefaultSpaceUnit, kTableViewLeftPadding, 0, kTableViewLeftPadding));
    }];
    _protypeCell = [self makeTableViewCell:sOrderDetatilItemCellId];
    [self makeOrderDetailsDataForShowing];
//    if (nil == self.extendOrder) { //request details
        [self.tableView refreshTableViewData];
//    }
}

- (void)setExtendOrder:(ExtendServiceOrderContent *)extendOrder
{
    if (_extendOrder != extendOrder) {
        _extendOrder = extendOrder;
        self.extendServiceType = (kExtendServiceType)[extendOrder.type integerValue];
    }
}

- (UILabel *)extendOrderStatusLabel
{
    if (nil == _extendOrderStatusLabel) {
        _extendOrderStatusLabel = [UILabel new];
        [_extendOrderStatusLabel clearBackgroundColor];
        _extendOrderStatusLabel.textColor = kColorDefaultOrange;
        _extendOrderStatusLabel.font = SystemFont(15);
    }
    return _extendOrderStatusLabel;
}

- (UIView*)getTableHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kButtonDefaultHeight)];
    headerView.backgroundColor = kColorWhite;
    UILabel *statusTitle = [[UILabel alloc]init];
    statusTitle.textColor = kColorDarkGray;
    statusTitle.text = @"状态";
    statusTitle.font = SystemFont(15);
    [headerView addSubview:statusTitle];
    [statusTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kTableViewLeftPadding));
        make.centerY.equalTo(headerView);
    }];

    [headerView addSubview:self.extendOrderStatusLabel];
    [self.extendOrderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusTitle.mas_right).with.offset(kTableViewLeftPadding);
        make.centerY.equalTo(headerView);
    }];

    return headerView;
}

- (LeftTextRightTextCell*)makeTableViewCell:(NSString*)identifier
{
    LeftTextRightTextCell *cell = [[LeftTextRightTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell clearBackgroundColor];
    cell.leftTextLabel.textColor = kColorBlack;
    cell.leftTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.rightTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.rightTextLabel.textAlignment = NSTextAlignmentLeft;
    cell.backgroundView = nil;
//    [cell layoutCustomSubViews];
    [cell addLineTo:kFrameLocationBottom];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (NSMutableArray*)buildCellItemData:(ExtendServiceOrderContent*)orderDetail
{
    NSMutableArray *sectionArray = [NSMutableArray new];
    NSMutableArray *rowArray;
    LeftTextRightTextModel *rowData;
    NSString *tempStr;
    ExtendCustomerInfo *customer = orderDetail.customerInfo;

    //section , 用户信息
    rowArray = [NSMutableArray new];
    rowData = [LeftTextRightTextModel new];  //row
    rowData.leftText = @"用户名";
    rowData.rightText = [Util defaultStr:kNoName ifStrEmpty:orderDetail.customerInfo.cusName];
    [rowArray addObject:rowData];

    rowData = [LeftTextRightTextModel new];  //row
    rowData.leftText = @"电话";
    rowData.rightText = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.customerInfo.cusTelNumber];
    rowData.modelTag = kOrderDetailsItemTelTag;
    rowData.rightTextColor = kColorDefaultGreen;
    [rowArray addObject:rowData];
    if (![Util isEmptyString:orderDetail.customerInfo.cusMobNumber]) {
        rowData = [LeftTextRightTextModel new];  //row
        rowData.leftText = @"电话2";
        rowData.rightText = orderDetail.customerInfo.cusMobNumber;
        rowData.modelTag = kOrderDetailsItemTelTag;
        rowData.rightTextColor = kColorDefaultGreen;
        [rowArray addObject:rowData];
    }
    rowData = [LeftTextRightTextModel new];  //row
    rowData.leftText = @"地址";

    NSString *province = [Util defaultStr:kUnknown ifStrEmpty:[MiscHelper provinceValueForCode:customer.province]];
    tempStr = [NSString jointStringWithSeparator:@"" strings:province
               ,[MiscHelper cityValueForCode:customer.city]
               ,[MiscHelper districtValueForCode:customer.town]
               ,customer.streetValue
               ,customer.detailAddress
               ,nil];
    rowData.rightText = tempStr;
    [rowArray addObject:rowData];
    [sectionArray addObject:rowArray];

    //section, 产品信息
    rowArray = [NSMutableArray new];
    if (kExtendServiceTypeSingle == self.extendServiceType
        && orderDetail.productInfoList.count > 0) {
        ExtendProductContent *product = orderDetail.productInfoList[0];

        rowData = [LeftTextRightTextModel new];  //row
        rowData.leftText = [MiscHelper extendProductBrandName:product];

        NSString *productName = [MiscHelper extendSubProductName:product forType:kExtendServiceTypeSingle];
        NSString *modelName = [MiscHelper extendProductModelName:product];

        rowData.rightText = [NSString stringWithFormat:@"%@ | %@",productName
                         ,modelName];
        rowData.rightTextColor = kColorDefaultOrange;
        [rowArray addObject:rowData];

        rowData = [LeftTextRightTextModel new];  //row
        rowData.leftText = @"机号";
        rowData.rightText = [Util defaultStr:kUnknown ifStrEmpty:product.zzfld00000b];
        rowData.rightTextColor = kColorDefaultRed;
        [rowArray addObject:rowData];

        tempStr = product.zzfld00002i.description;
        rowData = [LeftTextRightTextModel new];
        rowData.leftText = @"购买日期";
        rowData.rightText = tempStr;
        rowData.rightTextColor = kColorDefaultBlue;
        [rowArray addObject:rowData];

        tempStr = [NSString stringWithFormat:@"%@ 元", product.buyprice];
        rowData = [LeftTextRightTextModel new];
        rowData.leftText = @"购买价格";
        rowData.rightText = tempStr;
        rowData.rightTextColor = kColorDefaultRed;
        [rowArray addObject:rowData];

        tempStr = [Util defaultStr:kUnknown ifStrEmpty:product.zzfld00000e];
        rowData = [LeftTextRightTextModel new];
        rowData.leftText = @"购买门店";
        rowData.rightText = tempStr;
        [rowArray addObject:rowData];

        tempStr = [Util defaultStr:kUnknown ifStrEmpty:[self.configInfoMgr getConfigItemValueByType:MainConfigInfoTableType25 code:product.pricerange]];
        rowData = [LeftTextRightTextModel new];
        rowData.leftText = @"价格区间";
        rowData.rightText = tempStr;
        [rowArray addObject:rowData];
    }else {
        for (NSInteger productIndex = 0; productIndex < orderDetail.productInfoList.count; productIndex++) {
            ExtendProductContent *product = orderDetail.productInfoList[productIndex];
            rowData = [LeftTextRightTextModel new];
            NSString *titleStr = [NSString jointStringWithSeparator:@" | " strings:[MiscHelper extendProductBrandName:product]
                        , [MiscHelper extendSubProductName:product forType:kExtendServiceTypeMutiple]
                        , [MiscHelper extendProductModelName:product]
                        , nil];
            if (![Util isEmptyString:product.zzfld00000b]) {
                titleStr = [NSString stringWithFormat:@"%@\n%@", titleStr, product.zzfld00000b];
            }
            rowData.leftText = titleStr;
            [rowArray addObject:rowData];
        }
    }
    [sectionArray addObject:rowArray];
    
    //section,延保信息
    rowArray = [NSMutableArray new];
    
    BOOL isEContract = (1==[orderDetail.econtract integerValue]);
    rowData = [LeftTextRightTextModel new];
    rowData.leftText = @"合同类型";
    rowData.rightText = isEContract ? @"电子合同":@"纸质合同";
    [rowArray addObject:rowData];

    rowData = [LeftTextRightTextModel new];
    rowData.leftText = isEContract ? @"电子合同号" : @"书面合同号";
    rowData.rightText = [Util defaultStr:kUnknown ifStrEmpty:orderDetail.contractNum];
    rowData.rightTextColor = kColorDefaultOrange;
    [rowArray addObject:rowData];
    
    tempStr = [self.configInfoMgr getConfigItemValueByType:MainConfigInfoTableType24 code:orderDetail.reason];
    rowData = [LeftTextRightTextModel new];
    rowData.leftText = @"成交原因";
    rowData.rightText = [Util defaultStr:kUnknown ifStrEmpty:tempStr];
    [rowArray addObject:rowData];
    
    tempStr = [NSString dateStringWithInterval:[self.extendOrder.signDate doubleValue] formatStr:WZDateStringFormat5];
    rowData = [LeftTextRightTextModel new];
    rowData.leftText = @"签字日期";
    rowData.rightText = tempStr;
    rowData.rightTextColor = kColorDefaultBlue;
    [rowArray addObject:rowData];

    if (kExtendServiceTypeSingle == self.extendServiceType) {
        tempStr = [Util defaultStr:kUnknown ifStrEmpty:[self.configInfoMgr warrantyYearValueById:orderDetail.extendLife]];
    }else {
        tempStr = [Util defaultStr:kUnknown ifStrEmpty:[self.configInfoMgr mutiWarrantyYearValueById:orderDetail.extendLife]];
    }
    rowData = [LeftTextRightTextModel new];
    rowData.leftText = @"延保年限";
    rowData.rightText = tempStr;
    rowData.rightTextColor = kColorDefaultRed;
    [rowArray addObject:rowData];

    tempStr = [Util defaultStr:kNone ifStrEmpty:orderDetail.Description];
    rowData = [LeftTextRightTextModel new];
    rowData.leftText = @"合同描述";
    rowData.rightText = tempStr;
    [rowArray addObject:rowData];
    [sectionArray addObject:rowArray];
 
    return sectionArray;
}

#pragma mark - TableView Delegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    [self requestExtendOrderDetails:tableView withPage:pageInfo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewCellDefaultHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.textColor = kColorDefaultBlue;
    UIView *headerView = [tableView makeHeaderViewWithSubLabel:headerLabel bottomLineHeight:1];

    switch (section) {
        case 0:
            headerLabel.text = @"用户信息";
            break;
        case 1:
            if (kExtendServiceTypeSingle == self.extendServiceType
                && self.extendOrder.productInfoList.count > 0) {
                headerLabel.text = @"产品信息";
            }else {
                headerLabel.text = [NSString stringWithFormat:@"产品信息 ( %@ 台 )", @(self.extendOrder.productInfoList.count)];
                UIButton *mutiProductDetailsBtn = [UIButton transparentTextButton:@"查看产品详情"];
                [mutiProductDetailsBtn setTitleColor:kColorDefaultGreen forState:UIControlStateNormal];
                [mutiProductDetailsBtn addTarget:self action:@selector(mutiProductDetailsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [headerView addSubview:mutiProductDetailsBtn];
                [mutiProductDetailsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(headerView);
                    make.right.equalTo(headerView).with.offset(-kTableViewLeftPadding);
                }];
                headerView.userInteractionEnabled = YES;
            }
            break;
        case 2:
            headerLabel.text = @"延保信息";
            break;
        default:
            break;
    }
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.detailItemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *attrArray = self.detailItemArray[section];
    return attrArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *attrArray = self.detailItemArray[indexPath.section];
    LeftTextRightTextModel *orderAttr = attrArray[indexPath.row];

    [self setCell:self.protypeCell withData:orderAttr];

    return MAX([self.protypeCell fitHeight], kTableViewCellDefaultHeight);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *attrArray = self.detailItemArray[indexPath.section];
    LeftTextRightTextModel *orderAttr = attrArray[indexPath.row];

    LeftTextRightTextCell *cell = [tableView dequeueReusableCellWithIdentifier:sOrderDetatilItemCellId];
    if (nil == cell) {
        cell = [self makeTableViewCell:sOrderDetatilItemCellId];
    }
    return [self setCell:cell withData:orderAttr];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSArray *attrArray = self.detailItemArray[indexPath.section];
    LeftTextRightTextModel *orderAttr = attrArray[indexPath.row];

    if (kOrderDetailsItemTelTag == orderAttr.modelTag) {
        ReturnIf([Util isEmptyString:orderAttr.rightText]);
        NSArray *telArray = [orderAttr.rightText componentsSeparatedByString:@","];
        [CallingHelper startCallings:telArray fromViewController:self];
    }
}

- (void)requestExtendOrderDetails:(WZTableView*)tableView withPage:(PageInfo*)pageInfo
{
    ExtendOrderDetailsInputParams *input = [ExtendOrderDetailsInputParams new];
    input.extendprdId = [NSString stringWithFormat:@"%@", self.extendServiceOrderId];

    [self.httpClient extendOrderDetails:input response:^(NSError *error, HttpResponseData *responseData) {
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            NSDictionary *detailDic = responseData.resultData;
            self.extendOrder = [MiscHelper parserExtendOrderDetails:detailDic];
            [self makeOrderDetailsDataForShowing];
        }
        [tableView didRequestTableViewListDatasWithCount:1 totalCount:1 page:pageInfo response:responseData error:error];
    }];
}

- (void)makeOrderDetailsDataForShowing
{
    self.detailItemArray = [self buildCellItemData:self.extendOrder];
    self.extendOrderStatusLabel.text = getExtendServiceOrderStatusById(self.extendOrder.status);

    if (self.extendOrder.editable) {
        [self setNavBarRightButton:@"编辑" clicked:@selector(editExtendOrderButtonClicked:)];
    }
}

- (UITableViewCell*)setCell:(LeftTextRightTextCell*)cell withData:(LeftTextRightTextModel*)data
{
    data.rightTextColor = data.rightTextColor ? data.rightTextColor : kColorDarkGray;
    if (kOrderDetailsItemTelTag == data.modelTag && ![Util isEmptyString:data.rightText] && ![data.rightText isEqualToString:kUnknown]) {
        UIImageView *telImgView = [[UIImageView alloc]initWithImage:ImageNamed(@"phone-call-green")];
        data.accessoryView = telImgView;
    }
    cell.dataModel = data;
    [cell layoutCustomSubViews];
    return cell;
}

- (void)mutiProductDetailsBtnClicked:(id)sender
{
    MutiExtendDetailListViewController *productsVc = [[MutiExtendDetailListViewController alloc]init];
    productsVc.extendOrder = self.extendOrder;
    [self pushViewController:productsVc];
}

- (void)editExtendOrderButtonClicked:(id)sender
{
    OrderExtendEditViewController *extendEditVc = [[OrderExtendEditViewController alloc]init];
    extendEditVc.extendOrderEditMode = kExtendOrderEditModeEdit;
    extendEditVc.extendServiceType = (kExtendServiceType)[self.extendOrder.type integerValue];
    extendEditVc.extendOrder = self.extendOrder;
    [self pushViewController:extendEditVc];
}

@end
