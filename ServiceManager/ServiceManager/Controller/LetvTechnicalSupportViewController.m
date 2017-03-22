//
//  LetvTechnicalSupportViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/16.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvTechnicalSupportViewController.h"
#import "LetvTecSupportOrderListViewDelegateIMP.h"

@implementation LetvTechnicalSupportViewController

- (TecSupportOrderListViewDelegateIMP*)getOrderListViewDelegateIMP
{
    TecSupportOrderListViewDelegateIMP *delegate = [[LetvTecSupportOrderListViewDelegateIMP alloc]init];
    return delegate;
}

@end
