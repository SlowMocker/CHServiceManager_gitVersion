//
//  UserInfoEntity.h
//  BaseProject
//
//  Created by wangzhi on 15-1-24.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoEntity : NSObject
@property(nonatomic, copy)NSString *userId;     //注册成功后返回
@property(nonatomic, copy)NSString *userName;   //用户名,不是姓名,目前就是手机号
@property(nonatomic, assign)kUserRoleType userRoleType; //role Type
@property(nonatomic, copy)NSString *mobile;     //手机
@property(nonatomic, copy)NSString *nickName;   //昵称
@property(nonatomic, copy)NSString *avatar;     //头像
@property(nonatomic, copy)NSString *email;          //邮箱
@property(nonatomic, copy)NSString *address;        //地址
@property(nonatomic, assign)kPersonSexType sexType; //性别
@property(nonatomic, assign)CGFloat age;            //年龄
@property(nonatomic, copy)NSString *password;
@property(nonatomic, assign)BOOL isCreate; //1,非自建，2自建

//商户
@property(nonatomic, copy)NSString *serverId;

@property(nonatomic, assign)NSTimeInterval registerDate;
@property(nonatomic, assign)NSTimeInterval lastLoginDate;
@property(nonatomic, copy)NSString *token;      //用户token
@property(nonatomic, copy)NSString *tripleDesKey;   //3DES加密KEY

@property(nonatomic, copy,readonly)NSString *cityCode; //所在城市

+(instancetype)sharedInstance;

//同步、存储用户信息
- (void)synchronize;

//是否已登录
- (BOOL)isLogined;

//退出用户
- (void)exitUser;

@end
