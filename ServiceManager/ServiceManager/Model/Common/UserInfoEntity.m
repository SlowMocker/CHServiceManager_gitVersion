//
//  UserInfoEntity.m
//  BaseProject
//
//  Created by wangzhi on 15-1-24.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "UserInfoEntity.h"
#import "UserDefaults.h"
#import "ConfigInfoManager.h"

@implementation UserInfoEntity

//单例化
+ (instancetype)sharedInstance
{
    static UserInfoEntity *sUserInfoEntity = nil;
    static dispatch_once_t sOnceToken;
    dispatch_once(&sOnceToken, ^{
        UserInfoEntity *userEntityCache = [UserDefaults userInfo];
        if (nil != userEntityCache) {
            sUserInfoEntity = userEntityCache;
        }else{
            sUserInfoEntity = [[self alloc]init];
        }
    });

    return sUserInfoEntity;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.userRoleType = [aDecoder decodeIntegerForKey:@"userRoleType"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.sexType = [aDecoder decodeIntegerForKey:@"sexType"];
        self.age = [aDecoder decodeFloatForKey:@"age"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.tripleDesKey = [aDecoder decodeObjectForKey:@"tripleDesKey"];
        self.lastLoginDate = [aDecoder decodeDoubleForKey:@"lastLoginDate"];
        self.registerDate = [aDecoder decodeDoubleForKey:@"registerDate"];
        self.serverId = [aDecoder decodeObjectForKey:@"serverId"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.isCreate = [aDecoder decodeBoolForKey:@"isCreate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeInteger:_userRoleType forKey:@"userRoleType"];
    [aCoder encodeObject:_nickName forKey:@"nickName"];
    [aCoder encodeObject:_mobile forKey:@"mobile"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeInteger:_sexType forKey:@"sexType"];
    [aCoder encodeFloat:_age forKey:@"age"];
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_tripleDesKey forKey:@"tripleDesKey"];
    [aCoder encodeObject:_userId forKey:@"userId"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_serverId forKey:@"serverId"];
    [aCoder encodeDouble:_registerDate forKey:@"registerDate"];
    [aCoder encodeDouble:_lastLoginDate forKey:@"lastLoginDate"];
    [aCoder encodeObject:_avatar forKey:@"avatar"];
    [aCoder encodeBool:_isCreate forKey:@"isCreate"];
}

- (void)synchronize
{
    [UserDefaults setUserInfoEntity:self];
}

- (BOOL)isLogined
{
    return [self.token isNotEmpty];
}

- (void)exitUser
{
    self.userId = 0;
//    self.userName;
//    self.password;
//    self.mobile = nil;
//    self.userRoleType = 0
    self.nickName = nil;
    self.avatar = nil;
    self.email = nil;
    self.address = nil;
    self.serverId = nil;
    self.registerDate = 0;
    self.lastLoginDate = 0;
    self.token = nil;
    self.tripleDesKey = nil;
    self.isCreate = NO;
    [self synchronize];
}

@end
