//
//  OrderTableViewCell.h
//  ServiceManager
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZSwipeCell.h"
#import "OrderItemContentView.h"

@interface OrderTableViewCell : WZSwipeCell
@property(nonatomic, strong)OrderItemContentView *topOrderContentView;
@end
