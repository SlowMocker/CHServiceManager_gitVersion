//
//  WZImageViewer.h
//  ServiceManager
//
//  Created by wangzhi on 15/7/9.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZImageViewer : NSObject

//ITEM:WZSlideImageViewItem
@property(nonatomic, strong)NSArray *imageArray;

- (void)showImageViewerWithImageArray:(NSArray*)imageArray;

- (void)showImageViewer;

- (void)dismissImageViewer;
@end
