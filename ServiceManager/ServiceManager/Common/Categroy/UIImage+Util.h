//
//  UIImage+Util.h
//  ScienceFictionWorld
//
//  Created by JYS on 12-12-29.
//  Copyright (c) 2012年 swinhot. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CONTENT_MAX_WIDTH (280.0)

@interface UIImage (Util)

/** 压缩图片
 *
 * @param imageLength 压缩到指定的字节数
 *
 */
- (NSData *)compressedDataToDataLength:(NSUInteger)imageLength;

/** 按比例缩放图片 缩放比例取（原始宽度/限制宽度）和（原始高度/限制高度）两者之中的最小值
 *
 * @param limitedWith    宽度限制
 * @param limitedHeight  高度限制
 */
- (UIImage*)scaleWithLimitiedWidth:(float)limitedWidth limitedHeight:(float)limitedHeight;

/** 在不拉伸的情况下对图片尺寸进行压缩
 *
 */
- (UIImage*)scaledImageToLimitedSize:(CGSize)newSize;

/** 旋转图片
 *
 */
- (UIImage*)rotateImageByOrientation:(UIImageOrientation)orient;


/** 图片拼接
 *
 *  @param soureImage  要添加的图片
 *
 */
- (UIImage *)joinImage:(UIImage *)soureImage;

+ (UIImage*)imageWithColor:(UIColor*)color;

//将图片去色变为灰色
+(UIImage *)grayImage:(UIImage *)sourceImage;

+ (UIImage*)imageMapWithLatitude:(double)latitude longitude:(double)longitude;


//convert view to image
+ (UIImage*)imageWithView:(UIView*)view;


@end
