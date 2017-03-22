//
//  ScrollPageView.m
//  ShowProduct
//
//  Created by lin on 14-5-23.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "ScrollPageView.h"

@implementation ScrollPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        needUseDelegate = YES;
        [self commInit];
    }
    return self;
}

- (void)initData
{
    [self freshContentTableAtIndex:0];
}


- (void)commInit
{
    if (_contentItems == nil)
    {
        _contentItems = [[NSMutableArray alloc] init];
    }
    if (_scrollView == nil)
    {
        _scrollView = [[WZScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    [self addSubview:_scrollView];
}

#pragma mark - 其他辅助功能

#pragma mark 添加ScrollowViewd的ContentView

- (void)setContentOfTables:(NSInteger)aNumerOfTables
{
    for (int i = 0; i < aNumerOfTables; i++)
    {

    }
    CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.frame);
    [_scrollView setContentSize:CGSizeMake(scrollViewWidth * aNumerOfTables, self.frame.size.height)];
}

- (void)setContentItems:(NSMutableArray *)contentItems
{
    _contentItems = contentItems;
    CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.frame);
    for ( NSUInteger i = 0 ; i < contentItems.count; i ++ )
    {
        id content = [contentItems objectAtIndex:i];
        if ( [content isKindOfClass:[UIView class]] )
        {
            UIView *contentView = (UIView *)content;
            CGRect frame = contentView.frame;
            frame.origin.x = scrollViewWidth * i;
            contentView.frame = frame;
            [self.scrollView addSubview:content];

        }

    }

    [_scrollView setContentSize:CGSizeMake(scrollViewWidth * contentItems.count, self.frame.size.height)];

}

#pragma mark 移动ScrollView到某个页面

- (void)moveScrollowViewAthIndex:(NSInteger)aIndex
{
    needUseDelegate = NO;
    CGRect vMoveRect = CGRectMake(self.frame.size.width * aIndex, 0, self.frame.size.width, self.frame.size.width);
    [_scrollView scrollRectToVisible:vMoveRect animated:YES];
    currentPage= aIndex;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)])
    {
        [_delegate didScrollPageViewChangedPage:currentPage];
    }
}

#pragma mark 刷新某个页面

- (void)freshContentTableAtIndex:(NSInteger)aIndex
{
    if (_contentItems.count < aIndex)
    {
        return;
    }

}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    needUseDelegate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.frame);
    int page = (_scrollView.contentOffset.x + scrollViewWidth/2.0) / scrollViewWidth;
    if (currentPage == page)
    {
        return;
    }
    currentPage= page;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)] && needUseDelegate)
    {
        [_delegate didScrollPageViewChangedPage:currentPage];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {

    }

}

@end
