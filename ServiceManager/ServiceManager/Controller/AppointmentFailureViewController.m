//
//  AppointmentFailureViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/9/5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "AppointmentFailureViewController.h"
#import "WZTableView.h"
#import "WZTextView.h"
#import "WZSingleCheckViewController.h"
#import "ConfigInfoManager.h"

static CGFloat kNoteEditTextCellHeight = 130;

@interface AppointmentFailureViewController ()<WZTableViewDelegate, WZSingleCheckViewControllerDelegate>
{
    CheckItemModel *_failureReason;
}
@property(nonatomic, strong)WZTableView *tableView;
@property(nonatomic, strong)WZTextView *textView;

@property(nonatomic, strong)UITableViewCell *nameCell;
@property(nonatomic, strong)UITableViewCell *mobileCell;

@property(nonatomic, strong)UITableViewCell *reasonCell;
@property(nonatomic, strong)UITableViewCell *noteEditCell;

@property(nonatomic, strong)UIView *customFooterView;
@property(nonatomic, strong)UIButton *confirmButton;

//Item: sectionArray(item: cell view)
@property(nonatomic, strong)NSMutableArray *cellArray;

@end

@implementation AppointmentFailureViewController

- (NSMutableArray*)cellArray
{
    if (nil == _cellArray) {
        _cellArray = [[NSMutableArray alloc]init];
        
        //section 0
        NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
        [sectionArray addObject:self.nameCell];
        [sectionArray addObject:self.mobileCell];
        [_cellArray addObject:sectionArray];
        
        //section 1
        sectionArray = [[NSMutableArray alloc]init];
        [sectionArray addObject:self.reasonCell];
        [_cellArray addObject:sectionArray];
        
        //section 2
        sectionArray = [[NSMutableArray alloc]init];
        [sectionArray addObject:self.noteEditCell];
        [_cellArray addObject:sectionArray];
    }
    return _cellArray;
}

- (UITableViewCell*)nameCell
{
    if (nil == _nameCell) {
        _nameCell = [MiscHelper makeCellWithLeftIcon:nil leftTitle:nil rightText:nil];
        [_nameCell addLineTo:kFrameLocationBottom];
        _nameCell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return _nameCell;
}

- (UITableViewCell*)mobileCell
{
    if (nil == _mobileCell) {
        _mobileCell = [MiscHelper makeCellWithLeftIcon:nil leftTitle:nil rightText:nil];
        [_mobileCell addLineTo:kFrameLocationBottom];
        _mobileCell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return _mobileCell;
}

- (UITableViewCell*)reasonCell
{
    if (nil == _reasonCell) {
        _reasonCell = [MiscHelper makeCommonSelectCell:@"选择失败原因"];
        [_reasonCell addLineTo:kFrameLocationBottom];
        _reasonCell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return _reasonCell;
}

- (WZTextView*)textView
{
    if (nil == _textView) {
        _textView = [[WZTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 2*kTableViewLeftPadding, kNoteEditTextCellHeight) maxWords:300];
    }
    return _textView;
}

- (UITableViewCell*)noteEditCell
{
    if (nil == _noteEditCell) {
        _noteEditCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_noteEditCell.contentView addSubview:self.textView];
    }
    return _noteEditCell;
}

- (UIView*)customFooterView
{
    if (nil == _customFooterView) {
        CGRect frame = CGRectMake(0, 0, ScreenWidth - 2*kTableViewLeftPadding, kButtonDefaultHeight + kDefaultSpaceUnit * 2);
        _customFooterView = [[UIView alloc]initWithFrame:frame];
        [_customFooterView clearBackgroundColor];

        //add confirm button
        frame.size.height = kButtonDefaultHeight;
        _confirmButton = [UIButton redButton:@"确定"];
        [_confirmButton setBackgroundColor:kColorLightGray forState:UIControlStateDisabled];
        _confirmButton.frame = frame;
        _confirmButton.center = _customFooterView.center;
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_customFooterView addSubview:_confirmButton];
    }
    return _customFooterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[WZTableView alloc]initWithStyle:UITableViewStyleGrouped delegate:self];
    _tableView.tableView.headerHidden = YES;
    _tableView.tableView.footerHidden = YES;
    _tableView.pageInfo.pageSize = MAXFLOAT;
    [_tableView clearBackgroundColor];
    [_tableView.tableView clearBackgroundColor];
    _tableView.tableView.backgroundView = nil;
    _tableView.tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableView.tableFooterView = self.customFooterView;
    _tableView.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kTableViewLeftPadding, 0, kTableViewLeftPadding));
    }];
    
    [self setDataToViews];
}

