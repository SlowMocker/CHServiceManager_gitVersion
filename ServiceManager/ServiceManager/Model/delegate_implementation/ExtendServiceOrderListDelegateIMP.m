//
//  ExtendServiceOrderListDelegateIMP.m
//  ServiceManager
//
//  Created by mac on 15/8/27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ExtendServiceOrderListDelegateIMP.h"
#import "ExtendServiceOrderCell.h"
#import "ExtendOrderDetailsViewController.h"
#import "ExtendReceiveAccountQrCodeController.h"
#import "OrderExtendEditViewController.h"

@interface ExtendServiceOrderListDelegateIMP() <WZSwipeCellDelegate>
@end

@implementation ExtendServiceOrderListDelegateIMP

#pragma mark - override super methods

- (Class)getTableViewCellClass
{
    return [ExtendServiceOrderCell class];
}

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock
{
    ExtendOrderListInputParams *input = [ExtendOrderListInputParams new];
    input.userId = self.user.userId;
    input.pageNow = [NSString intStr:pageInfo.currentPage];
    input.type = [NSString intStr:self.extendServiceType];
    
    [self.httpClient extendOrderList:input response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *retOrders;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            retOrders = [MiscHelper parserExtendOrderList:responseData.resultData];
        }
        requestCallBackBlock(error, responseData, retOrders);
    }];
}

- (void)setCell:(UITableViewCell*)cell withData:(NSObject*)cellData
{
    ExtendServiceOrderContent *orderContent = (ExtendServiceOrderContent*)cellData;
    ExtendServiceOrderCell *orderCell = (ExtendServiceOrderCell*)cell;
    
    orderCell.delegate = self;
    
    NSArray *operateMenuBtnModels = [self makeCellRightButtons:orderContent];
    orderCell.topContentView.userInteractionEnabled = (operateMenuBtnModels.count > 0);
    [orderCell setRightButtonsWithModels:operateMenuBtnModels];

    [self setCellModel:orderCell withData:orderContent];
}

- (NSMutableArray*)makeCellRightButtons:(ExtendServiceOrderContent*)orderContent
{
    NSMutableArray *operateMenuBtnModels = [[NSMutableArray alloc]init];
    MenuButtonModel *menuBtnModel;
    BOOL isEContract = (1 == [orderContent.econtract integerValue]);

    do {
        if (isEContract) {
            if ([orderContent.status isEqualToString:@"SC20"]) { //提交
                if ([Util isEmptyString:orderContent.contractNum]) {
                    //未提交
                    menuBtnModel = [Util makeMenuButtonModel:kOrderOperationTypeEdit];
                    [operateMenuBtnModels addObject:menuBtnModel];
                    break;
                }else { //提交
                    menuBtnModel = [Util makeMenuButtonModel:kOrderOperationTypeReceiveAccount];
                    [operateMenuBtnModels addObject:menuBtnModel];
                    
                    menuBtnModel = [Util makeMenuButtonModel:kOrderOperationTypeDelete];
                    [operateMenuBtnModels addObject:menuBtnModel];
                }
            }
        }
        menuBtnModel = [Util makeMenuButtonModel:kOrderOperationTypeView];
        [operateMenuBtnModels addObject:menuBtnModel];
    } while (FALSE);

    return operateMenuBtnModels;
}

- (void)selectCellWithCellData:(NSObject*)cellData
{
    ExtendServiceOrderContent *orderContent = (ExtendServiceOrderContent*)cellData;
    [self pushToExtendOrderDetailsViewController:orderContent];
}

- (CGFloat)heightForCell:(UITableViewCell*)cell withCellData:(NSObject*)cellData
{
    ExtendServiceOrderCell *orderCell = (ExtendServiceOrderCell*)cell;
    return [orderCell fitHeight];
}

- (ExtendServiceOrderCell*)setCellModel:(ExtendServiceOrderCell*)cell withData:(ExtendServiceOrderContent*)data
{
    cell.extendOrder = data;
    return cell;
}

- (void)pushToExtendOrderDetailsViewController:(ExtendServiceOrderContent*)orderContent
{
    ExtendOrderDetailsViewController *extendOrderDetailsVc = [[ExtendOrderDetailsViewController alloc]init];
    extendOrderDetailsVc.extendServiceOrderId = orderContent.Id;
    extendOrderDetailsVc.extendServiceType = (orderContent.productInfoList.count > 1) ? kExtendServiceTypeMutiple : kExtendServiceTypeSingle;
    extendOrderDetailsVc.extendOrder = orderContent;
    [self.viewController pushViewController:extendOrderDetailsVc];
}

- (void)pushToExtendReceiveAccountQrCodeController:(ExtendServiceOrderContent*)orderContent
{
    ExtendReceiveAccountQrCodeController *vc = [[ExtendReceiveAccountQrCodeController alloc]init];
    vc.extendOrderTempNumber = orderContent.tempNum;
    [self.viewController pushViewController:vc];
}

- (void)deleteExtendServiceOrder:(ExtendServiceOrderContent*)orderContent
{
    [Util confirmAlertView:@"确定要删除此电子延保订单？" confirmAction:^{
        [self requestDeleteExtendServiceOrder:orderContent];
    }];
}
     
- (void)requestDeleteExtendServiceOrder:(ExtendServiceOrderContent*)orderContent
{
    DeleteExtendOrderInputParams *input = [[DeleteExtendOrderInputParams alloc]init];
    input.tempNum = orderContent.tempNum;

    [Util showWaitingDialog];
    [[HttpClientManager sharedInstance]deleteExtendOrder:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error && kHttpReturnCodeSuccess == responseData.resultCode)
        {
            [self deleteCellInCellData:orderContent];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)pushToEditOrderViewController:(ExtendServiceOrderContent*)orderContent
{
    OrderExtendEditViewController *extendEditVc = [[OrderExtendEditViewController alloc]init];
    extendEditVc.extendOrderEditMode = kExtendOrderEditModeEdit;
    extendEditVc.extendServiceType = (kExtendServiceType)[orderContent.type integerValue];
    extendEditVc.extendOrder = orderContent;
    [self.viewController pushViewController:extendEditVc];
}

- (void)swipeCell:(WZSwipeCell*)swipeCell menuButtonSelected:(NSInteger)menuButtonTag
{
    ExtendServiceOrderCell *orderCell = (ExtendServiceOrderCell*)swipeCell;

    kOrderOperationType operationType = (kOrderOperationType)menuButtonTag;
    switch (operationType) {
        case kOrderOperationTypeView:
            [self pushToExtendOrderDetailsViewController:orderCell.extendOrder];
            break;
        case kOrderOperationTypeReceiveAccount:
            [self pushToExtendReceiveAccountQrCodeController:orderCell.extendOrder];
            break;
        case kOrderOperationTypeDelete:
            [self deleteExtendServiceOrder:orderCell.extendOrder];
            break;
        case kOrderOperationTypeEdit:
            [self pushToEditOrderViewController:orderCell.extendOrder];
            break;
        default:
            break;
    }
}

@end
