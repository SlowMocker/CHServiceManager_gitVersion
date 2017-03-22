//
//  SideView.h
//  SmallSecretary2.0
//
//  Created by zhiqiangcao on 14-9-17.
//  Copyright (c) 2014年 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideBarEntity.h"

@protocol SideViewDelegate;

@interface SideView : UIView

@property (nonatomic, weak) id<SideViewDelegate> delegate;
@property (nonatomic, strong) UIView *accessoryView;

/**
 *  指定初始化方法
 *
 *  @param frame       初始化位置大小
 *  @param title       titleButton的标题
 *  @param sourceArray displayTable的datasource(SideBarEntity对象)
 *  @param next        是否还有下个侧边栏
 *  @param can         顶部按钮是否有点击效果
 *
 *  @return SideView实例
 */
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withSource:(NSArray *)sourceArray withNext:(BOOL)next titleButtonCanClick:(BOOL)can withSelectSideBarEntity:(SideBarEntity *)sideBarEntity mutiMode:(BOOL)mutiMode;

@end

@protocol SideViewDelegate <NSObject>

@optional
/**
 *  顶部按钮点击后事件
 *
 *  @param view   self
 *  @param sender 点击的按钮
 */
- (void)sideView:(SideView *)view clickTitleButton:(UIButton *)sender;
/**
 *  单元项点击后事件
 *
 *  @param view   self
 *  @param single 选中的单元项
 */
- (void)sideView:(SideView *)view chooseSideBarEntity:(SideBarEntity *)item;

@end
