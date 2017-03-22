//
//  UIImage+Util.m
//  ScienceFictionWorld
//
//  Created by JYS on 12-12-29.
//  Copyright (c) 2012年 swinhot. All rights reserved.
//

#import "UIImage+Util.h"


@implementation UIImage (Util)

/** 压缩图片
 *
 * @param imageLength 压缩到指定的字节数
 *
 */
- (NSData *)compressedDataToDataLength:(NSUInteger)imageLength
{

    UIImage *image = [self copy];
    CGFloat compressionQuality = 1.0;
    NSData *data = UIImageJPEGRepresentation(image, compressionQuality);
    NSUInteger dataLength = [data length];

    while ( dataLength > imageLength)
    {
        DLog(@"%s outer start compressionQuality is %f \ndataLength is %ld ", __FUNCTION__, compressionQuality, (unsigned long)dataLength);
        if ( compressionQuality < 0 ){
            return data;
        }
        compressionQuality -= 0.5;
        data = UIImageJPEGRepresentation(image, compressionQuality);
        dataLength = [data length];
        DLog(@"%s outer end compressionQuality is %f \ndataLength is %ld ", __FUNCTION__, compressionQuality, (unsigned long)dataLength);
    }

    return data;
}

/** 按比例缩放图片 缩放比例取（原始宽度/限制宽度）和（原始高度/限制高度）两者之中的最小值
 *
 * @param limitedWith    宽度限制
 * @param limitedHeight  高度限制
 */
- (UIImage*)scaleWithLimitiedWidth:(float)limitedWidth limitedHeight:(float)limitedHeight
{

    CGFloat width = self.size.width * self.scale/2.0;
    CGFloat height = self.size.height * self.scale/2.0;

    CGImageRef imgRef = self.CGImage;

    CGFloat horizontalScale = limitedWidth/width;
    CGFloat verticalScale = limitedHeight/height;

    CGFloat scaleRatio = 1.0;

    if ( horizontalScale < 1.0 || verticalScale < 1.0 )
    {
        scaleRatio = MIN(horizontalScale, verticalScale);

        width *= scaleRatio;
        height *= scaleRatio;
    }
    CGRect bounds = CGRectMake(0, 0, width, height);

    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;

    CGAffineTransform transform = CGAffineTransformIdentity;
    UIImageOrientation orient = self.imageOrientation;
    switch(orient)
    {

        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;

        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;

        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;

        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = boundHeight;
            bounds.size.width = bounds.size.width;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];

    }

    UIGraphicsBeginImageContext(bounds.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -1.0, 1.0);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextTranslateCTM(context, 0, -height);
    }

    CGContextConcatCTM(context, transform);

    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return imageCopy;
}

/** 在不拉伸的情况下对图片尺寸进行压缩
 *
 */
- (UIImage*)scaledImageToLimitedSize:(CGSize)newSize
{
    CGFloat width = self.size.width * self.scale/2.0;
    CGFloat height = self.size.height * self.scale/2.0;

    CGFloat horizontalScaleRatio = newSize.width/width;
    CGFloat verticalScaleRatio = newSize.height/height;

    CGFloat scaleRatio = 1.0;

    if ( horizontalScaleRatio < 1.0 || verticalScaleRatio < 1.0 )
    {
        scaleRatio = MIN(horizontalScaleRatio, verticalScaleRatio);

        width *= scaleRatio;
        height *= scaleRatio;
    }

    // Create a graphics image context

    UIGraphicsBeginImageContext(CGSizeMake(width, height));


    // Tell the old image to draw in this new context, with the desired
    // new size

    [self drawInRect:CGRectMake(0, 0, width, height)];


    // Get the new image from the context

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();


    // End the context

    UIGraphicsEndImageContext();

    // Return the new image.

    return newImage;
}


/** 旋转图片
 *
 */
