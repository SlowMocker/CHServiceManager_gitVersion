//
//  LetvPriceListViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/24.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvPriceListViewController.h"
#import "LetvFeeListViewDelegateIMP.h"
#import "LetvFeeEditViewController.h"
#import "LetvSmartProductSellEditViewController.h"

@interface LetvPriceListViewController ()

@end

@implementation LetvPriceListViewController

- (WZTableViewDelegateIMP*)getFeeListViewDelegateIMP
{
    LetvFeeListViewDelegateIMP *imp = [[LetvFeeListViewDelegateIMP alloc]init];
    imp.machineModelCode = self.machineModelCode;

    return imp;
}

- (void)addButtonClicked:(UIButton*)sender
{
    if (kPriceManageTypeService == self.feeManageType) {
        [self gotoLetvFeeEditViewController];
    }else if (kPriceManageTypeSells == self.feeManageType){
        [self gotoLetvSmartProductSellEditViewController];
    }
}

- (void)gotoLetvFeeEditViewController
{
    LetvFeeEditViewController *editVc;
    editVc = [[LetvFeeEditViewController alloc]init];

    editVc.orderObjectId = self.orderObjectId;
    editVc.orderKeyId = self.orderKeyId;
    editVc.brandCode = self.brandCode;
    editVc.categoryCode = self.categoryCode;
    editVc.machineModelCode = self.machineModelCode;
    editVc.title = @"添加费用项";
    
    [self pushViewController:editVc];
}

- (void)gotoLetvSmartProductSellEditViewController
{
    LetvSmartProductSellEditViewController *editVc;
    editVc = [[LetvSmartProductSellEditViewController alloc]init];
    
    editVc.orderObjectId = self.orderObjectId;
    editVc.orderKeyId = self.orderKeyId;
    editVc.brandCode = self.brandCode;
    editVc.categoryCode = self.categoryCode;
    editVc.title = @"添加销售费用项";

    [self pushViewController:editVc];
}

@end
