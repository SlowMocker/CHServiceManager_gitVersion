//
//  WZCheckMenuView.m
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-5-5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZCheckMenuView.h"

@implementation WZCheckMenuViewData
@end

@implementation WZCheckMenuViewListData
@end

@implementation WZCheckMenuViewSingleCheckData
@end

@implementation WZCheckMenuViewMutiCheckData
@end

@implementation WZTouchView
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self.delegate respondsToSelector:@selector(touchViewEndTapped:)]) {
        [self.delegate touchViewEndTapped:self];
    }
}
@end

@interface WZCheckMenuView()<UITableViewDataSource, UITableViewDelegate, WZTouchViewDelegate>
{
    WZCheckMenuViewData *_header;
    WZCheckMenuViewData *_currentLevelData;
    WZTouchView *_backTouchView;
    UIViewController* viewController;
    UIWindow* topWindow;
}
@end

@implementation WZCheckMenuView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self resetDefaultPropertyValue];
        [self addCustomSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self resetDefaultPropertyValue];
        [self addCustomSubViews];
    }
    return self;
}

- (void)resetDefaultPropertyValue
{
    _titleViewHeight = kTableViewCellDefaultHeight;
    _titleLeftButtonWidth = 50;
    _checkNorIcon = @"checkbox_nor";
    _checkSelIcon = @"checkbox_sel";
    _menuTextFont = SystemFont(14);
    _menuTextColor = kColorDarkGray;
    _mode = WZCheckMenuViewModeDefalut;
}

- (void)addCustomSubViews
{
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 2.0;

    _titleView = [UIView new];
    _titleView.backgroundColor = ColorWithHex(@"#f1f3f8");
    [self addSubview:_titleView];

    _listView = [UITableView new];
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_listView];

    _titleLeftButton = [UIButton new];
    [_titleLeftButton setImage:ImageNamed(@"btn_goback02") forState:UIControlStateNormal];
    [_titleLeftButton addTarget:self action:@selector(titleLeftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _titleLeftButton.hidden = YES;
    [_titleView addSubview:_titleLeftButton];

    _titleTextLabel = [UILabel new];
    _titleTextLabel.textAlignment = NSTextAlignmentCenter;
    [_titleTextLabel clearBackgroundColor];
    [_titleView addSubview:_titleTextLabel];
}

- (void)setCheckMenuItemArray:(NSMutableArray *)checkMenuItemArray
{
    if (_checkMenuItemArray != checkMenuItemArray) {
        _checkMenuItemArray = checkMenuItemArray;
        _header = [[WZCheckMenuViewData alloc]init];
        _header.nextLevelArray = _checkMenuItemArray;
    }
}

- (void)layoutCustomSubViews
{
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(self.titleViewHeight));
    }];
    _titleView.hidden = (self.titleViewHeight < 1);

    [_titleLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView);
        make.left.equalTo(_titleView);
        make.bottom.equalTo(_titleView);
        make.width.equalTo(@(self.titleLeftButtonWidth));
    }];

    [_titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView);
        make.left.equalTo(_titleView);
        make.bottom.equalTo(_titleView);
        make.right.equalTo(_titleView);
    }];

    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(self.titleViewHeight);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
}

- (void)showCheckMenuToView2:(UIView *)parentView
{
    [self layoutCustomSubViews];
    _currentLevelData = _header;

    NSArray *windows = [UIApplication sharedApplication].windows;
    UIView *baseView;
    if(windows.count > 0){
        UIView *window = [windows objectAtIndex:0];
        if(window.subviews.count > 0){
            baseView = [window.subviews objectAtIndex:0];
        }
        _backTouchView = [[WZTouchView alloc]initWithFrame:baseView.bounds];
        _backTouchView.backgroundColor = [UIColor lightGrayColor];
        _backTouchView.alpha = 0.4;
        _backTouchView.delegate = self;
        [baseView addSubview:_backTouchView];
        [baseView addSubview:self];

        CGPoint startPoint = [parentView convertPoint:self.frame.origin toView:baseView];
        CGRect frame = self.frame;
        frame.origin = startPoint;
        self.frame = frame;
    }
}

