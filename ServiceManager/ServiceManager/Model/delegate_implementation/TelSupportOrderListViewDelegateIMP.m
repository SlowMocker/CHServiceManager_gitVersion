//
//  TelSupportOrderListViewDelegateIMP.m
//  ServiceManager
//
//  Created by will.wang on 16/5/12.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "TelSupportOrderListViewDelegateIMP.h"
#import "OrderTableViewCellDataSetter.h"
#import "TaskDetailsViewController.h"
#import "OrderDetailViewController.h"
#import "OrderTableViewCellDataSetter.h"

@interface TelSupportOrderListViewDelegateIMP()
{
    WZSwipeCell *_selectedCell;
}
@end

@implementation TelSupportOrderListViewDelegateIMP

#pragma mark - override super methods

- (Class)getTableViewCellClass
{
    return [OrderTableViewCell class];
}

- (CGFloat)heightForCell:(UITableViewCell*)cell withCellData:(NSObject*)cellData
{
    OrderTableViewCell *orderCell = (OrderTableViewCell*)cell;
    return [orderCell fitHeight];
}

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock
{
    SupporterOrderListInPutParams *input = [SupporterOrderListInPutParams new];
    input.pagenow = [NSString intStr:pageInfo.currentPage];
    input.supporterId = self.user.userId;
    input.status = [NSString intStr:self.orderStatus];
    
    [self.httpClient supporter_orderList:input response:^(NSError *error, HttpResponseData *responseData) {
        
        NSArray *orderItems;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            orderItems = [MiscHelper parserObjectList:responseData.resultData objectClass:@"SupporterOrderContent"];
        }
        requestCallBackBlock(error, responseData, orderItems);
    }];
}

- (void)setCell:(UITableView*)cell withData:(OrderContent*)cellData
{
    OrderTableViewCell *orderCell = (OrderTableViewCell*)cell;
    SupporterOrderContent *order = (SupporterOrderContent*)cellData;
    
    //1, create right menu buttons
    NSArray *operateMenuBtnModels = [self makeCellRightButtons];
    orderCell.topContentView.userInteractionEnabled = (operateMenuBtnModels.count > 0);
    [orderCell setRightButtonsWithModels:operateMenuBtnModels];
    
    //2, set cell subviews layout
    [self setCellLayoutType:orderCell];
    
    //3, set data to cell
    [self setSupporterOrderContent:order toCell:orderCell];

    //4, set cell's delegate
    orderCell.delegate = self;
    orderCell.cellData = order;
}

- (void)selectCellWithCellData:(NSObject *)cellData
{
    [self pushToTaskDetailsViewController:(SupporterOrderContent*)cellData confirmMode:NO];
}

#pragma mark - set cell's layout type

- (void)setCellLayoutType:(OrderTableViewCell*)cell
{
    kOrderItemContentViewLayoutType layoutType = kOrderItemContentViewLayoutType1;

    switch (self.orderStatus) {
        case kSupporterOrderStatusApply:
        case kSupporterOrderStatusReceived:
            layoutType = kOrderItemContentViewLayoutType5;
            break;
        case kSupporterOrderStatusConfirmed:
            layoutType = kOrderItemContentViewLayoutType4;
            break;
        default:
            break;
    }

    cell.topOrderContentView.layoutType = layoutType;
}

#pragma mark - make cell's right menu buttons

- (MenuButtonModel*)makeMenuButtonModel:(kOrderOperationType)operateType backgroundColor:(UIColor*)backgroundColor
{
    MenuButtonModel *model = [MenuButtonModel new];
    model.title = getOrderOperationTypeStr(operateType);
    model.backgroundColor = backgroundColor;
    model.buttonTag = operateType;
    
    return model;
}

- (NSMutableArray*)makeCellRightButtons
{
    NSMutableArray *operateMenuBtnModels = [[NSMutableArray alloc]init];
    BOOL showView = YES;
    MenuButtonModel *menuBtnModel;
    
    switch (self.orderStatus) {
        case kSupporterOrderStatusApply:
        {
            menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeConfirm backgroundColor:kColorDefaultRed];
            [operateMenuBtnModels addObject:menuBtnModel];
        }
            break;
        default:
            return nil;
    }
    
    if (showView) {
        menuBtnModel = [self makeMenuButtonModel:kOrderOperationTypeView backgroundColor:kColorLightGreen];
        [operateMenuBtnModels addObject:menuBtnModel];
    }
    return operateMenuBtnModels;
}