- (UIImage*)rotateImageByOrientation:(UIImageOrientation)orient
{
	CGRect bnds = CGRectZero;
	UIImage *copy = nil;
	CGContextRef ctxt = nil;
	CGRect rect = CGRectZero;
	CGAffineTransform  tran = CGAffineTransformIdentity;
	bnds.size = self.size;
	rect.size = self.size;
	//CLog("%s, %d", __FUNCTION__, orient);
	switch (orient)
	{
		case UIImageOrientationUp:
			return self;
		case UIImageOrientationUpMirrored:
			tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			break;
		case UIImageOrientationDown:
			tran = CGAffineTransformMakeTranslation(rect.size.width,
													rect.size.height);
			tran = CGAffineTransformRotate(tran, M_PI);
			break;
		case UIImageOrientationDownMirrored:
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
			tran = CGAffineTransformScale(tran, 1.0, -1.0);
			break;
		case UIImageOrientationLeft: {
			//CGFloat wd = bnds.size.width;
            //			bnds.size.width = bnds.size.height;
            //			bnds.size.height = wd;
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
			tran = CGAffineTransformRotate(tran, -M_PI_2);
		}
			break;
		case UIImageOrientationLeftMirrored: {
			//CGFloat wd = bnds.size.width;
            //			bnds.size.width = bnds.size.height;
            //			bnds.size.height = wd;
			tran = CGAffineTransformMakeTranslation(rect.size.height,
													rect.size.width);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			tran = CGAffineTransformRotate(tran, -M_PI_2);
		}
			break;
		case UIImageOrientationRight: {
			CGFloat wd = bnds.size.width;
			bnds.size.width = bnds.size.height;
			bnds.size.height = wd;
			tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
			tran = CGAffineTransformRotate(tran, M_PI_2);
		}
			break;
		case UIImageOrientationRightMirrored: {
			//CGFloat wd = bnds.size.width;
            //			bnds.size.width = bnds.size.height;
            //			bnds.size.height = wd;
			tran = CGAffineTransformMakeScale(-1.0, 1.0);
			tran = CGAffineTransformRotate(tran, M_PI_2);
		}
			break;
		default:
			// orientation value supplied is invalid
			assert(false);
			return nil;
	}
	UIGraphicsBeginImageContext(rect.size);
	ctxt = UIGraphicsGetCurrentContext();
	switch (orient)
	{
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
			CGContextScaleCTM(ctxt, -1.0 * (rect.size.width / rect.size.height), 1.0 * (rect.size.height / rect.size.width));
			CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
			break;
		default:
			CGContextScaleCTM(ctxt, 1.0, -1.0);
			CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
			break;
	}
	CGContextConcatCTM(ctxt, tran);
	CGContextDrawImage(ctxt, rect, self.CGImage);
	copy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return copy;
}

/** 图片拼接
 *
 *  @param soureImage  要添加的图片
 *
 */
- (UIImage *)joinImage:(UIImage *)soureImage;
{

    CGSize composedSize = CGSizeMake(MAX(self.size.width, soureImage.size.width), self.size.height + soureImage.size.height);

    UIGraphicsBeginImageContext(composedSize);

    //Draw self
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];

    //Draw soureImage
    [soureImage drawInRect:CGRectMake(0 , self.size.height, soureImage.size.width, soureImage.size.height)];

    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return resultImage;
}

+ (UIImage*)imageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(UIImage *)grayImage:(UIImage *)sourceImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width * scale,
                                                  height * scale,
                                                  8,
                                                  width * scale * 4,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width * scale, height * scale), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

+ (UIImage*)imageMapWithLatitude:(double)latitude longitude:(double)longitude
{
    NSString *staticMapUrl = [NSString stringWithFormat:@"http://api.map.baidu.com/staticimage?zoom=13&markers=%@,%@&markerStyles=l,A",@(latitude), @(longitude)];

    NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];

    return image;
}

+ (UIImage*)imageWithView:(UIView*)view
{
    UIGraphicsBeginImageContext(view.bounds.size);

    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

@end
