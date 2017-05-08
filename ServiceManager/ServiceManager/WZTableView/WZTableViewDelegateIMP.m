//
//  WZTableViewDelegateIMP.m
//  ServiceManager
//
//  Created by will.wang on 15/8/28.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZTableViewDelegateIMP.h"

static NSString *sTableViewCell = @"sTableViewCell";

@interface WZTableViewDelegateIMP()

@property(nonatomic, strong)UITableViewCell *protypeCell;

@end

@implementation WZTableViewDelegateIMP

- (HttpClientManager *) httpClient {
    if (nil == _httpClient) {
        _httpClient = [HttpClientManager sharedInstance];
    }
    return _httpClient;
}

- (UserInfoEntity *) user {
    if (nil == _user) {
        _user = [UserInfoEntity sharedInstance];
    }
    return _user;
}

- (NSMutableArray *) itemDataArray {
    if (nil == _itemDataArray) {
        _itemDataArray = [[NSMutableArray alloc]init];
    }
    return _itemDataArray;
}

- (void) setTableView:(WZTableView *)tableView {
    if (_tableView != tableView) {
        _tableView = tableView;
        [self registerCellClass];
    }
}

- (nullable Class) getTableViewCellClass {
    return [UITableViewCell class];
}

- (void) registerCellClass {
    Class className = [self getTableViewCellClass];

    [self.tableView.tableView registerClass:className forCellReuseIdentifier:sTableViewCell];
    self.protypeCell = [self.tableView.tableView dequeueReusableCellWithIdentifier:sTableViewCell];
}

- (UITableViewCell *) protypeCell {
    if (nil == _protypeCell) {
        Class className = [self getTableViewCellClass];
        _protypeCell = [[className alloc]init];
    }
    return _protypeCell;
}

- (void) deleteCellInCellData:(NSObject*)cellData {
    NSInteger orderRow = [self.itemDataArray indexOfObject:cellData];
    
    if (NSNotFound != orderRow) {
        [self.itemDataArray removeObject:cellData];
        NSIndexPath *delRow = [NSIndexPath indexPathForRow:orderRow inSection:0];
        [self.tableView.tableView beginUpdates];
        [self.tableView.tableView deleteRowsAtIndexPaths:@[delRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView.tableView endUpdates];
    }
}

#pragma mark - WZTableViewDelegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo {
    [self requestOrderList:tableView withPage:pageInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DLog(@"row count %ld", (unsigned long)self.itemDataArray.count);
    return self.itemDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *cellData = self.itemDataArray[indexPath.row];
    [self setCell:self.protypeCell withData:cellData];
    
    return [self heightForCell:self.protypeCell withCellData:cellData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *cellData = self.itemDataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sTableViewCell];
    
    [self setCell:cell withData:cellData];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSObject *cellData = self.itemDataArray[indexPath.row];

    [self selectCellWithCellData:cellData];
}

- (void)requestOrderList:(WZTableView*)tableView withPage:(PageInfo*)pageInfo {
    [self queryOrderList:pageInfo response:^(NSError *error, HttpResponseData *responseData, NSArray *orderItems) {

        if(orderItems != self.itemDataArray) {
            if (pageInfo.currentPage == 1) { //update items
                [self.itemDataArray removeAllObjects];
            }
            if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
                if (orderItems.count > 0) {
                    [self.itemDataArray addObjectsFromArray:orderItems];
                }
            }
        }
        [tableView didRequestTableViewListDatasWithCount:orderItems.count totalCount:self.itemDataArray.count page:pageInfo response:responseData error:error];
    }];
}

- (CGFloat)heightForCell:(UITableViewCell*)cell withCellData:(NSObject*)cellData {
    return kTableViewCellDefaultHeight;
}

- (void)selectCellWithCellData:(NSObject*)cellData {
    UNIMPLEMENTED;
}

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock {
    UNIMPLEMENTED;
}

- (void)setCell:(UITableViewCell*)cell withData:(NSObject*)cellData {
    UNIMPLEMENTED;
}

@end
