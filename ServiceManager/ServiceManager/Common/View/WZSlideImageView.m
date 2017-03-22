//
//  WZSlideImageView.m
//  WZSlideImageViewProject
//
//  Created by wangzhi on 15-3-16.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZSlideImageView.h"
#define kPageControlViewHeight 30
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation WZSlideImageViewItem
@end

@interface WZSlideImageView()<UIScrollViewDelegate>
{
    NSTimer *myTimer;//定时器
}
@property(nonatomic, strong)UIScrollView *scrollView;
@end

@implementation WZSlideImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
//        [self addSubview:self.pageControl];
//        [self bringSubviewToFront:self.pageControl];

        [self addSubview:self.imageCountLabel];
        [self bringSubviewToFront:self.imageCountLabel];
    }
    return self;
}

- (UILabel*)imageCountLabel
{
    if (_imageCountLabel == nil) {
        CGSize labelSize = CGSizeMake(50, 24);
        CGRect frame;
        frame.origin.x = CGRectGetWidth(self.frame) - labelSize.width - kDefaultSpaceUnit;
        frame.origin.y = CGRectGetHeight(self.frame) - labelSize.height - kDefaultSpaceUnit;
        frame.size = labelSize;
        _imageCountLabel = [[UILabel alloc]initWithFrame:frame];
        _imageCountLabel.backgroundColor = kColorBlack;
        _imageCountLabel.alpha = 0.80;
        _imageCountLabel.font = SystemFont(15);
        _imageCountLabel.textColor = kColorWhite;
        _imageCountLabel.textAlignment = NSTextAlignmentCenter;
        _imageCountLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _imageCountLabel;
}

- (UIScrollView*)scrollView
{
    if (nil == _scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (nil == _pageControl) {
        CGRect frame = self.bounds;
        frame.origin.y = frame.size.height - kPageControlViewHeight;
        frame.size.height = kPageControlViewHeight;
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl = [[UIPageControl alloc]initWithFrame:frame];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (void)pageTurn:(UIPageControl *)sender
{
    NSInteger pageNum = self.pageControl.currentPage;

    [self scrollToPageIndex:pageNum];
}

#pragma UIScrollView delegate

-(void)scrollToNextPage:(id)sender
{
    ReturnIf(self.imageArray.count <= 0);

    NSInteger currentPage = self.pageControl.currentPage;
    NSInteger nextPage = (currentPage + 1)%self.imageArray.count;

    [self scrollToPageIndex:nextPage];

    self.pageControl.currentPage = currentPage;
}

- (UIImageView*)createImageButton:(WZSlideImageViewItem*)item frame:(CGRect)frame index:(NSInteger)index
{
    UIImageView *imageBtn = [[UIImageView alloc]initWithFrame:frame];

    if (![Util isEmptyString:item.imageName]) {
        [imageBtn setImage:ImageNamed(item.imageName)];
    }else {
        [imageBtn setImage:self.defaultImage];
    }

    if (![Util isEmptyString:item.imageUrl]) {
        [imageBtn setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:self.defaultImage];
    }

    imageBtn.tag = index;
    imageBtn.frame = frame;
    imageBtn.contentMode = self.imageContentMode;
    imageBtn.backgroundColor = [UIColor clearColor];

    imageBtn.userInteractionEnabled = YES;
    [imageBtn addSingleTapEventWithTarget:self action:@selector(imageItemClicked:)];

    item.imageView = imageBtn;

    return imageBtn;
}

- (void)imageItemClicked:(UIGestureRecognizer*)gesture
{
    UIImageView *imageView = (UIImageView*)gesture.view;

    if ([self.actionDelegate respondsToSelector:@selector(slideImageView:clicked:)]) {
        [self.actionDelegate slideImageView:self clicked:imageView];
    }
}

- (void)clearAllImageViews
{
    for(UIView *subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }
}

- (void)refreshImageViews
{
    CGRect frame;
    UIImageView *imageBtn;

    self.pageControl.numberOfPages = self.imageArray.count;

    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;

    for (int index = 0; index < [self.imageArray count]; index++) {
        frame = CGRectMake(width * index, 0, width, height);
        imageBtn = [self createImageButton:self.imageArray[index] frame:frame index:index];
        [self.scrollView addSubview: imageBtn];
    }

    [self.scrollView setContentSize:CGSizeMake(self.imageArray.count * width, height)];
    self.pageControl.currentPage = 0;
    [self updateCountLabelValue];
}

- (void)updateCountLabelValue
{
    [self.imageCountLabel setText:[NSString stringWithFormat:@"%@/%@",  @(self.pageControl.currentPage + 1), @(self.pageControl.numberOfPages)]];

}

- (void)scrollToPageIndex:(NSInteger)pageIndex
{
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;

    [self.scrollView scrollRectToVisible:CGRectMake(width * pageIndex, 0, width, height) animated:NO];
}

- (void)setImageArray:(NSArray *)imageArray
{
    if (_imageArray != imageArray) {
        _imageArray = imageArray;
    }
    if (nil != _imageArray && _imageArray.count > 0) {
        [self clearAllImageViews];
        [self refreshImageViews];
    }
}

- (void)setBSlide:(BOOL)bSlide
{
    if (_bSlide != bSlide) {
        _bSlide = bSlide;
    }
    [self launchTimerIfNeed];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [myTimer invalidate];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self launchTimerIfNeed];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth=self.scrollView.frame.size.width;

    NSInteger currentPage = floor((self.scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;

    if (currentPage >= self.imageArray.count) {
        self.pageControl.currentPage = 0;
    }else {
        self.pageControl.currentPage = currentPage;
    }
    [self updateCountLabelValue];
}

- (void)launchTimerIfNeed
{
    if (_bSlide) {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    }else {
        [myTimer invalidate];
        myTimer = nil;
    }
}

@end
