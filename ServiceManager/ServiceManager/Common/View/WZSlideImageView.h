//
//  WZSlideImageView.h
//  WZSlideImageViewProject
//
//  Created by wangzhi on 15-3-16.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZSlideImageView;

@protocol WZSlideImageViewDelegate <NSObject>

- (void)slideImageView:(WZSlideImageView*)slideView clicked:(UIImageView*)imageView;

@end

@interface WZSlideImageViewItem : NSObject
@property(nonatomic, copy)NSString *imageName;  //本地图片
@property(nonatomic, copy)NSString *imageUrl;   //远程图片

@property(nonatomic, strong)UIImageView *imageView; //无需传入，内部创建
@end

@interface WZSlideImageView : UIScrollView
@property(nonatomic, assign)BOOL bSlide;    //是否自动播放图片

@property(nonatomic, strong)UILabel *imageCountLabel;  //张数显示
@property(nonatomic, strong)UIPageControl *pageControl;

@property(nonatomic, copy)UIImage *defaultImage;
@property(nonatomic, assign)UIViewContentMode imageContentMode;

//item : WZSlideImageViewItem
@property(nonatomic, strong)NSArray *imageArray;
@property(nonatomic, assign)id<WZSlideImageViewDelegate>actionDelegate;
@end
