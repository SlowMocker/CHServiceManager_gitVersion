//
//  TripleDES.h
//  BaseProject
//
//  Created by wangzhi on 15-2-2.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripleDES : NSObject

+ (NSString*)TripleDES:(NSString*)plainText key:(NSString*)desKey encryptOrDecrypt:(CCOperation)encryptOrDecrypt;

@end
