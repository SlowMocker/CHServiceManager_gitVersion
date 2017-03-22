//
//  ExtendServiceOrderCell.m
//  ServiceManager
//
//  Created by will.wang on 10/6/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "ExtendServiceOrderCell.h"

static CGFloat kExtendServiceOrderTextHeight = 24;

@interface ExtendServiceOrderCell()
@property(nonatomic, strong)UIView *mainBoardView;

@property(nonatomic, strong)UILabel *customerLabel;
@property(nonatomic, strong)UILabel *telsLabel;
@property(nonatomic, strong)UILabel *statusLabel;
@property(nonatomic, strong)UIButton *orderTypeBtn;
@property(nonatomic, strong)UILabel *noLabel;
@property(nonatomic, strong)UILabel *startDateLabel;
@property(nonatomic, strong)UILabel *yearsLabel;
@end

@implementation ExtendServiceOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _mainBoardView = [[UIView alloc]init];
        _mainBoardView.backgroundColor = kColorWhite;
        [_mainBoardView addLineTo:kFrameLocationBottom];
        self.topContentView = self.mainBoardView;

        [self addCustomSubViews];
        [self layoutCustomSubViews];
    }
    return self;
}

- (void)addCustomSubViews
{
    _customerLabel = [self addLabelToMainBoardView:16 textColor:kColorBlack];

    _telsLabel = [self addLabelToMainBoardView:15 textColor:kColorDefaultGreen];
    _statusLabel = [self addLabelToMainBoardView:13 textColor:kColorDefaultOrange];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.layer.borderWidth = 0.5;
    _statusLabel.layer.borderColor = _statusLabel.textColor.CGColor;
    _statusLabel.layer.cornerRadius = 2.0;
    
    _orderTypeBtn = [UIButton redButton:@"急"];
    [_orderTypeBtn.titleLabel setFont:SystemFont(14)];
    [_orderTypeBtn circleCornerWithRadius:10];
    [self.mainBoardView addSubview:_orderTypeBtn];

    _noLabel = [self addLabelToMainBoardView:15 textColor:kColorDefaultBlue];
    _startDateLabel = [self addLabelToMainBoardView:15 textColor:kColorBlack];
    _yearsLabel = [self addLabelToMainBoardView:15 textColor:kColorDefaultRed];
}

- (void)layoutCustomSubViews
{
    [_customerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainBoardView).with.offset(kDefaultSpaceUnit/2);
        make.height.equalTo(@(kExtendServiceOrderTextHeight));
        make.left.equalTo(self.mainBoardView).with.offset(kTableViewLeftPadding);
        make.right.lessThanOrEqualTo(self.telsLabel.mas_left);
    }];

    [_telsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_customerLabel.mas_right).with.offset(kDefaultSpaceUnit);
        make.right.lessThanOrEqualTo(_statusLabel.mas_left).with.offset(-kDefaultSpaceUnit);
        make.width.greaterThanOrEqualTo(@(70));
        make.centerY.equalTo(self.customerLabel);
    }];

    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.customerLabel);
        make.height.equalTo(@(18));
        make.width.greaterThanOrEqualTo(@(40));
        make.right.equalTo(self.orderTypeBtn.mas_left).with.offset(-kDefaultSpaceUnit);
    }];

    [_orderTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.customerLabel);
        make.width.equalTo(@(20));
        make.height.equalTo(@(20));
        make.right.equalTo(self.mainBoardView).with.offset(-kTableViewLeftPadding);
    }];

    [_noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customerLabel.mas_bottom);
        make.left.equalTo(self.customerLabel);
        make.right.equalTo(self.statusLabel);
        make.height.equalTo(@(kExtendServiceOrderTextHeight));
    }];
    
    [_startDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noLabel.mas_bottom);
        make.left.equalTo(self.noLabel);
        make.right.lessThanOrEqualTo(self.yearsLabel.mas_left);
        make.height.equalTo(@(kExtendServiceOrderTextHeight));
    }];

    [_yearsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.startDateLabel);
        make.right.lessThanOrEqualTo(self.statusLabel);
        make.left.equalTo(self.startDateLabel.mas_right).with.offset(kDefaultSpaceUnit * 2);
        make.width.greaterThanOrEqualTo(@40);
    }];
}

