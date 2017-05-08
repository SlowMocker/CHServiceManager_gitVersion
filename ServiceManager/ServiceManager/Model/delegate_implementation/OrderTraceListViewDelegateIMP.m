//
//  OrderTraceListViewDelegateIMP.m
//  ServiceManager
//
//  Created by will.wang on 15/9/11.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "OrderTraceListViewDelegateIMP.h"
#import "OrderTraceCell.h"
#import "PerformOrderViewController.h"
#import "PartCodeInputAlertView.h"
#import "PartTraceInfoPopView.h"

@interface OrderTraceListViewDelegateIMP()<WZSwipeCellDelegate>
{
    WZSwipeCell *_selectedCell;
}
@end

@implementation OrderTraceListViewDelegateIMP

#pragma mark - override supper methods

- (Class)getTableViewCellClass
{
    return [OrderTraceCell class];
}

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock
{
    PartTracklistInputParams *input = [PartTracklistInputParams new];
    input.repairmanid = [UserInfoEntity sharedInstance].userId;
    input.pagenow = [NSString intStr:pageInfo.currentPage];
    
    [self.httpClient partTracklist:input response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *retOrders;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode){
            retOrders = [MiscHelper parserObjectList:responseData.resultData objectClass:@"OrderTraceInfos"];
        }
        requestCallBackBlock(error, responseData, retOrders);
    }];
}

- (void)setCell:(UITableViewCell*)cell withData:(NSObject*)cellData
{
    OrderTraceCell *traceCell = (OrderTraceCell*)cell;
    
    traceCell.traceInfo = (OrderTraceInfos*)cellData;
    traceCell.delegate = self;
    
    NSInteger indexRow = [self.itemDataArray indexOfObject:cellData];
    
    //cell background color
    UIColor *backgroundColor = indexRow%2 ? kColorDefaultBackGround :kColorWhite;
    traceCell.topContentView.backgroundColor = backgroundColor;

    traceCell.statusButtonClickedBlock = ^(id sender){
        OrderTraceCell *srcCell = (OrderTraceCell*)sender;
        [self viewPartTraceInfomation:srcCell.traceInfo];
    };
}

- (void)viewPartTraceInfomation:(OrderTraceInfos*)partTraceInfo
{
    PartTraceInfoPopView *infoView;
    infoView = [[PartTraceInfoPopView alloc]init];
    infoView.partInfos = partTraceInfo;
    infoView.titleLabel.text = @"审核未通过";
    [infoView show];
}

- (CGFloat)heightForCell:(UITableViewCell*)cell withCellData:(NSObject*)cellData
{
    OrderTraceCell *orderCell =(OrderTraceCell*)cell;
    return [orderCell fitHeight];
}

//变更条码，不需再改状态
- (void)editPartCode:(OrderTraceInfos*)traceInfos
{
    PartCodeInputAlertView *alertView =
    [self makePartCodeEditAlertView:traceInfos okButtonClicked:^(id object) {
        PartCodeInputAlertView *inputView = (PartCodeInputAlertView*)object;
        [self updatePartStatusToDOABack:traceInfos partCode:inputView.inputTextView.text operateType:@"-5"];
    }];
    alertView.titleLabel.text = @"变更备件条码";
    [alertView show];
}

- (void)confirmDOAReturnBack:(OrderTraceInfos*)traceInfos
{
    PartCodeInputAlertView *alertView =
    [self makePartCodeEditAlertView:traceInfos okButtonClicked:^(id object) {
        PartCodeInputAlertView *inputView = (PartCodeInputAlertView*)object;
        [self updatePartStatusToDOABack:traceInfos partCode:inputView.inputTextView.text operateType:@"-4"];
    }];
    [alertView show];
}

