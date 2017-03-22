//
//  YunCHIQAirConditioningInfoViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/9/14.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "YunCHIQAirConditioningInfoViewController.h"
#import "WZTableView.h"
#import "TwoTextLabelCell.h"

static NSString *sOrderDetatilItemCellId = @"sOrderDetatilItemCellId";

@interface YunCHIQAirConditioningInfoViewController ()<WZTableViewDelegate>
@property(nonatomic, strong)WZTableView *tableView;
@property(nonatomic, strong)TwoTextLabelCell *protypeCell;

//ITEM: NSArray(item: KeyValueModel)
@property(nonatomic, strong)NSMutableArray *detailItemArray;

@property(nonatomic, strong)CHIQYunAirConditioningInfos *deviceInfos;
@end

@implementation YunCHIQAirConditioningInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[WZTableView alloc]initWithStyle:UITableViewStyleGrouped delegate:self];
    _tableView.tableView.footerHidden = YES;
    _tableView.pageInfo.pageSize = MAXFLOAT;
    [_tableView clearBackgroundColor];
    [_tableView.tableView clearBackgroundColor];
    _tableView.tableView.backgroundView = nil;
    _tableView.tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kTableViewLeftPadding, 0, kTableViewLeftPadding));
    }];
    _protypeCell = [self makeTableViewCell:sOrderDetatilItemCellId];
    
    [_tableView refreshTableViewData];
}

- (TwoTextLabelCell*)makeTableViewCell:(NSString*)identifier
{
    TwoTextLabelCell *cell = [[TwoTextLabelCell alloc]initWithLayoutType:TwoTextLabelCellLayoutTopBottom reuseIdentifier:identifier];
    [cell clearBackgroundColor];
    cell.estimatedCellWidth = ScreenWidth - kTableViewLeftPadding * 2;
    cell.label1.textColor = kColorBlack;
    cell.label1.font = SystemFont(15);
    cell.label2.textColor = [UIColor grayColor];
    cell.label2.font = SystemFont(15);
    cell.backgroundView = nil;
    [cell addLineTo:kFrameLocationBottom];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (KeyValueModel*)model:(NSString*)value key:(NSString*)key keyExtro:(NSString*)keyExtro
{
    KeyValueModel *model = [KeyValueModel new];
    NSString *tempStr = key;

    if ([Util isEmptyString:key]) {
        tempStr = keyExtro;
    }else {
        if (![Util isEmptyString:keyExtro]) {
            tempStr = [NSString stringWithFormat:@"%@ (%@)", key, keyExtro];
        }
    }
    model.key = tempStr;

    model.value = [Util defaultStr:kUnknown ifStrEmpty:value];
    return model;
}

- (NSMutableArray*)buildCellItemData:(CHIQYunAirConditioningInfos*)device
{
    NSMutableArray *sectionArray = [NSMutableArray new];

    NSMutableArray *rowArray;
    KeyValueModel *rowData;

    //section
    rowArray = [NSMutableArray new];

    rowData = [self model:device.acModel key:@"整机机型" keyExtro:nil];
    [rowArray addObject:rowData];
    rowData = [self model:device.socPowerName key:@"SOC电源" keyExtro:device.socPowerCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.dcFanDriName key:@"直流风机驱动" keyExtro:device.dcFanDriCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.inBoardName key:@"室内主板" keyExtro:device.inBoardCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.dispSwitchName key:@"显示组件/含开关" keyExtro:device.dispSwitchCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.lightWareName key:@"光感组件" keyExtro:device.lightWareCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.dispWareName key:@"显示组件" keyExtro:device.dispWareCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.socWareName key:@"SOC组件" keyExtro:device.socWareCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.infraredWareName key:@"红外组件" keyExtro:device.infraredWareCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.inFanName key:@"室内风机" keyExtro:device.inFanCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.inTempSensorName key:@"室温传感器" keyExtro:device.inTempSensorCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.inPanSensorName key:@"内盘传感器" keyExtro:device.inPanSensorCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.compRadiatorName key:@"压驱组件/含散热器" keyExtro:device.compRadiatorCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.outBoardName key:@"室外主板" keyExtro:device.outBoardCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.compNoRadiatorName key:@"压驱组件/不含散热器" keyExtro:device.compNoRadiatorCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.compressorName key:@"压缩机" keyExtro:device.compressorCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.outFanName key:@"室外风机" keyExtro:device.outFanCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.gasSensorName key:@"排气传感器" keyExtro:device.gasSensorCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.outPanSensorName key:@"外盘传感器" keyExtro:device.outPanSensorCode];
    [rowArray addObject:rowData];
    rowData = [self model:device.outSensorName key:@"室外传感器" keyExtro:device.outSensorCode];
    [rowArray addObject:rowData];

    [sectionArray addObject:rowArray];

    return sectionArray;
}

#pragma mark - TableView Delegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    NSString *machineCode = [Util defaultStr:self.orderDetails.machinemodel2 ifStrEmpty:self.orderDetails.machinemodel];

    [self.httpClient getCHIQAirConditioningInfo:machineCode response:^(NSError *error, HttpResponseData *responseData) {
        NSString *retCode = [responseData.resultData objForKey:@"code"];
        if ([retCode isEqualToString:@"0"]) {
            responseData.resultCode = kHttpReturnCodeSuccess;
        }else {
            responseData.resultCode = kHttpReturnCodeErrorUnkown;
            responseData.resultInfo = retCode;
        }

        if (!error && responseData.resultCode == kHttpReturnCodeSuccess) {
            NSDictionary *deviceInfoDic = [responseData.resultData objForKey:@"orderlist"];
            self.deviceInfos = [[CHIQYunAirConditioningInfos alloc]initWithDictionary:deviceInfoDic];
            self.detailItemArray = [self buildCellItemData:self.deviceInfos];
        }
        [tableView didRequestTableViewListDatasWithCount:1 totalCount:1 page:pageInfo response:responseData error:error];
    }];
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
            headerLabel.text = @"设备信息";
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
    KeyValueModel *orderAttr = attrArray[indexPath.row];
    [self setCell:self.protypeCell withData:orderAttr];
    return MAX([self.protypeCell fitHeight], kTableViewCellDefaultHeight);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *attrArray = self.detailItemArray[indexPath.section];
    KeyValueModel *orderAttr = attrArray[indexPath.row];
    
    TwoTextLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:sOrderDetatilItemCellId];
    if (nil == cell) {
        cell = [self makeTableViewCell:sOrderDetatilItemCellId];
    }
    return [self setCell:cell withData:orderAttr];
}

- (TwoTextLabelCell*)setCell:(TwoTextLabelCell*)cell withData:(KeyValueModel*)data
{
    cell.label1.text = [NSString stringWithFormat:@" • %@",data.key];
    cell.label2.text = data.value;

    return cell;
}
@end
