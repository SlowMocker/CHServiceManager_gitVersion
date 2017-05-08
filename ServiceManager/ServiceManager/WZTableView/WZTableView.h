//
//  WZTableView.h
//  ServiceManager
//
//  Created by mac on 15/8/26.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

// 集成 MJRefresh
// 自带 loading
// delegate 为 WZTableViewDelegateIMP 对象（对该工程而言）

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

@class WZTableView;
@protocol WZTableViewDelegate <UITableViewDataSource, UITableViewDelegate>
@optional
/**
 *  获取 tableView 的数据源
 *
 *  @note  调用该接口后需要调用 didRequestTableViewListDatasWithCount
 *
 *  @param tableView 目标 tableView
 *  @param pageInfo  请求数据配置
 */
-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo;
@end

@interface WZTableView : UIView

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)PageInfo *pageInfo;/**< tableView 请求数据配置信息 */
@property(nonatomic, strong)id<WZTableViewDelegate> tableViewDelegate;

@property(nonatomic, assign)BOOL showWaitingDialog;/**< 是否显示 loading ｜ default: YES*/
@property(nonatomic, assign)BOOL bHasLoaded;/**< 已经 loaded 或者 loading */

@property(nonatomic, copy)NSString *noDataPromptText;/**< 无数据提示语 */
@property(nonatomic, copy)NSString *noDataPromptIcon;/**< 无数据提示 icon path */

- (id) initWithStyle:(UITableViewStyle)style delegate:(id<WZTableViewDelegate>)delegate;

/**
 *  实际由 delegate 调用 -tableView: requestListDatas:
 *  @note 只是请求数据并没有刷新 tableView
 */
- (void) refreshTableViewData;

/**
 *  invoke it after request | 这个接口会刷新 tableView
 *
 *  @param reqCountForPage requested list item count at this time
 *  @param totalCount      requested total list item count at all time
 *  @param page            request page info of this time
 *  @param response        response
 *  @param error           error
 */
-(void)didRequestTableViewListDatasWithCount:(NSInteger)reqCountForPage totalCount:(NSInteger)totalCount page:(PageInfo*)page response:(HttpResponseData*)response error:(NSError*)error;
@end
