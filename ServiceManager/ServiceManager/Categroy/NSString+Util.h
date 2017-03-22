//
//  NSString+Util.h
//  BaseProject
//
//  Created by wangzhi on 15-1-24.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSString (Util)

// 是否不为空
-(BOOL)isNotEmpty;

// 获取Documents路径 Documents
+ (NSString *)documentPath;

// 获取缓存路径 Library/Caches
+ (NSString *)cachePath;

// 已定义好的图片路径， Library/Caches/Images
+ (NSString *)imageCachePath;

// 是否是合法邮箱
- (BOOL)isValidEmail;

// 是否是合法手机号码
- (BOOL)isValidPhoneNumber;

// 是否是合法的18位身份证号码
- (BOOL)isValidPersonID;

// 根据文件名返回路径
+ (NSString *)pathWithFileName:(NSString *)fileName;

// 本地购物车路径
+ (NSString *)localShoppingCartPath;

#pragma mark - MD5

- (NSString *)md5Encrypt;

@end

#pragma mark - APP相关信息
@interface NSString (AppInfo)
+ (NSString*)appVersion;
+ (NSString*)appBundleVersion;
+ (NSString*)appBundleId;
@end

