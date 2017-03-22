//
//  ConfirmSupportViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/8/31.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ConfirmSupportViewController.h"
#import "LeftTextRightTextCell.h"
#import "TitleStarCell.h"

@interface ConfirmSupportViewController ()<WZTableViewDelegate>

//ITEM: NSArray(item: KeyValueModel)
@property(nonatomic, strong)NSMutableDictionary *cellDic;

@property(nonatomic, strong)TitleStarCell *starCell;
@property(nonatomic, strong)WZTextView *evaluateNote;//备注
@property(nonatomic, strong)UITableViewCell *evaluateNoteCell;

@property(nonatomic, strong)OrderContentDetails *orderDetails;

@end

@implementation ConfirmSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"技术确认";

    _cellDic = [[NSMutableDictionary alloc]init];

    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kTableViewLeftPadding, 0, kTableViewLeftPadding));
    }];

    _evaluateNote = [[WZTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 2*kTableViewLeftPadding, 38*2) maxWords:300];
    _evaluateNote.placeholder = @"请对本次服务进行评价";
    _evaluateNoteCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [_evaluateNoteCell.contentView addSubview:_evaluateNote];
    [_evaluateNoteCell clearBackgroundColor];
    [_evaluateNoteCell.contentView clearBackgroundColor];
    _starCell = [[TitleStarCell alloc]initWithTitle:@"评分" score:0.8];
    _starCell.backgroundColor = kColorClear;
    _starCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [_starCell addLineTo:kFrameLocationBottom];

    [self.tableView refreshTableViewData];
}

