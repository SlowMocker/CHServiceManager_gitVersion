//
//  WZImageViewController.m
//  ServiceManager
//
//  Created by wangzhi on 15/6/30.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZImageViewController.h"

@interface WZImageViewController()
@property(nonatomic, strong)UIView *backGroundView;
@property(nonatomic, strong)WZSlideImageView *slideImageView;
@end

@implementation WZImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.backGroundView];

    _slideImageView = [[WZSlideImageView alloc]initWithFrame:self.view.bounds];
    _slideImageView.defaultImage = ImageNamed(@"list_default_img");
    _slideImageView.bSlide = NO;
    _slideImageView.imageContentMode = UIViewContentModeScaleAspectFit;
    _slideImageView.actionDelegate = self.delegate;
    _slideImageView.imageArray = self.imageArray;
    _slideImageView.backgroundColor = kColorBlack;
    _slideImageView.alpha = 0.90;
    [self.view addSubview:_slideImageView];
}

- (UIView*)backGroundView
{
    if (nil == _backGroundView) {
        _backGroundView = [[UIView alloc]init];
        _backGroundView.backgroundColor = kColorBlack;
        _backGroundView.alpha = 0.60;
        _backGroundView.userInteractionEnabled = YES;
    }
    return _backGroundView;
}

@end
