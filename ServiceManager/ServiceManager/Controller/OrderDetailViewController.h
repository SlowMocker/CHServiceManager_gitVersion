//
//  OrderDetailViewController.h
//  ServiceManager
//
//  Created by will.wang on 15/8/31.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "BaseOrderDetailsViewController.h"

/**
 *  非乐视品牌工单详情
 */
@interface OrderDetailViewController : BaseOrderDetailsViewController
@property(nonatomic, strong)OrderContentModel *orderContent;

//YES 服务改善工单， NO 常规工单
@property(nonatomic, assign)BOOL isServiceImprovementOrder;
@end