-(void)do_OrderOperationTypeView:(OrderContent *)orderContent
{
    SupporterOrderContent *order = (SupporterOrderContent*)orderContent;

    OrderDetailViewController *orderDetailVc;
    orderDetailVc = [[OrderDetailViewController alloc]init];
    orderDetailVc.title = @"工单详情";

    OrderContentModel *orderContentModel = [OrderContentModel new];
    orderContentModel.object_id = [order.objectId description];

    orderDetailVc.orderContent = orderContentModel;
    [self.viewController pushViewController:orderDetailVc];
}

- (void)do_OrderOperationTypeConfirm:(OrderContent*)orderContent
{
    [self pushToTaskDetailsViewController:orderContent confirmMode:YES];
}

- (void)pushToTaskDetailsViewController:(OrderContent*)orderContent confirmMode:(BOOL)bConfirmMode
{
    SupporterOrderContent *order = (SupporterOrderContent*)orderContent;

    TaskDetailsViewController *taskDetailsVc = [[TaskDetailsViewController alloc]init];
    taskDetailsVc.title = @"任务详情";
    taskDetailsVc.orderContent = (SupporterOrderContent*)order;
    taskDetailsVc.orderStatus = self.orderStatus;
    taskDetailsVc.isConfirmMode = bConfirmMode;
    [self.viewController pushViewController:taskDetailsVc];
}

- (void)setSupporterOrderContent:(OrderContent*)orderContent toCell:(OrderTableViewCell*)cell
{
    SupporterOrderContent *supporterOrderContent = (SupporterOrderContent*)orderContent;
    
    OrderItemContentView *mainView = cell.topOrderContentView;
    
    mainView.orderIdLabel.text = supporterOrderContent.objectId;

    mainView.contentLabel.attributedText = [OrderTableViewCellDataSetter buildOrderAttrStr:supporterOrderContent.order_type catgory:supporterOrderContent.zzfld000003 customer:nil];

    [mainView showPrior:NO showUrgent:NO];
    [mainView updateProductRepairTypeToViews:supporterOrderContent.order_type];

    mainView.addressLabel.text = [Util defaultStr:@"客户地址未知" ifStrEmpty:supporterOrderContent.customerFullAddress];

    mainView.executeNameLabel.hidden = [Util isEmptyString:supporterOrderContent.workerName];
    mainView.executeNameLabel.text = [supporterOrderContent.workerName truncatingTailWhenLengthGreaterThan:6];

    if (self.orderStatus == kSupporterOrderStatusConfirmed) {
        mainView.statusLabel.text = supporterOrderContent.content;
        mainView.starView.score = [supporterOrderContent.score floatValue]/5;
    }else {
        mainView.statusLabel.hidden = YES;
        mainView.starView.hidden = YES;
    }
}

#pragma mark - cell's delegate

- (void)swipeCellRightButtonsWillShow:(WZSwipeCell*)cell
{
    WZSwipeCell *oldSelectedCell = _selectedCell;
    WZSwipeCell *newSelectedCell = cell;
    
    if (oldSelectedCell != newSelectedCell) {
        [oldSelectedCell hideRightButtons];
        _selectedCell = newSelectedCell;
    }
}

- (void)swipeCell:(WZSwipeCell *)swipeCell menuButtonSelected:(NSInteger)menuButtonTag
{
    kOrderOperationType operateType = (kOrderOperationType)menuButtonTag;
    OrderContent *order = (OrderContent*)swipeCell.cellData;

    switch (operateType) {
        case kOrderOperationTypeView://查看
            [self do_OrderOperationTypeView:order];
            break;
        case kOrderOperationTypeConfirm: //技术确认
            [self do_OrderOperationTypeConfirm:order];
            break;
        default:
            break;
    }
}

@end
