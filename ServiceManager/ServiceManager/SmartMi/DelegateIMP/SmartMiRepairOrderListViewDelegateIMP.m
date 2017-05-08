//
//  SmartMiRepairOrderListViewDelegateIMP.m
//  ServiceManager
//
//  Created by Wu on 17/3/27.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "SmartMiRepairOrderListViewDelegateIMP.h"
#import "OrderTableViewCellDataSetter.h"

@implementation SmartMiRepairOrderListViewDelegateIMP

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock
{
    SmartMiRepairOrderListInPutParams *input = [SmartMiRepairOrderListInPutParams new];
//    input.pagenow = [NSString intStr:pageInfo.currentPage];
//    input.repairmanid = self.user.userId;
//    input.type_id = [NSString intStr:self.orderStatus];
//    input.brands = self.filterCondition.brands;
//    input.productTypes = self.filterCondition.productTypes;
//    input.orderTypes = self.filterCondition.orderTypes;
    
//    @property (nonatomic , copy) NSString *repairManId;/**< 维修工编号 */
//    @property (nonatomic , copy) NSString *status;/**< 工单状态 */
//    @property (nonatomic , copy) NSString *currentPage;/**< 当前页 */
    
    input.repairManId = self.user.userId;
    input.currentPage = [NSString intStr:pageInfo.currentPage];
    input.status = [NSString intStr:self.orderStatus];
    
    [self.httpClient smartMi_repairer_orderList:input response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *orderItems;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            orderItems = [MiscHelper parserObjectList:responseData.resultData objectClass:@"SmartMiOrderContentModel"];
        }
        requestCallBackBlock(error, responseData, orderItems);
    }];
}

- (void)agreeOrder:(OrderContent*)order response:(RequestCallBackBlock)requestCallBackBlock
{
    SmartMiOrderContentModel *orderModel = (SmartMiOrderContentModel*)order;
    SmartMiRepairRefuseOrderInputParams *input = [SmartMiRepairRefuseOrderInputParams new];
    input.objectId= [orderModel.objectId description];;
    input.isreceivesign = @"0";
    
    [Util showWaitingDialog];
    [self.httpClient smartMi_repairer_refuseOrder:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        requestCallBackBlock(error, responseData);
    }];
}

- (NSString*)getExNoteStrWhenAgreeingOrder:(OrderContent*)order
{
    SmartMiOrderContentModel *orderModel = (SmartMiOrderContentModel*)order;
    BOOL bUnappointmented = [orderModel.status isEqualOneInArray:@[@"SR01",@"SR20",@"SR40"]];
    NSString *exNoteStr = @"";
    
//    if ([orderModel.source isEqualToString:@"73"] && bUnappointmented) { //tmall order
//        exNoteStr = @"\"天猫\"工单，请在1小时内预约，严格按照预约时间上门，并按公司标准收费";
//    }
    return exNoteStr;
}

- (void)refuseOrder:(OrderContent*)order reason:(CheckItemModel*)reason response:(RequestCallBackBlock)requestCallBackBlock
{
    SmartMiOrderContentModel *orderModel = (SmartMiOrderContentModel*)order;
    SmartMiRepairRefuseOrderInputParams *input = [SmartMiRepairRefuseOrderInputParams new];
    input.objectId = [orderModel.objectId description];
    input.isreceivesign = @"1";
    input.declinefounid = reason.key;
    input.realname = orderModel.workerName;
    input.memo = (NSString*)reason.extData;
    
    [Util showWaitingDialog];
    [self.httpClient smartMi_repairer_refuseOrder:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        requestCallBackBlock(error, responseData);
    }];
}

- (void)setCell:(OrderTableViewCell *)cell withData:(OrderContent *)order
{
    [super setCell:cell withData:order];
    
    //1, create right menu buttons
    NSArray *operateMenuBtnModels = [self makeCellRightButtons:order];
    cell.topContentView.userInteractionEnabled = (operateMenuBtnModels.count > 0);
    [cell setRightButtonsWithModels:operateMenuBtnModels];
    
    //2, set cell subviews layout
    [self setCellLayoutType:cell];
    
    //3, set data to cell
    [OrderTableViewCellDataSetter setSmartMiOrderContentModel:(SmartMiOrderContentModel*)order toCell:cell];
}

#pragma mark - set cell's layout type

- (void)setCellLayoutType:(OrderTableViewCell*)cell
{
    kOrderItemContentViewLayoutType layoutType = kOrderItemContentViewLayoutType1;
    
    switch (self.orderStatus) {
        case kRepairerOrderStatusNew:
            layoutType = kOrderItemContentViewLayoutType1;
            break;
        case kRepairerOrderStatusAppointFailure:
        case kRepairerOrderStatusWaitForAppointment:
            layoutType = kOrderItemContentViewLayoutType2;
            break;
        case kRepairerOrderStatusFinished:
            layoutType = kOrderItemContentViewLayoutType5;
            break;
        case kRepairerOrderStatusWaitForExecution:
        case kRepairerOrderStatusUnfinish:
            layoutType = kOrderItemContentViewLayoutType6;
            break;
        default:
            break;
    }
    
    cell.topOrderContentView.layoutType = layoutType;
}

- (NSMutableArray*)makeCellRightButtons:(OrderContent*)order
{
    NSMutableArray *operateMenuBtnModels = [[NSMutableArray alloc]init];
    MenuButtonModel *menuBtnModel;
    SmartMiOrderContentModel *orderContent = (SmartMiOrderContentModel *)order;
    
    switch (self.orderStatus) {
        case kRepairerOrderStatusNew:
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeAgree];
            [operateMenuBtnModels addObject:menuBtnModel];
            
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeRefuse];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kRepairerOrderStatusWaitForAppointment:
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeAppointment];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kRepairerOrderStatusAppointFailure:
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeChangeAppointment];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kRepairerOrderStatusWaitForExecution :
        {
//            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeSpecialFinish];
//            [operateMenuBtnModels addObject:menuBtnModel];
            
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeExecute];
            [operateMenuBtnModels addObject:menuBtnModel];
            
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeChangeAppointment];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kRepairerOrderStatusUnfinish:
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeSpecialFinish];
            [operateMenuBtnModels addObject:menuBtnModel];
            
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeExecute];
            [operateMenuBtnModels addObject:menuBtnModel];
            
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeAppointmentAgain];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        case kRepairerOrderStatusFinished:
        {
//            if ([orderContent.workerId isEqualToString:self.user.userId]) {
//                menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeExtend];
//                [operateMenuBtnModels addObject:menuBtnModel];
//                
////                if (1 == [orderContent.weChatVisit integerValue]
////                    && 0 == [orderContent.isComment integerValue]) {
////                    //微信点评但未点评
////                    menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeUserComment];
////                    [operateMenuBtnModels addObject:menuBtnModel];
////                }
//            }
        }
            break;
        case kRepairerOrderStatusTrace:
            break;
        default:
            break;
    }
    menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeView];
    [operateMenuBtnModels addObject:menuBtnModel];

    return operateMenuBtnModels;
}

@end

