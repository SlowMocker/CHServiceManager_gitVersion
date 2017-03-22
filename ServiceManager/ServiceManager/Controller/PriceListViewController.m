//
//  PriceListViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/3/31.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "PriceListViewController.h"
#import "PriceEditViewController.h"
#import "SmartProductSellEditViewController.h"
#import "FeeListViewDelegateIMP.h"
#import "WZTableView.h"

static NSString *sOrderTraceListCell = @"sOrderTraceListCell";

@interface PriceListViewController ()
{
    NSIndexPath *_selIndexPath;
    FeeListViewDelegateIMP *_tableViewDelegate;
}
@property(nonatomic, strong)WZTableView *tableView;
@property(nonatomic, strong)UIButton *syncButton;

@end

@implementation PriceListViewController

- (UIButton*)syncButton{
    if (_syncButton == nil) {
        _syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _syncButton.backgroundColor = [UIColor lightGrayColor];
        [_syncButton setTitle:@"立即同步" forState:UIControlStateNormal];
        [_syncButton setTitleColor:kColorDefaultGreen forState:UIControlStateNormal];
        [_syncButton addTarget:self action:@selector(syncButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _syncButton;
}

- (void)syncButtonClicked:(UIButton*)sender
{
    SyncFeeBillListInputParams *input = [SyncFeeBillListInputParams new];
    input.objectId = self.orderObjectId;

    [Util showWaitingDialog];
    [self.httpClient syncFeeBillList:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            [Util showToast:@"同步完毕"];
            [self.tableView refreshTableViewData];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (WZTableViewDelegateIMP*)getFeeListViewDelegateIMP
{
    return [[FeeListViewDelegateIMP alloc]init];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //tableview
    _tableViewDelegate = (FeeListViewDelegateIMP*)[self getFeeListViewDelegateIMP];
    _tableViewDelegate.priceListViewController = self;

    _tableView = [[WZTableView alloc]initWithStyle:UITableViewStylePlain delegate:_tableViewDelegate];
    _tableView.tableView.footerHidden = YES;
    _tableViewDelegate.tableView = _tableView;

    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    
    //sysn button
    [self.view addSubview:self.syncButton];
    [self.syncButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(kButtonDefaultHeight));
    }];
    
    [self setNavBarRightButton:@"添加" clicked:@selector(addButtonClicked:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.tableView refreshTableViewData];
}

- (void)addButtonClicked:(UIButton*)sender
{
    FeeEditViewController *editVc;
    NSString *titleText = @"添加费用项";

    if (kPriceManageTypeService == self.feeManageType) {
        editVc = [PriceEditViewController new];
    }else if (kPriceManageTypeSells == self.feeManageType){
        editVc = [SmartProductSellEditViewController new];
        titleText = @"添加销售费用项";
    }
    editVc.orderObjectId = self.orderObjectId;
    editVc.orderKeyId = self.orderKeyId;
    editVc.brandCode = self.brandCode;
    editVc.categoryCode = self.categoryCode;
    editVc.title = titleText;
    [self pushViewController:editVc];
}

- (void)showSyncButton:(BOOL)bShow
{
    CGFloat syncButtonHeight = bShow ? kButtonDefaultHeight : 0;
    UIEdgeInsets tableViewInsets = UIEdgeInsetsZero;
    tableViewInsets.bottom = syncButtonHeight;

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(tableViewInsets);
    }];

    [self.syncButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(syncButtonHeight));
    }];
    self.syncButton.hidden = !bShow;
}

@end

