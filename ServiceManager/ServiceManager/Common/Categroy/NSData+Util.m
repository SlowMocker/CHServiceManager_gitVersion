//
//  NSData+Util.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-28.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "NSData+Util.h"

@implementation NSData (Util)

+ (NSData*)jsonDataWithArray:(NSArray*)array
{
    return [[self class]jsonDataWithObject:array];
}

+ (NSData*)jsonDataWithDictionary:(NSDictionary*)dictionary
{
    return [[self class]jsonDataWithObject:dictionary];
}

+ (NSData*)jsonDataWithObject:(id)object
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];

    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

+ (NSData*)dataWithString:(NSString*)string
{
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData*)desDecryptData:(NSData*)cipherHexData withKey:(NSString*)desKey
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

+ (NSData*)desEncryptData:(NSData*)plainData withKey:(NSString*)desKey
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

+ (NSData *)dataFromHexString:(NSString *)hexString {
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSData *data = [NSData dataWithBytes:myBuffer length:[hexString length] / 2];
    free(myBuffer);
    return data;
}
@end
