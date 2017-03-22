//
//  NSData+Util.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-28.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSData (Util)
+ (NSData*)jsonDataWithDictionary:(NSDictionary*)dictionary;
+ (NSData*)jsonDataWithArray:(NSArray*)array;
+ (NSData*)dataWithString:(NSString*)string;    //with common string
+ (NSData *)dataFromHexString:(NSString *)hexString; //with hex string

#pragma mark - Des Encrypt & Decrypt
+ (NSData*)desEncryptData:(NSData*)plainData withKey:(NSString*)desKey;
+ (NSData*)desDecryptData:(NSData*)cipherHexData withKey:(NSString*)desKey;
@end
