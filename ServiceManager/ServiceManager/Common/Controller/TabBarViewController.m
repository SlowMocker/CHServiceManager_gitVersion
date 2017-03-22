//
//  MainTabBarViewController.m
//  BaseProject
//
//  Created by wangzhi on 15-1-23.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "TabBarViewController.h"
#import "BaseNavViewController.h"

#pragma mark - TabBarItemEntity

@implementation TabBarItemEntity
@end


#pragma mark - TabBarViewController

@interface TabBarViewController()
{
    NSInteger _numberOfTabBarItem;
}
@end

@implementation TabBarViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavBarBackgroundColor:kColorDefaultBlue];
    [self setBackGroundColor:kColorDefaultBackGround];
    
    self.tabBar.barTintColor = kColorDefaultBlue;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;
    }
}

-(void)loadTabBarViewController
{
    NSArray *tabBarItemVcArray = [self readControllers];
    [self setViewControllers:tabBarItemVcArray];
}

-(NSInteger)readNumberOfTabBarItem
{
    if ([self.dataSource respondsToSelector:@selector(numberOfTabBarItem)])
    {
        _numberOfTabBarItem = [self.dataSource numberOfTabBarItem];
    }
    return _numberOfTabBarItem;
}

//item: UINavigationController
-(NSMutableArray*)readControllers
{
    TabBarItemEntity *itemEntity;
    UIViewController *tabBarItemVc;
    NSMutableArray *tabBarVcArray = [[NSMutableArray alloc]init];

    //先读取count数
    [self readNumberOfTabBarItem];

    for (NSInteger tabBarItemIdx = 0; tabBarItemIdx < _numberOfTabBarItem; tabBarItemIdx++) {
        itemEntity = [self readTabBarItemEntityByIndex:tabBarItemIdx];
        tabBarItemVc = [self makeTableBarController:itemEntity];
        [tabBarVcArray addObject:tabBarItemVc];
    }
    return tabBarVcArray;
}

-(TabBarItemEntity*)readTabBarItemEntityByIndex:(NSInteger)tabBarItemIndex
{
    TabBarItemEntity *itemEntity;

    if ([self.dataSource respondsToSelector:@selector(tabBarItemEntityForItemIndex:)]) {
        itemEntity = [self.dataSource tabBarItemEntityForItemIndex:tabBarItemIndex];
    }

    return itemEntity;
}

- (UIViewController*)makeTableBarController:(TabBarItemEntity*)tabBarItemEntity
{
    BaseNavViewController *barVc = [[BaseNavViewController alloc]initWithSubViewController:tabBarItemEntity.controller];

    barVc.tabBarItem = [self makeTableBarItem:tabBarItemEntity];

    tabBarItemEntity.navigationVc = barVc->navController;
    tabBarItemEntity.tabBarItem = barVc.tabBarItem;

    return barVc;
}

- (UITabBarItem*)makeTableBarItem:(TabBarItemEntity*)entity
{
    UITabBarItem *barItem = [[UITabBarItem alloc]initWithTitle:entity.title image:entity.normalIcon selectedImage:entity.selectIcon];

    //Normal状态,标题色
    NSMutableDictionary *titleNormalAttr = [[NSMutableDictionary alloc]init];
    if (nil != entity.titleNormalColor) {
        [titleNormalAttr setObject:entity.titleNormalColor forKey:NSForegroundColorAttributeName];
    }
    [barItem setTitleTextAttributes:titleNormalAttr forState:UIControlStateNormal];

    //选择状态
    NSMutableDictionary *titleHighlightAttr = [[NSMutableDictionary alloc]init];
    if (nil != entity.titleSelectColor) {
        [titleHighlightAttr setObject:entity.titleSelectColor forKey:NSForegroundColorAttributeName];
    }
    [barItem setTitleTextAttributes:titleHighlightAttr forState:UIControlStateSelected];

    return barItem;
}

-(UIViewController*)getCurrentActivityVc
{
    BaseNavViewController *selectedNavVc = (BaseNavViewController*)self.selectedViewController;
    NSArray *vcStackArray = selectedNavVc->navController.viewControllers;
    UIViewController *topVc = (UIViewController*)[vcStackArray lastObject];
    if (nil == topVc) {
        topVc = selectedNavVc;
    }
    return topVc;
}

@end
