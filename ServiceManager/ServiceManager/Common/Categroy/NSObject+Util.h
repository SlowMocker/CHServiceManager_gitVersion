//
//  NSObject+Util.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-4.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

//自定义通知定义在 ConstString.h 中

@interface NSObject (Observer)

//发通知
-(void)postNotification:(NSString*)notification;
-(void)postNotification:(NSString*)notification object:(NSObject*)object userInfo:(NSDictionary*)userInfo;

//观察通知
-(void)doObserveNotification:(NSString*)notification selector:(SEL)selector;

//撤销观察通知
-(void)undoObserveNotification:(NSString*)notification;

//用同名key的字典初始化属性
- (instancetype)setPropertiesWithDic:(NSDictionary *)info;

//用同名key的字典初始化属性
- (instancetype)initWithDictionary:(NSDictionary*)dic;

//是否不是空对象
- (BOOL)isNotNullObject;

@end
