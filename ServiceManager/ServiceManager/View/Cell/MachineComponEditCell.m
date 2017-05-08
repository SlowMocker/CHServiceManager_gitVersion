//
//  MachineComponEditCell.m
//  ServiceManager
//
//  Created by will.wang on 15/9/16.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "MachineComponEditCell.h"
#import "WZSingleCheckViewController.h"

@interface MachineComponEditCell()<WZSingleCheckViewControllerDelegate>
{
    WZSingleCheckViewController *_partTypeViewController;
    WZSingleCheckViewController *_partSubTypeViewController;
    NSArray *_checkTypes;
}
@end

@implementation MachineComponEditCell

@synthesize additonalItem = _additonalItem;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kColorWhite;
        _showAddRemoveButtonsLine = YES;
        _componCount = 1;
        _minCount = 1;
        _checkTypes = [[ConfigInfoManager sharedInstance] componentTypes];
        _checkTypes = [Util convertConfigItemInfoArrayToCheckItemModelArray:_checkTypes];

        [self makeCustomSubViews];
        [self layoutCustomSubViews];
        [self addLineTo:kFrameLocationBottom];
    }
    return self;
}

- (void)makeCustomSubViews
{
    _componTypeSelBtn = [UIButton new];
    [_componTypeSelBtn setTitle:@"点击选择物料类别" forState:UIControlStateNormal];
    [_componTypeSelBtn setTitleColor:kColorDefaultBlue forState:UIControlStateNormal];
    [_componTypeSelBtn clearBackgroundColor];
    [_componTypeSelBtn addLineTo:kFrameLocationBottom];
    [_componTypeSelBtn addTarget:self action:@selector(componTypeSelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _componTypeSelBtn.titleLabel.font = SystemFont(15);
    [self.contentView addSubview:_componTypeSelBtn];

    _priceTextField = [UITextField new];
    _priceTextField.textAlignment = NSTextAlignmentCenter;
    _priceTextField.placeholder = @"请填入单价(元)";
    _priceTextField.textColor = kColorDefaultBlue;
    _priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_priceTextField clearBackgroundColor];
    [_priceTextField addLineTo:kFrameLocationRight];
    _priceTextField.font = SystemFont(15);
    [self.contentView addSubview:_priceTextField];

    _increaseBtn = [UIButton new];
    [_increaseBtn clearBackgroundColor];
    [_increaseBtn setTitle:@"+" forState:UIControlStateNormal];
    [_increaseBtn setTitleColor:kColorDefaultOrange forState:UIControlStateNormal];
    [_increaseBtn addTarget:self action:@selector(stepperButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:_increaseBtn];

    _componCountTextField = [UITextField new];
    [_componCountTextField setBackgroundColor:kColorDefaultBackGround];
    _componCountTextField.keyboardType = UIKeyboardTypeNumberPad;
    _componCountTextField.text = [NSString intStr:self.componCount];
    _componCountTextField.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_componCountTextField];

    _decreaseBtn = [UIButton new];
    [_decreaseBtn clearBackgroundColor];
    [_decreaseBtn setTitle:@"-" forState:UIControlStateNormal];
    [_decreaseBtn setTitleColor:kColorDefaultOrange forState:UIControlStateNormal];
    [_decreaseBtn addTarget:self action:@selector(stepperButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:_decreaseBtn];

    _addBtn = [self makeImageTextButton:@"add_gray" text:@"添加物料"];
    [_addBtn addLineTo:kFrameLocationTop];
    [_addBtn addLineTo:kFrameLocationRight];
    [self.contentView addSubview:_addBtn];

    _deleteBtn = [self makeImageTextButton:@"del_gray" text:@"删除物料"];
    [_deleteBtn addLineTo:kFrameLocationTop];
    [self.contentView addSubview:_deleteBtn];
}

- (UIButton*)makeImageTextButton:(NSString*)icon text:(NSString*)text
{
    UIButton *button = [[UIButton alloc]init];
    [button clearBackgroundColor];
    [button setTitleColor:kColorDarkGray forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    [button setImage:ImageNamed(icon) forState:UIControlStateNormal];
    button.titleLabel.font = SystemFont(15);

    return button;
}

- (void)layoutCustomSubViews
{
    [self.componTypeSelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@(kTableViewCellDefaultHeight));
    }];

    [self.priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.componTypeSelBtn.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_centerX);
        make.height.equalTo(@(kTableViewCellDefaultHeight));
    }];

    [self.decreaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.componTypeSelBtn.mas_bottom);
        make.left.equalTo(self.contentView.mas_centerX);
        make.height.equalTo(@(kTableViewCellDefaultHeight));
        make.width.equalTo(@(kTableViewCellDefaultHeight));
    }];
    
    [self.componCountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.decreaseBtn.mas_right);
        make.right.equalTo(self.increaseBtn.mas_left);
        make.centerY.equalTo(self.decreaseBtn);
        make.height.equalTo(@(30));
    }];
    [self.increaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.decreaseBtn);
        make.right.equalTo(self.contentView);
        make.size.equalTo(self.decreaseBtn);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceTextField.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_centerX);
        make.height.equalTo(@(kTableViewCellDefaultHeight));
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addBtn);
        make.left.equalTo(self.contentView.mas_centerX);
        make.right.equalTo(self.contentView);
        make.height.equalTo(self.addBtn);
    }];
}

