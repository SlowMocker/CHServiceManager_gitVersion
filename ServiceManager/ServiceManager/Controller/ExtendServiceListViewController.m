//
//  ExtendServiceListViewController.m
//  ServiceManager
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ExtendServiceListViewController.h"
#import "HorizontalButtonBarView.h"
#import "ScrollPageView.h"
#import "WZTableView.h"
#import "ExtendServiceOrderListDelegateIMP.h"
#import "OrderExtendEditViewController.h"

@interface ExtendServiceListViewController ()<HorizontalButtonBarViewDelegate, ScrollPageViewDelegate>
{
    HorizontalButtonBarView *_topBtnsNavView;
    ScrollPageView *_scrollPagesView;
    NSInteger _currentPageIndex;
}
@property(nonatomic, strong)NSMutableArray *listColumIds;
@end

@implementation ExtendServiceListViewController

- (NSMutableArray*)listColumIds
{
    if (nil == _listColumIds) {
        _listColumIds = [[NSMutableArray alloc]init];
        [_listColumIds addObject:@(kExtendServiceTypeSingle)];
        [_listColumIds addObject:@(kExtendServiceTypeMutiple)];
    }
    return _listColumIds;
}

- (WZTableViewDelegateIMP*)getContentTableViewDelegate:(kExtendServiceType)extendType
{
    WZTableViewDelegateIMP *delegateIMP;
    switch (extendType) {
        case kExtendServiceTypeSingle:
        case kExtendServiceTypeMutiple:
        {
            ExtendServiceOrderListDelegateIMP *impObj = [ExtendServiceOrderListDelegateIMP new];
            impObj.viewController = self;
            impObj.extendServiceType = extendType;
            delegateIMP = impObj;
        }
            break;
        default:
            break;
    }
    return delegateIMP;
}

- (NSMutableArray*)getContentPageViews
{
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
    frame = CGRectMake(0, CGRectGetMaxY(_topBtnsNavView.frame), ScreenWidth, ScreenHeight - 64 - 49 - CGRectGetMaxY(_topBtnsNavView.frame));
    _scrollPagesView = [[ScrollPageView alloc]initWithFrame:frame];
    _scrollPagesView.delegate = self;
    _scrollPagesView.contentItems = [self getContentPageViews];
    [self.view addSubview:_scrollPagesView];
    
    [_topBtnsNavView layoutSubviews];
    [_topBtnsNavView clickButtonAtIndex:0];
    
    [self setNavBarRightButton:@"添加" clicked:@selector(addExtendServiceOrderButtonClicked:)];
}

- (void)registerNotifications
{
    [self doObserveNotification:NotificationExtendOrderChanged selector:@selector(handleNotificationExtendOrderChanged)];
}

- (void)unregisterNotifications
{
    [self undoObserveNotification:NotificationExtendOrderChanged];
}

- (NSInteger)numberOfHorizontalButtons:(HorizontalButtonBarView*)buttonBarView
{
    return self.listColumIds.count;
}

- (NSString*)horizontalButtonBarView:(HorizontalButtonBarView*)barView buttonTitleForIndex:(NSInteger)btnIndex
{
    kExtendServiceType columId = [self.listColumIds[btnIndex]integerValue];
    return getExtendServiceTypeById(columId);
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

- (void)addExtendServiceOrderButtonClicked:(id)sender
{
    OrderExtendEditViewController *editVc = [[OrderExtendEditViewController alloc]init];
    editVc.extendOrderEditMode = kExtendOrderEditModeNew;
    
    kExtendServiceType extendType = (kExtendServiceType)[self.listColumIds[_currentPageIndex] integerValue];
    editVc.extendServiceType = extendType;
    [self pushViewController:editVc];
}

- (void)handleNotificationExtendOrderChanged
{
    WZTableView *curTableView = _scrollPagesView.contentItems[_currentPageIndex];
    curTableView.showWaitingDialog = NO;
    [curTableView refreshTableViewData];
}

@end
