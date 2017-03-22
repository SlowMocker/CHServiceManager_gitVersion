//
//  EditEmployeeViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/9/5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "EditEmployeeViewController.h"
#import "WZTableView.h"
#import "WZTextView.h"
#import "WZCheckListViewController.h"
#import "ConfigInfoManager.h"
#import "LabelEditCell.h"

@interface EditEmployeeViewController ()<WZTableViewDelegate>
{
    NSString *_failureReasonId;
}
@property(nonatomic, strong)WZTableView *tableView;

@property(nonatomic, strong)UITableViewCell *nameCell;
@property(nonatomic, strong)UITableViewCell *userIdCell;

@property(nonatomic, strong)LabelEditCell *telCell;

@property(nonatomic, strong)UIView *customFooterView;
@property(nonatomic, strong)UIButton *deleteButton;
@property(nonatomic, strong)UIButton *resetPwdButton;

//Item: sectionArray(item: cell view)
@property(nonatomic, strong)NSMutableArray *cellArray;

@end

@implementation EditEmployeeViewController

- (NSMutableArray*)cellArray
{
    if (nil == _cellArray) {
        _cellArray = [[NSMutableArray alloc]init];
        
        //section 0
        NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
        [sectionArray addObject:self.nameCell];
        [sectionArray addObject:self.userIdCell];
        [_cellArray addObject:sectionArray];
        
        //section 1
        sectionArray = [[NSMutableArray alloc]init];
        [sectionArray addObject:self.telCell];
        [_cellArray addObject:sectionArray];
    }
    return _cellArray;
}

- (UITableViewCell*)nameCell
{
    if (nil == _nameCell) {
        _nameCell = [MiscHelper makeCellWithLeftIcon:nil leftTitle:nil rightText:nil];
        _nameCell.selectionStyle =UITableViewCellSelectionStyleNone;
        [_nameCell clearBackgroundColor];
    }
    return _nameCell;
}

- (UITableViewCell*)userIdCell
{
    if (nil == _userIdCell) {
        _userIdCell = [MiscHelper makeCellWithLeftIcon:nil leftTitle:nil rightText:nil];
        [_userIdCell addLineTo:kFrameLocationBottom];
        _userIdCell.selectionStyle =UITableViewCellSelectionStyleNone;
        [_userIdCell clearBackgroundColor];
    }
    return _userIdCell;
}

- (UITableViewCell*)telCell
{
    if (nil == _telCell) {
        _telCell = [LabelEditCell makeLabelEditCell:@"电话" hint:nil keyBoardType:UIKeyboardTypeNamePhonePad unit:nil];
        _telCell.middleTextField.textColor = kColorBlack;
    }
    return _telCell;
}

- (UIView*)customFooterView
{
    if (nil == _customFooterView) {
        CGFloat topMargin = kButtonDefaultHeight;
        
        CGRect frame = CGRectMake(0, 0, ScreenWidth - 2*kTableViewLeftPadding, 2*kButtonDefaultHeight + topMargin + kDefaultSpaceUnit);
        _customFooterView = [[UIView alloc]initWithFrame:frame];
        [_customFooterView clearBackgroundColor];
        
        //add resetPwd button
        frame.size.height /= 2;
        frame = CGRectMake(0, topMargin, CGRectGetWidth(_customFooterView.frame), kButtonDefaultHeight);
        _resetPwdButton = [UIButton orangeButton:@"重置员工密码"];
        _resetPwdButton.frame = frame;
        [_resetPwdButton addTarget:self action:@selector(resetPasswordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_customFooterView addSubview:_resetPwdButton];

        //add delete button
        frame.origin.y = CGRectGetMaxY(_resetPwdButton.frame) + kDefaultSpaceUnit;
        _deleteButton = [UIButton redButton:@"删除员工"];
        _deleteButton.frame = frame;
        [_deleteButton addTarget:self action:@selector(deleteEmployeeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_customFooterView addSubview:_deleteButton];
    }
    return _customFooterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBarRightButton:@"保存" clicked:@selector(saveRepairerInfoButtonClicked:)];
    
    _tableView = [[WZTableView alloc]initWithStyle:UITableViewStylePlain delegate:self];
    _tableView.tableView.headerHidden = YES;
    _tableView.tableView.footerHidden = YES;
    _tableView.pageInfo.pageSize = MAXFLOAT;
    [_tableView clearBackgroundColor];
    [_tableView.tableView clearBackgroundColor];
    _tableView.tableView.backgroundView = nil;
    _tableView.tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.tableView.tableFooterView = self.customFooterView;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kTableViewLeftPadding, 0, kTableViewLeftPadding));
    }];
    
    [self setDataToViews];
}

