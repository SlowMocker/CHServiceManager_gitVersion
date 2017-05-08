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

@property(nonatomic, strong) WZTableView *tableView;
@property(nonatomic, strong) NSMutableArray *itemDataArray;/**< cell 数据源｜ 每个 cell 需要的数据的集合 */
@property(nonatomic, strong) HttpClientManager *httpClient;/**< 网络请求句柄 */
@property(nonatomic, strong) UserInfoEntity *user;/**< 用户信息［请求数据需要使用］ */

@property(nonatomic, weak) ViewController *viewController;

/**
 *  删除 cellData 所在的行
 *
 *  @param cellData cellData
 */
- (void) deleteCellInCellData:(NSObject*)cellData;

/**
 *  读取 tableview cell 的类，需重写
 *
 *  @return calss
 */
- (Class) getTableViewCellClass;

/**
 *  读取工单列表，子类需重写
 *
 *  @param pageInfo             请求数据配置信息
 *  @param requestCallBackBlock 回调
 */
- (void) queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock;

/**
 *  给 cell 数据
 *
 *  @param cell     cell
 *  @param cellData cellData
 */
- (void) setCell:(UITableViewCell*)cell withData:(NSObject*)cellData;

/**
 *  选中了某工单，子类需重写
 *
 *  @param cellData cellData
 */
- (void) selectCellWithCellData:(NSObject*)cellData;

/**
 *  返回行高，子类需重写
 */
- (CGFloat) heightForCell:(UITableViewCell*)cell withCellData:(NSObject*)cellData;
@end
