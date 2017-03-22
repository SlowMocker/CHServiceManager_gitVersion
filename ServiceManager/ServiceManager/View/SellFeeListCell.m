//
//  SellFeeListCell.m
//  ServiceManager
//
//  Created by will.wang on 16/3/31.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "SellFeeListCell.h"

#define kSellFeeListCellOneLineDefaultHeight (34)

@interface SellFeeListCell()
@property(nonatomic, strong)UIView *orderContentView;
@end

@implementation SellFeeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kColorWhite;
        self.contentView.backgroundColor = kColorWhite;
        self.topContentView = self.orderContentView;
        [self addLineTo:kFrameLocationBottom];
    }
    return self;
}

- (UIView*)orderContentView
{
    if (nil == _orderContentView) {
        _orderContentView = [[UIView alloc]init];
        _orderContentView.backgroundColor =kColorWhite;
        
        //add sub labels
        self.nameLabel = [self makeTextLabel:kColorDefaultBlue];
        self.nameLabel.font = SystemFont(15);
        [_orderContentView addSubview:self.nameLabel];
        
        self.isSyncLabel = [self makeTextLabel:kColorDefaultGray];
        self.isSyncLabel.textAlignment = NSTextAlignmentCenter;
        self.isSyncLabel.font = SystemFont(13);
        self.isSyncLabel.layer.borderWidth = 0.5;
        self.isSyncLabel.layer.borderColor = self.isSyncLabel.textColor.CGColor;
        self.isSyncLabel.layer.cornerRadius = 2.0;
        self.isSyncLabel.text = @"未同步";
        self.isSyncLabel.hidden = YES;
        [_orderContentView addSubview:self.isSyncLabel];

        self.contentLabel = [self makeTextLabel:[UIColor darkGrayColor]];
        self.contentLabel.font = SystemFont(14);
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_orderContentView addSubview:self.contentLabel];
        
        self.priceLabel = [self makeTextLabel:kColorDefaultRed];
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.font = SystemFont(17);
        [_orderContentView addSubview:self.priceLabel];

        //layout
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_orderContentView);
            make.left.equalTo(@(kTableViewLeftPadding));
            make.height.equalTo(@(kSellFeeListCellOneLineDefaultHeight));
            make.right.lessThanOrEqualTo(self.priceLabel.mas_left).with.offset(-kDefaultSpaceUnit/2);
        }];
        [self.isSyncLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel);
            make.left.equalTo(self.nameLabel.mas_right).with.offset(kDefaultSpaceUnit).priorityHigh();
            make.right.lessThanOrEqualTo(self.priceLabel.mas_left);
        }];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel);
            make.right.equalTo(_orderContentView).with.offset(-kTableViewLeftPadding);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom);
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(_orderContentView).with.offset(-kTableViewLeftPadding);
            make.bottom.equalTo(_orderContentView).with.offset(-kDefaultSpaceUnit);
            make.height.greaterThanOrEqualTo(@(kSellFeeListCellOneLineDefaultHeight));
        }];
    }
    return _orderContentView;
}

- (CGFloat)fitHeight
{
    CGFloat height = 0;

    height += kSellFeeListCellOneLineDefaultHeight; //the 1st title line
    height += kDefaultSpaceUnit;    //bottom space
    
    CGSize fitSize = [self.contentLabel sizeThatFits:CGSizeMake(ScreenWidth - kTableViewLeftPadding *2, MAXFLOAT)];

    height += fitSize.height; //content label height
    height += 1;    //extro 1 point
    
    return height;
}

- (UILabel*)makeTextLabel:(UIColor*)textColor
{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = textColor;
    [label clearBackgroundColor];
    label.font = SystemFont(14);
    
    return label;
}

- (void)setSellInfos:(SellFeeListInfos *)sellInfos{
    if (sellInfos != _sellInfos) {
        _sellInfos = sellInfos;
        [self setTraceInfoToViews];
        [self setMenuButtons];
    }
}

- (void)setLetvSellInfos:(LetvSellFeeListInfos *)letvSellInfos{
    if (letvSellInfos != _letvSellInfos) {
        _letvSellInfos = letvSellInfos;
        [self setLetvSellInfosToViews];
        [self setMenuButtons];
    }
}

- (MenuButtonModel*)makeMenuButtonModel:(kSellFeeListHandleType)handleType backgroundColor:(UIColor*)backgroundColor
{
    MenuButtonModel *model = [MenuButtonModel new];
    model.title = getSellFeeListHandleTypeStrById(handleType);
    model.backgroundColor = backgroundColor;
    model.buttonTag = handleType;

    return model;
}

- (void)setMenuButtons
{
    NSMutableArray *menuBtnModelArray = [NSMutableArray new];
    MenuButtonModel *menuBtnModel;

    menuBtnModel = [self makeMenuButtonModel:kSellFeeListHandleTypeEdit backgroundColor:kColorDefaultGreen];
    [menuBtnModelArray addObject:menuBtnModel];

    menuBtnModel = [self makeMenuButtonModel:kSellFeeListHandleTypeDelete backgroundColor:kColorDefaultRed];
    [menuBtnModelArray addObject:menuBtnModel];

    [self setRightButtonsWithModels:menuBtnModelArray];
}

