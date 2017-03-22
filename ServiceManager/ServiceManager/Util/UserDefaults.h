//
//  UserDefaults.h
//  BaseProject
//
//  Created by wangzhi on 15-1-24.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoEntity.h"

#define UserDefaultKeyPushAlias   @"PushAlias"
#define UserDefaultKeyPushDeviceToken   @"PushDeviceToken"
#define UserDefaultKeyUserInfoEntity    @"UserInfoEntity"
#define UserDefaultKeySavePassword      @"SaveUserPassword"
#define UserDefaultKeyHasLoadedMainInfo @"HasLoadedConfigMainInfo"
#define UserDefaultKeyMainInfoUpdateDate    @"MainInfoUpdateDate"
#define UserDefaultKeySubmittedQuestionnaireSurvey @"SubmittedQuestionnaireSurvey"
#define UserDefaultKeyHomeFeatureItem    @"HomeFeatureItem"


@interface UserDefaults : NSObject

+ (instancetype)sharedInstance;

+ (void)saveObject:(NSObject*)object forKey:(NSString*)key;

+ (NSObject*)restoreObjectForKey:(NSString*)key;

//PUSH时用到的deviceToken
+(void)setPushDeviceToken:(NSString*)deviceToken;
+(NSString*)pushDeviceToken;

//PUSH时用到的Alias
+(void)setPushAlias:(NSString*)alias;
+(NSString*)pushAlias;

//登录用户的相关信息
+(void)setUserInfoEntity:(UserInfoEntity*)userInfo;
+(UserInfoEntity*)userInfo;

//主数据上次更新时间
@property(nonatomic, strong)NSDate *mainInfoUpdateDate;

//最近一次参与的问卷调查
@property(nonatomic, copy)NSString *submittedQuestionnaireSurvey;

@end
