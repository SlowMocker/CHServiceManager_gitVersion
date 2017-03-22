//
//  TBSettingViewController.m
//  ServiceManager
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "TBSettingViewController.h"
#import "ChangePasswordViewController.h"
#import "AboutViewController.h"
#import "EmployeeManageViewCodntroller.h"
#import "ConfigInfoManager.h"
#import "InhouseAppCheckUpdate.h"

static const CGFloat kUserBaseInfoViewHeight = 66;

@interface TBSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

//content views
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *cellsArray;
@property(nonatomic, strong)UIView *tableHeaderView;
@property(nonatomic, strong)UIView *userInfoView;

//static cells
@property(nonatomic, strong)UITableViewCell *changePwdCell;
@property(nonatomic, strong)UITableViewCell *personManageCell;
@property(nonatomic, strong)UITableViewCell *cleanCacheCell;
@property(nonatomic, strong)UITableViewCell *savePwdCell;
@property(nonatomic, strong)UITableViewCell *updateDataCell;
@property(nonatomic, strong)UITableViewCell *updateVersionCell;
@property(nonatomic, strong)UITableViewCell *aboutCell;
@end

@implementation TBSettingViewController

- (UITableView*)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView clearBackgroundColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundView = nil;
        _tableView.scrollEnabled = NO;
        [_tableView hideExtraCellLine];
    }
    return _tableView;
}

- (UIView*)userInfoView
{
    if (nil == _userInfoView) {
        CGFloat exitButtonWidth = 50;
        
        CGRect frame = CGRectMake(0, 0, ScreenWidth, kUserBaseInfoViewHeight);
        _userInfoView = [[UIView alloc]initWithFrame:frame];
        _userInfoView.backgroundColor = kColorDefaultOrange;

        //name label
        frame = CGRectMake(kTableViewLeftPadding, 0, ScreenWidth - kTableViewLeftPadding - exitButtonWidth, kUserBaseInfoViewHeight/2);
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:frame];
        [nameLabel clearBackgroundColor];
        nameLabel.textColor = kColorWhite;
        nameLabel.font = SystemFont(16);
        nameLabel.text = [Util defaultStr:kNoName ifStrEmpty:self.user.nickName];
        nameLabel.adjustsFontSizeToFitWidth = YES;
        [_userInfoView addSubview:nameLabel];

        //mobile label
        frame.origin.y = CGRectGetMaxY(frame);
        UILabel *mobileLabel = [[UILabel alloc]initWithFrame:frame];
        [mobileLabel clearBackgroundColor];

        AttributeStringAttrs *telAttr = [AttributeStringAttrs new];
        telAttr.textColor = kColorWhite;
        telAttr.text = [NSString stringWithFormat:@"%@\t",self.user.mobile];
        telAttr.font = SystemFont(15);

        AttributeStringAttrs *roleAttr = [AttributeStringAttrs new];
        roleAttr.textColor = kColorDefaultGreen;
        roleAttr.text = getUserRoleTypeName(self.user.userRoleType);
        roleAttr.font = SystemFont(13);

        mobileLabel.attributedText = [NSString makeAttrString:@[telAttr,roleAttr]];
        [_userInfoView addSubview:mobileLabel];

        //exit icon
        frame = CGRectMake(CGRectGetWidth(_userInfoView.frame) - exitButtonWidth, 0, exitButtonWidth, CGRectGetHeight(_userInfoView.frame));
        UIButton *exitBtn = [UIButton imageButtonWithNorImg:@"exit_loginout" selImg:@"exit_loginout" size:frame.size target:self action:@selector(exitButtonClicked:)];
        exitBtn.frame = frame;
        [_userInfoView addSubview:exitBtn];
    }
    return _userInfoView;
}

