//
//  PleaseSelectViewCell.m
//  ServiceManager
//
//  Created by will.wang on 15/9/18.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "PleaseSelectViewCell.h"
#import "WZSingleCheckListPopView.h"

@implementation PleaseSelectViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selected = NO;
        [self addSingleTapEventWithTarget:self action:@selector(cellViewDidSelect:)];
    }
    return self;
}

- (void)setCheckedItem:(CheckItemModel *)checkedItem
{
    if (checkedItem != _checkedItem) {
        _checkedItem = checkedItem;
        self.detailTextLabel.text = [Util defaultStr:@"请选择" ifStrEmpty: _checkedItem.value];
    }
}

- (void)setCheckedItemKey:(NSString *)checkedItemKey
{
    CheckItemModel *item = [Util findItem:checkedItemKey FromCheckItemModelArray:self.self.checkItems];
    self.checkedItem = item;
}

- (NSString*)checkedItemKey
{
    return self.checkedItem.key;
}

- (void)cellViewDidSelect:(UIGestureRecognizer*)gesture
{
    BOOL isWillAppear = YES;

    if ([self.delegate respondsToSelector:@selector(selectMenuWillAppear:)]) {
        isWillAppear = [self.delegate selectMenuWillAppear:self];
    }

    if (isWillAppear) {
        [self popupSelectMenu];
    }
}

- (void)popupSelectMenu
{
    NSInteger index = [self.checkItems indexOfObject:self.checkedItem];
    NSString *title = self.checkViewTitle ? self.checkViewTitle : self.textLabel.text;
    
    WZSingleCheckListPopView *checkView =
    [[WZSingleCheckListPopView alloc]initWithCheckItems:self.checkItems title:title checkIndex:index checkedAction:^(NSInteger checkIndex) {
        self.checkedItem = self.checkItems[checkIndex];
        if ([self.delegate respondsToSelector:@selector(selectViewDidChecked:)]) {
            [self.delegate selectViewDidChecked:self];
        }
    }];
    [checkView show];
}

@end
