//
//  ContactEntitySearch.m
//  SmallSecretary1.6
//
//  Created by wangzhi on 14-8-28.
//  Copyright (c) 2014年 pretang. All rights reserved.
//

#import "ContactEntitySearch.h"
#import "AddressBookClientMgr.h"

typedef NS_ENUM(NSInteger, kCompareBaseType)
{
    kCompareBaseTypeName,
    kCompareBaseTypeNickName,
    kCompareBaseTypePhone
};

@interface ContactEntitySearch()<FuzzySearchDelegate>
{
    NSMutableSet *_searchedSet;
    kCompareBaseType _compareType;
}
@end

@implementation ContactEntitySearch

- (instancetype)init
{
    self = [super init];
    if (self) {
        _searchedSet = [[NSMutableSet alloc]init];
    }
    return self;
}

- (NSArray *)fuzzySearch:(NSArray *)clientArray keyWord:(NSString *)keyword
{
    FuzzySearch *search = [[FuzzySearch alloc]init];
    search.delegate = self;

    for (kCompareBaseType indexType = kCompareBaseTypeName; indexType <= kCompareBaseTypePhone; indexType++) {
        _compareType = indexType;
        NSArray *searchs = [search fuzzySearch:clientArray keyStr:keyword];
        [_searchedSet addObjectsFromArray:searchs];
    }
    return [_searchedSet allObjects];
}

#pragma mark - FuzzySearchDelegate

- (NSString *)fuzzySearch:(id)obj stringOfCompare:(NSObject *)object
{
    AddressBookClient *client = (AddressBookClient *)object;

    switch (_compareType) {
        case kCompareBaseTypeName:
            return client.name;
        case kCompareBaseTypeNickName:
            return client.nickName;
        case kCompareBaseTypePhone:
            return client.phone;
        default:
            return nil;
    }
}

@end
