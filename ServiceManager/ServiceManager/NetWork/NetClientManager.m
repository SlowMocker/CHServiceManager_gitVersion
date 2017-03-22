//
//  NetClientManager.m
//  BaseProject
//
//  Created by wangzhi on 15-1-23.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "NetClientManager.h"
#import "TripleDES.h"
#import "RSAForiOS.h"
#import "AppDelegate.h"

//服务端地址
static NSString *const sServerBaseUrl = kServerBaseUrl;
static AFNetworkReachabilityStatus _netStatus = AFNetworkReachabilityStatusUnknown;

#pragma mark - HttpResponseData

@implementation HttpResponseData
@end

#pragma mark - NetClientManager

@interface NetClientManager()
@property(atomic, assign)BOOL isAlerting; //弹框显示中
@end

@implementation NetClientManager

-(NSString*)desEncryptInputParams:(NSDictionary*)inputParams
{
    ReturnIf(nil == inputParams)nil;
    
    NSString *inputJsonStr = [NSString jsonStringWithDictionary:inputParams];
    
    return [inputJsonStr desEncryptWithDefaultKey];
}

+ (HttpResponseData*)parserResponseData:(NSObject*)retJsonData
{
    HttpResponseData *response = [[HttpResponseData alloc]init];

    if ([retJsonData isKindOfClass:[NSString class]]) {
        NSString *retJsonDataStr = (NSString*)retJsonData;
        ReturnIf([Util isEmptyString:retJsonDataStr])response;

        NSDictionary *retJsonDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithString:retJsonDataStr] options:NSJSONReadingAllowFragments error:nil];
        NSMutableDictionary *responsePlain = [NSMutableDictionary dictionaryWithDictionary:retJsonDic];
        if ([responsePlain isKindOfClass:[NSDictionary class]]) {
            response.resultCode = [responsePlain integerForKey:@"code"];
            response.resultInfo = [responsePlain stringForKey:@"msg"];
            response.resultData = [responsePlain objectForKey:@"data"];
        }
        return response;
    }else if([retJsonData isKindOfClass:[NSDictionary class]]){
        NSDictionary *retJsonDic = (NSDictionary*)retJsonData;
        response.resultCode = [retJsonDic integerForKey:@"code"];
        response.resultInfo = [retJsonDic stringForKey:@"msg"];
        response.resultData = [retJsonDic objectForKey:@"data"];
        return response;
    }
    return nil;
}

#pragma mark - Get Request

- (AFHTTPSessionManager*)get:(NSString*)relativePath params:(NSDictionary *)params additionalHeader:(NSDictionary*)additonalHeader response:(RequestCallBackBlock)requestCallBackBlock
{
    AFHTTPSessionManager *manager = [self makeSessionManager:additonalHeader];
    
    NSString *netError = [[self class]currentNetworkReachability];
    if ((nil != netError)) {
        HttpResponseData *resData = [HttpResponseData new];
        resData.resultCode = kHttpReturnCodeErrorNet;
        resData.resultInfo = getErrorCodeDescription(resData.resultCode);
        MAIN(^{
            requestCallBackBlock(nil, resData);
        });
        return manager;
    }

    NSString *paramsStr = [self desEncryptInputParams:params];

    if (![Util isEmptyString:paramsStr]) {
        if (![relativePath hasSuffix:@"/"]) {
            relativePath = [NSString stringWithFormat:@"%@/", relativePath];
        }
        relativePath = [NSString stringWithFormat:@"%@%@", relativePath, paramsStr];
    }
    [manager GET:relativePath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"[Get %@ Success]:%@", relativePath, responseObject);
        HttpResponseData *response = [[self class] parserResponseData:responseObject];
        [self handleSomeErrorIfNeed:response];
        requestCallBackBlock(nil, response);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"[Request Failure]:%@]\nError:%@, %@", relativePath, @(error.code), error.localizedDescription);
        HttpResponseData *response = [[HttpResponseData alloc]init];
        response.resultCode = kHttpReturnCodeErrorNet;
        response.resultInfo = error.localizedDescription;
        requestCallBackBlock(error, response);
    }];
    
    return manager;
}


- (AFHTTPSessionManager*)post:(NSString*)relativePath params:(NSDictionary *)params additionalHeader:(NSDictionary*)additonalHeader response:(RequestCallBackBlock)requestCallBackBlock
{
    AFHTTPSessionManager *manager = [self makeSessionManager:additonalHeader];
    DLog(@"[请求：%@", relativePath);

    NSString *netError = [[self class]currentNetworkReachability];
    if ((nil != netError)) {
        HttpResponseData *resData = [HttpResponseData new];
        resData.resultCode = kHttpReturnCodeErrorNet;
        resData.resultInfo = getErrorCodeDescription(resData.resultCode);
        MAIN(^{
            requestCallBackBlock(nil, resData);
        });
        return manager;
    }

    NSString *paramsStr = [self desEncryptInputParams:params];

    [manager POST:relativePath parameters:paramsStr success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"[请求返回：%@", relativePath);
        id responsePlain = [self decryptResponseDataIfNeed:responseObject];
        HttpResponseData *response = [[self class] parserResponseData:responsePlain];
        [self handleSomeErrorIfNeed:response];
        requestCallBackBlock(nil, response);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"\n[请求失败:%@]return:%@, %@, RESON：%@", relativePath, @(error.code), error.localizedDescription,error.localizedFailureReason);
        requestCallBackBlock(error, nil);
    }];
    
    return manager;
}

