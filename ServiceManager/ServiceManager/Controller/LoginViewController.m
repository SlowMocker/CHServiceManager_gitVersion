//
//  LoginViewController.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-6.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "WZPickerView.h"
#import "ConfigInfoManager.h"
#import "WZModal.h"
#import "IconLabelTextFiledView.h"

#define kItemViewHPadding   (30)
#define kRolePickerViewHeight   (170)

@interface LoginViewController () <WZPickerViewDelegate>
@property(nonatomic, strong)UIImageView *backgroundImageView;
@property(nonatomic, strong)IconLabelTextFiledView *usernameView;
@property(nonatomic, strong)IconLabelTextFiledView *userPasswordView;
@property(nonatomic, strong)IconLabelTextFiledView *userRoleView;
@property(nonatomic, strong)UIButton *loginButton;
@property(nonatomic, strong)UILabel *versionLabel;

- (NSString*)checkIsValidUserName:(NSString*)userNameUserInput;

@property(nonatomic, strong)NSMutableArray *rolesArray;
@property(nonatomic, assign)kUserRoleType selectedRoleType;
@end

@implementation LoginViewController

- (IconLabelTextFiledView*)makeInputView:(NSString*)iconName label:(NSString*)label hint:(NSString*)hintText
{
    CGRect frame = CGRectMake(kItemViewHPadding, 0, ScreenWidth - kItemViewHPadding*2, kItemViewHPadding);
    IconLabelTextFiledView *inputView = [[IconLabelTextFiledView alloc]initWithFrame:frame icon:iconName label:label placeHolder:hintText];
    inputView.label.textColor = kColorWhite;
    inputView.label.font = SystemFont(15);
    inputView.textFiled.font = SystemFont(15);
    inputView.textFiled.textAlignment = NSTextAlignmentCenter;
    
    return inputView;
}

- (IconLabelTextFiledView*)usernameView
{
    if (nil == _usernameView) {
        _usernameView = [self makeInputView:@"login_account" label:@"用户名" hint:@"请输入用户名"];
        _usernameView.textFiled.text = self.user.userName;
        _usernameView.textFiled.keyboardType = UIKeyboardTypePhonePad;
    }
    return _usernameView;
}

- (IconLabelTextFiledView*)userPasswordView
{
    if (nil == _userPasswordView) {
        _userPasswordView = [self makeInputView:@"login_password" label:@"密码" hint:@"请输入登录密码"];
        
        _userPasswordView.textFiled.secureTextEntry = YES;
        _userPasswordView.textFiled.keyboardType = UIKeyboardTypeDefault;
        
        if ([self.user.password isNotEmpty] && [ConfigInfoManager sharedInstance].bSavePassword) {
            _userPasswordView.textFiled.text = self.user.password;
        }else {
            _userPasswordView.textFiled.text = nil;
        }
    }
    return _userPasswordView;
}

- (IconLabelTextFiledView*)userRoleView
{
    if (nil == _userRoleView) {
        _userRoleView = [self makeInputView:@"login_role" label:@"角色" hint:@"请选择用户角色"];
        
        UIImageView *dropdown = [[UIImageView alloc]initWithImage:ImageNamed(@"dropdown")];
        [_userRoleView addSubview:dropdown];
        [dropdown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_userRoleView);
            make.right.equalTo(_userRoleView).with.offset(-6);
        }];
        
        UIButton *actionBtn = [UIButton transparentTextButton:nil];
        [actionBtn addTarget:self action:@selector(roleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_userRoleView addSubview:actionBtn];
        [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_userRoleView);
        }];
    }
    return _userRoleView;
}

