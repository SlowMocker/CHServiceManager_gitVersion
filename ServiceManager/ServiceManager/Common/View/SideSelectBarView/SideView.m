//
//  SideView.m
//  SmallSecretary2.0
//
//  Created by zhiqiangcao on 14-9-17.
//  Copyright (c) 2014年 pretang. All rights reserved.
//

#define SideViewItemsHeight (44)

#import "SideView.h"
#import "SideBarEntity.h"

#define SideViewCellBottomViewTag (-235619)
#define SideViewCellLeftViewTag (SideViewCellBottomViewTag + 1)

@interface SideView()
<
    UITableViewDataSource,
    UITableViewDelegate
    >
{
    UIButton *_titleButton;
    UITableView *_displayTableView;
    BOOL _next;
    BOOL _mutiMode;
    NSArray *_dataArray;
    SideBarEntity *_selectedSideBarEntity;
}

@end

@implementation SideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withSource:(NSArray *)sourceArray withNext:(BOOL)next titleButtonCanClick:(BOOL)can withSelectSideBarEntity:(SideBarEntity *)sideBarEntity mutiMode:(BOOL)mutiMode
{
    self = [self initWithFrame:frame];
    if (self)
    {
        _selectedSideBarEntity = sideBarEntity;
        _next = next;
        _mutiMode = mutiMode;
        _dataArray = [NSArray arrayWithArray:sourceArray];

        if (title)
        {
            _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _titleButton.frame = CGRectMake(0, 0, CGRectGetWidth(frame), SideViewItemsHeight);
            _titleButton.backgroundColor = ColorWithHex(@"#edf1f4");
            [_titleButton setTitle:title forState:UIControlStateNormal];
            [_titleButton setTitleColor:kColorDefaultGray forState:UIControlStateNormal];
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_titleButton.frame) - 0.5, CGRectGetWidth(_titleButton.frame), 0.5)];
            bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_titleButton addSubview:bottomView];
            if (can)
            {
                [_titleButton addTarget:self action:@selector(clickTitleButton:) forControlEvents:UIControlEventTouchUpInside];

                UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ct_nave_return"]];
                iconImageView.center = CGPointMake(8 + CGRectGetWidth(iconImageView.frame) / 2, CGRectGetHeight(_titleButton.frame) / 2);
                [_titleButton addSubview:iconImageView];
            }
        }

        _displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) style:UITableViewStylePlain];
        _displayTableView.dataSource = self;
        _displayTableView.delegate = self;
        _displayTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _displayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (_titleButton)
        {
            _displayTableView.tableHeaderView = _titleButton;
        }
        [_displayTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"sideViewCell"];
        [self addSubview:_displayTableView];
    }
    return self;
}
#pragma mark - 属性

- (void)setAccessoryView:(UIView *)accessoryView
{
    _accessoryView = accessoryView;
    _displayTableView.tableHeaderView = nil;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_titleButton.frame), CGRectGetHeight(_titleButton.frame) + CGRectGetHeight(accessoryView.frame))];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:_titleButton];
    accessoryView.center = CGPointMake(CGRectGetWidth(headerView.frame) / 2, CGRectGetHeight(_titleButton.frame) + CGRectGetHeight(accessoryView.frame) / 2);
    [headerView addSubview:accessoryView];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(headerView.frame) - 0.5, CGRectGetWidth(headerView.frame), 0.5)];
    bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headerView addSubview:bottomView];
    _displayTableView.tableHeaderView = headerView;

}

#pragma mark - 按钮点击时间

- (void)clickTitleButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(sideView:clickTitleButton:)])
    {
        [self.delegate sideView:self clickTitleButton:sender];
    }
}

- (void)updateCellTitle:(UITableViewCell*)cell withEntity:(SideBarEntity*)entity
{
    cell.textLabel.textColor = kColorDefaultGray;
    cell.textLabel.text = entity.name;
    cell.textLabel.font = kFontSizeCellTitle;

    if (_mutiMode) {
        UIImage *checkImage = ImageNamed(entity.isSelected ? @"checkbox_sel":@"checkbox_nor");
        [cell.imageView setImage:checkImage];
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sideViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SideBarEntity *item = [_dataArray objectAtIndex:indexPath.row];

    [self updateCellTitle:cell withEntity:item];

    if (_next)
    {
        if (nil == cell.accessoryView)
        {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrows"]];
        }
    }
    UIView *bottomView = [cell.contentView viewWithTag:SideViewCellBottomViewTag];
    if (!bottomView)
    {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_titleButton.frame) - 1, CGRectGetWidth(tableView.frame), 1)];
        bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.contentView addSubview:bottomView];
    }

    UIView *leftView = [cell.contentView viewWithTag:SideViewCellLeftViewTag];
    if ([_selectedSideBarEntity.idNumber isEqualToString:item.idNumber])
    {
        if (!leftView)
        {
            leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, SideViewItemsHeight)];
            leftView.backgroundColor = kColorDefaultOrange;
            leftView.tag = SideViewCellLeftViewTag;
            cell.textLabel.textColor = kColorDefaultOrange;
            [cell.contentView addSubview:leftView];
        }
    }
    else
    {
        [leftView removeFromSuperview];
        leftView = nil;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SideViewItemsHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat height = [self tableView:tableView heightForFooterInSection:section];
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), height)];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SideBarEntity *item = [_dataArray objectAtIndex:indexPath.row];

    if (_mutiMode) {
        item.isSelected = !item.isSelected;
    }
    if ([self.delegate respondsToSelector:@selector(sideView:chooseSideBarEntity:)])
    {
        [self.delegate sideView:self chooseSideBarEntity:item];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
