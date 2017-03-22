//
//  NSObject+Util.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-4.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "NSObject+Util.h"
#import <objc/runtime.h>

@implementation NSObject (Observer)

-(void)postNotification:(NSString*)notification
{
    [[NSNotificationCenter defaultCenter]postNotificationName:notification object:self];
}

-(void)postNotification:(NSString*)notification object:(NSObject*)object userInfo:(NSDictionary*)userInfo
{
    [[NSNotificationCenter defaultCenter]postNotificationName:notification object:object userInfo:userInfo];
}

-(void)doObserveNotification:(NSString*)notification selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:selector name:notification object:nil];
}

-(void)undoObserveNotification:(NSString*)notification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:notification object:nil];
}

- (instancetype)initWithDictionary:(NSDictionary*)dic
{
    self = [self init];
    if (nil != dic && [dic isKindOfClass:[NSDictionary class]]) {
        [self setPropertiesWithDic:dic];
    }
    return self;
}

- (instancetype)setPropertiesWithDic:(NSDictionary *)info
{
    NSArray *objPropertList = [self propertyList];
    NSArray *dicAllKeys = [info allKeys];

    [objPropertList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = [self replaceKeyIfNeed:obj];
        if ([dicAllKeys containsObject:key]) {
            NSObject *value = [info objectForKey:key];
            if (nil != value && ![value isKindOfClass:[NSNull class]] && nil != key ) {
                [self setValue:value forKey:obj];
            }
        }
    }];
    return self;
}

- (NSString*)replaceKeyIfNeed:(NSString*)key
{
    if ([key isEqualToString:@"Id"]) {
        return @"id";
    }
    if ([key isEqualToString:@"Description"]) {
        return @"description";
    }
    if ([key isEqualToString:@"desContent"]) {
        return @"description";
    }
    return key;
}

- (NSMutableArray *)propertyList
{
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [array addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return array;
}

- (BOOL)isNotNullObject
{
    return ![self isKindOfClass:[NSNull class]];
}

@end
