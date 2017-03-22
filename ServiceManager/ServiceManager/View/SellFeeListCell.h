//
//  SellFeeListCell.h
//  ServiceManager
//
//  Created by will.wang on 16/3/31.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  销售费用清单，用于费用管理列表
 */

#import "WZSwipeCell.h"

@class SellFeeListCell;

@interface SellFeeListCell : WZSwipeCell

@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *isSyncLabel; //是否同步到CRM
@property(nonatomic, strong)UILabel *priceLabel;
@property(nonatomic, strong)UILabel *contentLabel;

//用SellFeeListInfos去设置显示内容
@property(nonatomic, strong)SellFeeListInfos *sellInfos; //model 1

//用LetvSellFeeListInfos去设置显示内容
@property(nonatomic, strong)LetvSellFeeListInfos *letvSellInfos; //model2

@end