- (void)updateLayoutCustomSubViews
{
    self.addBtn.hidden = !self.showAddRemoveButtonsLine;
    self.deleteBtn.hidden = self.addBtn.hidden;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateLayoutCustomSubViews];
}

- (void)stepperButtonClicked:(UIButton*)stepperButton
{
    NSString *countStr = self.componCountTextField.text;

    if ([countStr isPureInt]) {
        NSInteger curCount = [countStr integerValue];
        NSInteger newCount = curCount;
        if (stepperButton == self.increaseBtn) {
            newCount = curCount + 1;
        }else if (stepperButton == self.decreaseBtn && curCount > self.minCount){
            newCount = curCount - 1;
        }
        self.componCountTextField.text = [NSString intStr:newCount];
    }else {
        DLog(@"Compon Count input format error");
    }
}

- (CGFloat)fitHeight
{
    NSInteger lineCount = self.showAddRemoveButtonsLine ? 3 : 2;
    return kTableViewCellDefaultHeight * lineCount;
}

- (void)componTypeSelBtnClicked:(id)sender
{
    [self selectPartItem];
}

- (void)selectPartItem
{
    _partTypeViewController = [MiscHelper pushToCheckListViewController:@"物料类别" checkItems:_checkTypes checkedItem:self.typeItem from:self.viewController delegate:self];
    _partTypeViewController.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)singleCheckViewController:(WZSingleCheckViewController*)viewController didChecked:(CheckItemModel*)checkedItem
{
    if (_partTypeViewController == viewController) {//选择故障类型
        if (self.typeItem != checkedItem) {
            self.typeItem = checkedItem;
            self.subTypeItem = nil;
        }
        
        NSArray *subtypes = [[ConfigInfoManager sharedInstance]subcomponentTypesOfType:(NSString*)self.typeItem.extData];
        subtypes = [Util convertConfigItemInfoArrayToCheckItemModelArray:subtypes];
    
        _partSubTypeViewController = [MiscHelper pushToCheckListViewController:@"物料子类" checkItems:subtypes checkedItem:self.subTypeItem from:viewController delegate:self];
    }else if (_partSubTypeViewController == viewController){//物料子类
        self.subTypeItem = checkedItem;

        NSString *tempStr = self.subTypeItem.value;
        if ([Util isEmptyString:tempStr]) {
            tempStr = self.typeItem.value;
        }
        [self.componTypeSelBtn setTitle:tempStr forState:UIControlStateNormal];
        [_partSubTypeViewController popTo:self.viewController];
    }
}

- (void)setAdditonalItem:(AdditionalBusinessItem *)additonalItem{
    if (_additonalItem != additonalItem) {
        _additonalItem = additonalItem;
        self.priceTextField.text = _additonalItem.price;
        self.componCountTextField.text = _additonalItem.num;
        [self.componTypeSelBtn setTitle:_additonalItem.type forState:UIControlStateNormal];
    }
}

- (AdditionalBusinessItem*)additonalItem
{
    if (_additonalItem == nil) {
        _additonalItem = [AdditionalBusinessItem new];
    }
    _additonalItem.type = self.typeItem.key;
    _additonalItem.items = self.subTypeItem.key;
    _additonalItem.price = self.priceTextField.text;
    _additonalItem.num = self.componCountTextField.text;

    return _additonalItem;
}

- (NSString*)checkInput
{
    ReturnIf([Util isEmptyString:self.priceTextField.text])@"请输入物料价格";
    ReturnIf(![self.priceTextField.text isValidNumber])@"请输入正确的物料价格";
    ReturnIf([Util isEmptyString:self.componCountTextField.text])@"请输入物料数量";
    ReturnIf(![self.componCountTextField.text isValidNumber])@"请输入正确的物料数量";
    ReturnIf([Util isEmptyString:self.typeItem.key])@"请选择物料类别";
    ReturnIf([Util isEmptyString:self.subTypeItem.key])@"请选择物料类别";

    return nil;
}
@end
