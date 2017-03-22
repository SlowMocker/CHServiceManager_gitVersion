//
//  TaskDetailsViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/8/31.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "TaskDetailsViewController.h"
#import "WZTableView.h"
#import "LeftTextRightTextCell.h"
#import "TitleStarCell.h"

#define kTaskDetailsItemTelTag     0x47832
#define kTaskDetailsItemStarTag    0x47833

@interface TaskDetailsViewController ()<WZTableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;

//ITEM: NSArray(item: KeyValueModel)
@property(nonatomic, strong)NSMutableArray *detailItemArray;
@property(nonatomic, strong)NSMutableDictionary *cellDic;

@property(nonatomic, strong)UIView *customFooterView;
@property(nonatomic, strong)UIButton *confirmButton;
@end

@implementation TaskDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _cellDic = [[NSMutableDictionary alloc]init];
    self.detailItemArray = [self buildCellItemData];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kTableViewLeftPadding, 0, kTableViewLeftPadding));
    }];
    if (self.isConfirmMode) {
        _tableView.tableFooterView = self.customFooterView;
    }
}

- (UITableView*)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]init];
        [_tableView addTopHeaderSpace:kDefaultSpaceUnit];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView clearBackgroundColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundView = nil;
        [_tableView hideExtraCellLine];
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
    rowData.key = @"工单";
    rowData.value = [Util defaultStr:kUnknown ifStrEmpty:self.orderContent.objectId];
    [rowArray addObject:rowData];

    rowData = [KeyValueModel new];  //row
    rowData.key = @"工号";
    rowData.value = [Util defaultStr:kUnknown ifStrEmpty:self.orderContent.workerId];
    [rowArray addObject:rowData];
    rowData = [KeyValueModel new];  //row
    rowData.key = @"手机";
    rowData.value = [Util defaultStr:kUnknown ifStrEmpty:self.orderContent.workerPhone];
    rowData.tag = kTaskDetailsItemTelTag;
    [rowArray addObject:rowData];
    rowData = [KeyValueModel new];  //row
    rowData.key = @"申请日期";
    rowData.value = [Util timeTextStringFromTimeNumStr:self.orderContent.applyTime];
    [rowArray addObject:rowData];

    if (!self.isConfirmMode) {
        rowData = [KeyValueModel new];  //row
        rowData.key = @"接受日期";
        rowData.value = [Util timeTextStringFromTimeNumStr:self.orderContent.acceptTime];
        [rowArray addObject:rowData];
    }
    [sectionArray addObject:rowArray];

    if (kSupporterOrderStatusConfirmed == self.orderStatus) {
        //section
        rowArray = [NSMutableArray new];
        rowData = [KeyValueModel new];  //row
        rowData.key = @"评分";
        rowData.value = self.orderContent.score;
        rowData.tag = kTaskDetailsItemStarTag;
        [rowArray addObject:rowData];
        rowData = [KeyValueModel new];  //row
        rowData.key = @"确认日期";
        rowData.value = [Util timeTextStringFromTimeNumStr:self.orderContent.confirmTime];
        [rowArray addObject:rowData];
        
        rowData = [KeyValueModel new];  //row
        rowData.key = @"描述";
        rowData.value = [Util defaultStr:kNone ifStrEmpty:self.orderContent.content];
        [rowArray addObject:rowData];
        [sectionArray addObject:rowArray];
    }
    return sectionArray;
}

#pragma mark - TableView Delegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    [tableView didRequestTableViewListDatasWithCount:1 totalCount:1 page:pageInfo response:nil error:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewCellDefaultHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.textColor = kColorDarkGray;
    headerLabel.adjustsFontSizeToFitWidth = YES;
    UIView *headerView = [tableView makeHeaderViewWithSubLabel:headerLabel bottomLineHeight:1];
    
    switch (section) {
        case 0:
        {
            AttributeStringAttrs *name = [AttributeStringAttrs new];
            name.text = [Util defaultStr:kNoName ifStrEmpty:self.orderContent.workerName];
            name.font = SystemBoldFont(18);
            name.textColor = kColorBlack;
            AttributeStringAttrs *attr = [AttributeStringAttrs new];
            attr.textColor = kColorDefaultBlue;
            attr.font = SystemFont(15);
            attr.text = [NSString stringWithFormat:@" (维修工)"];
            headerLabel.attributedText = [NSString makeAttrString:@[name, attr]];
        }
            break;
        case 1:
            headerLabel.text = [NSString stringWithFormat:@"%@\t对本次服务的评价", self.orderContent.workerName];
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
    return MAX([cell fitHeight], kTableViewCellDefaultHeight);
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
    if (orderAttr.tag == kTaskDetailsItemTelTag) {
        ReturnIf([Util isEmptyString:self.orderContent.workerPhone]);

        NSArray *telArray = [self.orderContent.workerPhone componentsSeparatedByString:@","];
        [CallingHelper startCallings:telArray fromViewController:self];
    }
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
        starCell.startView.score = [data.value floatValue]/5;
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
        if (orderAttr.tag == kTaskDetailsItemStarTag) { //5 star cell
            TitleStarCell *starCell = [[TitleStarCell alloc]initWithTitle:orderAttr.key score:[orderAttr.value floatValue]/5];
            starCell.backgroundColor = kColorClear;
            starCell.startView.userInteractionEnabled = NO;
            starCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [starCell addLineTo:kFrameLocationBottom];
            cell = starCell;
        }else { //other attribute cell
            LeftTextRightTextCell *attrCell = [self makeAttrTableViewCell:nil];
            if (orderAttr.tag == kTaskDetailsItemTelTag) {
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

- (void)confirmButtonClicked:(id)sender
{
    [self commitTaskConfirm];
}

- (void)commitTaskConfirm
{
    [self confirmTecSupportOrder:[self.orderContent.Id description] response:^(NSError *error, HttpResponseData *responseData) {
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            [Util  showToast:@"确认成功"];
            [self postNotification:NotificationOrderChanged];
            [self popViewController];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)confirmTecSupportOrder:(NSString*)supportId response:(RequestCallBackBlock)requestCallBackBlock
{
    SupporterAcceptInPutParams *input = [SupporterAcceptInPutParams new];
    input.supportId = [self.orderContent.Id description];
    
    [Util showWaitingDialog];
    [self.httpClient supporter_accept:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        requestCallBackBlock(error, responseData);
    }];
}

@end
