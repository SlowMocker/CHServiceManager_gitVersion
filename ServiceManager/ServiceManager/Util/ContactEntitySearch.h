//
//  ContactEntitySearch.h
//  SmallSecretary1.6
//
//  Created by wangzhi on 14-8-28.
//  Copyright (c) 2014年 pretang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FuzzySearch.h"

@interface ContactEntitySearch : NSObject

/**
 *  从客户列表中模糊搜索客户
 *
 *  @param clientArray ClientEntity 数组
 *  @param keyword      搜索关键字
 *
 *  @return 搜索后的结果
 *  @note 根据备注名、真名、手机号来搜索
 */
- (NSArray *)fuzzySearch:(NSArray *)clientArray keyWord:(NSString *)keyword;
@end
