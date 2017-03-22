//
//  BulletinBarView.h
//  ServiceManager
//
//  Created by will.wang on 2016/12/27.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BulletinBarView;

@protocol BulletinBarViewDelegate <NSObject>

//行数
- (NSInteger)bulletinBarView:(BulletinBarView *)bulletinView numberOfRowsInSection:(NSInteger)section;

//行视图
- (UITableViewCell*)bulletinBarView:(BulletinBarView *)bulletinView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

//行高
- (CGFloat)bulletinBarView:(BulletinBarView *)bulletinView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

//点击事件
- (void)bulletinBarView:(BulletinBarView *)bulletinView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BulletinBarView : UITableView
@property(nonatomic, assign)CGFloat timeInterval;   //滚动周期时间，默认5.0
@property(nonatomic, assign)CGFloat animateDuration; //滚动动画时间，默认1.0
@property(nonatomic, weak)id<BulletinBarViewDelegate> bulletinViewDelegate;

//推荐的init方法
- (instancetype)initWithFrame:(CGRect)frame;

//开启或停止动画
- (void)startAutoVerticalScrolling:(BOOL)bStart;

@end
