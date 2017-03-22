//
//  BulletDetailViewController.m
//  ServiceManager
//
//  Created by will.wang on 2016/12/26.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "BulletDetailViewController.h"
#import <MJRefresh.h>

@interface BulletDetailViewController ()
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *container;

@property(nonatomic, strong)UILabel *titleView;
@property(nonatomic, strong)UILabel *publisherView;
@property(nonatomic, strong)UILabel *dateView;
@property(nonatomic, strong)UIView *seprateLine;
@property(nonatomic, strong)UILabel *contentView;

@end

@implementation BulletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"公告";

    [self addCustomSubViews];
    [self layoutCustomSubViews];
    
    [self setBulletinInfoToViews:self.bulletin];
    [self requestBulletinDetails];
}

- (void)requestBulletinDetails {
    QueryBulletinDetailsInputParams *input = [[QueryBulletinDetailsInputParams alloc]init];
    input.noticeId = self.bulletin.noticeId.description;

    [Util showWaitingDialog];
    [self.httpClient queryBulletinDetails:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            BulletinInfo *details = [[BulletinInfo alloc]initWithDictionary:responseData.resultData];
            details.content = [Util defaultStr:kNone ifStrEmpty:details.content];
            [self setBulletinInfoToViews:details];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)refreshBulletinDetails:(id)sender
{
    if ([self.scrollView isHeaderRefreshing]) {
        [self.scrollView headerEndRefreshing];
    }

    [self requestBulletinDetails];
}

- (void)addCustomSubViews
{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.headerRefreshingText = @"正在刷新...";
    [_scrollView addHeaderWithTarget:self action:@selector(refreshBulletinDetails:)];
    [self.view addSubview:self.scrollView];
    
    _container = [[UIView alloc]init];
    [self.scrollView addSubview:self.container];
    
    _titleView = [[UILabel alloc]init];
    [_titleView setFontSize:16 textColor:kColorBlack lineBreakMode:NSLineBreakByWordWrapping lines:0];
    _titleView.font = SystemBoldFont(18);
    [self.container addSubview:self.titleView];
    
    _publisherView = [[UILabel alloc]init];
    [_publisherView setFontSize:14 textColor:kColorBlue lineBreakMode:NSLineBreakByWordWrapping lines:1];
    [self.container addSubview:self.publisherView];
    
    _dateView = [[UILabel alloc]init];
    [_dateView setFontSize:14 textColor:kColorDefaultOrange lineBreakMode:NSLineBreakByWordWrapping lines:1];
    [self.container addSubview:self.dateView];
    
    _seprateLine = [[UIView alloc]init];
    _seprateLine.backgroundColor = kColorLightGray;
    _seprateLine.alpha = 0.5;
    [self.container addSubview:_seprateLine];

    _contentView = [[UILabel alloc]init];
    [_contentView setFontSize:16 textColor:[UIColor darkTextColor] lineBreakMode:NSLineBreakByWordWrapping lines:0];
    [self.container addSubview:self.contentView];
}

- (void)layoutCustomSubViews
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kTableViewLeftPadding));
        make.left.equalTo(@(kTableViewLeftPadding));
        make.right.equalTo(@(-kTableViewLeftPadding));
    }];
    
    [self.publisherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).with.offset(kDefaultSpaceUnit/2);
        make.left.equalTo(self.titleView);
        make.right.equalTo(self.titleView);
    }];
    
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publisherView.mas_bottom).with.offset(kDefaultSpaceUnit/2);
        make.left.equalTo(self.titleView);
        make.right.equalTo(self.titleView);
    }];
    
    [self.seprateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateView.mas_bottom).with.offset(kDefaultSpaceUnit);
        make.left.equalTo(self.titleView);
        make.right.equalTo(self.titleView);
        make.height.equalTo(@(0.5));
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seprateLine.mas_bottom).with.offset(kDefaultSpaceUnit);
        make.left.equalTo(self.titleView);
        make.right.equalTo(self.titleView);
    }];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(kTableViewLeftPadding);
    }];
}

- (void)setBulletinInfoToViews:(BulletinInfo*)bulletin
{
    self.titleView.text = [Util defaultStr:@"标题未知" ifStrEmpty:bulletin.title];
    self.publisherView.text = [Util defaultStr:@"发布者未知" ifStrEmpty:bulletin.publisher];
    self.dateView.text = bulletin.createTimeText;
    self.contentView.text = bulletin.content;
}

@end
