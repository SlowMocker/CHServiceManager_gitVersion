//
//  RefuseOrderViewController.m
//  ServiceManager
//
//  Created by will.wang on 17/03/2017.
//  Copyright © 2017 wangzhi. All rights reserved.
//

#import "RefuseOrderViewController.h"

@interface RefuseOrderViewController ()<WZTableViewDelegate, WZSingleCheckViewControllerDelegate>
@property(nonatomic, strong)WZTableView *tableView;
@property(nonatomic, strong)UITableViewCell *reasonCell;

@property(nonatomic, strong)UITableViewCell *noteEditCell;

@property(nonatomic, strong)UIView *customFooterView;
@property(nonatomic, strong)UIButton *confirmButton;

@end

@implementation RefuseOrderViewController

- (UITableViewCell*)reasonCell
{
    if (nil == _reasonCell) {
        _reasonCell = [MiscHelper makeCommonSelectCell:@"拒绝原因"];
        [_reasonCell.detailTextLabel setFont:SystemFont(15)];
    }
    return _reasonCell;
}

- (WZTextView*)textView
{
    if (nil == _textView) {
        _textView = [[WZTextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 2*kTableViewLeftPadding, 130) maxWords:300];
        _textView.placeholder = @"在这儿输入拒绝备注";
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
        CGRect frame = CGRectMake(0, 0, ScreenWidth - 2*kTableViewLeftPadding, kButtonDefaultHeight + kDefaultSpaceUnit*2);
        _customFooterView = [[UIView alloc]initWithFrame:frame];
        [_customFooterView clearBackgroundColor];

        //add confirm button
        _confirmButton = [UIButton redButton:@"确定"];
        [_confirmButton setBackgroundColor:kColorLightGray forState:UIControlStateDisabled];
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_customFooterView addSubview:_confirmButton];
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(kButtonDefaultHeight));
            make.width.equalTo(_customFooterView);
            make.center.equalTo(_customFooterView);
        }];
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
    return 10;
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
            cellHeight = 130;
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
            cell = self.reasonCell;
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
        [self gotoReasonCheckViewController];
    }
}

- (void)gotoReasonCheckViewController
{
    NSArray *reasonArray = [ConfigInfoManager sharedInstance].refueseReasons;
    NSArray *fmtReasonArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:reasonArray];

    WZSingleCheckViewController *checkVc;
    checkVc = [MiscHelper pushToCheckListViewController:@"请选择拒绝原因" checkItems:fmtReasonArray checkedItem:self.checkedReasonItem from:self delegate:self];
}

- (void)confirmButtonClicked:(id)sender
{
    if (self.confirmBlock) {
        self.confirmBlock(self);
    }
}

- (void)singleCheckViewController:(WZSingleCheckViewController *)viewController didChecked:(CheckItemModel *)checkedItem
{
    self.checkedReasonItem = checkedItem;
    self.reasonCell.detailTextLabel.text = checkedItem.value;
    [viewController popViewController];
}

@end