//okButtonClickedBlock: 已做过条码正确性检查
- (PartCodeInputAlertView*)makePartCodeEditAlertView:(OrderTraceInfos*)traceInfos okButtonClicked:(VoidBlock_id)okButtonClickedBlock
{
    PartCodeInputAlertView *inpuAlertView;
    inpuAlertView = [[PartCodeInputAlertView alloc]init];
    inpuAlertView.partInfos = traceInfos;
    inpuAlertView.onOkButtonClicked = ^(id object){
        PartCodeInputAlertView *inputView = (PartCodeInputAlertView*)object;
        NSString *partCode = inputView.inputTextView.text;
        BOOL formatOk = (partCode && (18 == partCode.length));
        if (formatOk) {
            [inputView hide];
            okButtonClickedBlock(object);
        }else {
            [Util showToast:@"请输入正确的备件条码" toView:inputView];
        }
    };

    return inpuAlertView;
}

//1, Doa back: operate type is -4,
//2, change part code ,operateType is -5
- (void)updatePartStatusToDOABack:(OrderTraceInfos*)traceInfos partCode:(NSString*)partCode operateType:(NSString*)operateType
{
    SetPartTraceStatusInputParams *input = [SetPartTraceStatusInputParams new];
    input.dispatchparts_id = [traceInfos.dispatchparts_id description];
    input.puton_status = [NSString intStr:kOrderTraceStatusDoaBack];
    input.operate_type = operateType;
    input.zzfld00002s = partCode;
    [Util showWaitingDialog];
    __weak typeof (&*self)weakSelf = self;
    
    [self.httpClient setPartTraceStatus:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            [weakSelf.tableView refreshTableViewData];
            [weakSelf gotoPerformOrderViewController:traceInfos.object_id.description];
            [Util showToast:@"操作成功"];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)gotoPerformOrderViewController:(NSString*)orderId
{
    PerformOrderViewController *performVc = [[PerformOrderViewController alloc]init];
    performVc.orderListViewController = self.viewController;
    performVc.orderId = orderId;
    [self.viewController pushViewController:performVc];
}

- (void)updateOrder:(OrderTraceInfos*)traceInfos TraceStatus:(kOrderTraceStatus)targetStatus
{
    SetPartTraceStatusInputParams *input = [SetPartTraceStatusInputParams new];
    input.dispatchparts_id = [traceInfos.dispatchparts_id description];
    input.puton_status = [NSString intStr:targetStatus];
    input.operate_type = @"-3";
    
    [Util showWaitingDialog];
    __weak typeof (&*self)weakSelf = self;
    
    [self.httpClient setPartTraceStatus:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            [weakSelf gotoPerformOrderViewController:traceInfos.object_id.description];
            [Util showToast:@"操作成功"];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

#pragma mark - cell's delegate

- (void)swipeCell:(WZSwipeCell *)swipeCell menuButtonSelected:(NSInteger)menuButtonTag
{
    OrderTraceCell *orderTraceCell = (OrderTraceCell*)swipeCell;
    kOrderTraceHandleType handleType = (kOrderTraceHandleType)menuButtonTag;
    
    switch (handleType) {
        case kOrderTraceHandleTypeReceive:
        {
            [Util confirmAlertView:@"您确定要收货吗?" confirmAction:^(){
                [self updateOrder:orderTraceCell.traceInfo TraceStatus:kOrderTraceStatusConfirmReveived];
            }];
        }
            break;
        case kOrderTraceHandleTypeDOABack:
            [self confirmDOAReturnBack:orderTraceCell.traceInfo];
            break;
        case kOrderTraceHandleTypeEditPart:
            [self editPartCode:orderTraceCell.traceInfo];
            break;
        default:
            break;
    }
}

- (void)swipeCellRightButtonsDidShow:(WZSwipeCell*)cell
{
    WZSwipeCell *oldSelectedCell = _selectedCell;
    WZSwipeCell *newSelectedCell = cell;
    
    if (oldSelectedCell != newSelectedCell) {
        [oldSelectedCell hideRightButtons];
        _selectedCell = newSelectedCell;
    }
}

@end
