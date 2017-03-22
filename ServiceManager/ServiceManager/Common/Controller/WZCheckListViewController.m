//
//  WZCheckListViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/8/31.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZCheckListViewController.h"

static NSString *sCheckViewCellIdentifier = @"sCheckViewCellIdentifier";

@interface WZCheckListViewController ()<WZTableViewDelegate>
@property(nonatomic, strong)WZTableView *checkTableView;
@property(nonatomic, strong)UITableViewCell *protypeCell;
@end

@implementation WZCheckListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.checkTableView];
    [self.checkTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (WZTableView *)checkTableView
{
    if (nil == _checkTableView) {
        _checkTableView = [[WZTableView alloc]initWithStyle:UITableViewStylePlain delegate:self];
        _checkTableView.pageInfo.pageSize = MAXFLOAT;
        _checkTableView.tableView.footerHidden = YES;
        _checkTableView.tableView.headerHidden = YES;
        [_checkTableView.tableView hideExtraCellLine];
        [_checkTableView.tableView addTopHeaderSpace:kDefaultSpaceUnit];
        _checkTableView.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_checkTableView.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sCheckViewCellIdentifier];
        _protypeCell = [_checkTableView.tableView dequeueReusableCellWithIdentifier:sCheckViewCellIdentifier];
    }
    return _checkTableView;
}

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    [tableView didRequestTableViewListDatasWithCount:self.checkItemArray.count totalCount:self.checkItemArray.count page:pageInfo response:nil error:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.checkItemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckItemModel *checkItem = self.checkItemArray[indexPath.row];

    [self setCell:self.protypeCell withData:checkItem];
    
    return MAX([self.protypeCell fitHeight], kTableViewCellDefaultHeight);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckItemModel *checkItem = self.checkItemArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCheckViewCellIdentifier];

    return [self setCell:cell withData:checkItem];
}

- (UITableViewCell*)setCell:(UITableViewCell*)cell withData:(CheckItemModel*)cellModel
{
    //left point
    UIView *point = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
    [point circleView];
    cell.imageView.image = [UIImage imageWithView:point];
    cell.imageView.contentMode = UIViewContentModeCenter;

    cell.textLabel.text = cellModel.value;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CheckItemModel *selectItem = self.checkItemArray[indexPath.row];
    selectItem.isChecked = !selectItem.isChecked;

    if (selectItem.isChecked) {
        //check a item
        if ([self.delegate respondsToSelector:@selector(checkListViewController:didCheck:)]) {
            [self.delegate checkListViewController:self didCheck:selectItem];
        }
    }else {
        //cancel a item
    }
}

@end
