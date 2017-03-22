//
//  WZTableViewDelegateIMP.h
//  ServiceManager
//
//  Created by will.wang on 15/8/28.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZTableView.h"

/**
 * should subclass it
 */

@interface WZTableViewDelegateIMP : NSObject <WZTableViewDelegate>
@property(nonatomic, strong)WZTableView *tableView;
@property(nonatomic, strong)NSMutableArray *itemDataArray;
@property(nonatomic, strong)HttpClientManager *httpClient;
@property(nonatomic, strong)UserInfoEntity *user;

@property(nonatomic, weak)ViewController *viewController;

//删除cellData所在的行
- (void)deleteCellInCellData:(NSObject*)cellData;

//读取tableview cell的类，需重写
- (Class)getTableViewCellClass;

//读取工单列表，子类需重写
- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock;

//设置数据显示，子类需重写
- (void)setCell:(UITableViewCell*)cell withData:(NSObject*)cellData;

//选中了某工单，子类需重写
- (void)selectCellWithCellData:(NSObject*)cellData;

//返回行高，子类需重写
- (CGFloat)heightForCell:(UITableViewCell*)cell withCellData:(NSObject*)cellData;
@end
