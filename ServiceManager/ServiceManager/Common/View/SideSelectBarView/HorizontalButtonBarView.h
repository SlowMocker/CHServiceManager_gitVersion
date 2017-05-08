//
//  HorizontalScrollButtonView.h
//  ServiceManager
//
//  Created by mac on 15/8/27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HorizontalButtonBarView;

//protocal
@protocol HorizontalButtonBarViewDelegate <NSObject>
@optional
/**
 *  bar 上的按钮数
 */
- (NSInteger)numberOfHorizontalButtons:(HorizontalButtonBarView*)buttonBarView;
/**
 *  bar 上对应位置（btnIndex）按钮的title
 */
- (NSString*)horizontalButtonBarView:(HorizontalButtonBarView*)barView buttonTitleForIndex:(NSInteger)btnIndex;
/**
 *  bar 上对应位置（btnIndex）上的按钮
 */
- (UIButton*)horizontalButtonBarView:(HorizontalButtonBarView*)barView buttonForIndex:(NSInteger)btnIndex;
/**
 *  bar 上对应位置（btnIndex）按钮选中时的代理接口
 */
- (void)horizontalButtonBarView:(HorizontalButtonBarView*)barView didSelectedAtIndex:(NSInteger)btnIndex;
@end

//interface
@interface HorizontalButtonBarView : UIView

@property (nonatomic, assign)id <HorizontalButtonBarViewDelegate> delegate;

@property (nonatomic, assign)CGFloat buttonWidth;

//indicator view properties
@property (nonatomic, assign)BOOL showIndicatorView; //default is Yes
@property (nonatomic, strong)UIColor *indicatorViewColor; //default is button's selected status's title color
@property (nonatomic, assign)CGFloat indicatorViewHeight; //default is 2.5

//button attr
@property(nonatomic, strong)UIFont *buttonTitleFont; //default is 16
@property(nonatomic, strong)UIColor *buttonTitleNormalColor; //default is dark gray
@property(nonatomic, strong)UIColor *buttonTitleSelectedColor; //default is blue

//custom indicator view
@property (nonatomic, strong)UIView *selectedIndicatorView;

- (id)initWithFrame:(CGRect)frame delegate:(id<HorizontalButtonBarViewDelegate>)delegate;

//send click event to button
- (void)clickButtonAtIndex:(NSInteger)aIndex;

//set button.selected with YES, and focus it
- (void)changeButtonStateAtIndex:(NSInteger)aIndex;

@end
