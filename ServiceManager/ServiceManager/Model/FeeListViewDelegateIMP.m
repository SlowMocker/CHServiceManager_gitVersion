//
//  OrderTraceListViewDelegateIMP.m
//  ServiceManager
//
//  Created by will.wang on 15/9/11.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "FeeListViewDelegateIMP.h"
#import "PriceEditViewController.h"
#import "SmartProductSellEditViewController.h"

@interface FeeListViewDelegateIMP()<WZSwipeCellDelegate>
{
    WZSwipeCell *_selectedCell;
}
@property(nonatomic, strong)UITableViewCell *headerView;
@end

@implementation FeeListViewDelegateIMP

#pragma mark - override super methods

- (Class)getTableViewCellClass
{
    return [SellFeeListCell class];
}

-(void)queryExpenseListWithResponse:(RequestCallBackBlockV2)requestCallBackBlock
{
    ExpenseListInputParams *input = [ExpenseListInputParams new];
    input.objectId = self.priceListViewController.orderObjectId;
    if (kPriceManageTypeService == self.priceListViewController.feeManageType) {
        input.itmType = @"ZRVW";
    }else if (kPriceManageTypeSells == self.priceListViewController.feeManageType){
        input.itmType = @"ZPRV";
    }
    
    [self.httpClient queryExpenseList:input response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *retOrders;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode){
            retOrders = [MiscHelper parserObjectList:responseData.resultData objectClass:@"SellFeeListInfos"];
        }
        requestCallBackBlock(error, responseData, retOrders);
    }];
}

- (void)queryOrderList:(PageInfo*)pageInfo response:(RequestCallBackBlockV2)requestCallBackBlock
{
    [self queryExpenseListWithResponse:^(NSError *error, HttpResponseData *responseData, id extData) {
        NSArray *retOrders = (NSArray*)extData;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode){
            [self.itemDataArray setArray:retOrders];
        }else {
            [self.itemDataArray removeAllObjects];
        }

        //calc and show total price
        [self setTotalPrice:[self calcTotalPrice] toLabel:self.headerView.detailTextLabel];

        BOOL isAllSync = [self checkIsAllSyncToCRM];
        [self.priceListViewController showSyncButton:!isAllSync];
        
        requestCallBackBlock(error, responseData, self.itemDataArray);
    }];
}

- (void)setCell:(UITableViewCell*)cell withData:(NSObject*)cellData
{
    SellFeeListCell *feeCell = (SellFeeListCell*)cell;
    SellFeeListInfos *sellInfos = (SellFeeListInfos*)cellData;

    sellInfos.brandIdStr = self.priceListViewController.brandCode;
    sellInfos.categoryIdStr = self.priceListViewController.categoryCode;

    NSInteger rowIndex = [self.itemDataArray indexOfObject:cellData];
    //cell background color
    UIColor *backgroundColor = rowIndex%2 ? kColorDefaultBackGround :kColorWhite;
    feeCell.topContentView.backgroundColor = backgroundColor;
    feeCell.sellInfos = sellInfos;
    feeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    feeCell.delegate = self;
}

- (void)selectCellWithCellData:(NSObject*)cellData
{
}

//返回行高，子类需重写
- (CGFloat)heightForCell:(UITableViewCell*)cell withCellData:(NSObject*)cellData
{
    SellFeeListCell *feeCell = (SellFeeListCell*)cell;
    return [feeCell fitHeight];
}

- (UITableViewCell*)headerView{
    if (nil == _headerView) {
        _headerView = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        _headerView.textLabel.text = @"合计金额";
        _headerView.detailTextLabel.textColor = kColorDefaultRed;
        _headerView.detailTextLabel.font = SystemFont(17);
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, kButtonDefaultHeight);
        _headerView.contentView.backgroundColor = ColorWithHex(@"#f0f0f0");
        [self setTotalPrice:0.00 toLabel:_headerView.detailTextLabel];
        
        _headerView.layer.shadowColor = [UIColor grayColor].CGColor;
        _headerView.layer.shadowOffset = CGSizeMake(0,0);
        _headerView.layer.shadowOpacity = 0.5;
        _headerView.layer.shadowRadius = 3;
    }
    return _headerView;
}

