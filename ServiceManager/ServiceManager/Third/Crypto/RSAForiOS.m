//
//  RSAForiOS.m
//  SmallSecretary
//
//  Created by pretang001 on 14-6-5.
//  Copyright (c) 2014年 pretang. All rights reserved.
//

#import "RSAForiOS.h"
#import <Security/Security.h>
#import "Base64.h"

static SecKeyRef _publicKey;
static SecKeyRef _privateKey;

static RSAForiOS *sharedRSAForiOS;

@interface RSAForiOS()
-(void)initCertificateFiles;
@end

@implementation RSAForiOS

+ (RSAForiOS *)sharedInstance
{
    if ( sharedRSAForiOS == nil )
    {
        static dispatch_once_t predicate;
        dispatch_once(&predicate,
                      ^{
                          sharedRSAForiOS = [[self alloc] init];
                          [sharedRSAForiOS initCertificateFiles];
                      });

    }

    return sharedRSAForiOS;
}

-(void)initCertificateFiles
{
    [self extractPublicKeyFromCertificateFile];
    [self extractPrivateKeyFromPKCS12File];
}



#pragma mark - 加密
- (OSStatus)extractPublicKeyFromCertificateFile
{
    OSStatus status = -1;
    if (_publicKey == nil)
    {
        SecTrustRef trust;
        SecTrustResultType trustResult;
        NSData *derData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"]];
        if (derData)
        {
            SecCertificateRef cert = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)derData);
            SecPolicyRef policy = SecPolicyCreateBasicX509();
            status = SecTrustCreateWithCertificates(cert, policy, &trust);
            if (status == errSecSuccess && trust)
            {
                NSArray *certs = [NSArray arrayWithObject:(__bridge id)cert];
                status = SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)certs);
                if (status == errSecSuccess)
                {
                    status = SecTrustEvaluate(trust, &trustResult);
                    // 自签名证书可信
                    if (status == errSecSuccess && (trustResult == kSecTrustResultUnspecified || trustResult == kSecTrustResultProceed))
                    {
                        _publicKey = SecTrustCopyPublicKey(trust);
                        if (_publicKey)
                        {
                            DLog(@"Get public key successfully~ %@", _publicKey);
                        }
                        if (cert)
                        {
                            CFRelease(cert);
                        }
                        if (policy)
                        {
                            CFRelease(policy);
                        }
                        if (trust)
                        {
                            CFRelease(trust);
                        }
                    }
                }
            }
        }
    }
    return status;
}

