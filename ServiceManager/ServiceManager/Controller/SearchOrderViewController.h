//
//  SearchOrderViewController.h
//  ServiceManager
//
//  Created by will.wang on 15/9/5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ViewController.h"

@interface SearchOrderViewController : ViewController
//@property(nonatomic, copy)NSString *searchKeyWord;
@property(nonatomic, assign)kServiceBrandGroup serviceBrandGroup;/**< 搜索品牌 */
@property(nonatomic, assign)kSearchOrderGroupType searchOrderGroupType;/**< 搜索工单类型: 所有、已结、未结 */
@end
