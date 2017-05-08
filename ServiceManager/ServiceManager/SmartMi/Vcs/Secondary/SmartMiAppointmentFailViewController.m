//
//  SmartMiAppointmentFailViewController.m
//  ServiceManager
//
//  Created by Wu on 17/3/30.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "SmartMiAppointmentFailViewController.h"

#import "WZTableView.h"
#import "WZTextView.h"
#import "WZSingleCheckViewController.h"
#import "ConfigInfoManager.h"

static CGFloat kNoteEditTextCellHeight = 130;

@interface SmartMiAppointmentFailViewController ()<WZTableViewDelegate, WZSingleCheckViewControllerDelegate>

@property(nonatomic, strong)WZTableView *tableView;
@property(nonatomic, strong)WZTextView *textView;/**< 备注信息 textView */

@property(nonatomic, strong)UITableViewCell *nameCell;/**< 被预约客户姓名 cell */
@property(nonatomic, strong)UITableViewCell *mobileCell;/**< 被预约客户电话 cell */
@property(nonatomic, strong)UITableViewCell *reasonCell;/**< 预约失败原因 cell */
@property(nonatomic, strong)UITableViewCell *noteEditCell;/**< 备注信息编辑 cell */

@property(nonatomic, strong)UIView *customFooterView;/**< tableView footerView */
@property(nonatomic, strong)UIButton *confirmButton;/**< 提交按钮 */

@property(nonatomic, strong)NSMutableArray<NSArray<UITableViewCell *> *> *cells;/**< cell 数组 */

@end

@implementation SmartMiAppointmentFailViewController
{
    CheckItemModel *_failureReason;
}

#pragma mark
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self setDataToViews];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kTableViewLeftPadding, 0, kTableViewLeftPadding));
    }];
}

- (void) setDataToViews {
    NSString *tempStr;
    
    tempStr = [NSString stringWithFormat:@"姓名 : %@", self.smartMiOrderContent.name];
    self.nameCell.textLabel.text = tempStr;
    
    tempStr = [NSString stringWithFormat:@"电话 : %@", self.smartMiOrderContent.phoneNum];
    self.mobileCell.textLabel.text = tempStr;
}

#pragma mark
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cells.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cells[section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cells[indexPath.section][indexPath.row];
}

#pragma mark
#pragma mark UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableViewSectionHeaderHeight;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = self.cells[indexPath.section][indexPath.row];
    // 失败原因
    if (cell == self.reasonCell) {
        NSArray *reasonArray = [ConfigInfoManager sharedInstance].appointmentFailureReasons;
        NSArray *fmtReasonArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:reasonArray];
        
        [MiscHelper pushToCheckListViewController:@"预约失败原因" checkItems:fmtReasonArray checkedItem:_failureReason from:self delegate:self];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = kTableViewCellDefaultHeight;
    switch (indexPath.section) {
        case 2: //note edit
            cellHeight = kNoteEditTextCellHeight;
        default:
            break;
    }
    return cellHeight;
}

#pragma mark
#pragma mark WZSingleCheckViewControllerDelegate

- (void) singleCheckViewController:(WZSingleCheckViewController *)viewController didChecked:(CheckItemModel *)checkedItem {
    _failureReason = checkedItem;
    self.reasonCell.detailTextLabel.text = checkedItem.value;
    [viewController popViewController];
}

#pragma mark
#pragma mark event respose
- (void) confirmButtonClicked:(id)sender {
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

#pragma mark
#pragma mark private methods

- (NSString *) checkUserInput {
    if (nil == _failureReason) {
        return @"请选择预约失败原因";
    }
    return nil;
}

// 服务商预约失败
- (void) commitFacilitatorAppointmentOrderFailureStatus {
    SmartMiFacilitatorAppointmentOrderInputParams *input = [SmartMiFacilitatorAppointmentOrderInputParams new];
    input.objectId= [self.smartMiOrderContent.objectId description];
    input.flag = @"1";
    input.apptFailCause = _failureReason.key;
    input.apptMemo = self.textView.text;
    
    
    [Util showWaitingDialog];
    [self.httpClient smartMi_facilitator_appointmentOrder:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        
        if (!error) {
            NSString *promptStr = [Util getErrorDescritpion:responseData otherError:error];
            if (kHttpReturnCodeSuccess == responseData.resultCode) {
                promptStr = @"提交成功";
//                // 程序外调用系统发短信服务
//                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.smartMiOrderContent.phoneNum]];
//                [[UIApplication sharedApplication]openURL:url];
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

// 维修工预约失败
- (void) commitRepairerAppointmentOrderFailureStatus {
    SmartMiRepairerAppointmentOrderInputParams *input = [SmartMiRepairerAppointmentOrderInputParams new];
    input.objectId = [self.smartMiOrderContent.objectId description];
    input.flag = @"1";
    input.apptFailCause = _failureReason.key;
    input.apptMemo = self.textView.text;
    
    [Util showWaitingDialog];
    [self.httpClient smartMi_repairer_appointmentOrder:input response:^(NSError *error, HttpResponseData *responseData) {
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


#pragma mark
#pragma mark setters and getters
- (WZTableView *) tableView {
    if (_tableView == nil) {
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
    }
    return _tableView;
}

- (UITableViewCell *) nameCell {
    if (nil == _nameCell) {
        _nameCell = [MiscHelper makeCellWithLeftIcon:nil leftTitle:nil rightText:nil];
        [_nameCell addLineTo:kFrameLocationBottom];
        _nameCell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return _nameCell;
}

- (UITableViewCell *) mobileCell {
    if (nil == _mobileCell) {
        _mobileCell = [MiscHelper makeCellWithLeftIcon:nil leftTitle:nil rightText:nil];
        [_mobileCell addLineTo:kFrameLocationBottom];
        _mobileCell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return _mobileCell;
}

- (UITableViewCell *) reasonCell {
    if (nil == _reasonCell) {
        _reasonCell = [MiscHelper makeCommonSelectCell:@"选择失败原因"];
        [_reasonCell addLineTo:kFrameLocationBottom];
        _reasonCell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    return _reasonCell;
}

- (WZTextView *) textView {
    if (nil == _textView) {
        _textView = [[WZTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 2*kTableViewLeftPadding, kNoteEditTextCellHeight) maxWords:300];
    }
    return _textView;
}

- (UITableViewCell *) noteEditCell {
    if (nil == _noteEditCell) {
        _noteEditCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_noteEditCell.contentView addSubview:self.textView];
    }
    return _noteEditCell;
}

- (UIView *) customFooterView {
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

- (NSMutableArray<NSArray<UITableViewCell *> *> *)cells {
    if (_cells == nil) {
        _cells = [[NSMutableArray alloc]init];
        
        // 用户信息段
        NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
        [sectionArray addObject:self.nameCell];
        [sectionArray addObject:self.mobileCell];
        [_cells addObject:sectionArray];
        
        // 失败原因段
        sectionArray = [[NSMutableArray alloc]init];
        [sectionArray addObject:self.reasonCell];
        [_cells addObject:sectionArray];
        
        // 备注信息段
        sectionArray = [[NSMutableArray alloc]init];
        [sectionArray addObject:self.noteEditCell];
        [_cells addObject:sectionArray];
    }
    return _cells;
}


@end
