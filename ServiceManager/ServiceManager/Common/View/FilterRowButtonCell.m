//
//  FilterRowButtonCell.m
//  ServiceManager
//
//  Created by will.wang on 16/9/8.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "FilterRowButtonCell.h"

#pragma mark - FilterRowButton

/**
 *  用于筛选行中的按钮显示
 */

@interface FilterRowButton : UIButton
@property(nonatomic, assign)BOOL isChecked;
@property(nonatomic, strong)VoidBlock_id onButtonClicked;
@property(nonatomic, strong)CheckItemModel *checkModel;

- (instancetype)initWithClickedAtcion:(VoidBlock_id)onButtonClicked;
@end

@implementation FilterRowButton

- (instancetype)initWithClickedAtcion:(VoidBlock_id)onButtonClicked
{
    self = [super init];
    if (self) {
        _onButtonClicked = onButtonClicked;

        self.titleLabel.font = SystemFont(14);
        [self circleCornerWithRadius:3.0];
        self.layer.borderWidth = 1.5f;

        [self addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self setButtonColorForChecked:NO];
    }
    return self;
}

- (void)buttonClicked:(UIButton*)button
{
    self.isChecked = !self.isChecked;
    self.checkModel.isChecked = self.isChecked;

    if (nil != self.onButtonClicked) {
        self.onButtonClicked(self);
    }
}

- (void)setIsChecked:(BOOL)isChecked{
    if (_isChecked != isChecked) {
        _isChecked = isChecked;
        [self setButtonColorForChecked:isChecked];
    }
}

- (void)setButtonColorForChecked:(BOOL)isChecked
{
    if (isChecked) {
        [self setTitleColor:kColorDefaultRed forState:UIControlStateNormal];
        self.backgroundColor = kColorWhite;
        self.layer.borderColor = kColorDefaultRed.CGColor;
    }else {
        [self setTitleColor:kColorBlack forState:UIControlStateNormal];
        self.backgroundColor = kColorDefaultBackGround;
        self.layer.borderColor = kColorWhite.CGColor;
    }
}
@end


#pragma mark - FilterRowButtonCell

/**
 *  用于显示一个筛选行CELL
 */

@interface FilterRowButtonCell()

@property(nonatomic, assign)CGFloat horizentalSpace;
@property(nonatomic, assign)CGFloat verticalSpace;
@property(nonatomic, assign)CGFloat maxButtonCount;

@property(nonatomic, strong)NSMutableArray *itemButtons;
@end

@implementation FilterRowButtonCell

- (instancetype)initWithMaxButtonCount:(NSInteger)maxButtonCount reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.horizentalSpace = kDefaultSpaceUnit;
        self.verticalSpace = kDefaultSpaceUnit/2;
        self.maxButtonCount = MAX(1, maxButtonCount);
        _itemButtons = [NSMutableArray new];
        
        [self makeItemButtons];
    }
    return self;
}

- (void)filterRowButtonCell:(FilterRowButtonCell*)cell itemButtonClicked:(id)buttonInfo
{
    self.onCellItemButtonClicked(buttonInfo);
}

- (void)setItemDatas:(NSArray *)itemDatas{
    _itemDatas = itemDatas;

    for (NSInteger btnIndex = 0; btnIndex < self.itemButtons.count; btnIndex++) {
        FilterRowButton *itemBtn = self.itemButtons[btnIndex];

        if (self.itemDatas.count > btnIndex) {
            CheckItemModel *itemBtnModel = self.itemDatas[btnIndex];
            [itemBtn setTitle:itemBtnModel.value forState:UIControlStateNormal];
            itemBtn.tag = (NSInteger)itemBtnModel;
            itemBtn.checkModel = itemBtnModel;
            itemBtn.isChecked = itemBtnModel.isChecked;
            itemBtn.hidden = NO;
        }else {
            itemBtn.hidden = YES;
        }
    }
}

- (void)makeItemButtons
{
    for (NSInteger btnIndex = 0; btnIndex < self.maxButtonCount; btnIndex++) {
        FilterRowButton *rowBtn = [[FilterRowButton alloc]initWithClickedAtcion:^(FilterRowButton *itemBtn) {
            [self filterRowButtonCell:self itemButtonClicked:itemBtn.checkModel];
        }];
        [self.contentView addSubview:rowBtn];
        [self.itemButtons addObject:rowBtn];
    }
}

- (void)layoutItemButtons
{
    FilterRowButton *preButton;
    for (FilterRowButton *itemBtn in self.itemButtons) {
        [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (nil == preButton) {
                make.left.equalTo(@(self.horizentalSpace));
            }else {
                make.left.equalTo(preButton.mas_right).with.offset(self.horizentalSpace);
                make.width.equalTo(preButton);
            }
            make.top.equalTo(@(self.verticalSpace));
            make.bottom.equalTo(@(-self.verticalSpace));
        }];
        preButton = itemBtn;
    }
    [preButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-self.horizentalSpace));
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self layoutItemButtons];

    DLog(@"layoutSubviews called");
}

@end
