//
//  MutiExtendDetailListViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/8/31.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "MutiExtendDetailListViewController.h"
#import "WZTableView.h"
#import "LeftTextRightTextCell.h"

static NSString *sOrderDetatilItemCellId = @"sOrderDetatilItemCellId";

@interface MutiExtendDetailListViewController ()<WZTableViewDelegate>
@property(nonatomic, strong)WZTableView *tableView;
@property(nonatomic, strong)LeftTextRightTextCell *protypeCell;

//ITEM: NSArray(item: KeyValueModel)
@property(nonatomic, strong)NSMutableArray *detailItemArray;
@property(nonatomic, strong)OrderContentDetails *orderDetails;
@end

@implementation MutiExtendDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"产品信息详情";
    
    _tableView = [[WZTableView alloc]initWithStyle:UITableViewStyleGrouped delegate:self];
    _tableView.tableView.headerHidden = YES;
    _tableView.tableView.footerHidden = YES;
    _tableView.pageInfo.pageSize = MAXFLOAT;
    [_tableView clearBackgroundColor];
    [_tableView.tableView clearBackgroundColor];
    _tableView.tableView.backgroundView = nil;
    _tableView.tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kTableViewLeftPadding, 0, kTableViewLeftPadding));
    }];
    _protypeCell = [self makeTableViewCell:sOrderDetatilItemCellId];
    
    self.detailItemArray = [self buildCellItemData:self.orderDetails];
    [_tableView.tableView reloadData];
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
//    [cell layoutCustomSubViews];
    [cell addLineTo:kFrameLocationBottom];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (KeyValueModel*)makeCellData:(NSString*)title value:(NSString*)value
{
    KeyValueModel *model = [[KeyValueModel alloc]init];
    model.key = title;
    model.value = [Util defaultStr:kUnknown ifStrEmpty:value];
    return model;
}

- (NSMutableArray*)buildCellItemData:(OrderContentDetails*)orderDetail
{
    NSMutableArray *sectionArray = [NSMutableArray new];
    NSMutableArray *rowArray;
    NSString *tempStr;
    
    for (ExtendProductContent *product in self.extendOrder.productInfoList) {
        rowArray = [NSMutableArray new];

        [rowArray addObject:[self makeCellData:@"品牌" value:[MiscHelper extendProductBrandName:product]]];
        [rowArray addObject:[self makeCellData:@"品类" value:[MiscHelper extendSubProductName:product forType:kExtendServiceTypeMutiple]]];
        [rowArray addObject:[self makeCellData:@"机型" value:[MiscHelper extendProductModelName:product]]];
        [rowArray addObject:[self makeCellData:@"机号" value:product.zzfld00000b]];
        [rowArray addObject:[self makeCellData:@"发票编号" value:product.invoiceNo]];
        
        tempStr = product.zzfld00002i;
        [rowArray addObject:[self makeCellData:@"购买日期" value:tempStr]];

        tempStr = product.factoryWarrantyDue;
        [rowArray addObject:[self makeCellData:@"过保日期" value:tempStr]];

        tempStr = product.extendprdBeginDue;
        [rowArray addObject:[self makeCellData:@"延保起始日期" value:tempStr]];

        tempStr = product.extendprdEndDue;
        [rowArray addObject:[self makeCellData:@"延保过期日期" value:tempStr]];

        [sectionArray addObject:rowArray];
    }
    return sectionArray;
}

#pragma mark - TableView Delegate

-(void)tableView:(WZTableView*)tableView requestListDatas:(PageInfo*)pageInfo
{
    [tableView didRequestTableViewListDatasWithCount:1 totalCount:1 page:pageInfo response:nil error:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableViewCellDefaultHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.textColor = kColorDefaultBlue;
    UIView *headerView = [tableView makeHeaderViewWithSubLabel:headerLabel bottomLineHeight:1];
    headerLabel.text = [NSString stringWithFormat:@"产品%@",@(section + 1)];
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.detailItemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *attrArray = self.detailItemArray[section];
    return attrArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *attrArray = self.detailItemArray[indexPath.section];
    KeyValueModel *orderAttr = attrArray[indexPath.row];
    
    [self setCell:self.protypeCell withData:orderAttr];
    
    return MAX([self.protypeCell fitHeight], kTableViewCellDefaultHeight);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *attrArray = self.detailItemArray[indexPath.section];
    KeyValueModel *orderAttr = attrArray[indexPath.row];
    
    LeftTextRightTextCell *cell = [tableView dequeueReusableCellWithIdentifier:sOrderDetatilItemCellId];
    if (nil == cell) {
        cell = [self makeTableViewCell:sOrderDetatilItemCellId];
    }
    return [self setCell:cell withData:orderAttr];
}

- (UITableViewCell*)setCell:(LeftTextRightTextCell*)cell withData:(KeyValueModel*)data
{
    cell.leftTextLabel.text = data.key;
    cell.rightTextLabel.text = data.value;
    [cell layoutCustomSubViews];

    return cell;
}

@end
