//
//  LetvFeeEditViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/24.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvFeeEditViewController.h"
#import "LabelEditCell.h"
#import "TableViewDataHandle.h"

@interface LetvFeeEditViewController ()<WZTableViewDelegate, WZSingleCheckViewControllerDelegate>
{
    WZSingleCheckViewController *_feeItemTypeCheckViewController;
}

@property(nonnull, strong)TableViewDataHandle *sourceModel;

@property(nonatomic, strong)UITableViewCell *serviceTypeCell; //服务类型
@property(nonatomic, strong)PleaseSelectViewCell *handelCell; //处理代码
@property(nonatomic, strong)LabelEditCell *letvCodeCell;   //乐视代码
@property(nonatomic, strong)LabelEditCell *sftVersionCell;   //软件版本
@property(nonatomic, strong)LabelEditCell *receiptCell; //合同号

@property(nonatomic, strong)LetvBomContent *feeItemType; //费用用类型（物料代码）
@property(nonatomic, strong)NSArray *feeItemTypeArray; //CheckItemModel array
@end

@implementation LetvFeeEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createMembers];
    [self initMembers];
    
    [self setupTableViewCellModels];
}

//检查是否需要合同号
- (BOOL)checkIfNeedContractNum:(NSString*)letvCode{
    //乐视代码以'x'或'X'开头时，合同号必填；否则，选填。
    return [[letvCode uppercaseString]hasPrefix:@"X"];
}

- (LabelEditCell*)makeLabelEditCell:(NSString*)label hint:(NSString*)hintText
{
    LabelEditCell *editCell;

    editCell = [LabelEditCell makeLabelEditCell:label hint:hintText keyBoardType:UIKeyboardTypeDefault unit:nil];
    editCell.middleTextField.textAlignment = NSTextAlignmentCenter;
    editCell.middleTextField.font = SystemFont(15);
    
    return editCell;
}

- (void)createMembers
{
    //物料代码
    _serviceTypeCell = [MiscHelper makeCommonSelectCell:@"物料代码"];
    [_serviceTypeCell addLineTo:kFrameLocationBottom];

    //处理代码
    NSArray *itemArray = [self.configInfoMgr letv_handleCodes];
    itemArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:itemArray];
    _handelCell = [MiscHelper makeSelectItemCell:@"处理代码" checkItems:itemArray checkedItem:nil];

    //乐视代码
    _letvCodeCell = [self makeLabelEditCell:@"乐视代码" hint:nil];
    _letvCodeCell.middleTextField.enabled = NO;

    //软件版本
    _sftVersionCell = [self makeLabelEditCell:@"软件版本" hint:@"请输入软件版本"];

    //软件版本
    _receiptCell = [self makeLabelEditCell:@"延保合同号" hint:@"请输入延保合同号"];
    _receiptCell.middleTextField.keyboardType = UIKeyboardTypeNumberPad;

    [self setNavBarRightButton:@"提交" clicked:@selector(commitButtonClicked:)];
}

//物料代码
- (void)updateFeeItemType:(LetvBomContent*)itemCodeContent
{
    self.feeItemType = itemCodeContent;
    self.serviceTypeCell.detailTextLabel.text = [Util defaultStr:@"请选择" ifStrEmpty:self.feeItemType.bomDesc];
    self.letvCodeCell.middleTextField.text = [Util defaultStr:@"" ifStrEmpty:self.feeItemType.letvCodeName];
}

- (LetvBomContent*)getItemCodeContent:(LetvSellFeeListInfos*)feeItem
{
    LetvBomContent *content = [[LetvBomContent alloc]init];
    content.bomCode = feeItem.bomCode;
    content.bomDesc = feeItem.Description;
    content.letvCode = feeItem.letvCode;
    content.letvCodeName = feeItem.letvCodeName;

    return content;
}

