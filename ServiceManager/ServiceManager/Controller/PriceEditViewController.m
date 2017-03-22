//
//  AddRepairerViewController.m
//  ServiceManager
//
//  Created by mac on 15/10/5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "PriceEditViewController.h"
#import "LabelEditCell.h"
#import <UIAlertView+Blocks.h>
#import "PleaseSelectViewCell.h"

@interface PriceEditViewController ()
@property(nonatomic, strong)PleaseSelectViewCell *serviceTypeCell; //服务类型
@property(nonatomic, strong)LabelEditCell *priceCell;   //价格
@property(nonatomic, strong)LabelEditCell *receiptCell; //收据合同号
@property(nonatomic, strong)NSMutableArray *cellArray;
@end

@implementation PriceEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [UIView new];

    [self setNavBarRightButton:@"提交" clicked:@selector(commitButtonClicked:)];

    [self setupTableViewCells];
    [self updateTableViewCellsData];
}

- (PleaseSelectViewCell*)serviceTypeCell{
    if (nil == _serviceTypeCell) {
        NSArray *itemArray = [[ConfigInfoManager sharedInstance] findConfigItemsByType:MainConfigInfoTableType31 superCode:self.brandCode superParentCode:self.categoryCode];
        itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
        CheckItemModel *defaultItem;
        if (itemArray.count > 0) {
            defaultItem = itemArray[0];
        }
        _serviceTypeCell = [MiscHelper makeSelectItemCell:@"服务物料代码" checkItems:itemArray checkedItem:defaultItem];
    }
    return _serviceTypeCell;
}

- (LabelEditCell*)priceCell
{
    if (nil == _priceCell) {
        _priceCell = [LabelEditCell makeLabelEditCell:@"金额 (元)" hint:@"请输入金额" keyBoardType:UIKeyboardTypeNumberPad unit:nil];
        _priceCell.middleTextField.textAlignment = NSTextAlignmentCenter;
        _priceCell.middleTextField.textColor = kColorDefaultRed;
        _priceCell.middleTextField.font = SystemFont(16);
    }
    return _priceCell;
}

- (LabelEditCell*)receiptCell
{
    if (nil == _receiptCell) {
        _receiptCell = [LabelEditCell makeLabelEditCell:@"保外收据号" hint:@"请输入保外收据号" keyBoardType:UIKeyboardTypeASCIICapable unit:nil];
        _receiptCell.middleTextField.textAlignment = NSTextAlignmentCenter;
    }
    return _receiptCell;
}

- (NSMutableArray*)cellArray
{
    if (nil == _cellArray) {
        _cellArray = [[NSMutableArray alloc]init];
    }
    return _cellArray;
}

- (void)setupTableViewCells
{
    [self.cellArray addObject:self.serviceTypeCell];
    [self.cellArray addObject:self.priceCell];
    [self.cellArray addObject:self.receiptCell];
}

- (void)updateTableViewCellsData
{
    //service type
    CheckItemModel *serviceType = self.serviceTypeCell.checkedItem;
    for (CheckItemModel *model in self.serviceTypeCell.checkItems) {
        if ([model.key isEqualToString:self.feeInfos.orderedProd]) {
            serviceType = model;
            break;
        }
    }
    self.serviceTypeCell.checkedItem = serviceType;

    //price
    if (self.feeInfos.netValue) {
        self.priceCell.middleTextField.text = [NSString intStr:[self.feeInfos.netValue integerValue]];
    }
    
    //receipt No.
    self.receiptCell.middleTextField.text = self.feeInfos.zzfld00002v;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kDefaultSpaceUnit * 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellDefaultHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellArray[indexPath.row];
}

- (void)dismissKeyBoard
{
    [self.priceCell.middleTextField resignFirstResponder];
    [self.receiptCell.middleTextField resignFirstResponder];
}

-(void)commitButtonClicked:(UIButton*)regBtn
{
    NSString *inValidError;

    do {
        if (nil == self.serviceTypeCell.checkedItem) {
            inValidError = @"请选择服务物料代码";
        }
        BreakIf(nil != inValidError);

        //check receipt No.
        NSString *tempStr = self.receiptCell.middleTextField.text;
        if (self.user.isCreate) {
            if ([Util isEmptyString:tempStr]) {
                inValidError = @"请填写保外收据号";
                BreakIf(nil != inValidError);
            }
        }
        if (![Util isEmptyString:tempStr] && ![MiscHelper isValidReceiptNumber:tempStr]) {
            inValidError = @"请填写正确的保外收据号";
        }
        BreakIf(nil != inValidError);

        inValidError = [MiscHelper checkNumberInput:self.priceCell.middleTextField.text name:@"金额" greaterThan:0];
        BreakIf(nil != inValidError);

    } while (0);

    if (nil != inValidError) {
        [Util showToast:inValidError];
    }else {
        EditFeeOrderInputParams *input = [EditFeeOrderInputParams new];
        input.expenseId = self.feeInfos.Id.description;
        input.objectId = self.orderObjectId.description;
        input.dispatchinfoId = self.orderKeyId.description;
        input.orderedProd = self.serviceTypeCell.checkedItem.key;
        input.itmType = @"ZRVW";
        input.quantity = [NSString intStr:1];
        input.netValue = self.priceCell.middleTextField.text;
        input.zzfld00002v = self.receiptCell.middleTextField.text;
        input.operate_type = (nil == self.feeInfos.Id) ? @"-2" : @"-3";
        [self editFeeOrder:input];
    }
}

@end
