//
//  HomeTabBarViewController.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "HomeTabBarViewController.h"
#import "AppDelegate.h"
#import "MYBlurIntroductionView.h"


//tabbar item view controller
#import "TBHomePadViewController.h"
#import "TBExtendServiceViewController.h"
#import "TBSettingViewController.h"

@interface HomeTabBarViewController ()<TabBarViewControllerDelegate, UITabBarControllerDelegate, MYIntroductionDelegate>
{
    BOOL _isIntroShowed;    //是否已经显示过引导页
}

@property(nonatomic, strong)NSMutableArray *barItemArray;
@end

@implementation HomeTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    self.view.clipsToBounds = YES;

    _isIntroShowed = YES;

    //创建BarItems
    [self makeBarItems];

    [self loadTabBarViewController];

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/self.barItemArray.count, 49)];
    bgView.backgroundColor = kColorDefaultBlue;
    UIImage *selIndicatorImg = [UIImage imageWithView:bgView];
    [self.tabBar setSelectionIndicatorImage:selIndicatorImg];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (!_isIntroShowed) {
        _isIntroShowed = YES;
        [self buildIntro];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSMutableArray*)barItemArray
{
    if (nil == _barItemArray) {
        _barItemArray = [[NSMutableArray alloc]init];
    }
    return _barItemArray;
}

- (void)makeBarItems
{
    TabBarItemEntity *barItem;
    kUserRoleType userRole = [UserInfoEntity sharedInstance].userRoleType;
    
    //订单
    barItem = [[TabBarItemEntity alloc]init];
    if (kUserRoleTypeSupporter == userRole) {
        barItem.title = @"任务处理";
    }else {
        barItem.title = @"工单处理";
    }
    barItem.titleNormalColor = kColorWhite;
    barItem.titleSelectColor = kColorDefaultOrange;
    barItem.normalIcon = ImageNamed(@"repair_operation_white");
    barItem.selectIcon = ImageNamed(@"repair_operation_orange");
    barItem.controller = [[TBHomePadViewController alloc]init];
    barItem.controller.navigationItem.title = barItem.title;
    [self.barItemArray addObject:barItem];

    if (kUserRoleTypeFacilitator == userRole
        || kUserRoleTypeRepairer == userRole) {
        //performance
        barItem = [[TabBarItemEntity alloc]init];
        barItem.title = @"延保管理";
        barItem.titleNormalColor = kColorWhite;
        barItem.titleSelectColor = kColorDefaultOrange;
        barItem.normalIcon = ImageNamed(@"my_performance_white");
        barItem.selectIcon = ImageNamed(@"my_performance_orange");
        barItem.controller = [[TBExtendServiceViewController alloc]init];
        barItem.controller.navigationItem.title = barItem.title;
        [self.barItemArray addObject:barItem];
    }

    //setting
    barItem = [[TabBarItemEntity alloc]init];
    barItem.title = @"设置";
    barItem.titleNormalColor = kColorWhite;
    barItem.titleSelectColor = kColorDefaultOrange;
    barItem.normalIcon = ImageNamed(@"nav_setting_white");
    barItem.selectIcon = ImageNamed(@"nav_setting_orange");
    barItem.controller = [[TBSettingViewController alloc]init];
    barItem.controller.navigationItem.title = barItem.title;
    [self.barItemArray addObject:barItem];
}

#pragma mark - TabBarViewControllerDelegate

-(NSInteger)numberOfTabBarItem
{
    return self.barItemArray.count;
}

-(TabBarItemEntity*)tabBarItemEntityForItemIndex:(NSInteger)index
{
    return self.barItemArray[index];
}

#pragma mark - 选中了某页

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    TabBarItemEntity *selected = self.barItemArray[self.selectedIndex];
}

#pragma mark - Build MYBlurIntroductionView

-(void)buildIntro{
    //Create Stock Panel with header
    UIView *headerView = [[UIView alloc]init];
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"欢迎进入售后管家" description:@" " image:[UIImage imageNamed:@"HeaderImage.png"] header:headerView];

    //Create Stock Panel With Image
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"欢迎进入售后管家" description:@"" image:[UIImage imageNamed:@"ForkImage.png"]];

    //Add panels to an array
    NSArray *panels = @[panel1, panel2];

    //Create the introduction view and set its delegate
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    introductionView.delegate = self;
    introductionView.BackgroundImageView.image = [UIImage imageNamed:@"Toronto, ON.jpg"];
    //introductionView.LanguageDirection = MYLanguageDirectionRightToLeft;

    //Build the introduction with desired panels
    [introductionView buildIntroductionWithPanels:panels];

    //Add the introduction to your view
    [self.view addSubview:introductionView];
}

#pragma mark - MYIntroduction Delegate

-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"Introduction did change to panel %@", @(panelIndex));

    //You can edit introduction view properties right from the delegate method!
    //If it is the first panel, change the color to green!
    if (panelIndex == 0) {
        [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:1]];
    }
    //If it is the second panel, change the color to blue!
    else if (panelIndex == 1){
        [introductionView setBackgroundColor:[UIColor colorWithRed:50.0f/255.0f green:79.0f/255.0f blue:133.0f/255.0f alpha:1]];
    }

}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
    NSLog(@"Introduction did finish");
    self.navigationController.navigationBarHidden = NO;
}

@end
