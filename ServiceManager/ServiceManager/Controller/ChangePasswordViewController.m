//
//  ChangePasswordViewController.m
//  ServiceManager
//
//  Created by mac on 15/8/25.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "LabelEditCell.h"
#import <UIAlertView+Blocks.h>

@interface ChangePasswordViewController ()
@property(nonatomic, strong)LabelEditCell *oldPasswordCell;
@property(nonatomic, strong)LabelEditCell *passwordCell;
@property(nonatomic, strong)LabelEditCell *repeatPasswordCell;
@property(nonatomic, strong)UIView *tableFooterView;
@property(nonatomic, strong)NSMutableArray *cellArray;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = self.tableFooterView;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    [self makeTableViewCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if (self.isSelfViewNil) {
        _oldPasswordCell = nil;
        _passwordCell = nil;
        _repeatPasswordCell = nil;
        _tableFooterView = nil;
        _cellArray = nil;
    }
}

- (LabelEditCell*)passwordCell
{
    if (nil == _passwordCell) {
        _passwordCell = [LabelEditCell makeLabelEditCell:@"新密码" hint:@"请输入新密码" keyBoardType:UIKeyboardTypeDefault unit:nil];
        _passwordCell.middleTextField.secureTextEntry = YES;
    }
    return _passwordCell;
}

- (LabelEditCell*)oldPasswordCell
{
    if (nil == _oldPasswordCell) {
        _oldPasswordCell = [LabelEditCell makeLabelEditCell:@"当前密码" hint:@"请输入当前密码" keyBoardType:UIKeyboardTypeDefault unit:nil];
        _oldPasswordCell.middleTextField.secureTextEntry = YES;
    }
    return _oldPasswordCell;
}

- (LabelEditCell*)repeatPasswordCell
{
    if (nil == _repeatPasswordCell) {
        _repeatPasswordCell = [LabelEditCell makeLabelEditCell:@"确认密码" hint:@"再次输入新密码" keyBoardType:UIKeyboardTypeDefault unit:nil];
        _repeatPasswordCell.middleTextField.secureTextEntry = YES;
    }
    return _repeatPasswordCell;
}

- (NSMutableArray*)cellArray
{
    if (nil == _cellArray) {
        _cellArray = [[NSMutableArray alloc]init];
    }
    return _cellArray;
}

- (void)makeTableViewCells
{
    [self.cellArray addObject:self.oldPasswordCell];
    [self.cellArray addObject:self.passwordCell];
    [self.cellArray addObject:self.repeatPasswordCell];
}

- (UIView*)tableFooterView
{
    CGRect frame;
    
    if (nil == _tableFooterView) {
        frame = CGRectMake(0, 0, ScreenWidth, 100);
        _tableFooterView = [[UIView alloc]initWithFrame:frame];
        [_tableFooterView clearBackgroundColor];

        UIButton *resetPwdBtn = [UIButton orangeButton:@"修改密码"];
        resetPwdBtn.frame = CGRectMake(0, 0, ScreenWidth - kDefaultSpaceUnit * 2, kButtonDefaultHeight);
        resetPwdBtn.center = _tableFooterView.center;
        [resetPwdBtn addTarget:self action:@selector(resetPwdBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_tableFooterView addSubview:resetPwdBtn];
    }
    return _tableFooterView;
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

#pragma mark - 重置密码

- (void)resetPassword:(ChangePasswordInputParams*)param
{
    [Util showWaitingDialog];
    [self.httpClient changePassword:param response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error && (kHttpReturnCodeSuccess == responseData.resultCode)) {
            [Util showAlertView:@"修改密码成功" message:@"您需要重新登录" okAction:^{
                [Util logoutLocalUser];
                [kAppDelegate unbindAliasForPush];
                [Util startLoginViewController];
            }];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

-(void)resetPwdBtnClicked:(UIButton*)regBtn
{
    NSString *inValidError;

    do {
        //old password
        inValidError = [MiscHelper isValidPasswordStr:self.oldPasswordCell.middleTextField.text];
        BreakIf(nil != inValidError);

        //new password
        inValidError = [MiscHelper isValidPasswordStr:self.passwordCell.middleTextField.text];
        BreakIf(nil != inValidError);

        //repeat new password
        inValidError = [MiscHelper isValidPasswordStr:self.repeatPasswordCell.middleTextField.text];
        BreakIf(nil != inValidError);

        if (![self.repeatPasswordCell.middleTextField.text isEqualToString:self.passwordCell.middleTextField.text]) {
            inValidError = @"两次密码输入不一致";
            break;
        }
    } while (0);

    if (nil != inValidError) {
        [Util showToast:inValidError];
    }else {
        ChangePasswordInputParams *input = [ChangePasswordInputParams new];
        input.oldpassword = self.oldPasswordCell.middleTextField.text;
        input.newpassword = self.passwordCell.middleTextField.text;
        input.repairmanid = self.user.userId;
        [self resetPassword:input];
    }
}

@end
