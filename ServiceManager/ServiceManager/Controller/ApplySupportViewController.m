//
//  ApplySupportViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/8/27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ApplySupportViewController.h"
#import "WZTableView.h"
#import "EmployeeInfoCell.h"

static NSString *sApplySupporterListCellId = @"sApplySupporterListCellId";

@interface ApplySupportViewController()<WZTableViewDelegate>
{
    WZTableView *_tableView;
}
@property(nonatomic, strong)NSArray *itemDataArray;
@property(nonatomic, strong)EmployeeInfoCell *protypeCell;
@end

@implementation ApplySupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    [_tableView refreshTableViewData];
}

- (WZTableView*)tableView
{
    if (nil == _tableView) {
        _tableView = [[WZTableView alloc]initWithStyle:UITableViewStylePlain delegate:self];
        [_tableView.tableView registerClass:[EmployeeInfoCell class] forCellReuseIdentifier:sApplySupporterListCellId];
        [_tableView addLineTo:kFrameLocationTop];
        _tableView.tableView.footerHidden = YES;
        
        _protypeCell = [_tableView.tableView dequeueReusableCellWithIdentifier:sApplySupporterListCellId];
    }
    return _tableView;
}

#pragma mark - data source & delegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    [self requestSupporters:tableView withPage:pageInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.protypeCell fitHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmployeeInfoCell *cell = [[EmployeeInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sApplySupporterListCellId];
    
    return [self setCell:cell withData:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    EmployeeInfo *supporter = self.itemDataArray[indexPath.row];

    [Util confirmAlertView:[NSString stringWithFormat:@"您确定需要%@支持吗？", supporter.supportman_name] confirmAction:^{
        [self applySupporterToHelp:supporter];
    }];
}

- (EmployeeInfoCell*)setCell:(EmployeeInfoCell*)cell withData:(NSIndexPath*)indexPath
{
    EmployeeInfo *supporter = self.itemDataArray[indexPath.row];

    cell.nameLabel.text = [Util defaultStr:kNoName ifStrEmpty:supporter.supportman_name];
    
    //set the 1st telphone number to show
    NSArray *repairmanTels = [supporter.supportman_phone componentsSeparatedByString:@","];
    if (repairmanTels.count > 0) {
        cell.mobileLabel.text = repairmanTels[0];
    }
    cell.mobileLabel.textColor = kColorDefaultGreen;

    cell.taskCountLabel.text = [NSString stringWithFormat:@"待处理 %@ 位", supporter.supporttask_total];

    cell.infoLabel.text = [NSString stringWithFormat:@"工号 : %@", supporter.supportman_id];
    cell.infoLabel.textColor = kColorDefaultOrange;
    
    //cell background color
    UIColor *backgroundColor = indexPath.row%2 ? kColorDefaultBackGround :kColorWhite;
    cell.backgroundColor = backgroundColor;
    cell.contentView.backgroundColor = backgroundColor;
    
    [cell layoutCustomSubViews2];
    
    return cell;
}

- (void)requestSupporters:(WZTableView*)tableView withPage:(PageInfo*)pageInfo
{
    [self querySupportersWithOrderId:self.orderId response:^(NSError *error, HttpResponseData *responseData, id extData) {
        NSArray *supporterList = (NSArray*)extData;
        if(!error && kHttpReturnCodeSuccess == responseData.resultCode){
            self.itemDataArray = [NSArray arrayWithArray:supporterList];
        };
        [tableView didRequestTableViewListDatasWithCount:self.itemDataArray.count totalCount:self.itemDataArray.count page:pageInfo response:responseData error:error];
    }];
}

- (void)applySupporterToHelp:(EmployeeInfo*)supporter
{
    [Util showWaitingDialog];
    [self applySupporter:supporter response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            if ([self.delegate respondsToSelector:@selector(applySupportViewController:select:)]) {
                [self.delegate applySupportViewController:self select:supporter];
            }
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)querySupportersWithOrderId:(NSString*)orderId response:(RequestCallBackBlockV2)requestCallBackBlock
{
    GetEngneerListInputParams *input = [GetEngneerListInputParams new];
    input.object_id = orderId;
    
    [[HttpClientManager sharedInstance] getEngneerList:input response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *supporterList;
        if(!error && kHttpReturnCodeSuccess == responseData.resultCode){
            supporterList = [MiscHelper parserObjectList:responseData.resultData objectClass:@"EmployeeInfo"];
        }
        requestCallBackBlock(error, responseData, supporterList);
    }];
}

- (void)applySupporter:(EmployeeInfo*)supporter response:(RequestCallBackBlock)requestCallBackBlock
{
    ApplySupportHelpInputParams *input = [ApplySupportHelpInputParams new];
    input.workerId = self.user.userId;
    input.objectId = self.orderId;
    input.supporterId = supporter.supportman_id;
    
    [self.httpClient applySupportHelp:input response:requestCallBackBlock];
}

@end