- (void)setLetvSellInfosToViews
{
    NSString *tempStr;
    kPriceManageType type = getPriceManageTypeByCode(self.letvSellInfos.itmType);

    if (kPriceManageTypeService == type) { //费用管理
        tempStr = [Util defaultStr:@"未知名称" ifStrEmpty:self.letvSellInfos.Description];
        self.nameLabel.text = tempStr;
        self.nameLabel.textColor = [UIColor brownColor];

        //content
        ConfigItemInfo *handleCodeItem = [[ConfigInfoManager sharedInstance]findConfigItemInfoByType:MainConfigInfoTableType108 code:self.letvSellInfos.handleCode];
        
        AttributeStringAttrs *attr1 = [AttributeStringAttrs new];
        attr1.text = @"处理代码 : ";
        attr1.font = SystemBoldFont(14);
        attr1.textColor = kColorDefaultBlue;
        AttributeStringAttrs *attr2 = [AttributeStringAttrs new];
        attr2.text = [Util defaultStr:kUnknown ifStrEmpty:handleCodeItem.value];
        attr2.font = SystemFont(14);
        attr2.textColor = kColorDarkGray;

        AttributeStringAttrs *attr3 = [AttributeStringAttrs new];
        attr3.text = @"  乐视代码 : ";
        attr3.font = SystemBoldFont(14);
        attr3.textColor = kColorDefaultBlue;
        AttributeStringAttrs *attr4 = [AttributeStringAttrs new];
        attr4.text = [Util defaultStr:kUnknown ifStrEmpty:self.letvSellInfos.letvCodeName];
        attr4.font = SystemFont(14);
        attr4.textColor = kColorDarkGray;
        self.contentLabel.attributedText = [NSString makeAttrString:@[attr1, attr2, attr3, attr4]];

        //乐视费用项中没有价格，所以无价格数据时不显示价格项
        self.priceLabel.hidden = (self.letvSellInfos.totalPrice <= 0);
    }else {
        ConfigItemInfo *typeModel = [[ConfigInfoManager sharedInstance]findConfigItemInfoByType:MainConfigInfoTableType22 code:self.letvSellInfos.classify];
        tempStr = [Util defaultStr:@"产品代码未知" ifStrEmpty:typeModel.value];
        self.nameLabel.text = tempStr;

        //content
        tempStr = [NSString stringWithFormat:@"收据号 : %@ 数量 : %@件 单价 : %@元\n产品 : %@ 描述 : %@"
                   ,[Util defaultStr:kUnknown ifStrEmpty:self.letvSellInfos.receiptNum]
                   ,[Util defaultStr:kUnknown ifStrEmpty:self.letvSellInfos.quantity.description]
                   ,[Util defaultStr:kUnknown ifStrEmpty:self.letvSellInfos.unitPrice.description]
                   ,[Util defaultStr:kUnknown ifStrEmpty:self.letvSellInfos.bomCode]
                   ,[Util defaultStr:kUnknown ifStrEmpty:self.letvSellInfos.Description]];
        self.contentLabel.text = tempStr;
    }

    self.isSyncLabel.hidden = YES;

    tempStr = [NSString stringWithFormat:@"￥ %.2f", self.letvSellInfos.totalPrice];
    self.priceLabel.text = tempStr;
}

- (void)setTraceInfoToViews
{
    NSString *tempStr;
    kPriceManageType type = getPriceManageTypeByCode(self.sellInfos.itmType);
    
    if (kPriceManageTypeService == type) { //费用管理
        ConfigItemInfo *info = [[ConfigInfoManager sharedInstance]findConfigItemInfoByType:MainConfigInfoTableType31 code:self.sellInfos.orderedProd superCode:self.sellInfos.brandIdStr superParentCode:self.sellInfos.categoryIdStr];
        tempStr = [Util defaultStr:@"服务物料代码未知" ifStrEmpty:info.value];
        self.nameLabel.text = tempStr;
        
        //content
        tempStr = [NSString stringWithFormat:@"保外收据号 : %@", self.sellInfos.zzfld00002v];
        self.contentLabel.text = tempStr;
    }else {
        ConfigItemInfo *typeModel = [[ConfigInfoManager sharedInstance]findConfigItemInfoByType:MainConfigInfoTableType22 code:self.sellInfos.zzfld00005e];
        tempStr = [Util defaultStr:@"产品代码未知" ifStrEmpty:typeModel.value];
        self.nameLabel.text = tempStr;

        //content
        tempStr = [NSString stringWithFormat:@"收据号 : %@ 数量 : %@件 单价 : %@元\n产品 : %@ 描述 : %@", self.sellInfos.zzfld00002v, self.sellInfos.quantity, self.sellInfos.netValue, self.sellInfos.orderedProd,self.sellInfos.prodDescription];
        self.contentLabel.text = tempStr;
    }

    self.isSyncLabel.hidden = ![self.sellInfos.isSendtoCrm isEqualToString:@"0"];

    tempStr = [NSString stringWithFormat:@"￥ %.2f", self.sellInfos.totalPrice];
    self.priceLabel.text = tempStr;
}

@end
