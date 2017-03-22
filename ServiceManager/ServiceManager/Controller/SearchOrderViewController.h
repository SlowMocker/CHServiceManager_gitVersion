//
//  SearchOrderViewController.h
//  ServiceManager
//
//  Created by will.wang on 15/9/5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ViewController.h"

@interface SearchOrderViewController : ViewController
@property(nonatomic, copy)NSString *searchKeyWord;
@property(nonatomic, assign)kServiceBrandGroup serviceBrandGroup;
@property(nonatomic, assign)kSearchOrderGroupType searchOrderGroupType;
@end
