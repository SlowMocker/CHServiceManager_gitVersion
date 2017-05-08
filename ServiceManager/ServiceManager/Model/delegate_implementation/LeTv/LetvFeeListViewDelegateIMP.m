//
//  LetvFeeListViewDelegateIMP.m
//  ServiceManager
//
//  Created by will.wang on 16/5/23.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvFeeListViewDelegateIMP.h"
#import "FeeEditViewController.h"
#import "LetvFeeEditViewController.h"
#import "LetvSmartProductSellEditViewController.h"

@interface LetvFeeListViewDelegateIMP() <WZSwipeCellDelegate>
@end

@implementation LetvFeeListViewDelegateIMP

-(void)queryExpenseListWithResponse:(RequestCallBackBlockV2)requestCallBackBlock
{
    LetvExpenseListInputParams *input = [LetvExpenseListInputParams new];
    input.objectId = self.priceListViewController.orderObjectId;
    if (kPriceManageTypeService == self.priceListViewController.feeManageType) {
        input.itmType = @"ZRV1";
    }else if (kPriceManageTypeSells == self.priceListViewController.feeManageType){
        input.itmType = @"ZPRV";
    }
    input.model = self.machineModelCode;

    [self.httpClient letv_queryExpenseList:input response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *retOrders;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode){
            retOrders = [MiscHelper parserObjectList:responseData.resultData objectClass:@"LetvSellFeeListInfos"];
        }
        requestCallBackBlock(error, responseData, retOrders);
    }];
}

- (void)setCell:(UITableViewCell*)cell withData:(NSObject*)cellData
{
    SellFeeListCell *feeCell = (SellFeeListCell*)cell;
    LetvSellFeeListInfos *sellInfos = (LetvSellFeeListInfos*)cellData;
    
    sellInfos.brandIdStr = self.priceListViewController.brandCode;
    sellInfos.categoryIdStr = self.priceListViewController.categoryCode;

    NSInteger rowIndex = [self.itemDataArray indexOfObject:cellData];
    //cell background color
    UIColor *backgroundColor = rowIndex%2 ? kColorDefaultBackGround :kColorWhite;
    feeCell.topContentView.backgroundColor = backgroundColor;
    feeCell.letvSellInfos = sellInfos;
    feeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    feeCell.delegate = self;
}

- (CGFloat)calcTotalPrice
{
    CGFloat allItemsTotalPrice = 0.00;
    
    for (LetvSellFeeListInfos *feeInfos in self.itemDataArray) {
        allItemsTotalPrice += feeInfos.totalPrice;
    }
    return allItemsTotalPrice;
}

- (BOOL)checkIsAllSyncToCRM
{
    return YES; //乐视的费用管理先存在了我们的服务器，先不用考虑同步
}

- (void)editFeeItem:(kSellFeeListHandleType)handleType atCell:(SellFeeListCell*)cell
{
    kPriceManageType feeManageType = self.priceListViewController.feeManageType;
    if (kPriceManageTypeService == feeManageType) {
        [self gotoLetvFeeEditViewController:cell.letvSellInfos];
    }else if (kPriceManageTypeSells == feeManageType){
        [self gotoLetvSmartProductSellEditViewController:cell.letvSellInfos];
    }
}

- (void)gotoLetvFeeEditViewController:(LetvSellFeeListInfos*)letvFeeItem
{
    LetvFeeEditViewController *editVc;
    editVc = [[LetvFeeEditViewController alloc]init];

    editVc.orderObjectId = self.priceListViewController.orderObjectId;
    editVc.orderKeyId = self.priceListViewController.orderKeyId;
    editVc.brandCode = self.priceListViewController.brandCode;
    editVc.categoryCode = self.priceListViewController.categoryCode;
    editVc.machineModelCode = self.machineModelCode;
    editVc.title = @"编辑费用项";
    editVc.letvFeeInfos = letvFeeItem;

    [self.priceListViewController pushViewController:editVc];
}

- (void)gotoLetvSmartProductSellEditViewController:(LetvSellFeeListInfos*)letvFeeItem
{
    LetvSmartProductSellEditViewController *editVc;
    editVc = [[LetvSmartProductSellEditViewController alloc]init];
    
    editVc.orderObjectId = self.priceListViewController.orderObjectId;
    editVc.orderKeyId = self.priceListViewController.orderKeyId;
    editVc.brandCode = self.priceListViewController.brandCode;
    editVc.categoryCode = self.priceListViewController.categoryCode;
    editVc.title = @"编辑销售费用项";
    editVc.feeInfos = [[SellFeeListInfos alloc]initWithLetvSellFeeListInfos:letvFeeItem];
    [self.priceListViewController pushViewController:editVc];
}

- (void)deleteFeeItemInfo:(SellFeeListCell*)sellCell response:(RequestCallBackBlockV2)requestCallBackBlock
{
    LetvSellFeeListInfos *sellInfos = sellCell.letvSellInfos;
    LetvDeleteFeeOrderInputParams *input = [LetvDeleteFeeOrderInputParams new];
    input.expenseId = sellInfos.Id.description;
    input.objectId = sellInfos.objectId;
    
    [self.httpClient letv_deleteFeeOrder:input response:^(NSError *error, HttpResponseData *responseData) {
        requestCallBackBlock(error, responseData, sellInfos);
    }];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (kPriceManageTypeSells == self.priceListViewController.feeManageType) {
        return [super tableView:tableView viewForHeaderInSection:section];
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (kPriceManageTypeSells == self.priceListViewController.feeManageType) {
        return [super tableView:tableView heightForHeaderInSection:section];
    }else {
        return 1;
    }
}

@end