- (void)showCheckMenuToView:(UIView *)parentView
{
    [self layoutCustomSubViews];
    _currentLevelData = _header;

    NSArray *windows = [UIApplication sharedApplication].windows;
    if(windows.count > 0){
        _backTouchView = [[WZTouchView alloc]init];
        _backTouchView.backgroundColor = [UIColor lightGrayColor];
        _backTouchView.alpha = 0.4;
        _backTouchView.delegate = self;

        topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [topWindow setWindowLevel:UIWindowLevelAlert];

        viewController = [[UIViewController alloc]init];
        [viewController.view addSubview:_backTouchView];
        [viewController.view addSubview:self];
        _backTouchView.frame = viewController.view.bounds;

        [topWindow setRootViewController:viewController];
        [topWindow setHidden:NO];
        [topWindow setUserInteractionEnabled:YES];

        CGPoint startPoint = [parentView convertPoint:self.frame.origin toView:viewController.view];
        CGRect frame = self.frame;
        frame.origin = startPoint;
        self.frame = frame;
        [topWindow makeKeyAndVisible];
    }
}

- (void)touchViewClicked:(UIGestureRecognizer*)gesture
{
    [self removeCheckMenu];
}

- (void)removeCheckMenu
{
    if (self.mode == WZCheckMenuViewModeMutiCheck) {
        _checkedItems = [self getSubLevelTotalCheckedItem:_header];
    }
    if ([self.delegate respondsToSelector:@selector(checkMenuViewWillDismiss:)]) {
        [self.delegate checkMenuViewWillDismiss:self];
    }

    self.hidden = YES;
    _backTouchView.hidden = YES;
    [_backTouchView removeFromSuperview];
    [self removeFromSuperview];
    [topWindow resignKeyWindow];
    topWindow.hidden = YES;
    topWindow = nil;
}

//将当前选中项通知给观察者
- (void)noticeObserverSelectedMenuItem:(WZCheckMenuViewData*)menuItem
{
    if ([self.delegate respondsToSelector:@selector(checkMenuView:selected:)]) {
        [self.delegate checkMenuView:self selected:menuItem];
    }
}

