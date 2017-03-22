//
//  UserInfoEntity.h
//  BaseProject
//
//  Created by wangzhi on 15-1-24.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoEntity : NSObject
@property(nonatomic, strong)NSString *name;     //姓名
@property(nonatomic, strong)NSString *nickName; //昵称
@property(nonatomic, strong)NSString *phoneNumber;  //手机号
@property(nonatomic, strong)NSString *email;    //邮箱
@property(nonatomic, strong)NSString *address;  //地址
@property(nonatomic, assign)kPersonSexType sexType; //性别
@end
