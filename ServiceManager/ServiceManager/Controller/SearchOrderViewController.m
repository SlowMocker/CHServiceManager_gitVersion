//
//  SearchOrderViewController.m
//  ServiceManager
//
//  Created by will.wang on 10/30/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "SearchOrderViewController.h"
#import "HorizontalButtonBarView.h"
#import "ScrollPageView.h"
#import "WZTableView.h"
#import "WZTableViewDelegateIMP.h"

#import "SearchFacilitatorOrdersDelegateIMP.h"
#import "SearchRepairOrdersDelegateIMP.h"
#import "SearchLetvFacilitatorOrdersDelegateIMP.h"
#import "SearchLetvRepairOrdersDelegateIMP.h"

#pragma mark - 普通工单搜索

@interface OrderSearchHandleDelegateIMP : NSObject

//searched results
@property (nonatomic, strong)NSError *error;
@property (nonatomic, strong)HttpResponseData *responseData;
@property(nonatomic, strong)NSArray *allSearchedOrders;

@property(nonatomic, assign)kSearchOrderGroupType searchOrderGroupType;
@property(nonatomic, copy, readonly)NSString *searchOrderGroupTypeStr;

//sub class need to override them
- (OrderListViewDelegateIMP*)getOrderTableViewDelegateIMP;

//请求搜索工单
- (void)searchOrders:(NSString*)keyWord response:(RequestCallBackBlockV2)requestCallBackBlock;

//搜索到的工单所归的列组（工单类型）
- (NSArray*)groupsOrdersBelongTo;

//搜索返回后，更新orderListIMP中的值
- (void)updateOrderTableViewDelegateIMP:(OrderListViewDelegateIMP*)orderListImp;
@end

@implementation OrderSearchHandleDelegateIMP

- (NSString *)searchOrderGroupTypeStr{
    NSString *str;
    switch (self.searchOrderGroupType) {
        case kSearchOrderGroupTypeUnfinish:
            str = @"0";
            break;
        case kSearchOrderGroupTypeFinished:
            str = @"1";
            break;
        case kSearchOrderGroupTypeAll:
        default:
            str = @"";
            break;
    }
    return str;
}

- (void)searchOrders:(NSString*)keyWord response:(RequestCallBackBlockV2)requestCallBackBlock
{
    SearchOrdersInputParams *input = [SearchOrdersInputParams new];
    input.repairmanId = [UserInfoEntity sharedInstance].userId;
    input.objectId = keyWord;
    input.isFinishedOrder = self.searchOrderGroupTypeStr;
    [[HttpClientManager sharedInstance] searchOrders:input response:^(NSError *error, HttpResponseData *responseData, id extData) {
        [self handleSearchedOrders:error response:responseData orders:(NSArray *)extData];
        requestCallBackBlock(error, responseData,extData);
    }];
}

- (void)handleSearchedOrders:(NSError*)error response:(HttpResponseData*)responseData orders:(NSArray*)orders
{
    self.error = error;
    self.responseData = responseData;
    self.allSearchedOrders = orders;
}

- (NSArray*)groupsOrdersBelongTo
{
    NSMutableSet *groupsSet = [[NSMutableSet alloc]init];
    for (OrderContentModel *order in self.allSearchedOrders) {
        NSArray *groups = order.orderStatusSet;
        if (groups.count > 0) {
            [groupsSet addObjectsFromArray:groups];
        }
    }

    return [[groupsSet allObjects]sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue] > [obj2 integerValue];
    }];
}

- (void)updateOrderTableViewDelegateIMP:(OrderListViewDelegateIMP*)orderListImp
{
    if ([orderListImp isKindOfClass:[SearchLetvFacilitatorOrdersDelegateIMP class]]) {
        SearchLetvFacilitatorOrdersDelegateIMP *imp =
        (SearchLetvFacilitatorOrdersDelegateIMP*)orderListImp;
        imp.error = self.error;
        imp.responseData = self.responseData;
        imp.allSearchedOrders = self.allSearchedOrders;
    }else if([orderListImp isKindOfClass:[SearchLetvRepairOrdersDelegateIMP class]]) {
        SearchLetvRepairOrdersDelegateIMP *imp =
        (SearchLetvRepairOrdersDelegateIMP*)orderListImp;
        imp.error = self.error;
        imp.responseData = self.responseData;
        imp.allSearchedOrders = self.allSearchedOrders;
    }else if ([orderListImp isKindOfClass:[SearchFacilitatorOrdersDelegateIMP class]]) {
        SearchFacilitatorOrdersDelegateIMP *imp =
        (SearchFacilitatorOrdersDelegateIMP*)orderListImp;
        imp.error = self.error;
        imp.responseData = self.responseData;
        imp.allSearchedOrders = self.allSearchedOrders;
    }else if([orderListImp isKindOfClass:[SearchRepairOrdersDelegateIMP class]]) {
        SearchRepairOrdersDelegateIMP *imp =
        (SearchRepairOrdersDelegateIMP*)orderListImp;
        imp.error = self.error;
        imp.responseData = self.responseData;
        imp.allSearchedOrders = self.allSearchedOrders;
    }
}

