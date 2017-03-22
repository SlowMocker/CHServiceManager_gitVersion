//
//  WZSingleCheckListView.m
//  ServiceManager
//
//  Created by will.wang on 15/9/16.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZSingleCheckListView.h"

static NSString *sCheckViewCellIdentifier = @"CheckViewCellIdentifier";

@interface WZSingleCheckListView ()

@end

@implementation WZSingleCheckListView

- (instancetype)initWithCheckItems:(NSArray*)checkItems checkIndex:(NSInteger)checkIndex delegate:(id<WZSingleCheckListViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        _checkItemArray = checkItems;
        _delegate = delegate;
        _checkIndex = checkIndex;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView hideExtraCellLine];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sCheckViewCellIdentifier];
        _protypeCell = [_tableView dequeueReusableCellWithIdentifier:sCheckViewCellIdentifier];
    }
    return _tableView;
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
    checkItem.isChecked = (indexPath.row == self.checkIndex);
    
    if ([self.delegate respondsToSelector:@selector(checkListView:setCell:withData:)]) {
        [self.delegate checkListView:self setCell:cell withData:checkItem];
    }else {
        [self setCell:cell withData:checkItem];
    }

    return cell;
}

- (UITableViewCell*)setCell:(UITableViewCell*)cell withData:(CheckItemModel*)cellModel
{
    //left check image
    cell.imageView.image = ImageNamed(cellModel.isChecked ? @"selected_orange_none" :@"selected_gray_none");
    cell.imageView.contentMode = UIViewContentModeCenter;

    cell.textLabel.text = cellModel.value;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cell.textLabel.textColor = cellModel.isChecked ? kColorDefaultOrange : kColorDarkGray;
    cell.textLabel.font = SystemFont(15);
    cell.accessoryType = self.accessoryType;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.checkIndex != indexPath.row) {
        UITableViewCell *preChecked = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.checkIndex inSection:0]];
        self.checkIndex = indexPath.row;
        [tableView reloadTableViewCell:preChecked];
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }

    //check a item
    if ([self.delegate respondsToSelector:@selector(checkListView:didCheckAtIndex:)]) {
        [self.delegate checkListView:self didCheckAtIndex:indexPath.row];
    }
}

@end