- (void)setDataToViews
{
    NSString *tempStr;

    tempStr = [NSString stringWithFormat:@"姓名 : %@", self.repairer.realname];
    self.nameCell.textLabel.text = tempStr;

    tempStr = [NSString stringWithFormat:@"员工 ID : %@", self.repairer.userid];
    self.userIdCell.textLabel.text = tempStr;

    self.telCell.middleTextField.text = self.repairer.telephone;
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
    UIView *headerView = [tableView makeHeaderViewWithSubLabel:headerLabel bottomLineHeight:0.5];
    
    switch (section) {
        case 0:
            headerLabel.text = @"用户信息";
            break;
        case 1:
            headerLabel.text = @"联系方式";
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
    if (0 == indexPath.section) {
        return 34;
    }else {
        return kTableViewCellDefaultHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = self.cellArray[indexPath.section];
    return sectionArray[indexPath.row];
}

- (NSString*)canCommitUserInfo
{
    NSString *invalidStr;
    if (![self.telCell.middleTextField.text isValidTelNumber]) {
        invalidStr = @"请输入正确的联系电话";
    }
    return invalidStr;
}

- (void)changeRepairerInfo
{
    ChangeUserInfoInputParams *input = [ChangeUserInfoInputParams new];
    input.repairmanid = self.repairer.userid;
    input.telephone = self.telCell.middleTextField.text;

    [Util showWaitingDialog];
    [self.httpClient changeUserInfo:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            [Util showToast:@"保存成功"];
            self.repairer.telephone = input.telephone;
            if ([self.delegate respondsToSelector:@selector(editEmployeeViewController:didUpdateRepairInfo:)]) {
                [self.delegate editEmployeeViewController:self didUpdateRepairInfo:self.repairer];
            }
            [self postNotification:NotificationEmployeesChanged];
            [self popViewController];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)resetReparierPassword
{
    ChangePasswordInputParams *input = [ChangePasswordInputParams new];
    input.repairmanid = self.repairer.userid;
    input.newpassword = kRepairerInitialPassword;
    
    [Util showWaitingDialog];
    [self.httpClient changePassword:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            [Util showToast:@"重置密码成功"];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)deleteRepairer
{
    DeleteRepairerInputParams *input = [DeleteRepairerInputParams new];
    input.repairmanid = self.repairer.userid;
    
    [Util showWaitingDialog];
    [self.httpClient deleteRepairer:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            [Util showToast:@"删除成功"];
            if ([self.delegate respondsToSelector:@selector(editEmployeeViewController:didDeleteRepair:)]) {
                [self.delegate editEmployeeViewController:self didDeleteRepair:self.repairer];
            }
            [self postNotification:NotificationEmployeesChanged];
            [self popViewController];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)resetPasswordButtonClicked:(id)sender
{
    [self.telCell.middleTextField resignFirstResponder];

    NSString *message = [NSString stringWithFormat:@"您确定要重置%@的密码吗？",self.repairer.realname];
    [Util confirmAlertView:message confirmAction:^{
        [self resetReparierPassword];
    }];
}

- (void)deleteEmployeeButtonClicked:(id)sender
{
    [self.telCell.middleTextField resignFirstResponder];

    NSString *message = [NSString stringWithFormat:@"您确定要删除%@吗？",self.repairer.realname];
    [Util confirmAlertView:message confirmAction:^{
        [self deleteRepairer];
    }];
}

- (void)saveRepairerInfoButtonClicked:(id)sender
{
    NSString *invalidStr = [self canCommitUserInfo];

    if ([Util isEmptyString:invalidStr]) {

        [self.telCell.middleTextField resignFirstResponder];

        NSString *message = [NSString stringWithFormat:@"您确定要修改%@信息吗？",self.repairer.realname];
        [Util confirmAlertView:message confirmAction:^{
            [self changeRepairerInfo];
        }];
        DLog(@"saveing repairer info...");
    }else {
        [Util showToast:invalidStr];
    }
}

@end
