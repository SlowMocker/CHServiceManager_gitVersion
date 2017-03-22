//
//  DesUtils.m
//  DesEncription
//
//  Created by mac on 15/8/20.
//  Copyright (c) 2015年 will.wang. All rights reserved.
//

#import "DesUtils.h"
#import <CommonCrypto/CommonCrypto.h>
#import "Base64.h"

@implementation DesUtils

+ (NSData*)decryptData:(NSData*)cipherHexData withKey:(NSString*)desKey
{
    const void *cipherText =[cipherHexData bytes];
    size_t plainTextBufferSize = [cipherHexData length];

    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;

    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);

    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [desKey UTF8String];

    CCCrypt(kCCDecrypt,
            kCCAlgorithmDES,
            kCCOptionPKCS7Padding,
            vkey,
            kCCKeySizeDES,
            vkey,
            cipherText,
            plainTextBufferSize,
            (void *)bufferPtr,
            bufferPtrSize,
            &movedBytes);
    NSData *plainData = [NSData dataWithBytes:(const void *)bufferPtr
                          length:(NSUInteger)movedBytes];
    free(bufferPtr);
    return plainData;
}

+ (NSString*)encrypt:(NSString*)plainText withKey:(NSString*)desKey
{
    NSData *plainData = [NSData dataWithString:plainText];
    NSData *encryptedData = [self encryptData:plainData withKey:desKey];
    return [NSString hexStringFromData:encryptedData];
}

+ (NSData*)encryptData:(NSData*)plainData withKey:(NSString*)desKey
{
    const void *vplainText = [plainData bytes];
    size_t plainTextBufferSize = [plainData length];
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);

    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [desKey UTF8String];
    
    CCCrypt(kCCEncrypt,
            kCCAlgorithmDES,
            kCCOptionPKCS7Padding,
            vkey,
            kCCKeySizeDES,
            vkey,
            vplainText,
            plainTextBufferSize,
            (void *)bufferPtr,
            bufferPtrSize,
            &movedBytes);
    NSData *encryptedData = [NSData dataWithBytes:(void *)bufferPtr length:(NSUInteger)movedBytes];
    free(bufferPtr);
    
    return encryptedData;
}

+ (NSString*)decrypt:(NSString*)cipherHexStr withKey:(NSString*)desKey
{
    NSData *cipherHexData = [NSData dataWithString:cipherHexStr];
    NSData *plainData = [self decryptData:cipherHexData withKey:desKey];
    return [NSString hexStringFromData:plainData];
}

@end