//加密
- (NSMutableData *)encryptWithPublicKey:(NSData *)plainData
{
    // 分配内存块，用于存放加密后的数据段
    size_t cipherBufferSize = SecKeyGetBlockSize(_publicKey);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    double totalLength = [plainData length];
    size_t blockSize = cipherBufferSize - 12;
    size_t blockCount = (size_t)ceil(totalLength / blockSize);
    NSMutableData *encryptedData = [NSMutableData data];
    // 分段加密
    for (int i = 0; i < blockCount; i++)
    {
        NSUInteger loc = i * blockSize;
        // 数据段的实际大小。最后一段可能比blockSize小。
        NSUInteger dataSegmentRealSize = MIN(blockSize, [plainData length] - loc);
        // 截取需要加密的数据段
        NSData *dataSegment = [plainData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        OSStatus status = SecKeyEncrypt(_publicKey, kSecPaddingPKCS1, (const uint8_t *)[dataSegment bytes], dataSegmentRealSize, cipherBuffer, &cipherBufferSize);
        if (status == errSecSuccess)
        {
            NSData *encryptedDataSegment = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            // 追加加密后的数据段
            [encryptedData appendData:encryptedDataSegment];
        }
        else
        {
            if (cipherBuffer)
            {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer)
    {
        free(cipherBuffer);
    }
    return encryptedData;
}

//加密
- (NSMutableString *)base64EncryptWithPublicKey:(NSData *)plainData
{
    // 分配内存块，用于存放加密后的数据段
    size_t cipherBufferSize = SecKeyGetBlockSize(_publicKey);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    double totalLength = [plainData length];
    NSUInteger blockSize = cipherBufferSize - 12;
    NSUInteger blockCount = (NSUInteger)ceil(totalLength / blockSize);
    //    NSMutableData *encryptedData = [NSMutableData data];
    NSMutableString *encryptedString = [NSMutableString string];
    // 分段加密
    for (int i = 0; i < blockCount; i++)
    {
        NSUInteger loc = i * blockSize;
        // 数据段的实际大小。最后一段可能比blockSize小。
        NSUInteger dataSegmentRealSize = MIN(blockSize, [plainData length] - loc);
        // 截取需要加密的数据段
        NSData *dataSegment = [plainData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        OSStatus status = SecKeyEncrypt(_publicKey, kSecPaddingPKCS1, (const uint8_t *)[dataSegment bytes], dataSegmentRealSize, cipherBuffer, &cipherBufferSize);
        if (status == errSecSuccess)
        {
            // 追加加密后的数据段
            NSData *encryptedData = [Base64 encodeBytes:(const void *)cipherBuffer length:cipherBufferSize];
            NSString *encryptedStringSegment = [[NSString alloc]initWithData:encryptedData encoding:NSUTF8StringEncoding];
            [encryptedString appendString:encryptedStringSegment];
        }
        else
        {
            if (cipherBuffer)
            {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer)
    {
        free(cipherBuffer);
    }
    return encryptedString;
}

/** Base64编码后的加密字符串
 *
 *
 */
- (NSString *)rsaEncryptString:(NSString *)plainString
{

    NSData *plainData = [plainString dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableString *base64CipherString =  [self base64EncryptWithPublicKey:plainData];

    return base64CipherString;
}

#pragma mark - 解密
- (OSStatus)extractPrivateKeyFromPKCS12File
{
    NSString *pkcsPath = [[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"p12"];
    NSString *pkcsPassword = @"123456";

    return [self extractEveryThingFromPKCS12File:pkcsPath passphrase:pkcsPassword];
}

//获取私钥，密码是你生成私钥的时候生成的
- (OSStatus)extractEveryThingFromPKCS12File:(NSString *)pkcsPath passphrase:(NSString *)pkcsPassword
{
    SecIdentityRef identity;
    SecTrustRef trust;
    OSStatus status = -1;

    if (_privateKey == nil)
    {
        NSData *p12Data = [NSData dataWithContentsOfFile:pkcsPath];
        if (p12Data) {
            CFStringRef password = (__bridge CFStringRef)pkcsPassword;
            const void *keys[] = {
                kSecImportExportPassphrase
            };
            const void *values[] = {
                password
            };
            CFDictionaryRef options = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 1, NULL, NULL);
            CFArrayRef items = CFArrayCreate(kCFAllocatorDefault, NULL, 0, NULL);
            status = SecPKCS12Import((__bridge CFDataRef)p12Data, options, &items);
            if (status == errSecSuccess) {
                CFDictionaryRef identity_trust_dic = CFArrayGetValueAtIndex(items, 0);
                identity = (SecIdentityRef)CFDictionaryGetValue(identity_trust_dic, kSecImportItemIdentity);
                trust = (SecTrustRef)CFDictionaryGetValue(identity_trust_dic, kSecImportItemTrust);
                // certs数组中包含了所有的证书
                CFArrayRef certs = (CFArrayRef)CFDictionaryGetValue(identity_trust_dic, kSecImportItemCertChain);
                if ([(__bridge NSArray *)certs count] && trust && identity)
                {
                    // 如果没有下面一句，自签名证书的评估信任结果永远是kSecTrustResultRecoverableTrustFailure
                    status = SecTrustSetAnchorCertificates(trust, certs);
                    if (status == errSecSuccess)
                    {
                        SecTrustResultType trustResultType;
                        // 通常, 返回的trust result type应为kSecTrustResultUnspecified，如果是，就可以说明签名证书是可信的
                        status = SecTrustEvaluate(trust, &trustResultType);
                        if ((trustResultType == kSecTrustResultUnspecified || trustResultType == kSecTrustResultProceed) && status == errSecSuccess)
                        {
                            // 证书可信，可以提取私钥与公钥，然后可以使用公私钥进行加解密操作
                            status = SecIdentityCopyPrivateKey(identity, &_privateKey);
                            if (status == errSecSuccess && _privateKey)
                            {
                                // 成功提取私钥
                                DLog(@"Get private key successfully~ %@", _privateKey);
                            }
                        }
                    }
                }
                CFRelease(items);
            }
            if (options) {
                CFRelease(options);
            }
        }
    }
    return 0;
}


- (NSMutableData *)decryptWithPrivateKey:(NSData *)cipherData
{
    // 分配内存块，用于存放解密后的数据段
    size_t plainBufferSize = SecKeyGetBlockSize(_privateKey);
    uint8_t *plainBuffer = malloc(plainBufferSize * sizeof(uint8_t));
    // 计算数据段最大长度及数据段的个数
    NSUInteger totalLength = [cipherData length];
    size_t blockSize = plainBufferSize;
    size_t blockCount = (size_t)ceil(totalLength / blockSize);
    NSMutableData *decryptedData = [NSMutableData data];
    // 分段解密
    for (int i = 0; i < blockCount; i++)
    {
        NSUInteger loc = i * blockSize;
        // 数据段的实际大小。最后一段可能比blockSize小。
        NSUInteger dataSegmentRealSize = MIN(blockSize, totalLength - loc);
        // 截取需要解密的数据段
        NSData *dataSegment = [cipherData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        OSStatus status = SecKeyDecrypt(_privateKey, kSecPaddingPKCS1, (const uint8_t *)[dataSegment bytes], dataSegmentRealSize, plainBuffer, &plainBufferSize);
        if (status == errSecSuccess) {
            NSData *decryptedDataSegment = [[NSData alloc] initWithBytes:(const void *)plainBuffer length:plainBufferSize];
            [decryptedData appendData:decryptedDataSegment];
        }
        else
        {
            if (plainBuffer)
            {
                free(plainBuffer);
            }
            return nil;
        }
    }
    if (plainBuffer)
    {
        free(plainBuffer);
    }
    return decryptedData;
}

/** 解密Base64编码的字符串
 *
 *
 *  @return 解密后的字符串
 */
- (NSString *)rsaDecryptBase64String:(NSString *)cipherString
{
    //Base64分段大小
    NSUInteger blockSize = 172;
    //总共的段数
    NSUInteger blockCount = cipherString.length/blockSize;
    NSMutableData *decryptedData = [NSMutableData data];
    for ( NSUInteger i = 0 ; i < blockCount; i ++ )
    {
        //当前分段的Base64编码字符串
        NSString *cipherStringSegment = [cipherString substringWithRange:NSMakeRange( i * blockSize, blockSize)];
        //Base64解码
        NSData *cipherSegmentData = [Base64 decodeString:cipherStringSegment];
        //RSA解密
        NSData *decrytedSegmentData = [self decryptWithPrivateKey:cipherSegmentData];
        //添加解密出的数据
        [decryptedData appendData:decrytedSegmentData];
    }

    if ( decryptedData.length > 0 )
    {
        NSString *plainString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
        return plainString;
    }
    else
    {
        return nil;
    }
}

@end
