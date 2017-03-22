//
//  NetClientManager.h
//  BaseProject
//
//  Created by wangzhi on 15-1-23.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface AFTextRequestSerializer : AFHTTPRequestSerializer

@end

@interface AFTextResponseSerializer :AFHTTPResponseSerializer
@property(nonatomic, assign)BOOL isPlainData; //No for Des Encrypt, YES for Plain
@end

//Http返回
@interface HttpResponseData : NSObject
@property(nonatomic, assign)NSInteger resultCode;
@property(nonatomic, copy)NSString *resultInfo;
@property(nonatomic, strong)id resultData;
@property(nonatomic, strong)PageInfo *pageInfo; //如果带分页，则有效,否则不使用
@end

//http 请求类型
typedef NS_ENUM(NSInteger, kHttpRequestType)
{
    kHttpRequestTypeGet = 0,
    kHttpRequestTypePost = 1
};

//网络请求返回BLOCK
typedef void (^RequestCallBackBlock)(NSError *error, HttpResponseData* responseData);

typedef void (^RequestCallBackBlockV2)(NSError *error, HttpResponseData* responseData, id extData);

@interface NetClientManager : NSObject

@property(nonatomic, copy)NSString *tripleDesKey;

//additonalHeader 为针对特定请求自添加的头域
- (AFHTTPSessionManager*)get:(NSString*)relativePath params:(NSDictionary *)params additionalHeader:(NSDictionary*)additonalHeader response:(RequestCallBackBlock)requestCallBackBlock;

//additonalHeader 为针对特定请求自添加的头域
- (AFHTTPSessionManager*)post:(NSString*)relativePath params:(NSDictionary *)params additionalHeader:(NSDictionary*)additonalHeader response:(RequestCallBackBlock)requestCallBackBlock;

//上传图片
- (void)upload:(NSString*)relativePath imageData:(NSData*)imageData response:(RequestCallBackBlock)requestCallBackBlock;

//absoluteGetUrl: 默认服务器之外的地址GET请求
+ (void)getAbsoluteGetUrl:(NSString *)absoluteGetUrl response:(RequestCallBackBlock)requestCallBackBlock;

//it's reachable if return nil
+ (NSString*)currentNetworkReachability;

//monitor network
+ (void)startMonitorNetworkReachability;

@end
