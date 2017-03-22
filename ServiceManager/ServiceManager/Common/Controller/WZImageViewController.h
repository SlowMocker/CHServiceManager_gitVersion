//
//  WZImageViewController.h
//  ServiceManager
//
//  Created by wangzhi on 15/6/30.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "WZSlideImageView.h"

@interface WZImageViewController : ViewController

//ITEM:WZSlideImageViewItem
@property(nonatomic, strong)NSArray *imageArray;
@property(nonatomic, assign)id<WZSlideImageViewDelegate> delegate;

@end
