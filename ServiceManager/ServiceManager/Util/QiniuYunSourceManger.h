//
//  QiniuYunSourceManger.h
//  ServiceManager
//
//  Created by will.wang on 2017/2/13.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"

/**
 *  implementaion it in ui view controller
 */
@protocol QiniuImageUploaderDelegate <NSObject>
- (void)takeAndUploadPicture;
- (void)uploadImageToQiniuYun:(NSString*)imageFileFullPath;
@end

@interface QiniuYunSourceManger : NSObject

/**
 *1, tabke picture, 2, save to local cache, 3, upload
 */
- (void)takeAndUploadPicture:(ViewController*)baseViewController progress:(QNUpProgressHandler)progress complete:(QNUpCompletionHandler)completionHandler;

/**
 * 1, get token, 2, upload
 */
- (void)uploadImageToQiniuYun:(NSString*)filePath progress:(QNUpProgressHandler)progressHandler complete:(QNUpCompletionHandler)completionHandler;

/**
 * generate image file access url by key
 */
+ (NSString*)generateImageFileUrlInQiniu:(NSString*)key;

@end
