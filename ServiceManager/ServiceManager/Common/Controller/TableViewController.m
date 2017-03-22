//
//  TableViewController.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-6.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "TableViewController.h"
#import "LoginViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (HttpClientManager*)httpClient{
    if (nil == _httpClient) {
        _httpClient = [HttpClientManager sharedInstance];
    }
    return _httpClient;
}

- (UserInfoEntity*)user
{
    if (nil == _user) {
        _user = [UserInfoEntity sharedInstance];
    }
    return _user;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isSelfViewNil = NO;

    [self registerNotifications];

    [self setNavBarBackgroundColor:kColorDefaultBlue];

    [self setBackGroundColor:kColorDefaultBackGround];

    self.tableView.backgroundColor = kColorWhite;
    self.tableView.backgroundView = nil;

    //默认导航栏左按钮
    [self setDefaultNavBarLeftButton];

    [self setTitleColor:kColorWhite];
}

- (void)setTableViewTopSpace:(CGFloat)tableViewTopSpace
{
    if (tableViewTopSpace != _tableViewTopSpace) {
        UIView *topSpace = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, tableViewTopSpace)];
        topSpace.backgroundColor = kColorDefaultBackGround;
        self.tableView.tableHeaderView = topSpace;
    }
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;
        [self unregisterNotifications];
        self.isSelfViewNil = YES;
    }
}

//默认导航栏左按钮
- (void)setDefaultNavBarLeftButton
{
    [self setNavBarLeftButton:ImageNamed(@"go_back_white") highlighted:ImageNamed(@"go_back_white") clicked:@selector(navBarLeftButtonClicked:)];
}

//默认行为是返回上一级页面
- (void)navBarLeftButtonClicked:(UIButton*)defaultLeftButton
{
    [self popViewController];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 0;
//}

- (void)loginFirstIfNeed
{
    LoginViewController *loginVc = [[LoginViewController alloc]init];
    loginVc.defaultUserName = self.user.mobile;
    [self pushViewController:loginVc];
}

- (void)registerNotifications
{

}

- (void)unregisterNotifications
{

}

@end
