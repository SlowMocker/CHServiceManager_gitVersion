//
//  TripleDES.m
//  BaseProject
//
//  Created by wangzhi on 15-2-2.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "TripleDES.h"
#import "Base64.h"

@implementation TripleDES

//3des加解密
+ (NSString*)TripleDES:(NSString*)plainText key:(NSString*)desKey encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
    const void *vplainText;
    size_t plainTextBufferSize;

    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        NSData *EncryptData = [Base64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }

    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;

    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);

    const void *vkey = (const void *) [desKey UTF8String];

    CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    NSString *result;

    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [Base64 stringByEncodingData:myData];
    }

    free(bufferPtr);

    return result;
}

@end