- (OrderListViewDelegateIMP*)getOrderTableViewDelegateIMP
{
    OrderListViewDelegateIMP *imp;

    switch ([UserInfoEntity sharedInstance].userRoleType) {
        case kUserRoleTypeFacilitator:
        {
            imp = [SearchFacilitatorOrdersDelegateIMP new];
        }
            break;
        case kUserRoleTypeRepairer:
        {
            imp = [SearchRepairOrdersDelegateIMP new];
        }
            break;
        default:
            break;
    }
    return imp;
}

@end

#pragma mark - 乐视工单搜索

@interface LetvOrderSearchHandleDelegateIMP : OrderSearchHandleDelegateIMP
@end

@implementation LetvOrderSearchHandleDelegateIMP

- (void)searchOrders:(NSString*)keyWord response:(RequestCallBackBlockV2)requestCallBackBlock
{
    LetvSearchOrdersInputParams *input = [LetvSearchOrdersInputParams new];
    input.repairmanId = [UserInfoEntity sharedInstance].userId;
    input.objectId = keyWord;
    input.isFinishedOrder = self.searchOrderGroupTypeStr;

    [[HttpClientManager sharedInstance] letv_searchOrders:input response:^(NSError *error, HttpResponseData *responseData, id extData) {
        [self handleSearchedOrders:error response:responseData orders:(NSArray*)extData];
        requestCallBackBlock(error, responseData,extData);
    }];
}

- (NSArray*)groupsOrdersBelongTo
{
    NSMutableSet *groupsSet = [[NSMutableSet alloc]init];
    for (LetvOrderContentModel *order in self.allSearchedOrders) {
        NSArray *groups = order.orderStatusSet;
        if (groups.count > 0) {
            [groupsSet addObjectsFromArray:groups];
        }
    }
    return [[groupsSet allObjects]sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue] > [obj2 integerValue];
    }];
}

- (OrderListViewDelegateIMP*)getOrderTableViewDelegateIMP
{
    OrderListViewDelegateIMP *imp;

    switch ([UserInfoEntity sharedInstance].userRoleType) {
        case kUserRoleTypeFacilitator:
        {
            imp = [SearchLetvFacilitatorOrdersDelegateIMP new];
        }
            break;
        case kUserRoleTypeRepairer:
        {
            imp = [SearchLetvRepairOrdersDelegateIMP new];
        }
            break;
        default:
            break;
    }
    return imp;
}
@end

#pragma mark - SearchOrderViewController

@interface SearchOrderViewController()<UISearchBarDelegate,HorizontalButtonBarViewDelegate, ScrollPageViewDelegate>
{
    HorizontalButtonBarView *_topBtnsNavView;
    ScrollPageView *_scrollPagesView;
    NSInteger _currentPageIndex;
}
@property(nonatomic, strong)NSArray *listColumIds;

@property(nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)UIView *contentView;

@property (nonatomic, strong)OrderSearchHandleDelegateIMP *searchHandleDelegate;

@end

@implementation SearchOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //top searchBar
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入工单号";
    _searchBar.showsCancelButton = YES;
    [self.view addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(kButtonLargeHeight));
    }];
    
    //content view
    _contentView = [[UIView alloc]init];
    [self.view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.searchBar becomeFirstResponder];

    self.searchHandleDelegate = [self getOrderSearchHandleDelegateIMP:self.serviceBrandGroup];
    self.searchHandleDelegate.searchOrderGroupType = self.searchOrderGroupType;
}

- (OrderSearchHandleDelegateIMP*)getOrderSearchHandleDelegateIMP:(kServiceBrandGroup)serviceBrandGroup
{
    OrderSearchHandleDelegateIMP *handleDelegate;

    switch (serviceBrandGroup) {
        case kServiceBrandGroupPrimary:
            handleDelegate = [[OrderSearchHandleDelegateIMP alloc]init];
            break;
        case kServiceBrandGroupLetv:
            handleDelegate = [[LetvOrderSearchHandleDelegateIMP alloc]init];
            break;
        case kServiceBrandGroupMeLing:
            //add code here for meining
            break;
        default:
            break;
    }
    return handleDelegate;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    NSMutableArray *viewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    [viewControllers removeObject:self];
    self.navigationController.viewControllers = viewControllers;
}

- (WZTableViewDelegateIMP*)getContentTableViewDelegate:(NSInteger)typeId
{
    OrderListViewDelegateIMP *delegateIMP = [self.searchHandleDelegate getOrderTableViewDelegateIMP];

    if (nil != delegateIMP) {
        delegateIMP.viewController = self;
        delegateIMP.userRoleType = self.user.userRoleType;
        delegateIMP.orderStatus = typeId;
        [self.searchHandleDelegate updateOrderTableViewDelegateIMP:delegateIMP];
    }
    return delegateIMP;
}

