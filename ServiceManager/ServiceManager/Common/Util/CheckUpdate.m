//
//  CheckUpdate.m
//  BaseProject
//
//  Created by wangzhi on 15-1-22.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "CheckUpdate.h"
#import <AFNetworking/AFNetworking.h>

@implementation CheckUpdate

- (void)checkUpdateWithAppId:(NSString *)appId
{
    //获取当前应用版本号
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    _versionOfCurrent = [[appInfo objectForKey:@"CFBundleVersion"]doubleValue];
    NSString *updateUrlString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appId];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setTimeoutInterval:60];

    //开始检查更新
    if([self.delegate respondsToSelector:@selector(onStartCheckUpdate:)]){
        [self.delegate onStartCheckUpdate:self];
    }

    __block CheckUpdate *weakSelf = self;
    [manager POST:updateUrlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [weakSelf handleForCheckUpdateSucess:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [weakSelf handleForCheckUpdateError:error];
    }];
}

-(void)handleForCheckUpdateSucess:(id)responseObject
{
    NSDictionary *dict = (NSDictionary*)responseObject;
    NSInteger resultCount = [[dict objectForKey:@"resultCount"] integerValue];
    if (resultCount >= 1) {
        NSArray *resultArray = [dict objForKey:@"results"];
        NSDictionary *resultDict = [resultArray objectAtIndex:0];
        NSString *newVersion = [resultDict objForKey:@"version"];
        _versionInAppStore = [newVersion doubleValue];
        _trackViewUrl = [resultDict objForKey:@"trackViewUrl"];

        if (_versionInAppStore > _versionOfCurrent) {
            //有新版本
            if([self.delegate respondsToSelector:@selector(onDidCheckUpdateHasNewVerion:)]){
                [self.delegate onDidCheckUpdateHasNewVerion:self];
            }
        }else {
            //没有新版本
            if([self.delegate respondsToSelector:@selector(onDidCheckUpdateNoNewVerion:)]){
                [self.delegate onDidCheckUpdateNoNewVerion: self];
            }
        }
    }
}

-(void)handleForCheckUpdateError:(NSError*)error
{
    if([self.delegate respondsToSelector:@selector(onDidCheckUpdateHasError:error:)]){
        [self.delegate onDidCheckUpdateHasError:self error:error];
    }
}
@end
