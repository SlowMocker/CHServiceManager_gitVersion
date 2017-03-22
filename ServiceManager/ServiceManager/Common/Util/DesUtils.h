//
//  DesUtils.h
//  DesEncription
//
//  Created by mac on 15/8/20.
//  Copyright (c) 2015年 will.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesUtils : NSObject

//return encryped data with hexstring, not base64
+ (NSString*)encrypt:(NSString*)plainText withKey:(NSString*)desKey;

//return plain text
+ (NSString*)decrypt:(NSString*)cipherHexStr withKey:(NSString*)desKey;

@end
