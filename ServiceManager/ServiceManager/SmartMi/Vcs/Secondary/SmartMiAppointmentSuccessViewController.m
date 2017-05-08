//
//  SmartMiAppointmentViewController.m
//  ServiceManager
//
//  Created by Wu on 17/3/27.
//  Copyright © 2017年 wangzhi. All rights reserved.
//



#import "SmartMiAppointmentSuccessViewController.h"

#import "WZDatePickerView.h"
#import "WZTableView.h"
#import "WZTextView.h"

static CGFloat kDatePickerViewDefaultHeight = 236;
static CGFloat kNoteEditTextCellHeight = 130;

@interface SmartMiAppointmentSuccessViewController ()<WZTableViewDelegate, WZDatePickerViewDelegate>

@property (nonatomic , strong)WZTableView *tableView;
@property (nonatomic , strong)WZTextView *textView;/**< 备注信息描述信息填写框 */

@property (nonatomic , strong)UITableViewCell *dateCell;/**< 选择日期 cell */
@property (nonatomic , strong)UITableViewCell *noteEditCell;/**< 编辑备注信息 cell */

@property (nonatomic , strong)UIView *customFooterView;
@property (nonatomic , strong)UIButton *contactButton;/**< 联系人 btn */
@property (nonatomic , strong)UIButton *confirmButton;/**< 确定 btn */
@end

@implementation SmartMiAppointmentSuccessViewController
{
    NSTimeInterval _selectedTimeInterval;/**< 单位: s */
    BOOL _isDatePickerShowing;/**< date picker 是否展示 */
}

#pragma mark
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kTableViewLeftPadding, 0, kTableViewLeftPadding));
        make.width.mas_equalTo(ScreenWidth - 2*kTableViewLeftPadding);
        make.height.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isSelfViewNil) {
        self.customFooterView = nil;
    }
}

#pragma mark
#pragma mark WZTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableViewCellDefaultHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.textColor = kColorDarkGray;
    UIView *headerView = [tableView makeHeaderViewWithSubLabel:headerLabel bottomLineHeight:0];
    
    switch (section) {
        case 0:
            headerLabel.text = [self getDateTitleName];
            break;
        case 1:
            headerLabel.text = @"备注信息";
            break;
        default:
            break;
    }
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = kTableViewCellDefaultHeight;
    switch (indexPath.section) {
        case 1:
            cellHeight = kNoteEditTextCellHeight;
        default:
            break;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
            cell = self.dateCell;
            break;
        case 1:
            cell = self.noteEditCell;
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.section) {
        if (!_isDatePickerShowing) {
            [self popupDatePicker];
        }
    }
}

#pragma mark
#pragma mark WZDatePickerViewDelegate
- (void)datePickerViewFinished:(WZDatePickerView*)view selected:(NSTimeInterval)secs {
    _isDatePickerShowing = NO;
    
    _selectedTimeInterval = floor(secs / 60.0) * 60.0;
    
    NSString *dateTime = [NSString dateStringWithInterval:secs*1000 formatStr:WZDateStringFormat7];
    self.dateCell.detailTextLabel.text = dateTime;
}

- (void)datePickerViewCancel:(WZDatePickerView*)view {
    _isDatePickerShowing = NO;
}

#pragma mark
#pragma mark event respose
// contactButton (联系)
- (void) contactButtonClicked:(id)sender {
    NSArray *tels = [self.smartMiOrderContent.phoneNum componentsSeparatedByString:@","];
    if (tels.count > 0) {
        [CallingHelper startCallings:tels fromViewController:self];
    }
}
// confirmButton (确定)
- (void) confirmButtonClicked:(id)sender {
    NSString *invalid = [self checkUserInput];
    if (invalid == nil) {
        if (kUserRoleTypeFacilitator == self.user.userRoleType) {
            [self commitFacilitatorAppointmentOrderSuccessStatus];
        }
        else if (kUserRoleTypeRepairer == self.user.userRoleType) {
            [self commitRepairerAppointmentOrderSuccessStatus];
        }
    }
    else {
        [Util showToast:invalid];
    }
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

- (UITableViewCell *) dateCell {
    if (nil == _dateCell) {
        _dateCell = [MiscHelper makeCommonSelectCell:[self getDateTitleName]];
        [_dateCell.detailTextLabel setFont:SystemFont(16)];
    }
    return _dateCell;
}

- (WZTextView *) textView {
    if (nil == _textView) {
        _textView = [[WZTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 2*kTableViewLeftPadding, kNoteEditTextCellHeight) maxWords:300];
        _textView.placeholder = @"选填";
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
        CGFloat topMargin = kButtonDefaultHeight;
        
        CGFloat height = 2*kButtonDefaultHeight + topMargin + kDefaultSpaceUnit;
        
        CGRect frame = CGRectMake(0, 0, ScreenWidth - 2*kTableViewLeftPadding, height);
        _customFooterView = [[UIView alloc]initWithFrame:frame];
        [_customFooterView clearBackgroundColor];
        
        [_customFooterView addSubview:self.contactButton];
        [self.contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topMargin);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(CGRectGetWidth(_customFooterView.frame));
            make.height.mas_equalTo(kButtonDefaultHeight);
        }];
        
        [_customFooterView addSubview:self.confirmButton];
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contactButton.mas_bottom).offset(kDefaultSpaceUnit);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(CGRectGetWidth(_customFooterView.frame));
            make.height.mas_equalTo(kButtonDefaultHeight);
        }];
    }
    return _customFooterView;
}

