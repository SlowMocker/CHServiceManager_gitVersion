//
//  MutiImageAddingView.h
//  MutiImageView
//
//  Created by wangzhi on 15-2-26.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MutiImageAddingViewDelegate <NSObject>
@optional
- (void)mutiImageAddingView:(id)view imageClicked:(NSInteger)index image:(UIImage*)image;
- (void)mutiImageAddingView:(id)view addedNewImage:(UIImage*)image;
@end

@interface MutiImageAddingView : UIView
@property(nonatomic, strong)id<MutiImageAddingViewDelegate>delegate;
@property(nonatomic, strong)NSMutableArray *addedImgArray;

//必填
@property(nonatomic, strong)UIViewController *prensentBaseViewController;

//推荐使用些接口初始化
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<MutiImageAddingViewDelegate>)delegate;

//imageUrlArray ITEM: 为imageUrl
- (void)addImagesWithUrl:(NSArray*)imageUrlArray defaultImg:(UIImage*)defaultImage;

- (UIButton*)addImageItemWithImageUrl:(NSString*)imageUrl;

- (UIButton*)addImageItemWithImage:(UIImage*)image;

- (void)removeImageItemAtIndex:(NSInteger)imageIndex;

@end
