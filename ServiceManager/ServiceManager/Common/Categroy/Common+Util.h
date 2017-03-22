//
//  Common+Util.h
//  ServiceManager
//
//  Created by will.wang on 2017/2/22.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView(Util)

/**
 * @downloadUrl: image address
 * @defaultImage: default image to set if download error
 * a indicator will be show durning the downloading
 */
- (void)setImageWithDownloadUrl:(NSString*)downloadUrl defaultImage:(UIImage*)defaultImage;
@end
