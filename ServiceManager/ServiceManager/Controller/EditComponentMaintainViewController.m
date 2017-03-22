//
//  EditComponentMaintainViewController.m
//  ServiceManager
//
//  Created by will.wang on 2/17/16.
//  Copyright © 2016 wangzhi. All rights reserved.
//

/**
 *  添加或编辑备件
 */

#import "EditComponentMaintainViewController.h"
#import "TextFieldTableViewCell.h"
#import "ScanGraphicCodeViewController.h"
#import "PartsSearchViewController.h"

typedef NS_ENUM(NSInteger, kComponentMaitainOperateTarget)
{
    kComponentMaitainOperateTargetCheckOnPart = 0,  //选上件
    kComponentMaitainOperateTargetSearchOnPart,     //搜上件
    kComponentMaitainOperateTargetCheckOffPart,     //选下件
    kComponentMaitainOperateTargetSearchOffPart     //搜下件
};

@interface EditComponentMaintainViewController ()<WZSingleCheckViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    WZSingleCheckViewController *_screenCheckViewController;
    WZSingleCheckViewController *_partTypeCheckViewController;
    WZSingleCheckViewController *_partCheckViewController;
    
    CheckItemModel *_screenItem;
    CheckItemModel *_partTypeItem;
    CheckItemModel *_partItem;
    
    kComponentMaitainOperateTarget _operateTarget;
    RequestCallBackBlock commitCallBackBlock;
}

@property(nonatomic, strong)NSMutableArray *sectionTitleArray; //String
@property(nonatomic, strong)NSMutableArray *cellsArray; //2 array

//section 1
@property(nonatomic, strong)UITableViewCell *onPartNameCell;
@property(nonatomic, strong)UITableViewCell *onPartCodeCell;
@property(nonatomic, strong)UITableViewCell *onPartStatusCell;

//section 2
@property(nonatomic, strong)UITableViewCell *offPartNameCell;
@property(nonatomic, strong)UITableViewCell *offPartCodeCell;

//subviews
@property(nonatomic, strong)UIButton *scanBarCodeBtn;   //换上件
@property(nonatomic, strong)UIButton *scanBarCodeBtn2;  //换下件
@property(nonatomic, strong)UISegmentedControl *componentSegment; //new or applay

@property(nonatomic, strong)PartsContentInfo *onPartInfo; //换上件
@property(nonatomic, strong)PartsContentInfo *offPartInfo; //换下件

@property(nonatomic, strong)NSArray *screenArray;//item: NSString
@property(nonatomic, strong)NSArray *screenCheckArray;//item:CheckModelItem

@property(nonatomic, strong)NSArray *partTypesArray;//item:
@property(nonatomic, strong)NSArray *partTypesCheckArray;//item:CheckModelItem

@property(nonatomic, strong)NSArray *partsArray;//item:
@property(nonatomic, strong)NSArray *partsCheckArray;//item:CheckModelItem

@property(nonatomic, assign)BOOL isValueChanged;
@property(nonatomic, assign)BOOL isNew;

@property(nonatomic, strong)UITableView *tableView;
@end

@implementation EditComponentMaintainViewController

- (PartMaintainContent*)maintainContent{
    if (_maintainContent == nil) {
        _maintainContent = [PartMaintainContent new];
        _maintainContent.puton_part_number = @"1";
        _maintainContent.putoff_part_number = @"1";
        _maintainContent.puton_status = @"1";
        _maintainContent.putoff_status = @"1";
        _maintainContent.is_send_crm = @"1";

        self.isNew = YES;
    }
    return _maintainContent;
}

- (NSMutableArray*)sectionTitleArray{
    if (nil == _sectionTitleArray) {
        _sectionTitleArray = [[NSMutableArray alloc]init];
        [_sectionTitleArray addObject:@"换上件"];
        [_sectionTitleArray addObject:@"换下件"];
    }
    return _sectionTitleArray;
}

