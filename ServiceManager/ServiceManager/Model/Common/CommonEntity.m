//
//  CommonEntity.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-4.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "CommonEntity.h"

@implementation KeyValueModel
+(instancetype)modelWithValue:(NSString*)value forKey:(NSString*)key
{
    KeyValueModel *model = [KeyValueModel new];
    model.value = value;
    model.key = key;
    return model;
}
@end

@implementation CheckItemModel
+(instancetype)modelWithValue:(NSString*)value forKey:(NSString*)key
{
    CheckItemModel *model = [CheckItemModel new];
    model.value = value;
    model.key = key;
    return model;
}
- (BOOL)isEqual:(id)object
{
    ReturnIf(![object isKindOfClass:[self class]])NO;

    CheckItemModel *obj = (CheckItemModel*)object;
    do {
        BreakIf(![obj.key isEqualToString:_key]);
        BreakIf(![obj.value isEqualToString:_value]);
        return YES;
    } while (NO);
    return NO;
}

- (NSUInteger)hash
{
    return [_key hash] + [_value hash];
}
@end

@implementation TxtImgModel
@end

@implementation TxtTxtModel
@end

@implementation PageInfo
@end

@implementation ImageTextButtonData
@end