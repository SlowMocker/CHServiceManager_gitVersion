//
//  ExtendOrderDetailsViewController.h
//  ServiceManager
//
//  Created by will.wang on 10/12/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "ViewController.h"

/**
 * 延保单详情
 */

@interface ExtendOrderDetailsViewController : ViewController
@property(nonatomic, assign)kExtendServiceType extendServiceType;
@property(nonatomic, copy)NSString *extendServiceOrderId;
@property(nonatomic, strong)ExtendServiceOrderContent *extendOrder;
@end
