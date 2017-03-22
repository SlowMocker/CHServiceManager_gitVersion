//
//  WZTableView.h
//  ServiceManager
//
//  Created by mac on 15/8/26.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

/**
 * features:
 *  1, merge MJRefresh
 *  2, add list loading
 */

@class WZTableView;

@protocol WZTableViewDelegate <UITableViewDataSource, UITableViewDelegate>

@optional
//request list datas, you need to call didRequestTableViewListDatasWithCount after request
-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo;
@end

@interface WZTableView : UIView
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)PageInfo *pageInfo; //read only
@property(nonatomic, strong)id<WZTableViewDelegate> tableViewDelegate;

//if show waiting dialog or not when requesting, default is YES
@property(nonatomic, assign)BOOL showWaitingDialog;

@property(nonatomic, copy)NSString *noDataPromptText;
@property(nonatomic, copy)NSString *noDataPromptIcon; //icon name

//has it loaded or loading
@property(nonatomic, assign)BOOL bHasLoaded;

/**
 * init methods 
 */
- (instancetype)initWithStyle:(UITableViewStyle)style delegate:(id<WZTableViewDelegate>)delegate;

/**
 *  refresh data
 */
- (void)refreshTableViewData;

/** 
 * invoke it after request
 * reqCountForPage : requested list item count at this time
 * totalCount: requested total list item count at all time
 * page :  request page info of this time
 * response: response
 * error: error
 */
-(void)didRequestTableViewListDatasWithCount:(NSInteger)reqCountForPage
                                  totalCount:(NSInteger)totalCount
                                        page:(PageInfo*)page
                                    response:(HttpResponseData*)response
                                       error:(NSError*)error;
@end