- (NSMutableArray*)getContentPageViews
{
    NSMutableArray *pageViews = [[NSMutableArray alloc]init];
    
    for (NSInteger pageIndex = 0; pageIndex < self.listColumIds.count; pageIndex++) {
        WZTableViewDelegateIMP *delegate = [self getContentTableViewDelegate:(NSInteger)[self.listColumIds[pageIndex]integerValue]];
        WZTableView *contentTableView = [[WZTableView alloc]initWithStyle:UITableViewStylePlain delegate:(id)delegate];
        contentTableView.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        contentTableView.frame = _scrollPagesView.bounds;
        contentTableView.tag = pageIndex;
        contentTableView.tableView.headerHidden = YES;
        contentTableView.tableView.footerHidden = YES;
        [pageViews addObject:contentTableView];
        
        delegate.tableView = contentTableView;
    }
    return pageViews;
}

- (void)createGroupedOrders
{
    _currentPageIndex = -1;

    //indicator view
    CGRect frame = CGRectMake(0, 0, ScreenWidth, kButtonLargeHeight);
    _topBtnsNavView = [[HorizontalButtonBarView alloc]initWithFrame:frame delegate:self];
    _topBtnsNavView.buttonWidth = ScreenWidth/MAX(MIN(4, self.listColumIds.count), 1);
    [_topBtnsNavView addLineTo:kFrameLocationBottom];
    [self.contentView addSubview:_topBtnsNavView];
    
    //content table view
    frame = CGRectMake(0, CGRectGetMaxY(_topBtnsNavView.frame), ScreenWidth, ScreenHeight - 64 - CGRectGetMaxY(_topBtnsNavView.frame));
    _scrollPagesView = [[ScrollPageView alloc]initWithFrame:frame];
    _scrollPagesView.delegate = self;
    _scrollPagesView.contentItems = [self getContentPageViews];
    [self.contentView addSubview:_scrollPagesView];

    [_topBtnsNavView layoutSubviews];
    [_topBtnsNavView clickButtonAtIndex:0];
}

- (NSString*)getOrderTypeTitleByIndex:(NSInteger)index
{
    NSInteger columId = [self.listColumIds[index]integerValue];
    
    switch (self.user.userRoleType) {
        case kUserRoleTypeFacilitator:
        {
            return getFacilitatorOrderStatusStr(columId);
        }
        case kUserRoleTypeRepairer:
        {
            return getRepairerOrderStatusStr(columId);
        }
        default:
            break;
    }
    return nil;
}

- (NSInteger)numberOfHorizontalButtons:(HorizontalButtonBarView*)buttonBarView
{
    return self.listColumIds.count;
}

- (NSString*)horizontalButtonBarView:(HorizontalButtonBarView*)barView buttonTitleForIndex:(NSInteger)btnIndex
{
    return [self getOrderTypeTitleByIndex:btnIndex];
}

- (void)horizontalButtonBarView:(HorizontalButtonBarView*)barView didSelectedAtIndex:(NSInteger)btnIndex
{
    if (_currentPageIndex != btnIndex) {
        _currentPageIndex = btnIndex;
        [_scrollPagesView moveScrollowViewAthIndex:_currentPageIndex];
    }
}

- (void)didScrollPageViewChangedPage:(NSInteger)aPage
{
    _currentPageIndex = aPage;
    [_topBtnsNavView changeButtonStateAtIndex:aPage];
    
    WZTableView *targetTableView = _scrollPagesView.contentItems[aPage];
    if (!targetTableView.bHasLoaded) {
        [targetTableView refreshTableViewData];
    }
}

- (void)searchOrdersByKeyword:(NSString*)keyword
{
    [Util showWaitingDialog];
    [self.searchHandleDelegate searchOrders:keyword response:^(NSError *error, HttpResponseData *responseData, id extData) {
        [Util dismissWaitingDialog];
        if (!error &&kHttpReturnCodeSuccess == responseData.resultCode) {
            self.listColumIds = [self.searchHandleDelegate groupsOrdersBelongTo];
            [self.contentView removeAllSubviews];
            if (self.listColumIds.count > 0) {
                [self createGroupedOrders];
            }else {
                [self.contentView showPlaceHolderWithText:@"记录不存在！" image:nil];
            }
        }else {
            [self.contentView showPlaceHolderWithText:[Util getErrorDescritpion:responseData otherError:error] image:nil];
        }
    }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];

    if ([Util isEmptyString:searchBar.text]) {
        [Util showToast:@"工单号不能为空"];
    }else {
        [self searchOrdersByKeyword:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];

    [self popViewController];
}

@end