- (UIButton*)loginButton
{
    if (_loginButton == nil) {
        _loginButton = [UIButton redButton:@"登录"];
        [_loginButton circleCornerWithRadius:18.0];
        [_loginButton addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (NSMutableArray*)rolesArray
{
    if (nil == _rolesArray) {
        _rolesArray = [[NSMutableArray alloc]init];
        [_rolesArray addObject:@(kUserRoleTypeFacilitator)];
        [_rolesArray addObject:@(kUserRoleTypeRepairer)];
        //        [_rolesArray addObject:@(kUserRoleTypeDealer)];
        //        [_rolesArray addObject:@(kUserRoleTypeBranchManager)];
        [_rolesArray addObject:@(kUserRoleTypeSupporter)];
        //        [_rolesArray addObject:@(kUserRoleTypeMultiMediaManager)];
    }
    return _rolesArray;
}

- (NSDictionary*)getRoleItemDic:(kUserRoleType)roleType
{
    NSMutableDictionary *roleItem = [[NSMutableDictionary alloc]init];
    [roleItem setObj:getUserRoleTypeName(roleType) forKey:@(roleType)];
    return roleItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCustomSubviews];
    [self layoutCustomSubviews];
    
    self.selectedRoleType = self.user.userRoleType;
    self.userRoleView.textFiled.text = getUserRoleTypeName(self.selectedRoleType);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.disableRightPanBack = YES;
}

- (void)addCustomSubviews
{
    //background image
    _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [_backgroundImageView clearBackgroundColor];
    _backgroundImageView.image = ImageNamed(@"login_bg");
    [self.view addSubview:_backgroundImageView];

    //content views
    [self.view addSubview:self.usernameView];
    [self.view addSubview:self.userPasswordView];
    [self.view addSubview:self.userRoleView];
    [self.view addSubview:self.loginButton];
    
    //version label
    self.versionLabel = [[UILabel alloc]init];
    [self.versionLabel clearBackgroundColor];
    self.versionLabel.textColor = kColorWhite;
    self.versionLabel.font = [UIFont italicSystemFontOfSize:12];
    self.versionLabel.text = [NSString stringWithFormat:@"V%@ (%@)", [NSString appVersion], [NSString appBundleVersion]];
    [self.view addSubview:self.versionLabel];
}

- (void)layoutCustomSubviews
{
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.userPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(kItemViewHPadding);
        make.right.equalTo(self.view).with.offset(-kItemViewHPadding);
        make.center.equalTo(self.view);
        make.height.equalTo(@35);
    }];
    
    [self.usernameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userPasswordView);
        make.right.equalTo(self.userPasswordView);
        make.bottom.equalTo(self.userPasswordView.mas_top).with.offset(-kDefaultSpaceUnit);
        make.height.equalTo(self.userPasswordView);
    }];
    
    [self.userRoleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userPasswordView);
        make.right.equalTo(self.userPasswordView);
        make.top.equalTo(self.userPasswordView.mas_bottom).with.offset(kDefaultSpaceUnit);
        make.height.equalTo(self.userPasswordView);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userPasswordView);
        make.right.equalTo(self.userPasswordView);
        make.top.equalTo(self.userRoleView.mas_bottom).with.offset(kDefaultSpaceUnit*3);
        make.height.equalTo(self.userPasswordView);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-kDefaultSpaceUnit);
        make.bottom.equalTo(self.view).with.offset(-4);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if (self.isSelfViewNil) {
        _usernameView = nil;
        _userPasswordView = nil;
        _userRoleView = nil;
        _loginButton = nil;
    }
}

-(void)loginBtnClicked:(UIButton*)regBtn
{
    LoginInputParams *userInfo = [[LoginInputParams alloc]init];
    userInfo.userid = self.usernameView.textFiled.text;
    userInfo.password = self.userPasswordView.textFiled.text;
    userInfo.userrole = [NSString intStr:self.selectedRoleType];
    userInfo.type = @"IOS";
    
    [self.usernameView.textFiled resignFirstResponder];
    [self.userPasswordView.textFiled resignFirstResponder];
    
    NSString *inValidError;
    
    do {
        //check user
        inValidError = [self checkIsValidUserName:userInfo.userid];
        BreakIf(nil != inValidError);
        
        //check password
        inValidError = [MiscHelper isValidPasswordStr:userInfo.password];
        BreakIf(nil != inValidError);
        
        [self loginUser:userInfo];
    } while (0);
    
    if (nil != inValidError) {
        [Util showToast:inValidError];
    }
}

