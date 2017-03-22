//
//  ViewController.m
//  BaseProject
//
//  Created by wangzhi on 15-1-12.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "HttpClientManager.h"
#import "TripleDES.h"
#import "RSAForiOS.h"

@interface ViewController ()

@end

@implementation ViewController

- (HttpClientManager*)httpClient
{
    if (nil == _httpClient) {
        _httpClient = [HttpClientManager sharedInstance];
    }
    return _httpClient;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self testApi];

    [self des3test];
}

- (void)des3test
{
    NSString *desKey = @"0123456789abcdef01234567";

    NSString *plain = @"xhhehe测试";

    NSString *enCode = [TripleDES TripleDES:plain key:desKey encryptOrDecrypt:kCCEncrypt];
    NSLog(@"加密: %@", enCode);

    enCode = @"D1jV0zyvBwWVpZ9xfzvwZA==";
    NSString *deCode = [TripleDES TripleDES:enCode key:desKey encryptOrDecrypt:kCCDecrypt];
    NSLog(@"解密: %@", deCode);
}


- (void)testApi
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

    NSString *rsaParam = [[RSAForiOS sharedInstance]rsaEncryptString:@"你好，中国"];
    DLog(@"原文: 你好，中国\n RSA后：%@", rsaParam);
    [dic setObject:rsaParam forKey:@"name"];
    [self.httpClient testWithParm:dic response:^(NSError *error, id responseData) {
        
        NSLog(@"%@", responseData);
    }];

    rsaParam = [[RSAForiOS sharedInstance]rsaEncryptString:@"你好，美国"];
     DLog(@"原文: 你好，美国\n RSA后：%@", rsaParam);
    [dic setObject:rsaParam forKey:@"name"];
    [self.httpClient test1WithParm:dic response:^(NSError *error, id responseData) {
        NSLog(@"%@", responseData);
    }];

    rsaParam = [[RSAForiOS sharedInstance]rsaEncryptString:@"你好，德国"];
     DLog(@"原文: 你好，德国\n RSA后：%@", rsaParam);
    [dic setObject:rsaParam forKey:@"name"];
    [self.httpClient testWithParm:dic response:^(NSError *error, id responseData) {
        NSLog(@"%@", responseData);
    }];
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
