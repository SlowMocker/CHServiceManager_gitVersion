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
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUInteger propsCount;
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
        [dic setObject:value forKey:propName];
    }
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
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self dictionaryFromPropertyObject:obj];
}

-(void)setObj:(id)object forKey:(NSObject*)key
{
    if (nil != object && nil != key) {
        [self setObj:object forKey:key];
    }
}

-(id)objForKey:(NSObject *)key default:(id)dftObjIfNil
{
    id obj = [self objectForKey:key];
    return (nil != obj) ? obj : dftObjIfNil;
}

@end
