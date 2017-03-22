//
//  HistoryOrderListViewController.m
//  ServiceManager
//
//  Created by will.wang on 2016/12/26.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "HistoryOrderListViewController.h"
#import "WZTableViewDelegateIMP.h"
#import "FacilitatorOrderListViewDelegateIMP.h"
#import "RepairOrderListViewDelegateIMP.h"
#import "OrderFilterPopView.h"
#import "SearchOrderViewController.h"
#import "LetvFacilitatorOrderListViewDelegateIMP.h"
#import "LetvRepairOrderListViewDelegateIMP.h"

@interface HistoryOrderListViewController ()
@property(nonatomic, strong)OrderListViewDelegateIMP *tableViewDelegate;
@property(nonatomic, strong)OrderFilterPopView *filterView;
@property(nonatomic, strong)UIView *headerNoteView;
@end

@implementation HistoryOrderListViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.serviceBrandGroup = kServiceBrandGroupPrimary;
    }
    return self;
}

- (UIView*)headerNoteView{
    if (nil == _headerNoteView) {
        CGRect frame = CGRectMake(0, 0, ScreenWidth, 28);
        _headerNoteView = [[UIView alloc]initWithFrame:frame];
        _headerNoteView.backgroundColor = kColorDefaultBackGround;

        UILabel *noteLabel =[[UILabel alloc]init];
        [_headerNoteView addSubview:noteLabel];
        [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kTableViewLeftPadding));
            make.centerY.equalTo(_headerNoteView);
        }];
        noteLabel.textColor = [UIColor grayColor];
        noteLabel.font = SystemFont(14);
        noteLabel.text = @"最近7天的历史工单";
    }
    return _headerNoteView;
}

- (OrderFilterConditionItems*)filterCondition{
    if (nil == _filterCondition) {
        _filterCondition = [OrderFilterConditionItems new];
    }
    return _filterCondition;
}

- (OrderFilterPopView*)filterView{
    if (_filterView == nil) {
        _filterView = [[OrderFilterPopView alloc]init];
        _filterView.filterCondition = self.filterCondition;
        __weak typeof(self) weakSelf = self;
        _filterView.filterValueChangedBlock = ^(id sender){
            [weakSelf.tableView refreshTableViewData];
        };
    }
    return _filterView;
}

- (void)addNavRightButtons
{
    UIBarButtonItem *filterBtnItem, *searchBtnItem;
    NSMutableArray *btnItems = [[NSMutableArray alloc]init];

    switch (self.serviceBrandGroup) {
        case kServiceBrandGroupPrimary:
        {
            //filter button
            filterBtnItem = [self makeImageButtonItem:@"filter_list_white" target:self action:@selector(filterButtonClicked:)];
            [btnItems addObject:filterBtnItem];
        }
            break;
        default:
            break;
    }

    //search button
    searchBtnItem = [self makeImageButtonItem:@"search_white" target:self action:@selector(searchButtonClicked:)];
    [btnItems addObject:searchBtnItem];
    
    self.navigationItem.rightBarButtonItems = btnItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableViewDelegate = [self getContentTableViewDelegate];
    self.tableView.tableViewDelegate = self.tableViewDelegate;
    self.tableView.tableView.tableHeaderView = self.headerNoteView;

    [self.tableView refreshTableViewData];
    
    [self addNavRightButtons];
}

-(void)registerNotifications
{
    [self doObserveNotification:NotificationOrderChanged selector:@selector(handleNotificationOrderChanged)];
}

-(void)unregisterNotifications
{
    [self undoObserveNotification:NotificationOrderChanged];
}

- (void)handleNotificationOrderChanged
{
    [self.tableView refreshTableViewData];
}

- (void)searchButtonClicked:(UIButton*)sender
{
    [self gotoOrderSearchViewController];
}

- (void)filterButtonClicked:(UIButton*)sender
{
    [self.filterView show];
}

- (NSString*)getSearchViewControllerTitle:(kServiceBrandGroup)serviceBrandGroup
{
    NSString *title = @"搜索历史工单";

    switch (serviceBrandGroup) {
        case kServiceBrandGroupPrimary:
            break;
        case kServiceBrandGroupLetv:
            title = [title appendStr:@"(乐视)"];
            break;
        case kServiceBrandGroupMeLing:
            title = [title appendStr:@"(美菱)"];
            break;
        default:
            break;
    }
    return title;
}

- (void)gotoOrderSearchViewController
{
    SearchOrderViewController *searchVc = [[SearchOrderViewController alloc]init];
    searchVc.title = [self getSearchViewControllerTitle:self.serviceBrandGroup];
    searchVc.serviceBrandGroup = self.serviceBrandGroup;
    searchVc.searchOrderGroupType = kSearchOrderGroupTypeFinished;
    [self pushViewController:searchVc];
}

- (OrderListViewDelegateIMP*)getContentTableViewDelegate
{
    OrderListViewDelegateIMP *delegateIMP;
    OrderFilterConditionItems *filterCondition;

    switch (self.serviceBrandGroup) {
        case kServiceBrandGroupPrimary:
            delegateIMP = [self getContentTableViewDelegateForPrimaryBrand];
            filterCondition = self.filterCondition;
            break;
        case kServiceBrandGroupLetv:
            delegateIMP = [self getContentTableViewDelegateForLetv];
            break;
        case kServiceBrandGroupMeLing:
            delegateIMP = [self getContentTableViewDelegateForMeLing];
            break;
        default:
            break;
    }
    
    if (nil != delegateIMP) {
        delegateIMP.viewController = self;
        delegateIMP.userRoleType = self.user.userRoleType;
        delegateIMP.tableView = self.tableView;
        delegateIMP.filterCondition = filterCondition;
    }
    return delegateIMP;
}

- (OrderListViewDelegateIMP*)getContentTableViewDelegateForPrimaryBrand
{
    OrderListViewDelegateIMP *delegateIMP;
    
    switch (self.user.userRoleType) {
        case kUserRoleTypeFacilitator:
            delegateIMP = [FacilitatorOrderListViewDelegateIMP new];
            delegateIMP.orderStatus = kFacilitatorOrderStatusFinished;
            break;
        case kUserRoleTypeRepairer:
            delegateIMP = [RepairOrderListViewDelegateIMP new];
            delegateIMP.orderStatus = kRepairerOrderStatusFinished;
            break;
        default:
            break;
    }
    return delegateIMP;
}

- (OrderListViewDelegateIMP*)getContentTableViewDelegateForLetv
{
    OrderListViewDelegateIMP *delegateIMP;
    
    switch (self.user.userRoleType) {
        case kUserRoleTypeFacilitator:
            delegateIMP = [LetvFacilitatorOrderListViewDelegateIMP new];
            delegateIMP.orderStatus = kFacilitatorOrderStatusFinished;
            break;
        case kUserRoleTypeRepairer:
            delegateIMP = [LetvRepairOrderListViewDelegateIMP new];
            delegateIMP.orderStatus = kRepairerOrderStatusFinished;
            break;
        default:
            break;
    }

    return delegateIMP;
}

- (OrderListViewDelegateIMP*)getContentTableViewDelegateForMeLing
{
    //add delegate here for men ning
    return nil;
}

@end