- (NSString*)checkIsValidUserName:(NSString*)userNameUserInput
{
    NSString *inValidInfo = nil;
    if ([Util isEmptyString:userNameUserInput]) {
        inValidInfo = @"请输入用户名";
    }
    return inValidInfo;
}

#pragma mark - 登录

- (void)loginUser:(LoginInputParams*)loginInfo
{
    [Util showWaitingDialog];
    [self.httpClient login:loginInfo response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        if (!error && (kHttpReturnCodeSuccess == responseData.resultCode)) {
            //登录系统成功
            [self loginSuccess:responseData.resultData loginInfo:loginInfo];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

- (void)setDefaultUserName:(NSString *)defaultUserName
{
    if (_defaultUserName != defaultUserName) {
        _defaultUserName = [defaultUserName copy];
        self.usernameView.textFiled.text = _defaultUserName;
    }
}

- (void)loginSuccess:(id)resultData loginInfo:(LoginInputParams*)loginInfo
{
    //更新用户属性
    [Util syncUserInfo:resultData loginInfo:loginInfo];
    
    //通知相关对象
    [self postNotification:NotificationNameLogined];
    
    if ([self.delegate respondsToSelector:@selector(loginViewControllerLoginSuccess:)]) {
        [self.delegate loginViewControllerLoginSuccess:self];
    }
    
    //Reset Accout for push
    [kAppDelegate updatePushAlias:loginInfo.userid];
    
    //Home
    [kAppDelegate startHomeViewController];
}

- (void)showPickerViewWithAnimation:(WZPickerView*)pickerView
{
    WZModal *modalView = [WZModal sharedInstance];
    modalView.showCloseButton = NO;
    modalView.onTapOutsideBlock = nil;
    modalView.contentViewLocation = WZModalContentViewLocationBottom;
    [modalView showWithContentView:pickerView andAnimated:YES];
    return;
}

- (void)hidePickerViewWithAnimation:(WZPickerView*)pickerView
{
    [[WZModal sharedInstance] hideAnimated:NO];
}

- (void)roleButtonClicked:(id)sender
{
    [self.usernameView.textFiled resignFirstResponder];
    [self.userPasswordView.textFiled resignFirstResponder];
    
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - kRolePickerViewHeight, ScreenWidth, kRolePickerViewHeight);
    WZPickerView *rolePickerView = [[WZPickerView alloc]initWithFrame:frame delegate:self];
    rolePickerView.backgroundColor = kColorWhite;
    
    //set current selected role
    NSInteger selRow = [self.rolesArray indexOfObject:@(self.selectedRoleType)];
    [rolePickerView.picker selectRow:selRow inComponent:0 animated:YES];
    
    [self showPickerViewWithAnimation:rolePickerView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.rolesArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSNumber *roleTypeNum = self.rolesArray[row];
    kUserRoleType roleType = (kUserRoleType)[roleTypeNum integerValue];
    return getUserRoleTypeName(roleType);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return kButtonDefaultHeight;
}

- (void)wzpickerDidCancelSelect:(WZPickerView *)wzpicker
{
    [self hidePickerViewWithAnimation:wzpicker];
}

- (void)wzpickerDidFinishSelect:(WZPickerView *)wzpicker
{
    [self hidePickerViewWithAnimation:wzpicker];
    
    NSInteger selectRow = [wzpicker.picker selectedRowInComponent:0];
    NSNumber * roleTypeNum = self.rolesArray[selectRow];
    self.selectedRoleType = (kUserRoleType)[roleTypeNum integerValue];
    self.userRoleView.textFiled.text = getUserRoleTypeName(self.selectedRoleType);
}

@end
