//
//  UserDefaults.m
//  BaseProject
//
//  Created by wangzhi on 15-1-24.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults

+ (instancetype)sharedInstance
{
    static UserDefaults *sUserDefaults = nil;
    static dispatch_once_t sOnceToken;
    dispatch_once(&sOnceToken, ^{
        sUserDefaults = [[UserDefaults alloc]init];
    });
    return sUserDefaults;
}

+(void)saveObject:(NSObject*)object forKey:(NSString*)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (nil != object) {
        [userDefaults setObject:object forKey:key];
    }else {
        [userDefaults removeObjectForKey:key];
    }

    [userDefaults synchronize];
}

+(NSObject*)restoreObjectForKey:(NSString*)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+(void)setPushDeviceToken:(NSString*)deviceToken
{
    [[self class]saveObject:deviceToken forKey:UserDefaultKeyPushDeviceToken];
}

+ (NSString*)pushDeviceToken
{
    return (NSString*)[[self class]restoreObjectForKey:UserDefaultKeyPushDeviceToken];
}

+(void)setPushAlias:(NSString*)alias
{
    [[self class]saveObject:alias forKey:UserDefaultKeyPushAlias];
}

+(NSString*)pushAlias
{
    return (NSString*)[[self class]restoreObjectForKey:UserDefaultKeyPushAlias];
}

+ (void)setUserInfoEntity:(UserInfoEntity*)userInfo
{
    NSData *userData = nil;

    if (nil != userInfo) {
        userData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    }
    [[self class]saveObject:userData forKey:UserDefaultKeyUserInfoEntity];
}

+ (UserInfoEntity*)userInfo
{
    NSData *userData = (NSData*)[[self class]restoreObjectForKey:UserDefaultKeyUserInfoEntity];
    if (nil != userData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
    return nil;
}

- (void)setMainInfoUpdateDate:(NSDate *)mainInfoUpdateDate
{
    [[self class]saveObject:mainInfoUpdateDate forKey:UserDefaultKeyMainInfoUpdateDate];
}

- (NSDate*)mainInfoUpdateDate
{
    return (NSDate*)[[self class]restoreObjectForKey:UserDefaultKeyMainInfoUpdateDate];
}

- (void)setSubmittedQuestionnaireSurvey:(NSString*)surveryId{
    [[self class]saveObject:surveryId forKey:UserDefaultKeySubmittedQuestionnaireSurvey];
}

- (NSString*)submittedQuestionnaireSurvey{
    return (NSString*)[[self class]restoreObjectForKey:UserDefaultKeySubmittedQuestionnaireSurvey];
}

@end
