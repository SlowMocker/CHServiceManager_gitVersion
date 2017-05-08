//
//  ServiceImprovementListViewIMP.m
//  ServiceManager
//
//  Created by will.wang on 15/9/7.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ServiceImprovementListViewIMP.h"
#import "OrderDetailViewController.h"

@implementation ServiceImprovementListViewIMP

#pragma mark - override supper methods

- (Class)getTableViewCellClass
{
    return [ServiceImprovementCell class];
}

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock
{
    ServiceImproveListInPutParams *input = [ServiceImproveListInPutParams new];
    input.partner = self.user.userId;

    [self.httpClient facilitator_serviceImproveList:input response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *retOrders;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            retOrders = [MiscHelper parserOrderList:responseData.resultData];
        }
        requestCallBackBlock(error, responseData, retOrders);
    }];
}

- (void)setCell:(UITableViewCell*)cell withData:(NSObject*)cellData
{
    [self setCell:(ServiceImprovementCell*)cell withDataModel:(OrderContentModel*)cellData];
}

- (void)selectCellWithCellData:(NSObject*)cellData
{
    OrderDetailViewController *orderDetailVc;
    orderDetailVc = [[OrderDetailViewController alloc]init];
    orderDetailVc.title = @"工单详情";
    orderDetailVc.isServiceImprovementOrder = YES;
    orderDetailVc.orderContent = (OrderContentModel*)cellData;
    [self.viewController pushViewController:orderDetailVc];
}

- (CGFloat)heightForCell:(UITableViewCell*)cell withCellData:(NSObject*)cellData
{
    return [cell fitHeight];
}

- (UITableViewCell*)setCell:(ServiceImprovementCell*)cell withDataModel:(OrderContentModel*)orderContent
{
    NSString *tempStr;

    //set content datas
    cell.titleLabel.text = orderContent.object_id;

    //just show the 1st mobile number to cell
    NSArray *telArray = [orderContent.telnumber componentsSeparatedByString:@","];
    NSString *firstTel;
    if (telArray.count > 0) {
        firstTel = telArray[0];
    }

    tempStr = [NSString jointStringWithSeparator:@" | " strings
            :[Util defaultStr:@" " ifStrEmpty:orderContent.zzfld000003]
               ,[MiscHelper getOrderHandleTypeStrById:orderContent.process_type]
               ,firstTel
               ,nil];
    cell.contentLabel.text = tempStr;

    cell.addressLabel.text = [Util defaultStr:@"客户地址未知" ifStrEmpty:orderContent.customerFullAddress];

    return cell;
}

@end
