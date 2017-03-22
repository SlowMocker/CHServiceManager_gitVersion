//
//  WZSingleCheckViewController.h
//  ServiceManager
//
//  Created by will.wang on 9/29/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "ViewController.h"
#import "WZSingleCheckListView.h"

@class WZSingleCheckViewController;

@protocol WZSingleCheckViewControllerDelegate <NSObject>

@optional
- (void)singleCheckViewController:(WZSingleCheckViewController*)viewController didChecked:(CheckItemModel*)checkedItem;

@end

@interface WZSingleCheckViewController : ViewController
@property(nonatomic, assign)CheckItemModel *checkedItem;
@property(nonatomic, strong)NSArray *checkItemArray;//item:CheckItemModel
@property(nonatomic, assign)id<WZSingleCheckViewControllerDelegate>delegate;
@property(nonatomic, strong)id userInfo;
@property(nonatomic, assign)BOOL addHeaderSearchBar;
@property (nonatomic) UITableViewCellAccessoryType accessoryType;

- (UITableViewCell*)setCell:(UITableViewCell*)cell withData:(CheckItemModel *)cellModel;

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString;

- (NSArray*)filterOutItemsFrom:(NSArray*)items byString:(NSString*)searchString;
@end
