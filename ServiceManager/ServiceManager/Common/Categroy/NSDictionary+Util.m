//
//  NSDictionary+Util.m
//  BaseProject
//
//  Created by wangzhi on 15-1-24.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "NSDictionary+Util.h"
#import <objc/runtime.h>

@implementation NSDictionary (Util)

+ (NSDictionary*)dictionaryFromPropertyObject:(NSObject*)obj
{
    if (nil == obj) {
        return nil;
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);

    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];

        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil){
            value = [NSNull null];
        }else{
            value = [self getObjectInternal:value];
        }

        if ([propName isEqualToString:@"Description"]) {
            propName = @"description";
        }else if([propName isEqualToString:@"Id"]) {
            propName = @"id";
        }
        [dic setObj:value forKey:propName];
    }
    return dic;
}

+(NSDictionary*)dictionaryWithJsonString:(NSString*)jsonString
{
    NSData *data = [NSData dataWithString:jsonString];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return dic;
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }

    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }

    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObj:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self dictionaryFromPropertyObject:obj];
}

-(id)objForKey:(NSObject *)key
{
    return [self sam_safeObjectForKey:key];
}

-(id)objForKey:(NSObject *)key default:(id)dftObjIfNil
{
    id obj = [self objectForKey:key];
    return (nil != obj) ? obj : dftObjIfNil;
}

-(NSInteger)integerForKey:(NSObject*)key
{
    NSInteger intValue = 0;

    if (nil != key) {
        id object = [self sam_safeObjectForKey:key];
        intValue = [object integerValue];
    }
    return intValue;
}

- (CGFloat)floatForKey:(NSObject*)key
{
    CGFloat floatValue = 0.0;

    if (nil != key) {
        id object = [self sam_safeObjectForKey:key];
        floatValue = [object floatValue];
    }
    return floatValue;
}

- (double)doubleForKey:(NSObject*)key
{
    CGFloat doubleValue = 0.0;

    if (nil != key) {
        id object = [self sam_safeObjectForKey:key];
        doubleValue = [object doubleValue];
    }
    return doubleValue;
}

-(BOOL)boolForKey:(NSObject*)key
{
    BOOL boolValue = NO;

    if (nil != key) {
        id object = [self sam_safeObjectForKey:key];
        if ([object isKindOfClass:[NSString class]]) {
            NSString *strObj = (NSString*)object;
            if ((NSOrderedSame == [strObj caseInsensitiveCompare:ksTrue])
                ||(NSOrderedSame == [strObj caseInsensitiveCompare:ksYes])
                ||(NSOrderedSame == [strObj caseInsensitiveCompare:@"1"])) {
                boolValue = YES;
            }
        }else if ([object isKindOfClass:[NSNumber class]]){
            NSNumber *numObj = (NSNumber*)object;
            boolValue = [numObj boolValue];
        }
    }
    return boolValue;
}

-(NSString*)stringForKey:(NSObject*)key
{
    return [self sam_safeObjectForKey:key];
}

-(BOOL)containsKey:(NSObject*)key
{
    return [[self allKeys]containsObject:key];
}

- (id)sam_safeObjectForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == [NSNull null]) {
        return nil;
    }
    return object;
}

@end

@implementation NSMutableDictionary (Util)

- (void)setObj:(id)object forKey:(id <NSCopying>)aKey
{
    if (nil != object && nil != aKey) {
        [self setObject:object forKey:aKey];
    }
}
@end
