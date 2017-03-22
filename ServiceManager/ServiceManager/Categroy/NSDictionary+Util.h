//
//  NSDictionary+Util.h
//  BaseProject
//
//  Created by wangzhi on 15-1-24.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Util)

//将属性对象转为字典，支持多层
+(NSDictionary*)dictionaryFromPropertyObject:(NSObject*)object;

//object和key都不为nil时，才设置成功，防止系统原方法crash
-(void)setObj:(id)object forKey:(NSObject*)key;

//当key对应的值为nil，或不存在时,返回默认的dftObjIfNil
-(id)objForKey:(NSObject *)key default:(id)dftObjIfNil;

@end
