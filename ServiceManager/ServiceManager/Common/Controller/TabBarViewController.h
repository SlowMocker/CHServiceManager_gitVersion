//
//  TabBarViewController.h
//  BaseProject
//
//  Created by wangzhi on 15-1-23.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

@class TabBarViewController;
@class TabBarItemEntity;

@protocol TabBarViewControllerDelegate <NSObject>
-(NSInteger)numberOfTabBarItem;
-(TabBarItemEntity*)tabBarItemEntityForItemIndex:(NSInteger)index;
@end

@interface TabBarItemEntity : NSObject
@property(nonatomic, strong)NSString *title;    //标题,[必填]
@property(nonatomic, strong)UIColor *titleNormalColor;  //标题色
@property(nonatomic, strong)UIColor *titleSelectColor;  //选中时标题色

@property(nonatomic, strong)UIImage *normalIcon;    //图标
@property(nonatomic, strong)UIImage *selectIcon;    //选中时图标

@property(nonatomic, strong)UIViewController *controller; //TAB项对应的VC,[必填]

@property(nonatomic, strong)UINavigationController *navigationVc;     //controller所属的NavigationController
@property(nonatomic, strong)UITabBarItem *tabBarItem;
@end

@interface TabBarViewController : UITabBarController
@property(nonatomic, assign)id<TabBarViewControllerDelegate>dataSource;

//它将触发dataSouce的调用，并显示
- (void)loadTabBarViewController;

-(UIViewController*)getCurrentActivityVc;
@end
