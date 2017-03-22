//
//  EmployeeManageViewCodntroller.m
//  ServiceManager
//
//  Created by will.wang on 15/8/27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "BulletinListViewController.h"
#import "WZTableView.h"
#import "BulletinTableViewCell.h"
#import "BulletDetailViewController.h"

static NSString *sBulletinTableViewCell = @"sBulletinTableViewCell";

@interface BulletinListViewController ()<WZTableViewDelegate>
{
    WZTableView *_tableView;
}
@property(nonatomic, strong)NSMutableArray *itemDataArray;
@property(nonatomic, strong)BulletinTableViewCell *protypeCell;

@end

@implementation BulletinListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"公告";
    
    _tableView = [[WZTableView alloc]initWithStyle:UITableViewStylePlain delegate:self];
    [_tableView.tableView setFooterHidden:YES];
    [_tableView.tableView hideExtraCellLine];
    [_tableView.tableView registerClass:[BulletinTableViewCell class] forCellReuseIdentifier:sBulletinTableViewCell];
    self.protypeCell = [_tableView.tableView dequeueReusableCellWithIdentifier:sBulletinTableViewCell];

    [self.view addSubview:_tableView];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    [_tableView refreshTableViewData];
    
    self.itemDataArray = [[NSMutableArray alloc]init];
}

#pragma mark - table view delegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    [self requestBulletList:tableView withPage:pageInfo];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = self.itemDataArray.count;
    if (rowCount > 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BulletinInfo *bulletin = self.itemDataArray[indexPath.row];
    [self setData:bulletin toCell:self.protypeCell];
    return [self.protypeCell fitHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BulletinTableViewCell *cell = (BulletinTableViewCell*)[tableView dequeueReusableCellWithIdentifier:sBulletinTableViewCell];
    BulletinInfo *bulletin = self.itemDataArray[indexPath.row];

    return [self setData:bulletin toCell:cell];
}

- (NSAttributedString*)buildBulletinTitle:(BulletinInfo*)bulletin
{
    NSMutableArray *titleTextArray = [NSMutableArray new];

    if (bulletin.isTop) {
        AttributeStringAttrs *topAttr = [AttributeStringAttrs new];
        topAttr.text = @"[顶] ";
        topAttr.textColor = kColorDefaultRed;
        topAttr.font = SystemBoldFont(15);
        [titleTextArray addObject:topAttr];
    }
    
    AttributeStringAttrs *textAttr = [AttributeStringAttrs new];
    textAttr.text = [Util defaultStr:@"标题未知" ifStrEmpty:bulletin.title];
    textAttr.textColor = kColorBlack;
    textAttr.font = SystemFont(15);
    [titleTextArray addObject:textAttr];

    return [NSString makeAttrString:titleTextArray];
}

- (BulletinTableViewCell*)setData:(BulletinInfo*)bulletin toCell:(BulletinTableViewCell*)cell
{
    //fill data
    cell.titleTextView.attributedText = [self buildBulletinTitle:bulletin];
    cell.summaryTextView.text = bulletin.summary;
    cell.dateTextView.text = bulletin.createTimeText;

    return cell;
}

- (void)requestBulletList:(WZTableView*)tableView withPage:(PageInfo*)pageInfo
{
    QueryBulletListInputParams *input = [QueryBulletListInputParams new];
    input.pagenow = [NSString intStr:pageInfo.currentPage];

    [[HttpClientManager sharedInstance]queryBulletList:input response:^(NSError *error, HttpResponseData *responseData) {
        NSArray *bulletins;
        if(!error && kHttpReturnCodeSuccess == responseData.resultCode){
            bulletins = [MiscHelper parserObjectList:responseData.resultData objectClass:@"BulletinInfo"];
            if (bulletins.count > 0) {
                if (pageInfo.currentPage == 1) { //update items
                    [self.itemDataArray removeAllObjects];
                }
                [self.itemDataArray addObjectsFromArray:bulletins];
            }
        }
        [tableView didRequestTableViewListDatasWithCount:bulletins.count totalCount:self.itemDataArray.count page:pageInfo response:responseData error:error];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BulletinInfo *bulletin = self.itemDataArray[indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BulletDetailViewController *detailVc = [[BulletDetailViewController alloc]init];
    detailVc.title = @"公告详情";
    detailVc.bulletin = bulletin;

    [self pushViewController:detailVc];
}

@end
