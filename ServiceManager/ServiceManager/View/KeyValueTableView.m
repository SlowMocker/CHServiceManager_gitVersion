//
//  KeyValueTableView.m
//  ServiceManager
//
//  Created by wangzhi on 15-5-27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "KeyValueTableView.h"
#import "LeftTextRightTextCell.h"

static NSString *sLeftTextRightTextCell = @"sLeftTextRightTextCell";

@interface KeyValueTableView()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)LeftTextRightTextCell *protypeCell;
@end

@implementation KeyValueTableView

- (instancetype)initWithDefault
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;

        [self registerClass:[LeftTextRightTextCell class] forCellReuseIdentifier:sLeftTextRightTextCell];
        _protypeCell = [self dequeueReusableCellWithIdentifier:sLeftTextRightTextCell];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)setCellDataArray:(NSArray *)cellDataArray
{
    _cellDataArray = [cellDataArray copy];
    [self reloadData];
}

- (void)configCell:(LeftTextRightTextCell*)cell withLeftText:(NSString*)leftText rightText:(NSString*)rightText
{
    [cell clearBackgroundColor];
    [cell.contentView clearBackgroundColor];
    [cell.leftTextLabel setText:leftText];
    [cell.rightTextLabel setText:rightText];
    [cell layoutCustomSubViews];
    [cell addDefaultSepraterLine];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyValueModel *data = self.cellDataArray[indexPath.row];

    if (self.constHeight > 1) {
        return self.constHeight;
    }else {
        [self configCell:self.protypeCell withLeftText:data.key rightText:data.value];
        return [self.protypeCell fitHeight];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftTextRightTextCell *cell = [tableView dequeueReusableCellWithIdentifier:sLeftTextRightTextCell];
    KeyValueModel *data = self.cellDataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [self configCell:cell withLeftText:data.key rightText:data.value];

    return cell;
}

@end
