//
//  TwoKeyValueTableView.m
//  ServiceManager
//
//  Created by wangzhi on 15-5-27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "TwoKeyValueTableView.h"
#import "LeftAttrRightAttrCell.h"

static NSString *sLeftAttrRightAttrCell = @"sLeftAttrRightAttrCell";

@interface TwoKeyValueTableView()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)LeftAttrRightAttrCell *protypeCell;
@end

@implementation TwoKeyValueTableView

- (instancetype)initWithDefault
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        _constHeight = kTableViewCellDefaultHeight;
        [self registerClass:[LeftAttrRightAttrCell class] forCellReuseIdentifier:sLeftAttrRightAttrCell];
        _protypeCell = [self dequeueReusableCellWithIdentifier:sLeftAttrRightAttrCell];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)setCellDataArray:(NSArray *)cellDataArray
{
    _cellDataArray = [cellDataArray copy];
    [self reloadData];
}

- (LeftAttrRightAttrCell*)configCell:(LeftAttrRightAttrCell*)cell withIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row * 2 < self.cellDataArray.count) {
        KeyValueModel *leftAttr;
        leftAttr = self.cellDataArray[indexPath.row*2];
        [cell.leftAttrLabel setText:leftAttr.key];
        [cell.leftAttrValueLabel setText:leftAttr.value];
    }
    if (indexPath.row * 2 + 1 < self.cellDataArray.count) {
        KeyValueModel *rightAttr;
        rightAttr = self.cellDataArray[indexPath.row*2+1];
        [cell.rightAttrLabel setText:rightAttr.key];
        [cell.rightAttrValueLabel setText:rightAttr.value];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell clearBackgroundColor];
    [cell.contentView clearBackgroundColor];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.constHeight > 1) {
        return self.constHeight;
    }else {
        [self configCell:self.protypeCell withIndexPath:indexPath];
        return [self.protypeCell fitHeight];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDataArray.count/2 + ((self.cellDataArray.count%2 == 0) ? 0 : 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftAttrRightAttrCell *cell = [tableView dequeueReusableCellWithIdentifier:sLeftAttrRightAttrCell];

    return [self configCell:cell withIndexPath:indexPath];
}

@end