- (UILabel*)addLabelToMainBoardView:(CGFloat)fontSize textColor:(UIColor*)textColor
{
    UILabel *label = [UILabel new];
    [label clearBackgroundColor];
    label.font = SystemFont(fontSize);
    label.textColor = textColor;
    [self.mainBoardView addSubview:label];
    return label;
}

- (NSAttributedString*)makeKeyValueAttrStr:(NSString*)key value:(NSString*)value keyColor:(UIColor*)keyColor valueColor:(UIColor*)valueColor
{
    AttributeStringAttrs *titleAttr = [AttributeStringAttrs new];
    titleAttr.text = [NSString stringWithFormat:@"%@ : ", key];
    titleAttr.textColor = keyColor;
    titleAttr.font = SystemFont(15);
    
    AttributeStringAttrs *valueAttr = [AttributeStringAttrs new];
    valueAttr.text = value;
    valueAttr.textColor = valueColor;
    valueAttr.font = SystemFont(15);
    
    return [NSString makeAttrString:@[titleAttr, valueAttr]];
}

- (void)setExtendOrder:(ExtendServiceOrderContent *)extendOrder
{
    _extendOrder = extendOrder;

    [self setExtendOrderDataToViews];
}

- (void)setExtendOrderDataToViews
{
    NSString *tempStr;

    self.customerLabel.text = [Util defaultStr:kNoName ifStrEmpty:self.extendOrder.customerInfo.cusName];

    self.telsLabel.text = [MiscHelper thumbTelnumbers:self.extendOrder.customerInfo.cusTelNumber];

    tempStr = [Util defaultStr:kUnknown ifStrEmpty:self.extendOrder.contractNum];
    self.noLabel.attributedText = [self makeKeyValueAttrStr:@"合同编号" value:tempStr keyColor:kColorDefaultOrange valueColor:kColorDefaultOrange];

    tempStr = [NSString dateStringWithInterval:[self.extendOrder.signDate doubleValue] formatStr:WZDateStringFormat5];
    self.startDateLabel.attributedText = [self makeKeyValueAttrStr:@"日  期" value:tempStr keyColor:kColorDefaultBlue valueColor:kColorDefaultBlue];

    if (kExtendServiceTypeSingle == [self.extendOrder.type integerValue]) {
        tempStr = [Util defaultStr:kUnknown ifStrEmpty:[[ConfigInfoManager sharedInstance] warrantyYearValueById:self.extendOrder.extendLife]];
    }else {
        tempStr = [Util defaultStr:kUnknown ifStrEmpty:[[ConfigInfoManager sharedInstance] mutiWarrantyYearValueById:self.extendOrder.extendLife]];
    }
    self.yearsLabel.text = [NSString stringWithFormat:@"延保%@", tempStr];

    tempStr = [Util defaultStr:kUnknown ifStrEmpty:getExtendServiceOrderStatusById(self.extendOrder.status)];
    self.statusLabel.text = [NSString stringWithFormat:@"%@ ", tempStr];
    
    BOOL isEOrder =  (1 == [self.extendOrder.econtract integerValue]);
    [self setOrderTypeBtnData:isEOrder];

    //reset status
    if (isEOrder && [self.extendOrder.status isEqualToString:@"SC20"]
        && [Util isEmptyString:self.extendOrder.contractNum]) {
        self.statusLabel.text = @"待提交";
    }
}

- (void)setOrderTypeBtnData:(BOOL)isEOrder
{
    if (isEOrder) {
        self.orderTypeBtn.backgroundColor = ColorWithHex(@"#7f0f7e");
        [self.orderTypeBtn setTitleForAllStatus:@"电"];
    }else {
        self.orderTypeBtn.backgroundColor = ColorWithHex(@"#1a9bfc");
        [self.orderTypeBtn setTitleForAllStatus:@"纸"];
    }
}

- (CGFloat)fitHeight
{
    return kExtendServiceOrderTextHeight * 3 + kDefaultSpaceUnit;
}

@end
