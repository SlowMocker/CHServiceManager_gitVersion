//
//  AppointmentViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/9/5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "AppointmentViewController.h"
#import "WZDatePickerView.h"

static CGFloat kDatePickerViewDefaultHeight = 236;
static CGFloat kNoteEditTextCellHeight = 130;


@interface AppointmentViewController ()<WZTableViewDelegate, WZDatePickerViewDelegate>
{
    NSTimeInterval _selectedTimeInterval;   //s
    BOOL _isDatePickerShowing;
}
@property(nonatomic, strong)WZTableView *tableView;
@property(nonatomic, strong)WZTextView *textView;

@property(nonatomic, strong)UITableViewCell *dateCell;
@property(nonatomic, strong)UITableViewCell *noteEditCell;

@property(nonatomic, strong)UIView *customFooterView;
@property(nonatomic, strong)UIButton *contactButton;
@property(nonatomic, strong)UIButton *confirmButton;
@end

@implementation AppointmentViewController

- (NSString*)getDateTitleName
{
    return [NSString stringWithFormat:@"%@时间", self.title];
}

- (UITableViewCell*)dateCell
{
    if (nil == _dateCell) {
        _dateCell = [MiscHelper makeCommonSelectCell:[self getDateTitleName]];
        [_dateCell.detailTextLabel setFont:SystemFont(16)];
    }
    return _dateCell;
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
        CGFloat topMargin = kButtonDefaultHeight;

        CGRect frame = CGRectMake(0, 0, ScreenWidth - 2*kTableViewLeftPadding, 2*kButtonDefaultHeight + topMargin + kDefaultSpaceUnit);
        _customFooterView = [[UIView alloc]initWithFrame:frame];
        [_customFooterView clearBackgroundColor];

        //add contact button
        frame.size.height /= 2;
        frame = CGRectMake(0, topMargin, CGRectGetWidth(_customFooterView.frame), kButtonDefaultHeight);
        _contactButton = [[UIButton alloc]initWithFrame:frame];
        [_contactButton clearBackgroundColor];
        NSAttributedString *attrStr = [self getContactButtonAttrStr];
        [_contactButton setAttributedTitle:attrStr forState:UIControlStateNormal];
        [_contactButton addTarget:self action:@selector(contactButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_customFooterView addSubview:_contactButton];

        //add confirm button
        frame.origin.y = CGRectGetMaxY(_contactButton.frame) + kDefaultSpaceUnit;
        _confirmButton = [UIButton redButton:@"确定"];
        [_confirmButton setBackgroundColor:kColorLightGray forState:UIControlStateDisabled];
        _confirmButton.frame = frame;
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_customFooterView addSubview:_confirmButton];
    }
    return _customFooterView;
}

- (NSAttributedString*)getContactButtonAttrStr
{
    AttributeStringAttrs *attrItem1;
    attrItem1 = [[AttributeStringAttrs alloc]init];
    attrItem1.text = @"预约请联系";
    attrItem1.textColor = kColorDarkGray;
    attrItem1.font = SystemFont(14);

    AttributeStringAttrs *attrItem2;
    attrItem2 = [[AttributeStringAttrs alloc]init];
    attrItem2.text = self.orderContent.telnumber;
    attrItem2.textColor = kColorDefaultGreen;
    attrItem2.font = SystemFont(14);
    attrItem2.underLineStyle = NSUnderlineStyleSingle;

    AttributeStringAttrs *attrItem3;
    attrItem3 = [[AttributeStringAttrs alloc]init];
    attrItem3.text = self.orderContent.custname;
    attrItem3.textColor = kColorDarkGray;
    attrItem3.font = SystemFont(14);
    
    return [NSString makeAttrString:@[attrItem1, attrItem2, attrItem3]];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isSelfViewNil) {
        self.customFooterView = nil;
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = kTableViewCellDefaultHeight;
    switch (indexPath.section) {
        case 1:
            cellHeight = kNoteEditTextCellHeight;
        default:
            break;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.section) {
        if (!_isDatePickerShowing) {
            [self popupDatePicker];
        }
    }
}

- (void)popupDatePicker
{
    CGRect frame = CGRectMake(0, ScreenHeight - 64 - kDatePickerViewDefaultHeight, ScreenWidth, kDatePickerViewDefaultHeight);
    WZDatePickerView *datePicker = [[WZDatePickerView alloc]initWithFrame:frame delegate:self];
    datePicker.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDate *focusDate = [NSDate date];

    datePicker.datePicker.date = focusDate;
    datePicker.datePicker.minimumDate = focusDate;
    
    [datePicker showToBottom];
}

- (void)datePickerViewFinished:(WZDatePickerView*)view selected:(NSTimeInterval)secs
{
    _isDatePickerShowing = NO;

    _selectedTimeInterval = floor(secs / 60.0) * 60.0;

    NSString *dateTime = [NSString dateStringWithInterval:secs*1000 formatStr:WZDateStringFormat7];
    self.dateCell.detailTextLabel.text = dateTime;
}

- (void)datePickerViewCancel:(WZDatePickerView*)view
{
    _isDatePickerShowing = NO;
}

- (void)contactButtonClicked:(id)sender
{    
    NSArray *tels = [self.orderContent.telnumber componentsSeparatedByString:@","];
    if (tels.count > 0) {
        [CallingHelper startCallings:tels fromViewController:self];
    }
}

- (NSString*)checkUserInput
{
    if (_selectedTimeInterval <= 0) {
        return @"请选择预约时间";
    }
    return nil;
}

- (void)confirmButtonClicked:(id)sender
{
    NSString *invalid = [self checkUserInput];
    if (nil == invalid) {
        if (kUserRoleTypeFacilitator == self.user.userRoleType) {
            [self commitFacilitatorAppointmentOrderSuccessStatus];
        }else if (kUserRoleTypeRepairer == self.user.userRoleType){
            [self commitRepairerAppointmentOrderSuccessStatus];
        }
    }else {
        [Util showToast:invalid];
    }
}

- (void)commitFacilitatorAppointmentOrderSuccessStatus
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

    if (kAppointmentOperateType1stTime == self.appointmentOperateType) {
        AppointmentOrderInputParams *input = [AppointmentOrderInputParams new];
        input.object_id = [self.orderContent.object_id description];
        input.flag = @"0";
        input.memo = self.textView.text;
        input.date_yy = [NSString dateStringWithInterval:_selectedTimeInterval*1000 formatStr:WZDateStringFormat9];
        [self.httpClient facilitator_appointmentOrder:input response:responseCallback];
    }else { //二次预约和改约
        ChangeAppointmentOrderInputParams *input = [ChangeAppointmentOrderInputParams new];
        input.object_id = [self.orderContent.object_id description];
        input.date_gy = [NSString dateStringWithInterval:_selectedTimeInterval*1000 formatStr:WZDateStringFormat9];
        input.memo = self.textView.text;
        [self.httpClient facilitator_changeAppointmentOrder:input response:responseCallback];
    }
}

- (void)commitRepairerAppointmentOrderSuccessStatus
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
    input.flag = @"0";
    input.memo = self.textView.text;
    input.appointmenttime = [NSString dateStringWithInterval:_selectedTimeInterval*1000 formatStr:WZDateStringFormat9];
    [self.httpClient repairer_appointmentOrder:input response:responseCallback];
}

@end
