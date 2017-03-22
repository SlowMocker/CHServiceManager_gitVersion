//
//  WZTableSearchView.h
//  ServiceManager
//
//  Created by will.wang on 10/16/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "WZTableView.h"

typedef NSPredicate* (^SearchFilterBlock) (NSString *searchText);

@interface WZTableSearchView : WZTableView
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, assign)BOOL searchInTableView;
@property (nonatomic, strong)NSArray *itemDataArray;
@property (nonatomic, strong)NSArray *searchedItemDataArray;

@property(nonatomic, weak)ViewController *viewController;

@property(nonatomic, strong)SearchFilterBlock filterBlock;
@end
