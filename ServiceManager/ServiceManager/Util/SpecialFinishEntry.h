//
//  SpecialFinishEntry.h
//  ServiceManager
//
//  Created by will.wang on 2016/12/15.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialFinishEntry : NSObject

/**
 *  检查是否能特殊完工，如果能进进入，否则提示错误
 *  orderId: 工单号
 *  orderListVc : 工单列表的VC
 *  fromVC: push前的VC
 **/
- (void)gotoSpecialPerformVCByOrderId:(NSString*)orderId orderListVc:(ViewController*)orderListVc fromVc:(ViewController*)fromVc;

/**
 *  检查是否能特殊完工，如果能进进入，否则提示错误
 *  orderDetails: 工单详情
 *  orderListVc : 工单列表的VC
 *  fromVC: push前的VC
 **/
- (void)gotoSpecialPerformVCByOrderDetails:(OrderContentDetails*)orderDetails orderListVc:(ViewController*)orderListVc fromVc:(ViewController*)fromVc;


@end