- (void)setViewsDataWithLetvFeeInfos:(LetvSellFeeListInfos*)feeItem
{
    //fee type
    [self updateFeeItemType:[self getItemCodeContent:feeItem]];

    //handle code
    CheckItemModel *handleCode = self.handelCell.checkedItem;
    for (CheckItemModel *model in self.handelCell.checkItems) {
        if ([model.key isEqualToString:self.letvFeeInfos.handleCode]) {
            handleCode = model;
            break;
        }
    }
    self.handelCell.checkedItem = handleCode;

    //letv code
    self.letvCodeCell.middleTextField.text = self.letvFeeInfos.letvCodeName;

    //sft version
    self.sftVersionCell.middleTextField.text = self.letvFeeInfos.softwareVersion;
    
    //receipt
    self.receiptCell.middleTextField.text = self.letvFeeInfos.contractNum;
}

- (void)initMembers
{
    self.tableView.tableViewDelegate = self;

    if (self.letvFeeInfos) {
        [self setViewsDataWithLetvFeeInfos:self.letvFeeInfos];
    }
}

- (void)requestFeeItemTypes:(NSString*)model
{
    LetvQueryBomCodesInputParams *input = [[LetvQueryBomCodesInputParams alloc]init];
    input.model = self.machineModelCode;
    
    [Util showWaitingDialog];
    [self.httpClient letv_queryBomCodes:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            NSArray *tempItems = [MiscHelper parserObjectList:responseData.resultData objectClass:@"LetvBomContent"];
            self.feeItemTypeArray = [self convertLetvBomContentsToCheckItems:tempItems];
            [self pushToCheckListVcToSelectFeeItem];
        }else{
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (NSArray*)convertLetvBomContentsToCheckItems:(NSArray*)letvBomArray
{
    NSMutableArray *items = [[NSMutableArray alloc]init];
    
    for (LetvBomContent *letvBom in letvBomArray) {
        CheckItemModel *model = [CheckItemModel modelWithValue:letvBom.bomDesc forKey:letvBom.bomCode];
        model.extData = letvBom;
        [items addObject:model];
    }
    return items;
}

- (void)pushToCheckListVcToSelectFeeItem
{
    CheckItemModel *selectItem = [self getSelectedItemLastTime];
    _feeItemTypeCheckViewController = [MiscHelper pushToCheckListViewController:self.serviceTypeCell.textLabel.text checkItems:self.feeItemTypeArray checkedItem:selectItem from:self delegate:self];
}

- (CheckItemModel*)getSelectedItemLastTime
{
    ReturnIf([Util isEmptyString:self.feeItemType.bomCode])nil;

    CheckItemModel *seletedItem = [CheckItemModel modelWithValue:self.feeItemType.bomDesc forKey:self.feeItemType.bomCode];
    for (CheckItemModel *item in self.feeItemTypeArray) {
        if ([item isEqual:seletedItem]) {
            return item;
        }
    }
    return nil;
}

- (void)setupTableViewCellModels
{
    if (nil == _sourceModel) {
        _sourceModel = [[TableViewDataHandle alloc]init];
    }else {
        [_sourceModel cleanDataSourceModel];
    }

    [_sourceModel setHeaderData:nil forSection:0];
    
    TableViewCellData *cellData;
    NSInteger rowIndex = 0;
    
    NSMutableArray *cellArray = [[NSMutableArray alloc]init];
    [cellArray addObject:self.serviceTypeCell];
    [cellArray addObject:self.handelCell];
    [cellArray addObject:self.letvCodeCell];
    [cellArray addObject:self.sftVersionCell];

    BOOL needContractNum = [self checkIfNeedContractNum:self.feeItemType.letvCode];
    if (needContractNum) {
        [cellArray addObject:self.receiptCell];
    }
    for (NSObject *rowCell in cellArray) {
        cellData = [TableViewCellData makeWithOtherData:rowCell];
        [_sourceModel setCellData:cellData forSection:0 row:rowIndex++];
    }
}

- (void)commitButtonClicked:(UIButton*)sender
{
    LetvEditFeeOrderInputParams *feeItem = [self readFeeOrderInfo];
    NSString *invaildStr = [self checkFeeOrderInfo:feeItem];
    if (![Util isEmptyString:invaildStr]) {
        [Util showToast:invaildStr];
    }else {
        [self commitFeeOrderInfo:feeItem];
    }
}

- (LetvEditFeeOrderInputParams*)readFeeOrderInfo
{
    LetvEditFeeOrderInputParams *feeItem = [[LetvEditFeeOrderInputParams alloc]init];
    feeItem.Id = self.letvFeeInfos.Id.description;
    feeItem.bomCode = self.feeItemType.bomCode;
    feeItem.Description = self.feeItemType.bomDesc;
    feeItem.handleCode = self.handelCell.checkedItem.key;
    feeItem.letvCode = self.feeItemType.letvCode;
    feeItem.softwareVersion = self.sftVersionCell.middleTextField.text;
    feeItem.contractNum = self.receiptCell.middleTextField.text;
    feeItem.itmType = @"ZRV1";
    feeItem.dispatchInfoId = self.orderKeyId;
    feeItem.objectId = self.orderObjectId;

    return feeItem;
}

- (NSString*)checkFeeOrderInfo:(LetvEditFeeOrderInputParams*)feeItem
{
    NSString *invaildStr;
    
    do {
        if (self.letvFeeInfos && nil == self.letvFeeInfos.Id) {
            invaildStr = @"费用项编号为空";
            break;
        }
        if ([Util isEmptyString:feeItem.bomCode]) {
            invaildStr = @"请选择物料代码";
            break;
        }
        if ([Util isEmptyString:feeItem.Description]) {
            invaildStr = @"请选择物料代码";
            break;
        }
        if ([Util isEmptyString:feeItem.handleCode]) {
            invaildStr = @"请选择处理代码";
            break;
        }
        //乐视代码 后台判断了，不作判断

        //feeItem.softwareVersion 选填
        if (![Util isEmptyString:feeItem.softwareVersion]) {
            if (feeItem.softwareVersion.length > 40) {
                invaildStr = @"软件版本不能大于40个字符";
                break;
            }
        }

        BOOL needContractNum = [self checkIfNeedContractNum:feeItem.letvCode];
        if (needContractNum) {
            if ([Util isEmptyString:feeItem.contractNum]) {
                invaildStr = @"请填写延保合同号";
                break;
            }
            if (feeItem.contractNum.length != 10) {
                invaildStr = @"请填写10位数字延保合同号";
                break;
            }
            if (![feeItem.contractNum isPureInt]) {
                invaildStr = @"请填写10位数字延保合同号";
                break;
            }
        }else {
            feeItem.contractNum = @"";
        }

        if ([Util isEmptyString:feeItem.dispatchInfoId]) {
            invaildStr = @"工单表主键不能为空";
            break;
        }
        if ([Util isEmptyString:feeItem.objectId]) {
            invaildStr = @"工单号不能为空";
            break;
        }
    } while (0);
    
    return invaildStr;
}

- (void)dismissKeyBoard
{
    [self.letvCodeCell.middleTextField resignFirstResponder];
    [self.sftVersionCell.middleTextField resignFirstResponder];
    [self.receiptCell.middleTextField resignFirstResponder];
}

- (void)commitFeeOrderInfo:(LetvEditFeeOrderInputParams*)feeItem
{
    [self dismissKeyBoard];
    
    [Util showWaitingDialog];
    [self.httpClient letv_editFeeOrder:feeItem response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error && (kHttpReturnCodeSuccess == responseData.resultCode)) {
            [self popViewController];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}


#pragma mark - Tableview delegate & data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sourceModel numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellDefaultHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellData *cellData = [_sourceModel cellDataForSection:indexPath.section row:indexPath.row];

    return (UITableViewCell*)cellData.otherData;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    TableViewCellData *cellData = [_sourceModel cellDataForSection:indexPath.section row:indexPath.row];
    UITableViewCell *selectCell = (UITableViewCell*)cellData.otherData;

    if (selectCell == self.serviceTypeCell) {
        if (self.feeItemTypeArray.count > 0) {
            [self pushToCheckListVcToSelectFeeItem];
        }else {
            [self requestFeeItemTypes:self.machineModelCode];
        }
    }
}

#pragma mark - fee item selected

- (void)singleCheckViewController:(WZSingleCheckViewController*)viewController didChecked:(CheckItemModel*)checkedItem
{
    if (_feeItemTypeCheckViewController == viewController){ //选择街道
        LetvBomContent *itemCode = (LetvBomContent*)checkedItem.extData;
        [self updateFeeItemType:itemCode];
        [self setupTableViewCellModels];
        [self.tableView.tableView reloadData];
        [viewController popViewController];
    }
}

@end
