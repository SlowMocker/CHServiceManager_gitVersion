//
//  MagicalRecordHelper.m
//  ServiceManager
//
//  Created by will.wang on 15/9/18.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "MagicalRecordHelper.h"

@implementation MagicalRecordHelper

+ (void)setup
{
    [MagicalRecord enableShorthandMethods];

    [MagicalRecord setupCoreDataStack];
}

+ (void)cleanup
{
    [MagicalRecord setupCoreDataStack];
}

@end
