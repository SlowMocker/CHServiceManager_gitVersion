//
//  WZImageViewController.m
//  ServiceManager
//
//  Created by wangzhi on 15/6/30.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZImageViewer.h"
#import "WZSlideImageView.h"

@interface WZImageViewer() <WZSlideImageViewDelegate>
@property(nonatomic, strong)UIView *backGroundView;
@property(nonatomic, strong)WZSlideImageView *slideImageView;
@end

@implementation WZImageViewer

- (UIWindow*)currentKeyWindow
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    return window;
}

- (void)showImageViewerWithImageArray:(NSArray*)imageArray
{
    _imageArray = imageArray;
    [self showImageViewer];
}

- (void)showImageViewer
{
    CGRect frame = [UIScreen mainScreen].bounds;

    _backGroundView = [[UIView alloc]initWithFrame:frame];
    _backGroundView.backgroundColor = kColorBlack;
    _backGroundView.alpha = 0.80;
    _backGroundView.userInteractionEnabled = YES;
    [_backGroundView addSingleTapEventWithTarget:self action:@selector(singleTapEventAction:)];

    _slideImageView = [[WZSlideImageView alloc]initWithFrame:frame];
    _slideImageView.defaultImage = ImageNamed(@"list_default_img");
    _slideImageView.bSlide = NO;
    _slideImageView.imageContentMode = UIViewContentModeScaleAspectFit;
    _slideImageView.actionDelegate = self;
    _slideImageView.imageArray = self.imageArray;
    _slideImageView.backgroundColor = kColorBlack;
    _slideImageView.alpha = 0.90;

    [_backGroundView addSubview:_slideImageView];

    [[self currentKeyWindow]addSubview:_backGroundView];
}

- (void)dismissImageViewer
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _backGroundView.bounds;
        frame.origin.y = CGRectGetMaxY(_backGroundView.frame);
        frame.size.height = 0;
        _backGroundView.frame = frame;
    } completion:^(BOOL finished) {
        _backGroundView.hidden = YES;
        [_backGroundView removeFromSuperview];
    }];

    [_backGroundView removeFromSuperview];
}

- (void)slideImageView:(WZSlideImageView*)slideView clicked:(UIImageView*)imageView
{
    [self dismissImageViewer];
}

- (void)singleTapEventAction:(UIGestureRecognizer*)recognizer
{
    [self dismissImageViewer];
}

@end
