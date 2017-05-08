//
//  TBOrderListViewController.m
//  ServiceManager
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "OrderListViewController.h"
#import "HorizontalButtonBarView.h"
#import "ScrollPageView.h"
#import "WZTableView.h"
#import "OrderFilterPopView.h"

#import "FacilitatorOrderListViewDelegateIMP.h"
#import "RepairOrderListViewDelegateIMP.h"
#import "TelSupportOrderListViewDelegateIMP.h"
#import "ServiceImprovementListViewIMP.h"

@interface OrderListViewController ()<HorizontalButtonBarViewDelegate, ScrollPageViewDelegate>


@property(nonatomic, strong) OrderFilterPopView *filterView;/**< 品牌过滤右侧边 view */
@property(nonatomic, strong) NSMutableArray *listColumIds;/**< view 上的选择条的 title 数组 */

@end

@implementation OrderListViewController
{
    HorizontalButtonBarView *_topBtnsNavView;/**< view 上的选择条 */
    ScrollPageView *_scrollPagesView;/**< page view */
    NSInteger _currentPageIndex;/**< 当前的 page */
}

#pragma mark
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentPageIndex = -1;
    
    //indicator view
    CGRect frame = CGRectMake(0, 0, ScreenWidth, kButtonLargeHeight);
    _topBtnsNavView = [[HorizontalButtonBarView alloc]initWithFrame:frame delegate:self];
    _topBtnsNavView.buttonWidth = ScreenWidth/MAX(MIN(4, self.listColumIds.count), 1);
    [_topBtnsNavView addLineTo:kFrameLocationBottom];
    [self.view addSubview:_topBtnsNavView];
    
    //content table view
    frame = CGRectMake(0, CGRectGetMaxY(_topBtnsNavView.frame), ScreenWidth, ScreenHeight - 64 - CGRectGetMaxY(_topBtnsNavView.frame));
    _scrollPagesView = [[ScrollPageView alloc]initWithFrame:frame];
    _scrollPagesView.delegate = self;
    _scrollPagesView.contentItems = [self getContentPageViews];
    [self.view addSubview:_scrollPagesView];
    
    [_topBtnsNavView layoutSubviews];
    [_topBtnsNavView clickButtonAtIndex:0];
    
    [self addNavRightButtons];
    
    [self loadAllOrderListIfNotLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark
#pragma mark Notification
- (void) registerNotifications {
    // 监听工单改变
    [self doObserveNotification:NotificationOrderChanged selector:@selector(handleNotificationOrderChanged)];
}

- (void) unregisterNotifications {
    [self undoObserveNotification:NotificationOrderChanged];
}
// notification action
- (void) handleNotificationOrderChanged {
    [self updateAllOrderList:YES];
}

- (void) updateAllOrderList:(BOOL)bWaitingDialog {
    for (WZTableView *tableView in _scrollPagesView.contentItems) {
        tableView.showWaitingDialog = bWaitingDialog;
        [tableView refreshTableViewData];
    }
}

#pragma mark
#pragma mark HorizontalButtonBarViewDelegate
- (NSInteger) numberOfHorizontalButtons:(HorizontalButtonBarView*)buttonBarView {
    return self.listColumIds.count;
}

// 显示 title
- (NSString *) horizontalButtonBarView:(HorizontalButtonBarView*)barView buttonTitleForIndex:(NSInteger)btnIndex {
    return [self getOrderTypeTitleByIndex:btnIndex];
}

- (void) horizontalButtonBarView:(HorizontalButtonBarView*)barView didSelectedAtIndex:(NSInteger)btnIndex {
    if (_currentPageIndex != btnIndex) {
        _currentPageIndex = btnIndex;
        [_scrollPagesView moveScrollowViewAthIndex:_currentPageIndex];
    }
}
#pragma mark
#pragma mark ScrollPageViewDelegate
- (void) didScrollPageViewChangedPage:(NSInteger)aPage {
    _currentPageIndex = aPage;
    [_topBtnsNavView changeButtonStateAtIndex:aPage];
    
    WZTableView *targetTableView = _scrollPagesView.contentItems[aPage];
    if (!targetTableView.bHasLoaded) {
        [targetTableView refreshTableViewData];
    }
}

#pragma mark
#pragma mark Event respose (NavigationController)
// 返回按钮
- (void) navBarLeftButtonClicked:(UIButton *)defaultLeftButton {
    [super navBarLeftButtonClicked:defaultLeftButton];
    
    BOOL bFilter = (![Util isEmptyString:self.filterCondition.brands]
            ||![Util isEmptyString:self.filterCondition.productTypes]
            ||![Util isEmptyString:self.filterCondition.orderTypes]);
    if (bFilter) {
        [self.filterView resetAllFilterConditions];
    }
}
// 过滤按钮
- (void) filterButtonClicked:(UIButton*)sender {
    [self.filterView show];
}
// 搜索按钮
- (void) searchButtonClicked:(UIButton*)sender {
    [self gotoOrderSearchViewController];
}

#pragma mark
#pragma mark public methods

- (BOOL) checkIfShowFilterBtn {
    if (self.user.userRoleType == kUserRoleTypeRepairer
        || self.user.userRoleType == kUserRoleTypeFacilitator) {
        return YES;
    }
    return NO;
}

- (void) gotoOrderSearchViewController {
    SearchOrderViewController *searchVc = [[SearchOrderViewController alloc]init];
    searchVc.title = @"搜索工单";
    searchVc.serviceBrandGroup = kServiceBrandGroupPrimary;
    searchVc.searchOrderGroupType = kSearchOrderGroupTypeUnfinish;
    [self pushViewController:searchVc];
}

#pragma mark
#pragma mark !!!! Need care now
/**
 *  获取所有的 tableView
 */
- (NSMutableArray*) getContentPageViews {
    NSMutableArray *pageViews = [[NSMutableArray alloc]init];
    
    for (NSInteger pageIndex = 0; pageIndex < self.listColumIds.count; pageIndex++) {
        WZTableViewDelegateIMP *delegate = [self getContentTableViewDelegate:(NSInteger)[self.listColumIds[pageIndex]integerValue]];
        WZTableView *contentTableView = [[WZTableView alloc]initWithStyle:UITableViewStylePlain delegate:(id)delegate];
        contentTableView.frame = _scrollPagesView.bounds;
        contentTableView.tag = pageIndex;
        [pageViews addObject:contentTableView];
        
        delegate.tableView = contentTableView;
    }
    return pageViews;
}
// 根据用户角色给 tableView 设置代理
- (WZTableViewDelegateIMP *) getContentTableViewDelegate:(NSInteger)typeId {
    WZTableViewDelegateIMP *delegateIMP;
    
    switch (self.user.userRoleType) {
        case kUserRoleTypeFacilitator:
        {
            switch (typeId) {
                case kFacilitatorOrderStatusNew:
                case kFacilitatorOrderStatusReceived:
                case kFacilitatorOrderStatusAssigned:
                case kFacilitatorOrderStatusWaitForAppointment:
                case kFacilitatorOrderStatusWaitForExecution:
                case kFacilitatorOrderStatusRefused:
                case kFacilitatorOrderStatusAppointed:
                case kFacilitatorOrderStatusAppointFailure:
                case kFacilitatorOrderStatusUnfinish:
                {
                    FacilitatorOrderListViewDelegateIMP *impObj = [FacilitatorOrderListViewDelegateIMP new];
                    impObj.viewController = self;
                    impObj.userRoleType = self.user.userRoleType;
                    impObj.orderStatus = typeId;
                    impObj.filterCondition = self.filterCondition;
                    delegateIMP = impObj;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case kUserRoleTypeRepairer:
        {
            switch (typeId) {
                case kRepairerOrderStatusNew:
                case kRepairerOrderStatusWaitForAppointment:
                case kRepairerOrderStatusAppointFailure:
                case kRepairerOrderStatusWaitForExecution :
                case kRepairerOrderStatusUnfinish:
                {
                    RepairOrderListViewDelegateIMP *impObj = [RepairOrderListViewDelegateIMP new];
                    impObj.viewController = self;
                    impObj.userRoleType = self.user.userRoleType;
                    impObj.orderStatus = typeId;
                    impObj.filterCondition = self.filterCondition;
                    delegateIMP = impObj;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case kUserRoleTypeSupporter:
        {
            switch (typeId) {
                case kSupporterOrderStatusApply:
                case kSupporterOrderStatusReceived:
                case kSupporterOrderStatusConfirmed:
                {
                    TelSupportOrderListViewDelegateIMP *impObj = [TelSupportOrderListViewDelegateIMP new];
                    impObj.viewController = self;
                    impObj.userRoleType = self.user.userRoleType;
                    impObj.orderStatus = typeId;
                    delegateIMP = impObj;
                }
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
    return delegateIMP;
}

#pragma mark
#pragma mark private methods
- (void) loadAllOrderListIfNotLoad {
    for (WZTableView *tableView in _scrollPagesView.contentItems) {
        if (!tableView.bHasLoaded) {
            tableView.showWaitingDialog = YES;
            [tableView refreshTableViewData];
        }
    }
}

- (void) addNavRightButtons {
    UIBarButtonItem *filterBtnItem, *searchBtnItem;
    NSMutableArray *btnItems = [[NSMutableArray alloc]init];
    
    BOOL showFilterBtn = [self checkIfShowFilterBtn];
    
    if (showFilterBtn) {
        //filter button
        filterBtnItem = [self makeImageButtonItem:@"filter_list_white" target:self action:@selector(filterButtonClicked:)];
        [btnItems addObject:filterBtnItem];
    }
    
    //search button
    if (kUserRoleTypeFacilitator == self.user.userRoleType
        || kUserRoleTypeRepairer == self.user.userRoleType) {
        searchBtnItem = [self makeImageButtonItem:@"search_white" target:self action:@selector(searchButtonClicked:)];
        [btnItems addObject:searchBtnItem];
    }
    
    self.navigationItem.rightBarButtonItems = btnItems;
}

- (NSString *) getOrderTypeTitleByIndex:(NSInteger)index {
    NSInteger columId = [self.listColumIds[index]integerValue];
    
    switch (self.user.userRoleType) {
        case kUserRoleTypeFacilitator:
        {
            return getFacilitatorOrderStatusStr(columId);
        }
            break;
        case kUserRoleTypeRepairer:
        {
            return getRepairerOrderStatusStr(columId);
        }
            break;
        case kUserRoleTypeSupporter:
        {
            return getSupporterOrderStatusStr(columId);
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark
#pragma mark setters and getters
- (OrderFilterConditionItems *) filterCondition {
    if (nil == _filterCondition) {
        _filterCondition = [OrderFilterConditionItems new];
    }
    return _filterCondition;
}

- (OrderFilterPopView *) filterView {
    if (_filterView == nil) {
        _filterView = [[OrderFilterPopView alloc]init];
        _filterView.filterCondition = self.filterCondition;
        __weak typeof(self) weakSelf = self;
        _filterView.filterValueChangedBlock = ^(id sender){
            [weakSelf handleNotificationOrderChanged];
        };
    }
    return _filterView;
}

- (NSArray *) listColumIds {
    if (nil == _listColumIds) {
        if ([self isZM]) {
            _listColumIds = [[NSMutableArray alloc]init];
            switch (self.user.userRoleType) {
                case kUserRoleTypeFacilitator:
                {
                    [_listColumIds addObject:@(kFacilitatorOrderStatusNew)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusReceived)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusAssigned)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusRefused)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusWaitForAppointment)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusAppointed)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusAppointFailure)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusWaitForExecution)];
//                    [_listColumIds addObject:@(kFacilitatorOrderStatusUnfinish)];
                }
                    break;
                case kUserRoleTypeRepairer:
                {
                    [_listColumIds addObject:@(kRepairerOrderStatusNew)];
                    [_listColumIds addObject:@(kRepairerOrderStatusWaitForAppointment)];
                    [_listColumIds addObject:@(kRepairerOrderStatusAppointFailure)];
                    [_listColumIds addObject:@(kRepairerOrderStatusWaitForExecution)];
//                    [_listColumIds addObject:@(kRepairerOrderStatusUnfinish)];
                }
                    break;
                case kUserRoleTypeSupporter:
                {
                    [_listColumIds addObject:@(kSupporterOrderStatusApply)];
                    [_listColumIds addObject:@(kSupporterOrderStatusReceived)];
                    [_listColumIds addObject:@(kSupporterOrderStatusConfirmed)];
                }
                    break;
                default:
                    break;
            }
        }
        else {
            _listColumIds = [[NSMutableArray alloc]init];
            switch (self.user.userRoleType) {
                case kUserRoleTypeFacilitator:
                {
                    [_listColumIds addObject:@(kFacilitatorOrderStatusNew)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusReceived)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusAssigned)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusRefused)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusWaitForAppointment)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusAppointed)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusAppointFailure)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusWaitForExecution)];
                    [_listColumIds addObject:@(kFacilitatorOrderStatusUnfinish)];
                }
                    break;
                case kUserRoleTypeRepairer:
                {
                    [_listColumIds addObject:@(kRepairerOrderStatusNew)];
                    [_listColumIds addObject:@(kRepairerOrderStatusWaitForAppointment)];
                    [_listColumIds addObject:@(kRepairerOrderStatusAppointFailure)];
                    [_listColumIds addObject:@(kRepairerOrderStatusWaitForExecution)];
                    [_listColumIds addObject:@(kRepairerOrderStatusUnfinish)];
                }
                    break;
                case kUserRoleTypeSupporter:
                {
                    [_listColumIds addObject:@(kSupporterOrderStatusApply)];
                    [_listColumIds addObject:@(kSupporterOrderStatusReceived)];
                    [_listColumIds addObject:@(kSupporterOrderStatusConfirmed)];
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    return _listColumIds;
}

- (BOOL) isZM {
    return NO;
}


@end
