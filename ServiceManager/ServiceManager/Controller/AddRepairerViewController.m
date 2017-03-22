//
//  AddRepairerViewController.m
//  ServiceManager
//
//  Created by mac on 15/10/5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "AddRepairerViewController.h"
#import "LabelEditCell.h"
#import <UIAlertView+Blocks.h>

@interface AddRepairerViewController ()
@property(nonatomic, strong)LabelEditCell *nameCell;
@property(nonatomic, strong)LabelEditCell *phoneCell;
@property(nonatomic, strong)UIView *tableFooterView;
@property(nonatomic, strong)NSMutableArray *cellArray;
@end

@implementation AddRepairerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加维修工";

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
        _nameCell = nil;
        _phoneCell = nil;
        _tableFooterView = nil;
        _cellArray = nil;
    }
}

- (LabelEditCell*)phoneCell
{
    if (nil == _phoneCell) {
        _phoneCell = [LabelEditCell makeLabelEditCell:@"电话" hint:@"请输入联系电话" keyBoardType:UIKeyboardTypeNamePhonePad unit:nil];
    }
    return _phoneCell;
}

- (LabelEditCell*)nameCell
{
    if (nil == _nameCell) {
        _nameCell = [LabelEditCell makeLabelEditCell:@"姓名" hint:@"请输入维修工姓名" keyBoardType:UIKeyboardTypeDefault unit:nil];
    }
    return _nameCell;
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
    [self.cellArray addObject:self.nameCell];
    [self.cellArray addObject:self.phoneCell];
}

- (UIView*)tableFooterView
{
    CGRect frame;
    
    if (nil == _tableFooterView) {
        frame = CGRectMake(0, 0, ScreenWidth, 100);
        _tableFooterView = [[UIView alloc]initWithFrame:frame];
        [_tableFooterView clearBackgroundColor];
        
        UIButton *addButton = [UIButton orangeButton:@"添加"];
        addButton.frame = CGRectMake(0, 0, ScreenWidth - kDefaultSpaceUnit * 2, kButtonDefaultHeight);
        addButton.center = _tableFooterView.center;
        [addButton addTarget:self action:@selector(addRepairerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_tableFooterView addSubview:addButton];
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

#pragma mark - 添加维修工

- (void)addNewRepairer:(NewRepairerInputParams*)param
{
    [Util showWaitingDialog];
    [self.httpClient facilitator_newRepairer:param response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error && (kHttpReturnCodeSuccess == responseData.resultCode)) {
            [Util showToast:@"添加成功"];
            [self postNotification:NotificationEmployeesChanged];
            [self popViewController];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

-(void)addRepairerBtnClicked:(UIButton*)regBtn
{
    NSString *inValidError;
    
    do {
        if ([Util isEmptyString:self.nameCell.middleTextField.text]) {
            inValidError = @"姓名不能为空";
        }
        BreakIf(nil != inValidError);
        
        if ([Util isEmptyString:self.phoneCell.middleTextField.text]) {
            inValidError = @"电话不能为空";
        }
        BreakIf(nil != inValidError);

        if (self.phoneCell.middleTextField.text.length > 20) {
            inValidError = @"电话号码最多20位";
        }
        BreakIf(nil != inValidError);
    } while (0);
    
    if (nil != inValidError) {
        [Util showToast:inValidError];
    }else {
        NewRepairerInputParams *input = [NewRepairerInputParams new];
        input.username = self.nameCell.middleTextField.text;
        input.telephone = self.phoneCell.middleTextField.text;
        input.partner = self.user.userId;
        [self addNewRepairer:input];
    }
}

@end