- (void)reloadTableView
{
    BOOL hideButton = (_currentLevelData == _header);
    self.titleLeftButton.hidden = hideButton;
    [self.listView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellDefaultHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *menuItems = _currentLevelData.nextLevelArray;

    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = self.menuTextColor;
        cell.textLabel.font = self.menuTextFont;
        [cell addLineTo:kFrameLocationBottom];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSArray *menuItems = _currentLevelData.nextLevelArray;
    WZCheckMenuViewData *itemData = menuItems[indexPath.row];
    NSInteger nextLevelCount = [self getNextSubLevelItemCount:itemData]; //是否还有下层子选项
    NSString *cellTitle = itemData.menuItemText;
    NSString *cellIcon  = nil;

    switch (self.mode) {
        case WZCheckMenuViewModeSingleCheck:
            break;
        case WZCheckMenuViewModeMutiCheck:
        {
            WZCheckMenuViewMutiCheckData *mutiCheckItem = (WZCheckMenuViewMutiCheckData*)itemData;
            if (nextLevelCount > 0) {
                NSInteger totalCheckedCout = [self calcSubLevelTotalCheckedCount:itemData];
                NSInteger totalCout= [self getSubLevelTotalItemCount:itemData];
                cellTitle = [NSString stringWithFormat:@"%@(%@/%@)",itemData.menuItemText,@(totalCheckedCout),@(totalCout)];
                cellIcon = nil;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else {
                //最后一层才显示check Icon
                cellIcon = mutiCheckItem.isChecked ? self.checkSelIcon : self.checkNorIcon;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
            break;
        case WZCheckMenuViewModeList:
        {
            WZCheckMenuViewListData *listItem = (WZCheckMenuViewListData*)itemData;
            cellIcon = listItem.menuItemIcon;
            if (cellIcon == nil) {
                cell.textLabel.center = cell.contentView.center;
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
            }
        }
            break;
        default:
            break;
    }

    cell.textLabel.text = cellTitle;

    if (cellIcon != nil) {
        [cell.imageView setImage:ImageNamed(cellIcon)];
    }else {
        [cell.imageView setImage:nil];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *menuItems = _currentLevelData.nextLevelArray;
    WZCheckMenuViewData *selItem = menuItems[indexPath.row];

    NSInteger nextLevelCount = [self getNextSubLevelItemCount:selItem]; //是否还有下层子选项
    BOOL needRemoveSelfView = (nextLevelCount > 0) ? NO :YES;

    switch (self.mode) {
        case WZCheckMenuViewModeSingleCheck:
        {
            if (nextLevelCount <= 0) {
//                [self.checkedItems removeAllObjects];
//                [self.checkedItems addObject:selItem];
            }
        }
            break;
        case WZCheckMenuViewModeMutiCheck:
        {
            WZCheckMenuViewMutiCheckData *mutiCheckItem = (WZCheckMenuViewMutiCheckData*)selItem;
            needRemoveSelfView = NO;
            if (nextLevelCount <= 0) {
                mutiCheckItem.isChecked = !mutiCheckItem.isChecked;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                if (mutiCheckItem.isChecked) {
//                    [self.checkedItems addObject:selItem];
                }else {
                    if ([self.checkedItems containsObject:selItem]){
//                        [self.checkedItems removeObject:selItem];
                    }
                }
            }
        }
            break;
        case WZCheckMenuViewModeList:
            break;
        default:
            break;
    }

    if (nextLevelCount <= 0) {
        [self noticeObserverSelectedMenuItem:selItem];
        if (needRemoveSelfView) {
            [self removeCheckMenu];
        }
    }else {
        _currentLevelData = selItem;
        [self reloadTableView]; //显示下一级
    }
}

//读取下一级选项数
- (NSInteger)getNextSubLevelItemCount:(WZCheckMenuViewData*)menuViewData
{
    NSArray *nextSubLevelArray = menuViewData.nextLevelArray;
    return nextSubLevelArray.count;
}

//读取叶结点选项数
- (NSInteger)getSubLevelTotalItemCount:(WZCheckMenuViewData*)menuViewData
{
    NSArray *nextSubLevelArray = menuViewData.nextLevelArray;
    NSInteger totalCount = 0;

    for (WZCheckMenuViewMutiCheckData *data in nextSubLevelArray) {
        if (data.nextLevelArray != nil) {
            totalCount += [self getSubLevelTotalItemCount:data];
        }else {
            totalCount++;
        }
    }
    return totalCount;
}

//读取叶结点checked选项数
- (NSInteger)calcSubLevelTotalCheckedCount:(WZCheckMenuViewData*)menuViewData
{
    NSArray *nextSubLevelArray = menuViewData.nextLevelArray;
    NSInteger checkedCount = 0;

    for (WZCheckMenuViewMutiCheckData *data in nextSubLevelArray) {
        if (data.nextLevelArray != nil) {
            checkedCount += [self calcSubLevelTotalCheckedCount:data];
        }else if (data.isChecked) {
            checkedCount++;
        }
    }
    return checkedCount;
}

//读取叶结点checked选项数
- (NSArray*)getSubLevelTotalCheckedItem:(WZCheckMenuViewData*)menuViewData
{
    NSArray *nextSubLevelArray = menuViewData.nextLevelArray;

    NSMutableArray *checkeds = [[NSMutableArray alloc]init];
    NSArray *subLevelCheckeds;

    for (WZCheckMenuViewMutiCheckData *data in nextSubLevelArray) {
        if (data.nextLevelArray != nil) {
            subLevelCheckeds = [self getSubLevelTotalCheckedItem:data];
            [checkeds addObjectsFromArray:subLevelCheckeds];
        }else if (data.isChecked) {
            [checkeds addObject:data];
        }
    }

    return checkeds;
}


- (void)titleLeftButtonClicked:(UIButton*)button
{
    WZCheckMenuViewData *previousLevelData = _currentLevelData.previousLevel;
    if (nil != previousLevelData) {
        _currentLevelData = previousLevelData;
    }else {
        _currentLevelData = _header;
    }
    [self reloadTableView];
}

- (void)touchViewEndTapped:(UIView*)touchView
{
    [self removeCheckMenu];
}

@end
