//
//  SmartProductSellEditViewController.h
//  ServiceManager
//
//  Created by will.wang on 16/3/31.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "FeeEditViewController.h"

#import "LabelEditCell.h"
#import <UIAlertView+Blocks.h>
#import "PleaseSelectViewCell.h"
#import "LeftTextRightTextCell.h"
#import "ProductModelSearchViewController.h"

/**
 *  智能产品销售编辑或添加
 */

@interface SmartProductSellEditViewController : FeeEditViewController

@property(nonatomic, strong)CheckItemModel *typeItem; //分类
@property(nonatomic, strong)CheckItemModel *subTypeItem;    //产品

@property(nonatomic, strong)PleaseSelectViewCell *smartProductTypeCell; //智能产品分类
@property(nonatomic, strong)UITableViewCell *productCodeCell; //产品代码
@property(nonatomic, strong)LeftTextRightTextCell *productDesCell;//产品描述
@property(nonatomic, strong)LabelEditCell *countCell;   //数量
@property(nonatomic, strong)LabelEditCell *priceCell;   //单价（元）
@property(nonatomic, strong)LabelEditCell *totalPriceCell;//金额（元）
@property(nonatomic, strong)LabelEditCell *receiptCell; //收据号
@end
