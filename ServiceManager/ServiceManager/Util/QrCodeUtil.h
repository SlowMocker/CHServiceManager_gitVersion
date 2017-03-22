//
//  QrCodeUtil.h
//  ServiceManager
//
//  Created by will.wang on 2016/12/15.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QrCodeUtil : NSObject

+ (NSString*)readQrCodeFromImage:(UIImage*)qrImage;

+ (UIImage*)generateQrCodeImage:(NSString*)qrCode sideLength:(CGFloat)sideLength;

@end
