//
//  TelSupportOrderListViewDelegateIMP.h
//  ServiceManager
//
//  Created by will.wang on 16/5/12.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "WZTableViewDelegateIMP.h"
#import "WZSwipeCell.h"
#import "OrderTableViewCell.h"

/**
 *  技术支持人员，工单列表
 */

@interface TelSupportOrderListViewDelegateIMP : WZTableViewDelegateIMP<WZSwipeCellDelegate>
@property(nonatomic, assign)kUserRoleType userRoleType;
@property(nonatomic, assign)NSInteger orderStatus;

- (void)pushToTaskDetailsViewController:(OrderContent*)orderContent confirmMode:(BOOL)bConfirmMode;

- (void)setSupporterOrderContent:(OrderContent*)orderContent toCell:(OrderTableViewCell*)cell;

@end
