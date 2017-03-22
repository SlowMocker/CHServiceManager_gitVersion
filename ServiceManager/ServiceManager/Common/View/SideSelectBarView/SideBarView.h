//
//  SideBarView.h
//  SmallSecretary2.0
//
//  Created by zhiqiangcao on 14-9-17.
//  Copyright (c) 2014年 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideView.h"

/**
 *  侧边栏展现位置
 */
typedef NS_ENUM(NSUInteger, kSideBarType)
{
    /**
     *  侧边栏居左(默认)
     */
    kSideBarTypeLeft,
    /**
     *  侧边栏居右
     */
    kSideBarTypeRight
};

@protocol SideBarViewDelegate;

@interface SideBarView : UIView

@property (nonatomic, weak) id<SideBarViewDelegate> delegate;

//辅助视图（弹出一个侧边栏如果需要就需要设置一次，只会对当前可视的侧边栏起效）
@property (nonatomic, strong) UIView *accessoryView;

@property (nonatomic, weak) UIView *fatherView;//父视图

/**
 *  添加侧边栏
 *
 *  @param size        侧边栏大小
 *  @param title       侧边栏标题
 *  @param sourceArray 侧边栏table的datasource, item:SideBarEntity
 *  @param next        是否还有下个侧边栏
 */
- (void)addSideViewWithSize:(CGSize)size WithTitle:(NSString *)title withDataSource:(NSArray *)sourceArray withNext:(BOOL)next withSelectSideBarEntity:(SideBarEntity *)sideBarEntity mutiMode:(BOOL)mutiMode;

/**
 *  移除当前的侧边栏（如果还有上一级侧边栏则展现上一级侧边栏）
 */
- (void)removeCurrentSideView;

/**
 *  从当前视图移除
 */
- (void)remove;

@end

@protocol SideBarViewDelegate <NSObject>

@optional
- (void)SideBarView:(SideBarView *)sideBar chooseSideBarEntity:(SideBarEntity *)item;

- (void)SideBarViewWillHide:(SideBarView *)sideBar;

- (void)SideBarView:(SideBarView *)sideBar backToSideView:(SideView *)sideView;

@end