+ (void)getAbsoluteGetUrl:(NSString *)getUrl response:(RequestCallBackBlock)requestCallBackBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setTimeoutInterval:60];

    [manager GET:getUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HttpResponseData *response = [self parserResponseData:responseObject];
        requestCallBackBlock(nil, response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        requestCallBackBlock(error, nil);
    }];
}

+ (NSString*)currentNetworkReachability
{
    NSString *netStatus;

    AFNetworkReachabilityManager *reachabilityMgr = [AFNetworkReachabilityManager sharedManager];

    switch (reachabilityMgr.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusNotReachable:
            netStatus = @"连接服务器失败";
            break;
        default:
            break;
    }
    return netStatus;
}

+ (void)startMonitorNetworkReachability
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DLog(@"network status changed: %@", @(status));
        if (_netStatus != status) { //changed
            _netStatus = status;
            NSString *errStr = [[self class]currentNetworkReachability];
            if (errStr) {
                MAIN(^{
                    [Util showTopAlertView:errStr];
                });
            }

            //1, WWAN下，当且仅当没主数据时，去下载
            if (_netStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
                [[ConfigInfoManager sharedInstance]loadConfigInfosIfNoData];
            }else if (_netStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
                //2，WIFI下时，没主数据时，去下载，更新时间到时去更新
                [[ConfigInfoManager sharedInstance]updateConfigInfosIfNeed];
            }
        }
    }];
}

- (void)upload:(NSString*)relativePath imageData:(NSData*)imageData response:(RequestCallBackBlock)requestCallBackBlock
{
    AFHTTPSessionManager *manager = [self makeSessionManager:nil];

    NSMutableURLRequest *request = [self makeUploadImageRequest:imageData uploadTo:relativePath];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (nil == error) {
            id responsePlain = [self decryptResponseDataIfNeed:responseObject];
            HttpResponseData *response = [[self class] parserResponseData:responsePlain];
            [self handleSomeErrorIfNeed:response];
            requestCallBackBlock(nil, response);
        }else {
            DLog(@"\n[API:%@]return:%@, %@", relativePath, @(error.code), error.localizedDescription);
            requestCallBackBlock(error, nil);
        }
    }];
    [task resume];
}

- (NSMutableURLRequest*)makeUploadImageRequest:(NSData*)imageData uploadTo:(NSString*)uploadPath
{
    NSString *uploadFullPath = [NSString stringWithFormat:@"%@%@",kServerBaseUrl, uploadPath];

    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uploadFullPath]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];

    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];

    //添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];

    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:imageData];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];

    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];

    //设置Content-Length
    NSInteger contentLength = [myRequestData length];
    [request setValue:[NSString stringWithFormat:@"%@", @(contentLength)] forHTTPHeaderField:@"Content-Length"];

    //设置http body
    [request setHTTPBody:myRequestData];

    //http method
    [request setHTTPMethod:@"POST"];

    return request;
}

-(id)decryptResponseDataIfNeed:(id)responseObject
{
    id responsePlain = (NSDictionary*)responseObject;

    do {
        BOOL bContinue = NO;
        bContinue = [responseObject isKindOfClass:[NSDictionary class]];
        BreakIf(!bContinue);

        bContinue = [[responseObject allKeys]count] == 1;
        BreakIf(!bContinue);

        NSString *onlyKey = [[responseObject allKeys]lastObject];
        NSString *responseStr = [responseObject objForKey:onlyKey];

        bContinue = [responseStr isNotEmpty];
        BreakIf(!bContinue);

        NSString *resPlainStr;

        if (NSOrderedSame == [onlyKey caseInsensitiveCompare:@"Triple"]) {
            //说明是3des加密, 解密吧
            resPlainStr = [TripleDES TripleDES:responseStr key:self.tripleDesKey encryptOrDecrypt:kCCDecrypt];
        }else if (NSOrderedSame == [onlyKey caseInsensitiveCompare:@"RSA"]){
            //说明是RSA加密, 解密吧
            resPlainStr = [[RSAForiOS sharedInstance]rsaDecryptBase64String:responseStr];
        }else {
            //不支持的格式
            BreakIf(YES);
        }

        //还原为Dic
        NSData *resData = [resPlainStr dataUsingEncoding:NSUTF8StringEncoding];
        responsePlain = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    } while (0);
    return responsePlain;
}


