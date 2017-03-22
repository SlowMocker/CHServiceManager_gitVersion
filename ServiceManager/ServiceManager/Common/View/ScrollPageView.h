//
//  ScrollPageView.h
//  ShowProduct
//
//  Created by lin on 14-5-23.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZScrollView.h"

@protocol ScrollPageViewDelegate <NSObject>
- (void)didScrollPageViewChangedPage:(NSInteger)aPage;
@end

@interface ScrollPageView : UIView<UIScrollViewDelegate>
{
    NSInteger currentPage;
    BOOL needUseDelegate;
}
@property (nonatomic, retain) WZScrollView *scrollView;

@property (nonatomic, retain) NSMutableArray *contentItems;

@property (nonatomic, weak) id<ScrollPageViewDelegate> delegate;

#pragma mark 添加ScrollowViewd的ContentView
- (void)setContentOfTables:(NSInteger)aNumerOfTables;

#pragma mark 滑动到某个页面
- (void)moveScrollowViewAthIndex:(NSInteger)aIndex;

#pragma mark 刷新某个页面
- (void)freshContentTableAtIndex:(NSInteger)aIndex;

@end
