//
//  QuickFuzzySearch.h
//  FUZZYTEST
//
//  Created by will.wang on 16/8/9.
//  Copyright © 2016年 will.wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuickFuzzySearch : NSObject

/**
 *  模糊查询，支持拼音首字母查询、被包含查询。
 *
 *  @param dataArray NSString array
 *  @param key       string keyword
 *
 *  @return matched string array
 */
+ (NSArray*)userFuzzySearch:(NSArray *)dataArray keyStr:(NSString *)key;

@end