- (NSURLSessionConfiguration*)configSessionConfiguration:(NSDictionary*)moreHeaders
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

    //设置我们的缓存大小 其中内存缓存大小设置10M  磁盘缓存5M
    NSURLCache *cache = [[NSURLCache alloc]initWithMemoryCapacity:kNetWorkDataMemoryCache
                                                     diskCapacity:kNetWorkDataDiskCache
                                                         diskPath:[NSString cachePath]];
    [config setURLCache:cache];

    [config setRequestCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];

    [config setTimeoutIntervalForRequest:kNetWorkRequestTimeOut];
    [config setTimeoutIntervalForResource:kNetWorkRequestTimeOut];

    //设置头
    NSDictionary *baseHeaders = [self getBaseHttpHeaders];
    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]initWithDictionary:baseHeaders];
    [headerDic addEntriesFromDictionary:moreHeaders];
    [config setHTTPAdditionalHeaders:headerDic];

    return config;
}

//moreHeaders 为自添加的头域
-(AFHTTPSessionManager*)makeSessionManager:(NSDictionary*)moreHeaders
{
    NSURL *baseUrl = [NSURL URLWithString:sServerBaseUrl];
    NSURLSessionConfiguration *config = [self configSessionConfiguration:moreHeaders];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:baseUrl sessionConfiguration:config];

    AFTextRequestSerializer *requestSerializer = [AFTextRequestSerializer serializer];
    AFTextResponseSerializer *responseSerializer = [AFTextResponseSerializer serializer];

    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = responseSerializer;

    return manager;
}

#pragma mark - 配置Header域基础项

-(NSDictionary*)getBaseHttpHeaders
{
    NSMutableDictionary *baseHeaders = [[NSMutableDictionary alloc]init];

    //系统名称
    NSString *osName = @"IOS";
    [baseHeaders setObject:osName forKey:ksOsName];

    //系统版本
    NSString *systemVersion = [[UIDevice currentDevice]systemVersion];
    [baseHeaders setObject:systemVersion forKey:ksSystemVersion];

    //App 版本号
    [baseHeaders setObject:[NSString appVersion] forKey:@"appVersion"];

    //App bundle Id
    [baseHeaders setObject:[NSString appBundleId] forKey:@"appBundle"];

    //add user token if logined
    UserInfoEntity *user = [UserInfoEntity sharedInstance];
    if ([user isLogined] && [user.token isNotEmpty]) {
        [baseHeaders setObject:user.token forKey:@"token"];
        [baseHeaders setObject:user.userName forKey:@"userid"];
    }

    //Push Device Token
    if (![Util isEmptyString:[UserDefaults pushDeviceToken]]) {
        [baseHeaders setObject:[UserDefaults pushDeviceToken] forKey:@"appPushDeviceToken"];
    }

    //city code
    if ([user.cityCode isNotEmpty]) {
        [baseHeaders setObject:user.cityCode forKey:@"cityCode"];
    }
    return baseHeaders;
}

- (void)handleSomeErrorIfNeed:(HttpResponseData*)response
{
    switch (response.resultCode) {
        case kHttpReturnCodeTokenIsInvalid:
        {
            if (!self.isAlerting) {
                self.isAlerting = YES;
                [Util showAlertView:nil message:@"您已被挤下线或连接已失效，请重新登录" okAction:^{
                    self.isAlerting = NO;
                    [Util logoutLocalUser];
                    [kAppDelegate unbindAliasForPush];
                    [Util startLoginViewController];
                }];
            }
        }
            break;
        default:
            break;
    }
}

@end

#pragma mark - AFTextRequestSerializer

@implementation AFTextRequestSerializer

+ (instancetype)serializer {
    return [[self alloc]init];
}

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
withParameters:(id)parameters
error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
        return [super requestBySerializingRequest:request withParameters:parameters error:error];
    }
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if (parameters) {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }

        [mutableRequest setHTTPBody:[NSData dataWithString:parameters]];
    }
    
    return mutableRequest;
}

@end

#pragma mark - AFTextResponseSerializer

@implementation AFTextResponseSerializer

+ (instancetype)serializer {
    AFTextResponseSerializer *serializer = [[self alloc] init];
    return serializer;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/json", @"text/json",@"text/plain",@"text/javascript", nil];
    
    return self;
}

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (!error || NetClientAFErrorOrUnderlyingErrorHasCodeInDomain(*error, NSURLErrorCannotDecodeContentData, AFURLResponseSerializationErrorDomain)) {
            return nil;
        }
    }
    if (data.length > 0) {
        NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (!self.isPlainData) {
            return [dataStr desDecryptWithDefaultKey];
        }else {
            return [dataStr decodeFromPercentEscapeString];
        }
    }else {
        return nil;
    }
}

static BOOL NetClientAFErrorOrUnderlyingErrorHasCodeInDomain(NSError *error, NSInteger code, NSString *domain)
{
    if ([error.domain isEqualToString:domain] && error.code == code) {
        return YES;
    } else if (error.userInfo[NSUnderlyingErrorKey]) {
        return NetClientAFErrorOrUnderlyingErrorHasCodeInDomain(error.userInfo[NSUnderlyingErrorKey], code, domain);
    }
    
    return NO;
}
@end