- (void)setDataToViews
{
    NSString *tempStr;
    
    tempStr = [NSString stringWithFormat:@"姓名 : %@", self.orderContent.custname];
    self.nameCell.textLabel.text = tempStr;

    tempStr = [NSString stringWithFormat:@"电话 : %@", self.orderContent.telnumber];
    self.mobileCell.textLabel.text = tempStr;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewCellDefaultHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.textColor = kColorDarkGray;
    UIView *headerView = [tableView makeHeaderViewWithSubLabel:headerLabel bottomLineHeight:0];

    switch (section) {
        case 0:
            headerLabel.text = @"用户信息";
            break;
        case 1:
            headerLabel.text = @"失败原因";
            break;
        case 2:
            headerLabel.text = @"备注信息";
            break;
        default:
            break;
    }
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.cellArray[section];
    return sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = kTableViewCellDefaultHeight;
    switch (indexPath.section) {
        case 2: //note edit
            cellHeight = kNoteEditTextCellHeight;
        default:
            break;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = self.cellArray[indexPath.section];
    return sectionArray[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *selCell = self.cellArray[indexPath.section][indexPath.row];
    if (selCell == self.reasonCell) {
        NSArray *reasonArray = [ConfigInfoManager sharedInstance].appointmentFailureReasons;
        NSArray *fmtReasonArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:reasonArray];
        
        [MiscHelper pushToCheckListViewController:@"预约失败原因" checkItems:fmtReasonArray checkedItem:_failureReason from:self delegate:self];
    }
}

- (void)singleCheckViewController:(WZSingleCheckViewController *)viewController didChecked:(CheckItemModel *)checkedItem
{
    _failureReason = checkedItem;
    self.reasonCell.detailTextLabel.text = checkedItem.value;
    [viewController popViewController];
}

- (NSString*)checkUserInput
{
    if (nil == _failureReason) {
        return @"请选择预约失败原因";
    }
    return nil;
}

- (void)confirmButtonClicked:(id)sender
{
    NSString *invalid = [self checkUserInput];
    if (nil == invalid) {
        if (kUserRoleTypeFacilitator == self.user.userRoleType) {
            [self commitFacilitatorAppointmentOrderFailureStatus];
        }else if (kUserRoleTypeRepairer == self.user.userRoleType){
            [self commitRepairerAppointmentOrderFailureStatus];
        }
    }else {
        [Util showToast:invalid];
    }
}

- (void)commitFacilitatorAppointmentOrderFailureStatus
{
    AppointmentOrderInputParams *input = [AppointmentOrderInputParams new];
    input.object_id = [self.orderContent.object_id description];
    input.flag = @"1";
    input.reason = _failureReason.key;
    input.memo = self.textView.text;

    [Util showWaitingDialog];
    [self.httpClient facilitator_appointmentOrder:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error) {
            NSString *promptStr = [Util getErrorDescritpion:responseData otherError:error];
            if (kHttpReturnCodeSuccess == responseData.resultCode) {
                promptStr = @"提交成功";
            }
            switch (responseData.resultCode) {
                case kHttpReturnCodeSuccess:
                case kHttpReturnCodeChangedAssign:
                    [self postNotification:NotificationOrderChanged];
                    [self popViewController];
                    break;
                default:
                    break;
            }
            [Util showToast:promptStr];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)commitRepairerAppointmentOrderFailureStatus
{
    RequestCallBackBlock responseCallback = ^(NSError *error, HttpResponseData* responseData){
        [Util dismissWaitingDialog];

        if (!error) {
            NSString *promptStr = [Util getErrorDescritpion:responseData otherError:error];
            if (kHttpReturnCodeSuccess == responseData.resultCode) {
                promptStr = @"提交成功";
            }
            switch (responseData.resultCode) {
                case kHttpReturnCodeSuccess:
                case kHttpReturnCodeChangedAssign:
                    [self postNotification:NotificationOrderChanged];
                    [self popViewController];
                    break;
                default:
                    break;
            }
            [Util showToast:promptStr];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    };

    [Util showWaitingDialog];
    RepairerAppointmentOrderInputParams *input = [RepairerAppointmentOrderInputParams new];
    input.object_id = [self.orderContent.object_id description];
    input.flag = @"1";
    input.memo = self.textView.text;
    input.reason = _failureReason.key;
    [self.httpClient repairer_appointmentOrder:input response:responseCallback];
}

@end
