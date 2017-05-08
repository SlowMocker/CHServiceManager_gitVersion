//
//  BaseOrderDetailsViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/4.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "BaseOrderDetailsViewController.h"
#import "WZTableView.h"
#import "LeftTextRightTextCell.h"
#import "WZModal.h"

//static
static NSString *sOrderDetatilItemCellId = @"sOrderDetatilItemCellId";
static NSInteger sHeaderLabelViewTag = 0x2024387;

@interface BaseOrderDetailsViewController ()<WZTableViewDelegate>
@property(nonatomic, strong)LeftTextRightTextCell *protypeCell;
@property(nonatomic, strong)NSMutableDictionary *headerViewCache;
@end

@implementation BaseOrderDetailsViewController

- (NSMutableDictionary*)headerViewCache{
    if (nil == _headerViewCache) {
        _headerViewCache = [NSMutableDictionary new];
    }
    return _headerViewCache;
}

- (TableViewDataHandle*)detalsDataModel{
    if (nil == _detalsDataModel) {
        _detalsDataModel = [[TableViewDataHandle alloc]init];
    }
    return _detalsDataModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self alertUpdateMainConfigInfoIfNeed]) {
        return;
    }
    _tableView = [[WZTableView alloc]initWithStyle:UITableViewStyleGrouped delegate:self];
    _tableView.tableView.footerHidden = YES;
    _tableView.pageInfo.pageSize = MAXFLOAT;
    [_tableView clearBackgroundColor];
    [_tableView.tableView clearBackgroundColor];
    _tableView.tableView.backgroundView = nil;
    _tableView.tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _protypeCell = [self makeTableViewCell:sOrderDetatilItemCellId];
}

-(void)registerNotifications
{
    [self doObserveNotification:NotificationOrderDetailsChanged selector:@selector(handleNotificationOrderDetailsChanged)];
}

-(void)unregisterNotifications
{
    [self undoObserveNotification:NotificationOrderDetailsChanged];
}

- (void)handleNotificationOrderDetailsChanged
{
    [self.tableView refreshTableViewData];
}

- (UIButton*)urgeButton {
    if (nil == _urgeButton) {
        _urgeButton = [UIButton redButton:nil];
        [_urgeButton addTarget:self action:@selector(urgeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _urgeButton;
}

- (LeftTextRightTextCell*)makeTableViewCell:(NSString*)identifier
{
    LeftTextRightTextCell *cell = [[LeftTextRightTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell clearBackgroundColor];
    cell.leftTextLabel.textColor = kColorBlack;
    cell.leftTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.rightTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.rightTextLabel.textAlignment = NSTextAlignmentLeft;
    cell.backgroundView = nil;
    [cell addLineTo:kFrameLocationBottom];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - TableView Delegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    UNIMPLEMENTED;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewCellDefaultHeight;
}

- (UIView*)getHeaderLabelViewInSection:(NSInteger)section
{
    NSString *sectionKey = [NSString intStr:section];

    UIView *headerView;
    if ([self.headerViewCache containsKey:sectionKey]) {
        headerView = self.headerViewCache[sectionKey];
    }else {
        UILabel *headerLabel = [[UILabel alloc]init];
        headerLabel.tag = sHeaderLabelViewTag;
        headerLabel.textColor = kColorDefaultBlue;
        headerView = [self.tableView.tableView makeHeaderViewWithSubLabel:headerLabel bottomLineHeight:1];
    }
    return headerView;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [self getHeaderLabelViewInSection:section];
    UILabel *headerLabel = (UILabel*)[headerView viewWithTag:sHeaderLabelViewTag];

    [self setDataToHeaderLabel:headerLabel inSection:section];

    return headerView;
}

- (void)setDataToHeaderLabel:(UILabel*)headerLabel inSection:(NSInteger)section
{
    TableViewSectionHeaderData *headerData = [self.detalsDataModel headerDataOfSection:section];
    headerLabel.text = headerData.title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.detalsDataModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.detalsDataModel numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellData *cellData = [self.detalsDataModel cellDataForSection:indexPath.section row:indexPath.row];
    
    [self setCell:self.protypeCell withData:cellData];
    
    return MAX([self.protypeCell fitHeight], kTableViewCellDefaultHeight);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellData *cellData = [self.detalsDataModel cellDataForSection:indexPath.section row:indexPath.row];
    
    LeftTextRightTextCell *cell = [tableView dequeueReusableCellWithIdentifier:sOrderDetatilItemCellId];
    if (nil == cell) {
        cell = [self makeTableViewCell:sOrderDetatilItemCellId];
    }
    return [self setCell:cell withData:cellData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell*)setCell:(LeftTextRightTextCell*)cell withData:(TableViewCellData*)data
{
    cell.leftTextLabel.text = data.title;
    cell.rightTextLabel.text = data.subTitle;
    cell.accessoryView = nil;
    cell.rightTextLabel.textColor = kColorDarkGray;

    [cell layoutCustomSubViews];

    return cell;
}

-(void)urgeButtonClicked:(UIButton*)sender
{
    UNIMPLEMENTED;
}

- (void)popTextView:(NSString*)text
{
    WZModal *modal = [WZModal sharedInstance];

    //reset pop view
    modal.showCloseButton = NO;
    modal.tapOutsideToDismiss = YES;
    modal.onTapOutsideBlock = nil;
    modal.contentViewLocation = WZModalContentViewLocationMiddle;
    
    //add textview
    UIView *boardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    boardView.backgroundColor = kColorWhite;
    [boardView addSingleTapEventWithTarget:self action:@selector(boardViewClicked:)];

    UITextView *textView = [[UITextView alloc]init];
    textView.backgroundColor = kColorClear;
    textView.text = text;
    textView.textColor = kColorDarkGray;
    textView.textAlignment = NSTextAlignmentCenter;
    textView.font = SystemFont(20);
    textView.editable = NO;
    CGSize fitSize = [textView sizeThatFits:CGSizeMake(ScreenWidth - 60, MAXFLOAT)];
    textView.bounds = CGRectMake(0, 0, fitSize.width, MIN(fitSize.height, ScreenHeight));

    [boardView addSubview:textView];
    textView.center = boardView.center;

    [modal showWithContentView:boardView andAnimated:YES];
}

- (void)boardViewClicked:(id)sender
{
    [[WZModal sharedInstance]hide];
}

@end