- (UITableView*)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView clearBackgroundColor];
        _tableView.backgroundView = nil;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kDefaultSpaceUnit, 0, kDefaultSpaceUnit));
    }];

    [self makeCustomSubViews];
    if ([self.maintainContent.puton_status isEqualToString:@"2"]) {
        self.componentSegment.selectedSegmentIndex = 1;
    }
    [self setContentDataToViews:self.maintainContent];

    [self setNavBarRightButton:@"提交" clicked:@selector(commitButtonClicked:)];
}

#pragma mark - data source & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.cellsArray[section];
    return sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewCellDefaultHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellDefaultHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellsArray[indexPath.section][indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *selCell = self.cellsArray[indexPath.section][indexPath.row];
    if (selCell == self.onPartNameCell) {
        if (self.isNew) {
            [self bomSearchLabelClicked:nil];
        }
    }else if (selCell == self.onPartCodeCell){
        if (self.isNew) {
            [self componentSearchLabelClicked:nil];
        }
    }else if (selCell == self.offPartNameCell){
        if (self.isNew) {
            [self changeTypeLabelClicked:nil];
        }
    }else if (selCell == self.offPartCodeCell){
        if (self.isNew) {
            [self destroyedComponentSearchLabelClicked:nil];
        }
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.textColor = kColorDefaultBlue;
    UIView *headerView = [tableView makeHeaderViewWithSubLabel:headerLabel bottomLineHeight:0];
    headerLabel.text = self.sectionTitleArray[section];

    return headerView;
}

- (void)setContentDataToViews:(PartMaintainContent*)content
{
    //set data
    self.onPartNameCell.detailTextLabel.text = [Util defaultStr:@"点击查询物料\t" ifStrEmpty:content.part_text];
    self.onPartNameCell.detailTextLabel.textColor = [Util isEmptyString:content.part_text] ? kColorLightGray: kColorBlack;

    self.onPartCodeCell.detailTextLabel.text = [Util defaultStr:@"点击搜索物料" ifStrEmpty:content.puton_part_matno];
    self.onPartCodeCell.detailTextLabel.textColor = [Util isEmptyString:content.puton_part_matno] ? kColorLightGray: kColorBlack;

    self.offPartNameCell.detailTextLabel.text = [Util defaultStr:@"点击查询物料\t" ifStrEmpty:content.putoff_part_text];
    self.offPartNameCell.detailTextLabel.textColor = [Util isEmptyString:content.putoff_part_text] ? kColorLightGray: kColorBlack;

    self.offPartCodeCell.detailTextLabel.text = [Util defaultStr:@"点击搜索物料" ifStrEmpty:content.putoff_part_matno];
    self.offPartCodeCell.detailTextLabel.textColor = [Util isEmptyString:content.putoff_part_matno] ? kColorLightGray: kColorBlack;

    self.onPartStatusCell.accessoryView = self.componentSegment;
    
    if (!self.isNew) {
        self.onPartNameCell.detailTextLabel.textColor = kColorLightGray;
        self.onPartCodeCell.detailTextLabel.textColor = kColorLightGray;
        self.offPartNameCell.detailTextLabel.textColor = kColorLightGray;
        self.offPartCodeCell.detailTextLabel.textColor = kColorLightGray;
    }
    self.scanBarCodeBtn.enabled = self.isNew;
    self.scanBarCodeBtn2.enabled = self.isNew;
}

-(UISegmentedControl*)makeSegmentedControl
{
    UISegmentedControl *segment;
    segment = [[UISegmentedControl alloc]initWithItems:@[@"创建",@"申请"]];
    [segment addTarget:self action:@selector(componentSegmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    segment.tintColor = kColorDefaultOrange;
    segment.selectedSegmentIndex = 0;
    
    return segment;
}

- (UILabel*)makeLabel:(NSString*)placeHolder clickAction:(SEL)clickAction
{
    UILabel *label = [[UILabel alloc]init];
    [label clearBackgroundColor];
    label.textColor = kColorDarkGray;
    label.font = SystemFont(14);
    label.text = placeHolder;
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    
    if (clickAction) {
        [label addSingleTapEventWithTarget:self action:clickAction];
    }
    return label;
}

- (UITableViewCell*)makeTableViewCell:(NSString*)title value:(NSString*)value
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = title;
    cell.textLabel.font = SystemFont(14);
    cell.textLabel.textColor = kColorDarkGray;

    cell.detailTextLabel.text = value;
    cell.detailTextLabel.font = SystemFont(15);
    cell.detailTextLabel.textColor = kColorBlack;
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)makeCustomSubViews
{
    NSMutableArray *sectionCells = [[NSMutableArray alloc]init];
    self.cellsArray = [[NSMutableArray alloc]init];

    //onPart name cell
    self.onPartNameCell = [self makeTableViewCell:@"物料名称" value:@"查询物料"];
    _scanBarCodeBtn = [UIButton imageButtonWithNorImg:@"dealer_erweima" selImg:@"dealer_erweima" size:CGSizeMake(40, 40) target:self action:@selector(scanBarCodeButtonClicked:)];
    [_scanBarCodeBtn setImage:ImageNamed(@"dealer_erweima_disable") forState:UIControlStateDisabled];
    self.onPartNameCell.accessoryView = _scanBarCodeBtn;
    [sectionCells addObject:self.onPartNameCell];
    
    //onPart code cell
    self.onPartCodeCell = [self makeTableViewCell:@"物料代码" value:@"搜索物料"];
    self.onPartCodeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [sectionCells addObject:self.onPartCodeCell];

    //onPart status cell
    self.onPartStatusCell = [self makeTableViewCell:@"物料状态" value:nil];
    _componentSegment = [self makeSegmentedControl];
    [sectionCells addObject:self.onPartStatusCell];

    [self.cellsArray addObject:sectionCells];
    sectionCells = [[NSMutableArray alloc]init];

    //offPart name cell
    self.offPartNameCell = [self makeTableViewCell:@"物料名称" value:@"查询物料"];
    _scanBarCodeBtn2 = [UIButton imageButtonWithNorImg:@"dealer_erweima" selImg:@"dealer_erweima" size:CGSizeMake(40, 40) target:self action:@selector(scanBarCodeButtonClicked:)];
    [_scanBarCodeBtn2 setImage:ImageNamed(@"dealer_erweima_disable") forState:UIControlStateDisabled];
    self.offPartNameCell.accessoryView = _scanBarCodeBtn2;
    [sectionCells addObject:self.offPartNameCell];

    //offPart code cell
    self.offPartCodeCell = [self makeTableViewCell:@"物料代码" value:@"搜索物料"];
    self.offPartCodeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [sectionCells addObject:self.offPartCodeCell];

    [self.cellsArray addObject:sectionCells];
}

- (NSArray*)changeScreensToCheckItems
{
    NSMutableArray *checkItems = [[NSMutableArray alloc]init];
    
    for (NSString *screen in self.screenArray) {
        CheckItemModel *model = [[CheckItemModel alloc]init];
        model.key = screen;
        model.value = screen;
        [checkItems addObject:model];
    }
    return checkItems;
}

- (NSArray*)changePartTypesToCheckItems
{
    NSMutableArray *checkItems = [[NSMutableArray alloc]init];
    
    for (NSString *partType in self.partTypesArray) {
        CheckItemModel *model = [[CheckItemModel alloc]init];
        model.key = partType;
        model.value = model.key;
        [checkItems addObject:model];
    }
    return checkItems;
}

- (NSArray*)changePartListToCheckItems
{
    NSMutableArray *checkItems = [[NSMutableArray alloc]init];
    
    for (NSDictionary *partDic in self.partsArray) {
        CheckItemModel *model = [[CheckItemModel alloc]init];
        model.key = [partDic objForKey:@"part_matno"];
        model.value = [partDic objForKey:@"part_desc"];
        [checkItems addObject:model];
    }
    return checkItems;
}

- (void)pushToScreenCheckViewController
{
    self.screenCheckArray = [self changeScreensToCheckItems];
    
    _screenCheckViewController = [MiscHelper pushToCheckListViewController:@"选择备件" checkItems:self.screenCheckArray checkedItem:_screenItem from:self delegate:self];
    _screenCheckViewController.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)pushToPartTypesCheckViewController
{
    self.partTypesCheckArray = [self changePartTypesToCheckItems];
    
    _partTypeCheckViewController = [MiscHelper pushToCheckListViewController:@"选择备件" checkItems:self.partTypesCheckArray checkedItem:_partTypeItem from:self delegate:self];
    _partTypeCheckViewController.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)pushToPartListCheckViewController
{
    self.partsCheckArray = [self changePartListToCheckItems];
    _partCheckViewController = [MiscHelper pushToCheckListViewController:@"选择备件" checkItems:self.partsCheckArray checkedItem:_partItem from:self delegate:self];
}

- (void)requestScreensAndShow
{
    RepairerSelectPartsInputParams *input = [RepairerSelectPartsInputParams new];
    input.mac_product_id = self.productInfo.product_id;
    input.zzfld000003 = self.productInfo.zz0017;
    
    [Util showWaitingDialog];
    [[HttpClientManager sharedInstance]repairer_selectParts:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            self.screenArray = responseData.resultData;
            if ([self.screenArray isKindOfClass:[NSArray class]]
                && self.screenArray.count > 0) {
                [self pushToScreenCheckViewController];
            }
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)requestPartTypesAndShow
{
    RepairerPartTypesInputParams *input = [RepairerPartTypesInputParams new];
    input.mac_product_id = self.productInfo.product_id;
    input.zzfld000003 = self.productInfo.zz0017;
    input.screen_model = _screenItem.key;
    
    [Util showWaitingDialog];
    [[HttpClientManager sharedInstance]repairer_partTypes:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            self.partTypesArray = responseData.resultData;
            if ([self.partTypesArray isKindOfClass:[NSArray class]]
                && self.partTypesArray.count > 0) {
                [self pushToPartTypesCheckViewController];
            }
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)requestPartListAndShow
{
    RepairerPartListInputParams *input = [RepairerPartListInputParams new];
    input.mac_product_id = self.productInfo.product_id;
    input.zzfld000003 = self.productInfo.zz0017;
    input.screen_model = _screenItem.key;
    input.part_name = _partTypeItem.key;
    
    [Util showWaitingDialog];
    [[HttpClientManager sharedInstance]repairer_partList:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            self.partsArray = responseData.resultData;
            if ([self.partsArray isKindOfClass:[NSArray class]]
                && self.partsArray.count > 0) {
                [self pushToPartListCheckViewController];
            }
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)requestPartContent
{
    RepairerPartGetInputParams *input = [RepairerPartGetInputParams new];
    input.mac_product_id = self.productInfo.product_id;
    input.part_product_id = _partItem.key;
    
    [Util showWaitingDialog];
    [[HttpClientManager sharedInstance]repairer_partFindInfo:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            NSArray *array = responseData.resultData;
            if (array.count > 0) {
                //get data and show to views
                PartsContentInfo *content = [[PartsContentInfo alloc]initWithDictionary:array[0]];
                if (_operateTarget == kComponentMaitainOperateTargetCheckOnPart) {
                    [self updateOnPartContent:content];
                }else if (_operateTarget == kComponentMaitainOperateTargetCheckOffPart){
                    [self updateOffPartContent:content];
                }
            }
            UIViewController *currentActiveVc = [self.navigationController.viewControllers lastObject];
            [currentActiveVc popTo:self];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

//检查是否能添加此备件
-(BOOL)couldAddComponent:(PartsContentInfo*)component
{
    for (PartMaintainContent *part in self.componentArray) {
        if (![Util isEmptyString:part.puton_part_matno]
            && [part.puton_part_matno isEqualToString:component.product_id]) {
            if (![part.puton_status isEqualToString:@"10"]
                && ![part.puton_status isEqualToString:@"11"]) {
                return NO;
            }
        }
    }
    return YES;
}

//set data and show to ui
- (void)updateOnPartContent:(PartsContentInfo*)content
{
    BOOL couldAdd = [self couldAddComponent:content];
    
    if (couldAdd) {
        self.isValueChanged = YES;
        
        self.onPartInfo = content;
        self.maintainContent.parts_bominfo_id = content.parts_bominfo_id;
        self.maintainContent.parts_maininfo_id = content.Id;
        self.maintainContent.puton_part_matno = content.product_id;
        self.maintainContent.part_text = content.short_text;
        
        self.offPartInfo = content;
        self.maintainContent.putoff_part_matno = content.product_id;
        self.maintainContent.putoff_part_text = content.short_text;
        
        [self setContentDataToViews:self.maintainContent];
    }else {
        [Util showToast:@"已添加过此备件，不能重复添加"];
    }
}

//set data and show to ui
- (void)updateOffPartContent:(PartsContentInfo*)content
{
    self.isValueChanged = YES;
    
    self.offPartInfo = content;
    self.maintainContent.putoff_part_matno = content.product_id;
    self.maintainContent.putoff_part_text = content.short_text;
    
    [self setContentDataToViews:self.maintainContent];
}

- (void)gotoPartsSearchViewController {
    PartsSearchViewController *partSearchVc = [[PartsSearchViewController alloc]init];
    partSearchVc.productInfo = self.productInfo;
    partSearchVc.modelSelectedBlock = ^(ViewController *viewController, PartsContentInfo *part){
        if (_operateTarget == kComponentMaitainOperateTargetSearchOnPart) {
            [self updateOnPartContent:part];
        }else if (_operateTarget == kComponentMaitainOperateTargetSearchOffPart){
            [self updateOffPartContent:part];
        }
        [viewController popViewController];
    };
    [self pushViewController:partSearchVc];
}

- (void)scanBarCodeButtonClicked:(UIButton*)sender
{
    BOOL isOnPart = (sender == self.scanBarCodeBtn);

    [ScanGraphicCodeViewController fastScanWithComplete:^(NSString *codeText) {
        [self getPartInfoByMachineCode:codeText isOnPart: isOnPart];
    } fromViewController:self];
}

- (void)bomSearchLabelClicked:(UIGestureRecognizer*)sender
{
    _operateTarget = kComponentMaitainOperateTargetCheckOnPart;
    [self requestScreensAndShow];
}

- (void)componentSearchLabelClicked:(UIGestureRecognizer*)sender
{
    _operateTarget = kComponentMaitainOperateTargetSearchOnPart;
    [self gotoPartsSearchViewController];
}

- (void)destroyedComponentSearchLabelClicked:(UIButton*)sender
{
    _operateTarget = kComponentMaitainOperateTargetSearchOffPart;
    [self gotoPartsSearchViewController];
}

- (void)componentSegmentValueChanged:(UISegmentedControl*)segment
{
    if (segment == self.componentSegment) {
        self.maintainContent.puton_status = (0 == segment.selectedSegmentIndex) ? @"1" : @"2";
        self.isValueChanged = YES;
    }
}

- (void)changeTypeLabelClicked:(UIGestureRecognizer*)segment
{
    _operateTarget = kComponentMaitainOperateTargetCheckOffPart;
    [self requestScreensAndShow];
}

- (void)singleCheckViewController:(WZSingleCheckViewController*)viewController didChecked:(CheckItemModel*)checkedItem
{
    if (viewController == _screenCheckViewController) {
        _screenItem = checkedItem;
        [self requestPartTypesAndShow];
    }else if (viewController == _partTypeCheckViewController){
        _partTypeItem = checkedItem;
        [self requestPartListAndShow];
    }else if (viewController == _partCheckViewController){
        _partItem = checkedItem;
        [self requestPartContent];
    }
}

- (void)getPartInfoByMachineCode:(NSString*)machineCode isOnPart:(BOOL)isOnPart
{
    GetPartsInfoInputParams *input = [GetPartsInfoInputParams new];
    input.partsBarcode = machineCode;
    
    [Util showWaitingDialog];
    [[HttpClientManager sharedInstance]repairer_getPartsInfo:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            PartsContentInfo *content = [[PartsContentInfo alloc]initWithDictionary:responseData.resultData];
            if (isOnPart) {
                [self updateOnPartContent:content];
            }else {
                [self updateOffPartContent:content];
            }
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)newComponentMaintainItemToServer:(RequestCallBackBlock)requestCallBackBlock
{
    //delete from server
    PartMaintainContent *content = self.maintainContent;
    
    RepairerAddPartInputParams *input = [RepairerAddPartInputParams new];
    input.object_id = [self.orderDetails.object_id description];//工单号
    input.parts_maininfo_id = [content.parts_maininfo_id description];//主数据表id
    input.parts_bominfo_id = [content.parts_bominfo_id description];//Bom表id
    input.putoff_part_matno = [content.putoff_part_matno description];//换下件物料
    input.putoff_part_number = content.putoff_part_number;//换下件数量
    input.putoff_status = content.putoff_status;//换下件状态，默认1创建
    input.puton_part_matno = content.puton_part_matno;//换上件物料
    input.puton_part_number = content.puton_part_number;//换上件数量
    input.puton_status = content.puton_status;//换上件状态
    
    [self.httpClient repairer_addPart:input response:requestCallBackBlock];
}

- (void)updateComponentMaintainItemToServer:(RequestCallBackBlock)requestCallBackBlock
{
    PartMaintainContent *content = self.maintainContent;

    RepairerUpdatePartInputParams *input = [RepairerUpdatePartInputParams new];
    input.puton_status = [content.puton_status description];//换上件状态
    input.dispatchparts_id = [content.dispatch_parts_id description];
    
    [self.httpClient repairer_updatePart:input response:requestCallBackBlock];
}

- (void)commitButtonClicked:(id)sender
{
    if (!self.isNew && !self.isValueChanged) {
        [Util showToast:@"备件信息无变更，无需提交"];
        return;
    }

    //check data
    if (![MiscHelper isMaintainContentIntegrateForNew:self.maintainContent]) {
        [Util showToast:@"备件信息不完整，不能提交"];
        return;
    }

    __weak typeof(&*self)weakSelf = self;
    commitCallBackBlock = ^(NSError *error, HttpResponseData *responseData){
        [Util dismissWaitingDialog];
        if (!error && kHttpReturnCodeSuccess==responseData.resultCode){
            [Util showToast:@"提交成功"];
            if ([responseData.resultData isKindOfClass:[NSDictionary class]] && [responseData.resultData containsKey:@"dispatchPartsId"]) {
                weakSelf.maintainContent.dispatch_parts_id = [[responseData.resultData objForKey:@"dispatchPartsId"]description];
            }
            [weakSelf postNotification:NotificationOrderDetailsChanged];
            if ([weakSelf.delegate respondsToSelector:@selector(componentMaintainEditCellDidEdit:)]) {
                [weakSelf.delegate componentMaintainEditCellDidEdit:weakSelf.maintainContent];
            }
            [weakSelf popViewController];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    };
    
    [Util showWaitingDialog];
    if (self.isNew) { //新增备件
        [self newComponentMaintainItemToServer:commitCallBackBlock];
    }else {//更新备件状态
        [self updateComponentMaintainItemToServer:commitCallBackBlock];
    }
}

@end
