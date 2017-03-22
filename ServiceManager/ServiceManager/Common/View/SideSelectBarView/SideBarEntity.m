//
//  SideBarEntity.m
//  SmallSecretary2.0
//
//  Created by zhiqiangcao on 14-9-17.
//  Copyright (c) 2014年 pretang. All rights reserved.
//

#import "SideBarEntity.h"

@implementation SideBarEntity

- (NSMutableArray *)nextArray
{
    if (nil == _nextArray)
    {
        _nextArray = [NSMutableArray array];
    }
    return _nextArray;
}

@end