- (WZTableView*)tableView
{
    if (nil == _tableView) {
        _tableView = [[WZTableView alloc]initWithStyle:UITableViewStyleGrouped delegate:self];
        _tableView.tableView.headerHidden = YES;
        _tableView.tableView.footerHidden = YES;
        _tableView.pageInfo.pageSize = MAXFLOAT;
        [_tableView clearBackgroundColor];
        [_tableView.tableView clearBackgroundColor];
        _tableView.tableView.backgroundView = nil;
        _tableView.tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (UIView*)customFooterView
{
    if (nil == _customFooterView) {
        CGRect frame = CGRectMake(0, 0, ScreenWidth - 2*kTableViewLeftPadding, kButtonDefaultHeight + kDefaultSpaceUnit * 2);
        _customFooterView = [[UIView alloc]initWithFrame:frame];
        [_customFooterView clearBackgroundColor];
        
        //add confirm button
        frame.size.height = kButtonDefaultHeight;
        _confirmButton = [UIButton redButton:@"提交"];
        [_confirmButton setBackgroundColor:kColorLightGray forState:UIControlStateDisabled];
        _confirmButton.frame = frame;
        _confirmButton.center = _customFooterView.center;
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_customFooterView addSubview:_confirmButton];
    }
    return _customFooterView;
}

- (LeftTextRightTextCell*)makeAttrTableViewCell:(NSString*)identifier
{
    LeftTextRightTextCell *cell = [[LeftTextRightTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell clearBackgroundColor];
    cell.leftTextLabel.textColor = kColorBlack;
    cell.leftTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.rightTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.rightTextLabel.textAlignment = NSTextAlignmentLeft;
    cell.backgroundView = nil;
//    [cell layoutCustomSubViews];
    [cell addLineTo:kFrameLocationBottom];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSMutableArray*)buildCellItemData
{
    NSMutableArray *sectionArray = [NSMutableArray new];
    NSMutableArray *rowArray;
    KeyValueModel *rowData;
    
    //section
    rowArray = [NSMutableArray new];
    rowData = [KeyValueModel new];  //row
    rowData.key = @"姓名";
    rowData.value = [Util defaultStr:kUnknown ifStrEmpty:self.orderContent.supporterName];
    [rowArray addObject:rowData];

    rowData = [KeyValueModel new];  //row
    rowData.key = @"工号";
    rowData.value = [Util defaultStr:kUnknown ifStrEmpty:self.orderContent.supporterId];
    [rowArray addObject:rowData];

    rowData = [KeyValueModel new];  //row
    rowData.key = @"电话";
    rowData.value = [Util defaultStr:kUnknown ifStrEmpty:self.orderContent.supporterPhone];
    rowData.tag = kConfirmSupportDetailsItemTelTag;
    [rowArray addObject:rowData];
    [sectionArray addObject:rowArray];

    //section
    rowArray = [NSMutableArray new];
    rowData = [KeyValueModel new];  //row
    rowData.key = @"申请日期";
    rowData.value = [NSString dateStringWithInterval:[self.orderContent.applyTime doubleValue] formatStr:WZDateStringFormat5];
    [rowArray addObject:rowData];

    rowData = [KeyValueModel new];  //row
    rowData.key = @"接受日期";
    rowData.value = [NSString dateStringWithInterval:[self.orderContent.acceptTime doubleValue] formatStr:WZDateStringFormat5];
    [rowArray addObject:rowData];
    [sectionArray addObject:rowArray];

    //section
    rowArray = [NSMutableArray new];
    rowData = [KeyValueModel new];  //row
    rowData.key = @"评分";
    rowData.value = [NSString stringWithFormat:@"%.2f",[self.orderContent.score floatValue]/5];
    rowData.tag = kConfirmSupportDetailsItemStarTag;
    [rowArray addObject:rowData];

    rowData = [KeyValueModel new];  //row
    rowData.key = @"评价";
    rowData.value = self.bEditMode ? nil : self.orderContent.content;
    [rowArray addObject:rowData];

    if (self.bEditMode) {
        rowData = [KeyValueModel new];  //row
        rowData.key = @"请对本次服务进行评价";
        rowData.value = self.orderContent.content;
        rowData.tag = kConfirmSupportDetailsItemDescriptionTag;
        [rowArray addObject:rowData];
    }
    [sectionArray addObject:rowArray];

    return sectionArray;
}

#pragma mark - TableView Delegate

- (void)getSupportOrderConent:(RequestCallBackBlockV2)requestCallBackBlock
{
    GetOrderDetailsInputParams *input = [GetOrderDetailsInputParams new];
    input.object_id = [self.orderId description];
    [self.httpClient getOrderDetails:input response:^(NSError *error, HttpResponseData *responseData) {
        SupporterOrderContent *orderContent;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            NSDictionary *orderDic = responseData.resultData;
            OrderContentDetails *orderDetails = [MiscHelper parserOrderContentDetails:orderDic];
            orderContent = orderDetails.supportInfo;
        }
        requestCallBackBlock(error, responseData, orderContent);
    }];
}

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    [self getSupportOrderConent:^(NSError *error, HttpResponseData *responseData, id extData) {
        self.orderContent = (SupporterOrderContent*)extData;
        self.bEditMode = ([self.orderContent.status integerValue] != kSupporterOrderStatusConfirmed);
        self.detailItemArray = [self buildCellItemData];
        self.tableView.tableView.tableFooterView = self.bEditMode ? self.customFooterView : nil;
        
        [tableView didRequestTableViewListDatasWithCount:1 totalCount:1 page:pageInfo response:responseData error:error];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewCellDefaultHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.textColor = kColorDefaultBlue;
    UIView *headerView = [tableView makeHeaderViewWithSubLabel:headerLabel bottomLineHeight:1];
    
    switch (section) {
        case 0:
            headerLabel.text = @"技术支持";
            break;
        case 1:
        {
            AttributeStringAttrs *titleAttr = [AttributeStringAttrs new];
            titleAttr.text = [NSString stringWithFormat:@"%@\t",@"工单信息"];
            titleAttr.textColor = headerLabel.textColor;
            AttributeStringAttrs *orderAttr = [AttributeStringAttrs new];
            orderAttr.text = [Util defaultStr:@"" ifStrEmpty:self.orderId];
            orderAttr.textColor = kColorDefaultOrange;
            headerLabel.attributedText = [NSString makeAttrString:@[titleAttr, orderAttr]];
        }
            break;
        case 2:
            headerLabel.text = @"服务评价";
            break;
        default:
            break;
    }
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.detailItemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *attrArray = self.detailItemArray[section];
    return attrArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    if (cell == self.evaluateNoteCell) {
        return 80;
    }else {
        return MAX([cell fitHeight], kTableViewCellDefaultHeight);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *attrArray = self.detailItemArray[indexPath.section];
    KeyValueModel *orderAttr = attrArray[indexPath.row];
    
    //call
    if (orderAttr.tag == kConfirmSupportDetailsItemTelTag) {
        ReturnIf([Util isEmptyString:self.orderContent.supporterPhone]);
        NSArray *telArray = [self getSupporterTelephoneNumbers];
        [CallingHelper startCallings:telArray fromViewController:self];
    }
}

- (NSArray*)getSupporterTelephoneNumbers
{
    return [self.orderContent.supporterPhone componentsSeparatedByString:@","];
}

//set cell data
- (UITableViewCell*)setCell:(UITableViewCell*)cell withData:(KeyValueModel*)data
{
    if ([cell isKindOfClass:[LeftTextRightTextCell class]]) {
        LeftTextRightTextCell *attrCell = (LeftTextRightTextCell*)cell;
        attrCell.leftTextLabel.text = data.key;
        attrCell.rightTextLabel.text = data.value;
        [attrCell layoutCustomSubViews];
    }else if ([cell isKindOfClass:[TitleStarCell class]]){
        TitleStarCell *starCell = (TitleStarCell*)cell;
        starCell.startView.score = [data.value floatValue];
        starCell.startView.userInteractionEnabled = self.bEditMode;
    }else if (cell == self.evaluateNoteCell){
        self.evaluateNote.text = data.value;
        self.evaluateNote.placeholder = self.bEditMode ? data.key : nil;
        self.evaluateNote.textView.editable = self.bEditMode;
        self.evaluateNote.backgroundColor = kColorClear;
        self.evaluateNote.wordLimitLabel.hidden = !self.bEditMode;
    }
    return cell;
}

//make cell and set data
- (UITableViewCell*)cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray *attrArray = self.detailItemArray[indexPath.section];
    KeyValueModel *orderAttr = attrArray[indexPath.row];
    
    UITableViewCell *cell;
    
    NSString *cellKey = [NSString stringWithFormat:@"section%@row%@", @(indexPath.section), @(indexPath.row)];
    if ([_cellDic containsKey:cellKey]) {
        cell = [_cellDic objForKey:cellKey];
    }
    if (nil == cell) {
        if (orderAttr.tag == kConfirmSupportDetailsItemStarTag) { //5 star cell
            cell = self.starCell;
        }else if (orderAttr.tag == kConfirmSupportDetailsItemDescriptionTag){
            cell = self.evaluateNoteCell;
        }else { //other attribute cell
            LeftTextRightTextCell *attrCell = [self makeAttrTableViewCell:nil];
            if (orderAttr.tag == kConfirmSupportDetailsItemTelTag) {
                UIImageView *telImgView = [[UIImageView alloc]initWithImage:ImageNamed(@"phone-call-green")];
                attrCell.accessoryView = telImgView;
                attrCell.rightTextLabel.textColor = kColorDefaultGreen;
            }
            cell = attrCell;
        }
        [_cellDic setObject:cell forKey:cellKey];
    }
    
    return [self setCell:cell withData:orderAttr];
}

- (ConfirmSupportInputParams*)getRepairerComment
{
    ConfirmSupportInputParams *input = [ConfirmSupportInputParams new];
    input.supportInfoId = [self.orderContent.Id description];
    input.score = [NSString stringWithFormat:@"%.1f",self.starCell.startView.score * 5];
    input.content = self.evaluateNote.text;
    return input;
}

- (NSString*)checkUserComment:(ConfirmSupportInputParams*)input
{
    ReturnIf([Util isEmptyString:input.score]||[input.score floatValue] < 0.01)@"请对本次服务进行评分";
    ReturnIf([Util isEmptyString:input.content])@"请对本次服务进行评价";

    return nil;
}

- (void)confirmButtonClicked:(id)sender
{
    ConfirmSupportInputParams *input = [self getRepairerComment];
    NSString *invalidStr = [self checkUserComment:input];
    
    if (![Util isEmptyString:invalidStr]) {
        [Util showToast:invalidStr];
    }else {
        [self commitTaskConfirm:input];
    }
}

- (void)commitTaskConfirm:(ConfirmSupportInputParams*)input
{
    [Util showWaitingDialog];
    [self.httpClient repairer_confirmSupport:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            [Util showToast:@"确认成功"];
            [self postNotification:NotificationOrderChanged];
            [self popViewController];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

@end