- (UITableViewCell*)changePwdCell
{
    if (nil == _changePwdCell) {
        _changePwdCell = [MiscHelper makeCellWithLeftIcon:@"modifi_password" leftTitle:@"修改密码" rightText:nil];
        _changePwdCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return _changePwdCell;
}

- (UITableViewCell*)personManageCell
{
    if (nil == _personManageCell) {
        _personManageCell = [MiscHelper makeCellWithLeftIcon:@"user_line_ico" leftTitle:@"人员管理" rightText:nil];
        _personManageCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return _personManageCell;
}

- (UITableViewCell*)cleanCacheCell
{
    if (nil == _cleanCacheCell) {
        _cleanCacheCell = [MiscHelper makeCellWithLeftIcon:@"clearcache" leftTitle:@"清除缓存" rightText:nil];
        _cleanCacheCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return _cleanCacheCell;
}

- (UITableViewCell*)savePwdCell
{
    if (nil == _savePwdCell) {
        _savePwdCell = [MiscHelper makeCellWithLeftIcon:@"save_password" leftTitle:@"保存密码" rightText:nil];
        
        //right switch
        UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 40, 24)];
        switchView.onTintColor = kColorDefaultOrange;
        switchView.on = [ConfigInfoManager sharedInstance].bSavePassword;
        [switchView addTarget:self action:@selector(savePasswordSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        _savePwdCell.accessoryView = switchView;
    }
    return _savePwdCell;
}

- (UITableViewCell*)updateDataCell
{
    if (nil == _updateDataCell) {
        _updateDataCell = [MiscHelper makeCellWithLeftIcon:@"refresh_update" leftTitle:@"更新主数据" rightText:nil];
    }
    return _updateDataCell;
}

- (UITableViewCell*)updateVersionCell
{
    if (nil == _updateVersionCell) {
        _updateVersionCell = [MiscHelper makeCellWithLeftIcon:@"new_update" leftTitle:@"版本更新" rightText:nil];
    }
    return _updateVersionCell;
}

- (UITableViewCell*)aboutCell
{
    if (nil == _aboutCell) {
        _aboutCell = [MiscHelper makeCellWithLeftIcon:@"about" leftTitle:@"关于" rightText:nil];
    }
    return _aboutCell;
}

- (NSArray*)addSettingCells
{
    NSMutableArray *cells = [[NSMutableArray alloc]init];
    NSMutableArray *sectionCells;

    //section 0
    if (kUserRoleTypeFacilitator == self.user.userRoleType) {
        //服务商,人员管理
        sectionCells = [[NSMutableArray alloc]init];
        [sectionCells addObject:self.personManageCell];
        [cells addObject:sectionCells];
    }else if(kUserRoleTypeRepairer ==self.user.userRoleType){
        //维修工,修改密码
        sectionCells = [[NSMutableArray alloc]init];
        [sectionCells addObject:self.changePwdCell];
        [cells addObject:sectionCells];
    }else if (kUserRoleTypeSupporter == self.user.userRoleType){
        //技工，暂时不做修改密码
    }

    //section 1
    sectionCells = [[NSMutableArray alloc]init];
    [sectionCells addObject:self.cleanCacheCell];
    [sectionCells addObject:self.savePwdCell];
    [cells addObject:sectionCells];
    
    //section 2
    sectionCells = [[NSMutableArray alloc]init];
    [sectionCells addObject:self.updateDataCell];
    [sectionCells addObject:self.updateVersionCell];
    [sectionCells addObject:self.aboutCell];
    [cells addObject:sectionCells];
    
    return cells;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    self.cellsArray = [self addSettingCells];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    self.tableView.tableHeaderView = self.userInfoView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //set cached size
    CGFloat cachedSize = [MiscHelper cacheFolderSize];
    NSString *cachedStr;
    if (cachedSize/1024 >= 1) {
        cachedStr = [NSString stringWithFormat:@"%.1fMB",cachedSize/1024];
    }else {
        cachedStr = [NSString stringWithFormat:@"%.0fKB",cachedSize];
    }
    self.cleanCacheCell.detailTextLabel.text = cachedStr;

    [self.configInfoMgr loadConfigInfosIfNoData];
    [self setMainConfigInfoUpdateTimeText];
}

- (void)registerNotifications
{
    [self doObserveNotification:NotificationMainConfigInfoUpdated selector:@selector(handleNotificationMainConfigInfoUpdated)];
    [self doObserveNotification:NotificationMainConfigInfoUpdateFailed selector:@selector(handleNotificationMainConfigInfoUpdateFailed)];
}

-(void)unregisterNotifications
{
    [self undoObserveNotification:NotificationMainConfigInfoUpdated];
    [self undoObserveNotification:NotificationMainConfigInfoUpdateFailed];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rowArray = [self.cellsArray objectAtIndex:section];
    return rowArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kButtonDefaultHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rowArray = [self.cellsArray objectAtIndex:indexPath.section];
    return rowArray[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rowArray = [self.cellsArray objectAtIndex:indexPath.section];
    UITableViewCell *selectedCell = rowArray[indexPath.row];

    if (selectedCell == self.personManageCell) {
        EmployeeManageViewCodntroller *manageVc = [[EmployeeManageViewCodntroller alloc]init];
        manageVc.title = @"维修工管理";
        [self pushViewController:manageVc];
    }else if (selectedCell == self.changePwdCell) {
        ChangePasswordViewController *changePwdVc = [[ChangePasswordViewController alloc]init];
        changePwdVc.title = self.changePwdCell.textLabel.text;
        [self pushViewController:changePwdVc];
    }else if (selectedCell == self.cleanCacheCell){
        [Util showWaitingDialog];
        [MiscHelper cleanCacheFolderWithComplete:^{
            [Util dismissWaitingDialog];
            [Util showToast:@"清理完成"];
            self.cleanCacheCell.detailTextLabel.text = [NSString stringWithFormat:@"%.0fKB",[MiscHelper cacheFolderSize]];
        }];
    }else if (selectedCell == self.updateDataCell){
        if ([ConfigInfoManager sharedInstance].isLoading) {
            [Util showToast:@"正在更新中..."];
            [self setMainConfigInfoUpdateTimeText];
        }else {
            [Util confirmAlertView:@"更新主数据将需要几分钟时间，您确定要更新吗?" confirmAction:^{
                [[ConfigInfoManager sharedInstance]updateConfigInfosWithWaitingDialog:YES];
                [self setMainConfigInfoUpdateTimeText];
            }];
        }
    }else if (selectedCell == self.updateVersionCell){
        [[InhouseAppCheckUpdate sharedInstance]checkAppVersion:YES afterCheckAction:nil];
    }else if (selectedCell == self.aboutCell){
        AboutViewController *aboutVc = [[AboutViewController alloc]init];
        aboutVc.title = self.aboutCell.textLabel.text;
        [self pushViewController:aboutVc];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isSelfViewNil) {
        self.cellsArray = nil;
        self.tableHeaderView = nil;
        self.tableView = nil;
        self.userInfoView = nil;
        self.changePwdCell = nil;
        self.cleanCacheCell = nil;
        self.savePwdCell = nil;
        self.updateDataCell = nil;
        self.updateVersionCell = nil;
        self.aboutCell = nil;
    }
}

- (void)exitButtonClicked:(id)sender
{
    [Util confirmAlertView:@"您确定要退出吗？" confirmAction:^{
        [self exitCurrentUser];
    }];
}

- (void)savePasswordSwitchChanged:(UISwitch*)savePwdSwitch
{
    [ConfigInfoManager sharedInstance].bSavePassword = savePwdSwitch.isOn;
}

- (void)setMainConfigInfoUpdateTimeText
{
    //set main info update date
    NSDate *mainInfoUpdateDate = [UserDefaults sharedInstance].mainInfoUpdateDate;
    if (mainInfoUpdateDate) {
        NSString *dateText = [NSString dateStringWithDate:mainInfoUpdateDate strFormat:WZDateStringFormat3];
        self.updateDataCell.detailTextLabel.text = [NSString stringWithFormat:@"上次更新%@",dateText];
    }else if (self.configInfoMgr.isLoading){
        NSString *prompt = self.configInfoMgr.hasLoadedMainInfo ? @"更新中..." : @"加载中...";
        self.updateDataCell.detailTextLabel.text = prompt;
    }else {
        self.updateDataCell.detailTextLabel.text = [NSString stringWithFormat:@"下载失败"];
    }
}

- (void)handleNotificationMainConfigInfoUpdated
{
    [self setMainConfigInfoUpdateTimeText];
}

- (void)handleNotificationMainConfigInfoUpdateFailed
{
    [self setMainConfigInfoUpdateTimeText];
}

@end
