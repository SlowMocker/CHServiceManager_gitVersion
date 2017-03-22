//
//  RSAForiOS.h
//  SmallSecretary
//
//  Created by pretang001 on 14-6-5.
//  Copyright (c) 2014年 pretang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAForiOS : NSObject

+ (RSAForiOS *)sharedInstance;

#pragma mark - 加密

- (OSStatus)extractPublicKeyFromCertificateFile;

/** Base64编码后的加密字符串
 *
 *
 */
- (NSString *)rsaEncryptString:(NSString *)plainString;

#pragma mark - 解密

- (OSStatus)extractPrivateKeyFromPKCS12File;

/** 解密Base64编码的字符串
 *
 *
 *  @return 解密后的字符串
 */
- (NSString *)rsaDecryptBase64String:(NSString *)base64cipherString;

@end
