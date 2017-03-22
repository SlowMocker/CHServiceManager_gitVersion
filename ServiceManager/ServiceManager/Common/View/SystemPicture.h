//
//  SystemPicture.h
//  MutiImageView
//
//  Created by wangzhi on 15-2-26.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SystemPicture;

@protocol SystemPictureDelegate <NSObject>
@optional
- (void)systemPicture:(SystemPicture*)object pickingImage:(UIImage*)image;
- (void)systemPicturePickingImageCancel:(SystemPicture*)object;
@end

@interface SystemPicture : NSObject

- (instancetype)initWithDelegate:(id<SystemPictureDelegate>)delegate baseViewController:(UIViewController*)baseViewController;

@property(nonatomic,assign)id<SystemPictureDelegate>delegate;
@property(nonatomic, strong)UIViewController *baseViewController;

//选择相册或相机
-(void)startSelect;

//直接调用相机
- (void)takePictureByCamera;
@end
