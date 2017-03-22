//
//  YunDeviceInfoViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/9/14.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "YunDeviceInfoViewController.h"
#import "WZTableView.h"
#import "TwoTextLabelCell.h"

static NSString *sOrderDetatilItemCellId = @"sOrderDetatilItemCellId";

@interface YunDeviceInfoViewController ()<WZTableViewDelegate>
@property(nonatomic, strong)WZTableView *tableView;
@property(nonatomic, strong)TwoTextLabelCell *protypeCell;

//ITEM: NSArray(item: KeyValueModel)
@property(nonatomic, strong)NSMutableArray *detailItemArray;

@property(nonatomic, strong)DeviceInfos *deviceInfos;
@end

@implementation YunDeviceInfoViewController

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

- (NSMutableArray*)buildCellItemData:(DeviceInfos*)device
{
    NSMutableArray *sectionArray = [NSMutableArray new];
    NSMutableArray *rowArray;
    KeyValueModel *rowData;

    //section
    rowArray = [NSMutableArray new];
    rowData = [self model:device.zzfld00002i key:@"购机日期" keyExtro:nil];
    [rowArray addObject:rowData];

    rowData = [self model:device.zzfld00000e key:@"购机商场" keyExtro:nil];
    [rowArray addObject:rowData];

    rowData = [self model:device.barCode key:@"机器条码" keyExtro:nil];
    [rowArray addObject:rowData];
    
    rowData = [self model:device.mainboardDesc key:@"主板" keyExtro:device.mainboardCode];
    [rowArray addObject:rowData];

    rowData = [self model:device.powerDesc key:@"电源" keyExtro:device.powerCode];
    [rowArray addObject:rowData];

    rowData = [self model:device.screenType key:@"屏型号" keyExtro:nil];
    [rowArray addObject:rowData];

    rowData = [self model:device.screenFactory key:@"屏厂家" keyExtro:nil];
    [rowArray addObject:rowData];

    [sectionArray addObject:rowArray];

    return sectionArray;
}

#pragma mark - TableView Delegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    GetDeviceInfosInputParams *input = [GetDeviceInfosInputParams new];
    input.machinemodel = [Util defaultStr:self.orderDetails.machinemodel2 ifStrEmpty:self.orderDetails.machinemodel];

    [self.httpClient getDeviceInfos:input response:^(NSError *error, HttpResponseData *responseData) {

        if (!error && responseData.resultCode == kHttpReturnCodeSuccess) {
            DLog(@"device info:%@", responseData.resultData);
            
            NSDictionary *deviceInfoDic = responseData.resultData;
            self.deviceInfos = [[DeviceInfos alloc]initWithDictionary:deviceInfoDic];
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
