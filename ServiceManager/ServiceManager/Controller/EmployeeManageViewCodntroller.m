//
//  EmployeeManageViewCodntroller.m
//  ServiceManager
//
//  Created by will.wang on 15/8/27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "EmployeeManageViewCodntroller.h"
#import "WZTableView.h"
#import "ThreeButtonCell.h"
#import "EditEmployeeViewController.h"
#import "AddRepairerViewController.h"

static NSString *sEditEmployeeListCell = @"sEditEmployeeListCell";

@interface ImpEmployeeManageTableViewDelegate ()<EditEmployeeViewControllerDelegate>
{
    NSIndexPath *_selIndexPath;
}
@end

@implementation ImpEmployeeManageTableViewDelegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    [self requestMyRepairers:tableView withPage:pageInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThreeButtonCell *cell = (ThreeButtonCell*)[tableView dequeueReusableCellWithIdentifier:sEditEmployeeListCell];
    if (nil == cell) {
        cell = [[ThreeButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sEditEmployeeListCell];
        [cell.button1 setTitleColor:kColorDefaultBlue forState:UIControlStateNormal];
        [cell.button2 setTitleColor:kColorDefaultBlue forState:UIControlStateNormal];
        [cell.button3 setTitleColor:kColorDefaultOrange forState:UIControlStateNormal];
        cell.button1.userInteractionEnabled = NO;
        cell.button2.userInteractionEnabled = NO;
        cell.button3.userInteractionEnabled = NO;
    }

    //cell background color
    UIColor *backgroundColor = indexPath.row%2 ? kColorWhite : kColorDefaultBackGround;
    cell.backgroundColor = backgroundColor;
    cell.contentView.backgroundColor = backgroundColor;
    [cell addBottomLine:kColorDefaultBackGround];
    
    //fill data
    MyRepairerBaseInfo *repairer = self.itemDataArray[indexPath.row];
    NSString *name = [Util defaultStr:kNoName ifStrEmpty:repairer.realname];
    NSString *mobile = [Util defaultStr:@"暂无联系电话" ifStrEmpty:repairer.telephone];
    NSString *userId = [Util defaultStr:@" " ifStrEmpty:repairer.userid];
    return  [cell configureCellDatas:@[name, mobile, userId]];
}

- (void)requestMyRepairers:(WZTableView*)tableView withPage:(PageInfo*)pageInfo
{
    RepairerMangerListInputParams *input = [RepairerMangerListInputParams new];
    input.partner = [UserInfoEntity sharedInstance].userId;

    [[HttpClientManager sharedInstance] repairerManageList:input response:^(NSError *error, HttpResponseData *responseData) {
        if(!error && kHttpReturnCodeSuccess == responseData.resultCode){
            NSArray *listArray = responseData.resultData;
            NSArray *repairerList = [MiscHelper parserObjectList:listArray objectClass:@"MyRepairerBaseInfo"];
            [self.itemDataArray setArray:repairerList];
        }else {
            [self.itemDataArray removeAllObjects];
        }
        [tableView didRequestTableViewListDatasWithCount:self.itemDataArray.count totalCount:self.itemDataArray.count page:pageInfo response:responseData error:error];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selIndexPath = indexPath;

    MyRepairerBaseInfo *repairer = self.itemDataArray[indexPath.row];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    EditEmployeeViewController *editVc = [[EditEmployeeViewController alloc]init];
    editVc.title = @"员工维护";
    editVc.repairer = repairer;
    [self.viewController pushViewController:editVc];
}

@end

#pragma mark - EmployeeManageViewCodntroller

@interface EmployeeManageViewCodntroller ()
{
    WZTableView *_tableView;
    ImpEmployeeManageTableViewDelegate *_tableViewDelegate;
}
@end

@implementation EmployeeManageViewCodntroller

- (void)viewDidLoad {
    [super viewDidLoad];

    //高级别的服务商有权添加维修工
    if (!self.user.isCreate) {
        [self setNavBarRightButton:@"添加" clicked:@selector(addNewRepairerButtonClicked:)];
    }
    _tableViewDelegate = [[ImpEmployeeManageTableViewDelegate alloc]init];
    _tableViewDelegate.viewController = self;
    _tableView = [[WZTableView alloc]initWithStyle:UITableViewStylePlain delegate:_tableViewDelegate];
    [_tableView.tableView setFooterHidden:YES];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    [_tableView refreshTableViewData];
}

- (void)registerNotifications
{
    [self doObserveNotification:NotificationEmployeesChanged selector:@selector(handelNotificationEmployeesChanged)];
}

- (void)unregisterNotifications
{
    [self undoObserveNotification:NotificationEmployeesChanged];
}

- (void)handelNotificationEmployeesChanged
{
    [_tableView refreshTableViewData];
}

- (void)addNewRepairerButtonClicked:(id)sender
{
    AddRepairerViewController *addVc = [[AddRepairerViewController alloc]init];
    [self pushViewController:addVc];
}

@end