- (void)setTotalPrice:(CGFloat)totalPrice toLabel:(UILabel*)label
{
    label.text = [NSString stringWithFormat:@"￥ %.2f", totalPrice];
}

#pragma mark - WZTableView delegate & datasource

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  kButtonDefaultHeight;
}

- (CGFloat)calcTotalPrice
{
    CGFloat allItemsTotalPrice = 0.00;

    for (SellFeeListInfos *feeInfos in self.itemDataArray) {
        allItemsTotalPrice += feeInfos.totalPrice;
    }
    return allItemsTotalPrice;
}

- (BOOL)checkIsAllSyncToCRM
{
    for (SellFeeListInfos *infos in self.itemDataArray) {
        ReturnIf([infos.isSendtoCrm isEqualToString:@"0"]) NO;
    }
    return YES;
}

- (void)deleteFeeItemInfo:(SellFeeListCell*)sellCell response:(RequestCallBackBlockV2)requestCallBackBlock
{
    SellFeeListInfos *sellInfos = sellCell.sellInfos;

    DeleteFeeOrderInputParams *input = [DeleteFeeOrderInputParams new];
    input.expenseId = sellInfos.Id.description;
    input.objectId = sellInfos.objectId;

    [self.httpClient deleteFeeOrder:input response:^(NSError *error, HttpResponseData *responseData) {
        requestCallBackBlock(error, responseData, sellInfos);
    }];
}

- (void)deleteFeeList:(SellFeeListCell*)feeItemCell
{
    [Util showWaitingDialog];
    [self deleteFeeItemInfo:feeItemCell response:^(NSError *error, HttpResponseData *responseData, id deletedItem) {
        [Util dismissWaitingDialog];
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            [self.itemDataArray removeObject:deletedItem];
            
            //calc and show total price
            [self setTotalPrice:[self calcTotalPrice] toLabel:self.headerView.detailTextLabel];
            [self.tableView.tableView reloadData];
        }else {
            BOOL isAllSync = [self checkIsAllSyncToCRM];
            [self.priceListViewController showSyncButton:!isAllSync];
            
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)editFeeItem:(kSellFeeListHandleType)handleType atCell:(SellFeeListCell*)cell
{
    FeeEditViewController *editVc;
    kPriceManageType feeManageType = self.priceListViewController.feeManageType;
    NSString *titleText = @"编辑费用项";
    if (kPriceManageTypeService == feeManageType) {
        editVc = [PriceEditViewController new];
    }else if (kPriceManageTypeSells == feeManageType){
        editVc = [SmartProductSellEditViewController new];
        titleText = @"编辑销售费用项";
    }
    editVc.orderObjectId = self.priceListViewController.orderObjectId;
    editVc.orderKeyId = self.priceListViewController.orderKeyId;
    editVc.brandCode = self.priceListViewController.brandCode;
    editVc.categoryCode = self.priceListViewController.categoryCode;
    editVc.title = titleText;
    editVc.feeInfos = cell.sellInfos;
    [self.priceListViewController pushViewController:editVc];
}

#pragma mark - cell's delegate

- (void)swipeCellRightButtonsDidShow:(WZSwipeCell*)cell
{
    WZSwipeCell *oldSelectedCell = _selectedCell;
    WZSwipeCell *newSelectedCell = cell;
    
    if (oldSelectedCell != newSelectedCell) {
        [oldSelectedCell hideRightButtons];
        _selectedCell = newSelectedCell;
    }
}

- (void)swipeCell:(WZSwipeCell*)swipeCell menuButtonSelected:(NSInteger)menuButtonTag
{
    SellFeeListCell *sellFeeListCell = (SellFeeListCell *)swipeCell;
    kSellFeeListHandleType handleType = (kSellFeeListHandleType)menuButtonTag;
    switch (handleType) {
        case kSellFeeListHandleTypeEdit:
            [self editFeeItem:handleType atCell:sellFeeListCell];
            break;
        case kSellFeeListHandleTypeDelete:
            [Util confirmAlertView:@"您确定要删除吗?" confirmAction:^{
                [self deleteFeeList:sellFeeListCell];
            }];
    }
}

@end
