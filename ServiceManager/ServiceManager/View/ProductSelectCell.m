//
//  ProductSelectCell.m
//  ServiceManager
//
//  Created by wangzhi on 15-8-17.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ProductSelectCell.h"
#import "WZSingleCheckListPopView.h"

@interface ProductSelectCell()
@property(nonatomic, strong)NSArray *typeItemsArray; //checkItemModel
@property(nonatomic, strong)UIButton *button1;
@property(nonatomic, strong)UIButton *button2;
@property(nonatomic, strong)UIButton *button3;
@property(nonatomic, assign)CGFloat buttonWidth;
@end

@implementation ProductSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.buttonWidth = (ScreenWidth - kTableViewLeftPadding * 2)/3;

        [self addCustomSubViews];
        [self layoutCustomSubViews];
        [self addLineTo:kFrameLocationBottom];
    }
    return self;
}

- (void)setTypeItemEditable:(BOOL)typeItemEditable{
    if (typeItemEditable != _typeItemEditable) {
        _typeItemEditable = typeItemEditable;
        [self.button3 setImage:_typeItemEditable ?ImageNamed(@"dropdown_hit"): nil
                      forState:UIControlStateNormal];
        self.button3.userInteractionEnabled = YES;
        self.button3.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.button3.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.button3.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    }
}

- (void)setBrandItem:(KeyValueModel *)brandItem
{
    if (_brandItem != brandItem) {
        _brandItem = brandItem;
        [self setTitle:brandItem toButton:self.button1];
    }
}

- (void)setProductItem:(KeyValueModel *)productItem
{
    if (_productItem != productItem) {
        _productItem = productItem;
        [self setTitle:productItem toButton:self.button2];
    }
}

- (NSArray*)typeItemsArray{
    if (nil == _typeItemsArray || _typeItemsArray.count <= 0) {
        _typeItemsArray = [self getTypeItemsByBrand:self.brandItem product:self.productItem];
    }
    return _typeItemsArray;
}

- (void)setTypeItem:(KeyValueModel *)typeItem defaultItem:(BOOL)setDefaultItem
{
    //set default checkitem if typeItem is empty and setDefaultItem is true
    if ([Util isEmptyString:typeItem.key]){
        if (setDefaultItem) {
            if (self.typeItemsArray.count > 0) {
                typeItem = self.typeItemsArray[0];
            }
        }
    }
    _typeItem = typeItem;

    if (self.typeItemEditable && !setDefaultItem && [Util isEmptyString:typeItem.key]) {
        [self.button3 setTitle:@"请选择" forState:UIControlStateNormal];
    }else {
        [self setTitle:typeItem toButton:self.button3];
    }
}

- (void)setTypeItem:(KeyValueModel *)typeItem
{
    if (self.typeItemEditable) {
        if (nil == typeItem || [Util isEmptyString:typeItem.key]) { //设置第一项为默认品类
            if (self.typeItemsArray.count > 0) {
                typeItem = self.typeItemsArray[0];
            }else {
                _typeItem = nil;
                [self.button3 setTitle:@"请选择" forState:UIControlStateNormal];
                return;
            }
        }
    }
    _typeItem = typeItem;
    [self setTitle:typeItem toButton:self.button3];
}

- (NSArray*)getTypeItemsByBrand:(KeyValueModel*)brand product:(KeyValueModel*)product{
    ConfigInfoManager *cfgMgr = [ConfigInfoManager sharedInstance];
    NSArray *subProducts = [cfgMgr subProductsOfProduct:product.key];
    
    return [Util convertConfigItemInfoArrayToCheckItemModelArray:subProducts];
}

- (UIButton*)makeButton
{
    UIButton *button = [[UIButton alloc]init];
    [button clearBackgroundColor];
    [button setTitleColor:kColorDarkGray forState:UIControlStateNormal];
    [button.titleLabel setFont:SystemFont(14)];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.userInteractionEnabled = NO;

    return button;
}

- (void)setTitle:(KeyValueModel*)item toButton:(UIButton*)button
{
    [button setTitle:item.value forState:UIControlStateNormal];
}

- (void)buttonClicked:(UIButton*)button
{
    //目前只用于品类选择，品牌和产品是只读的。
    [self selectProductTypeItem];
}

- (void)selectProductTypeItem
{
    CheckItemModel *curChecked = [CheckItemModel modelWithValue:self.typeItem.value forKey:self.typeItem.key];
    NSInteger index = [self.typeItemsArray indexOfObject:curChecked];

    WZSingleCheckListPopView *checkView =
    [[WZSingleCheckListPopView alloc]initWithCheckItems:self.typeItemsArray title:@"品类" checkIndex:index checkedAction:^(NSInteger checkIndex) {
        CheckItemModel *checkedItem = self.typeItemsArray[checkIndex];
        if (checkedItem) {
            self.typeItem = [KeyValueModel modelWithValue:checkedItem.value forKey:checkedItem.key];
            if ([self.delegate respondsToSelector: @selector(typeItemSelectValueChanged:value:)]) {
                [self.delegate typeItemSelectValueChanged:self value:self.typeItem];
            }
        }
    }];
    [checkView show];
}

- (void)addCustomSubViews
{
    _button1 = [self makeButton];
    [self.contentView addSubview:_button1];
    [_button1 addLineTo:kFrameLocationRight];
    
    _button2 = [self makeButton];
    [self.contentView addSubview:_button2];
    [_button2 addLineTo:kFrameLocationRight];

    _button3 = [self makeButton];
    [self.contentView addSubview:_button3];
}

- (void)layoutCustomSubViews
{
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.width.equalTo(@(self.buttonWidth));
    }];
    
    [_button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_button1.mas_right);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.width.equalTo(_button1);
    }];
    
    [_button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_button2.mas_right);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-kTableViewLeftPadding);
    }];
}

@end
