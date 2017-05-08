//
//  WZTableView.m
//  ServiceManager
//
//  Created by mac on 15/8/26.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZTableView.h"

@interface WZTableView ()
@end

@implementation WZTableView
{
    BOOL _bNomoreData;
}
#pragma mark
#pragma mark init
- (id)initWithStyle:(UITableViewStyle)style delegate:(id<WZTableViewDelegate>)delegate {
    self = [self initWithFrame:CGRectZero style:style];
    if (self) {
        self.tableViewDelegate = delegate;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:style];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        // 集成 MJRefresh
        [_tableView addHeaderWithTarget:self action:@selector(tableViewHeaderRefreshAction)];
        [_tableView addFooterWithTarget:self action:@selector(tableViewFooterAddMoreAction)];
        _tableView.headerRefreshingText = @"正在刷新...";
        _tableView.footerRefreshingText = @"正在加载...";
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
        }];
        
        self.noDataPromptText = @"暂无相关数据";
        self.noDataPromptIcon = @"data_error_black";
        self.showWaitingDialog = YES;
        self.bHasLoaded = NO;
    }
    return self;
}

#pragma mark
#pragma mark public methods
- (void) refreshTableViewData {
    self.pageInfo.currentPage = 1; // 刷新当前 tableView 数据，默认只显示最新的第一页数据
    _bNomoreData = NO;
    [self requestListDataForPage:self.pageInfo];
}

-(void) didRequestTableViewListDatasWithCount:(NSInteger)reqCountForPage totalCount:(NSInteger)totalCount page:(PageInfo*)page response:(HttpResponseData*)response error:(NSError*)error {
    NSString *nilOrErrStr = nil;
    
    if (nil != response || nil != error) {
        nilOrErrStr = [Util getErrorDescritpion:response otherError:error];
    }
    if (totalCount > 0 && kHttpReturnCodeRecordNotExists == response.resultCode) {
        nilOrErrStr = nil;
    }
    if (self.showWaitingDialog) {
        [Util dismissWaitingDialogFromView:self];
    }
    if ([self.tableView isHeaderRefreshing]) {
        [self.tableView headerEndRefreshing];
    }
    if ([self.tableView isFooterRefreshing]) {
        [self.tableView footerEndRefreshing];
    }
    
    _bNomoreData = (reqCountForPage < self.pageInfo.pageSize);
    
    if ([Util isEmptyString:nilOrErrStr]) { //request success
        if (0 >= totalCount) {
            [self showHintViewWithImage:self.noDataPromptIcon text:self.noDataPromptText];
        }else {
            [self removeHintPromptViewIfExists];
        }
    }else {
        [self showHintViewWithImage:self.noDataPromptIcon text:nilOrErrStr];
    }
    
    [self.tableView reloadData];
    
    //请求有错，就认为没加载成功
    self.bHasLoaded = (nil == error && response.resultCode != kHttpReturnCodeErrorNet);
}

#pragma mark
#pragma mark MJRefresh respose event
- (void)tableViewHeaderRefreshAction {
    [self refreshTableViewData];
}

- (void)tableViewFooterAddMoreAction {
    if (!_bNomoreData) {
        self.pageInfo.currentPage++;
        [self requestListDataForPage:self.pageInfo];
    }
    else {
        [Util showToast:@"没有更多数据"];
        [self.tableView footerEndRefreshing];
    }
}

#pragma mark
#pragma mark setters and getters
- (PageInfo *) pageInfo {
    if (nil == _pageInfo) {
        _pageInfo = [[PageInfo alloc]init];
        _pageInfo.pageSize = kDefaultListPageSize; // 1 页 15 条
        _pageInfo.currentPage = 1;
    }
    return _pageInfo;
}

- (void) setTableViewDelegate:(id<WZTableViewDelegate>)tableViewDelegate {
    if (_tableViewDelegate != tableViewDelegate) {
        _tableViewDelegate = tableViewDelegate;
        self.tableView.delegate = tableViewDelegate;
        self.tableView.dataSource = tableViewDelegate;
    }
}

#pragma mark
#pragma mark private methods

- (void) requestListDataForPage:(PageInfo*)reqPage {
    self.bHasLoaded = YES;
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:requestListDatas:)]) {
        if (self.showWaitingDialog) {
            [Util showWaitingDialogToView:self];
        }
        [self.tableViewDelegate tableView:self requestListDatas:reqPage];
    }
}
// 展示提示
- (void) showHintViewWithImage:(NSString*)imageName text:(NSString*)text {
    UIView *promptView;

    promptView = [self showPlaceHolderWithImage:imageName text:text frame:self.bounds];
    
    //refresh data when user click prompt view
    [promptView addSingleTapEventWithTarget:self action:@selector(tableViewHeaderRefreshAction)];
}
// 移除提示
- (void)removeHintPromptViewIfExists {
    [self removePlaceholderViews];
}

@end