- (UIButton *) contactButton {
    if (_contactButton == nil) {
        _contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contactButton clearBackgroundColor];
        NSAttributedString *attrStr = [self contactButtonAttrStr];
        [_contactButton setAttributedTitle:attrStr forState:UIControlStateNormal];
        [_contactButton addTarget:self action:@selector(contactButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactButton;
}

- (UIButton *) confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [UIButton redButton:@"确定"];
        [_confirmButton setBackgroundColor:kColorLightGray forState:UIControlStateDisabled];
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

#pragma mark
#pragma mark private methods
- (NSString *) getDateTitleName {
    return [NSString stringWithFormat:@"%@时间", self.title];
}

// 检查用户输入是否合法
- (NSString*) checkUserInput {
    if (_selectedTimeInterval <= 0) {
        return @"请选择预约时间";
    }
    return nil;
}

// 服务商预约成功
- (void) commitFacilitatorAppointmentOrderSuccessStatus {
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
    
    if (kAppointmentOperateType1stTime == self.appointmentOperateType) { // 预约
        SmartMiFacilitatorAppointmentOrderInputParams *input = [SmartMiFacilitatorAppointmentOrderInputParams new];
        input.objectId = [self.smartMiOrderContent.objectId description];
        input.flag = @"0";
        input.apptMemo = self.textView.text;
        input.apptDate = [NSString dateStringWithInterval:_selectedTimeInterval*1000 formatStr:WZDateStringFormat9];
        
        NSDate *appoDate = [Util dateWithString:input.apptDate format:@"yyyyMMddHHmmss"];
        NSDate *date = [NSDate date];
        if (([date timeIntervalSince1970] > [appoDate timeIntervalSince1970])) {
            [Util dismissWaitingDialog];
            [Util showToast:@"预约日期不能早于提交日期"];
            return;
        }
        
        [self.httpClient smartMi_facilitator_appointmentOrder:input response:responseCallback];
    }
    else { // 二次预约和改约
        SmartMiFacilitatorChangeAppointmentOrderInputParams *input = [SmartMiFacilitatorChangeAppointmentOrderInputParams new];
        input.objectId = [self.smartMiOrderContent.objectId description];
        input.lastApptDate = [NSString dateStringWithInterval:_selectedTimeInterval*1000 formatStr:WZDateStringFormat9];
        input.apptMemo = self.textView.text;
        [self.httpClient smartMi_facilitator_changeAppointmentOrder:input response:responseCallback];
    }
}

// 维修工预约成功
- (void) commitRepairerAppointmentOrderSuccessStatus {
    SmartMiRepairerAppointmentOrderInputParams *input = [SmartMiRepairerAppointmentOrderInputParams new];
    input.objectId = [self.smartMiOrderContent.objectId description];
    input.flag = @"0";
    input.apptMemo = self.textView.text;
    input.apptDate = [NSString dateStringWithInterval:_selectedTimeInterval*1000 formatStr:WZDateStringFormat9];
    
    NSDate *appoDate = [Util dateWithString:input.apptDate format:@"yyyyMMddHHmmss"];
    NSDate *date = [NSDate date];
    if (([date timeIntervalSince1970] > [appoDate timeIntervalSince1970])) {
        [Util showToast:@"预约日期不能早于提交日期"];
        return;
    }
    
    
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

// 弹出 date picker
- (void) popupDatePicker {
    CGRect frame = CGRectMake(0, ScreenHeight - 64 - kDatePickerViewDefaultHeight, ScreenWidth, kDatePickerViewDefaultHeight);
    WZDatePickerView *datePicker = [[WZDatePickerView alloc]initWithFrame:frame delegate:self];
    datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDate *focusDate = [NSDate date];
    
    datePicker.datePicker.date = focusDate;
    datePicker.datePicker.minimumDate = focusDate;
    
    [datePicker showToBottom];
}

// 联系人 btn title 设置
- (NSAttributedString *) contactButtonAttrStr {
    AttributeStringAttrs *attrItem1;
    attrItem1 = [[AttributeStringAttrs alloc]init];
    attrItem1.text = @"预约请联系";
    attrItem1.textColor = kColorDarkGray;
    attrItem1.font = SystemFont(14);
    
    AttributeStringAttrs *attrItem2;
    attrItem2 = [[AttributeStringAttrs alloc]init];
    attrItem2.text = self.smartMiOrderContent.phoneNum;
    attrItem2.textColor = kColorDefaultGreen;
    attrItem2.font = SystemFont(14);
    attrItem2.underLineStyle = NSUnderlineStyleSingle;
    
    AttributeStringAttrs *attrItem3;
    attrItem3 = [[AttributeStringAttrs alloc]init];
    attrItem3.text = self.smartMiOrderContent.name;
    attrItem3.textColor = kColorDarkGray;
    attrItem3.font = SystemFont(14);
    
    return [NSString makeAttrString:@[attrItem1, attrItem2, attrItem3]];
}



@end
