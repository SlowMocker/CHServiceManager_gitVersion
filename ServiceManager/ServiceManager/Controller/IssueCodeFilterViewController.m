//
//  IssueCodeFilterViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/27.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "IssueCodeFilterViewController.h"

@interface IssueCodeFilterViewController ()

@end

@implementation IssueCodeFilterViewController

- (void)viewDidLoad {
    self.checkItemArray = [self readIssueCodeCheckItems];
    self.addHeaderSearchBar = YES;
    [super viewDidLoad];
}

- (NSArray *)readIssueCodeCheckItems
{
    NSArray *checkItems = [self.configInfoMgr letv_issueCodesOfCategory:nil brandId:nil];
    checkItems = [Util convertConfigItemInfoArrayToCheckItemModelArray:checkItems];

    return  checkItems;
}

- (UITableViewCell*)setCell:(UITableViewCell*)cell withData:(CheckItemModel*)cellModel
{
    [super setCell:cell withData:cellModel];
    
    NSMutableArray *attrArray = [NSMutableArray new];
    
    AttributeStringAttrs *valueItem = [AttributeStringAttrs new];
    valueItem.text = cellModel.value;
    [attrArray addObject:valueItem];

    AttributeStringAttrs *keyItem = [AttributeStringAttrs new];
    keyItem.text = [NSString stringWithFormat:@" (%@)", cellModel.key];
    keyItem.textColor = kColorDefaultOrange;
    keyItem.font = [UIFont italicSystemFontOfSize:14];
    [attrArray addObject:keyItem];
    
    cell.textLabel.attributedText = [NSString makeAttrString:@[valueItem, keyItem]];

    return cell;
}

- (NSArray*)filterOutItemsFrom:(NSArray*)items byString:(NSString*)searchString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.value CONTAINS[c] %@ OR SELF.key CONTAINS[c] %@ ", searchString, searchString];
    return [items filteredArrayUsingPredicate:predicate];
}

@end
