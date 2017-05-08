//
//  OrderTraceCell.m
//  ServiceManager
//
//  Created by will.wang on 15/9/11.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "OrderTraceCell.h"

#define kOrderTraceCellOneLineDefaultHeight (21)

@interface OrderTraceCell()
@property(nonatomic, strong)UIView *orderContentView;
@end

@implementation OrderTraceCell

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
        _orderContentView.backgroundColor = kColorWhite;

        //add sub labels
        self.orderIdLabel = [self makeTextLabel:kColorDefaultOrange];
        [_orderContentView addSubview:self.orderIdLabel];

        self.partNameLabel = [self makeTextLabel:kColorDefaultBlue];
        self.partNameLabel.numberOfLines = 0;
        self.partNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_orderContentView addSubview:self.partNameLabel];

        self.partNoLabel = [self makeTextLabel:[UIColor purpleColor]];
        self.partNoLabel.font = SystemFont(13);
        [_orderContentView addSubview:self.partNoLabel];

        self.partCodeLabel = [self makeTextLabel:kColorDarkGray];
        self.partCodeLabel.font = SystemFont(13);
        [_orderContentView addSubview:self.partCodeLabel];
        
        self.statusButton = [[UIButton alloc]init];
        self.statusButton.backgroundColor = kColorClear;
        [self.statusButton setTitleColor:kColorDefaultRed forState:UIControlStateNormal];
        self.statusButton.titleLabel.font = SystemFont(13);
        [self.statusButton circleCornerWithRadius:2.0];
        self.statusButton.layer.borderColor = kColorDefaultRed.CGColor;
        [self.statusButton addTarget:self action:@selector(statusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_orderContentView addSubview:self.statusButton];

        //layout
        [self.orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_orderContentView).with.offset(kDefaultSpaceUnit/2);
            make.left.equalTo(@(kTableViewLeftPadding));
            make.height.equalTo(@(kOrderTraceCellOneLineDefaultHeight));
            make.right.lessThanOrEqualTo(self.statusButton.mas_left).with.offset(-kDefaultSpaceUnit/2);
        }];
        [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.orderIdLabel);
            make.right.equalTo(_orderContentView).with.offset(-kTableViewLeftPadding);
            make.height.equalTo(@(18));
            make.width.greaterThanOrEqualTo(@(40));
        }];
        [self.partNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.orderIdLabel.mas_bottom);
            make.left.equalTo(self.orderIdLabel);
            make.right.equalTo(self.statusButton);
            make.height.greaterThanOrEqualTo(@(kOrderTraceCellOneLineDefaultHeight));
        }];
        [self.partNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.partNameLabel.mas_bottom);
            make.left.equalTo(self.orderIdLabel);
            make.bottom.equalTo(_orderContentView).with.offset(-kDefaultSpaceUnit/2);
            make.height.equalTo(@(kOrderTraceCellOneLineDefaultHeight));
        }];
        [self.partCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.partNoLabel.mas_right).with.offset(kDefaultSpaceUnit);
            make.right.equalTo(_orderContentView).with.offset(-kTableViewLeftPadding);
            make.centerY.equalTo(self.partNoLabel);
        }];
    }
    return _orderContentView;
}

- (UILabel*)makeTextLabel:(UIColor*)textColor
{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = textColor;
    [label clearBackgroundColor];
    label.font = SystemFont(14);
    
    return label;
}

- (void)setTraceInfo:(OrderTraceInfos *)traceInfo
{
    if (traceInfo != _traceInfo) {
        _traceInfo = traceInfo;
        [self setTraceInfoToViews];
        [self setMenuButtons];
    }
}

- (MenuButtonModel*)makeMenuButtonModel:(kOrderTraceHandleType)handleType backgroundColor:(UIColor*)backgroundColor
{
    MenuButtonModel *model = [MenuButtonModel new];
    model.title = getOrderTraceHandleTypeStrById(handleType);
    model.backgroundColor = backgroundColor;
    model.buttonTag = handleType;

    return model;
}

- (void)setMenuButtons
{
    NSMutableArray *menuBtnModelArray = [NSMutableArray new];
    MenuButtonModel *menuBtnModel;

    if ([self.traceInfo.puton_status isEqualToString:[NSString intStr:kOrderTraceStatusSent]]) {
        menuBtnModel = [self makeMenuButtonModel:kOrderTraceHandleTypeReceive backgroundColor:kColorDefaultGreen];
        [menuBtnModelArray addObject:menuBtnModel];
    }else if ([self.traceInfo.puton_status isEqualToString:[NSString intStr:kOrderTraceStatusConfirmReveived]]){
        menuBtnModel = [self makeMenuButtonModel:kOrderTraceHandleTypeDOABack backgroundColor:kColorDefaultGreen];
        [menuBtnModelArray addObject:menuBtnModel];
    }else if ([self.traceInfo.puton_status isEqualToString:[NSString intStr:kOrderTraceStatusDoaBack]]){
        menuBtnModel = [self makeMenuButtonModel:kOrderTraceHandleTypeEditPart backgroundColor:kColorDefaultGreen];
        [menuBtnModelArray addObject:menuBtnModel];
    }
    [self setRightButtonsWithModels:menuBtnModelArray];
}

- (void)setTraceInfoToViews
{
    NSString *tempStr;
    BOOL isStatusDoaBack = [self.traceInfo.puton_status isEqualToString:[NSString intStr:kOrderTraceStatusDoaBack]];


    tempStr = [NSString stringWithFormat:@"工单号 : %@", self.traceInfo.object_id];
    self.orderIdLabel.text = tempStr;

    tempStr = [Util defaultStr:@"名称未知" ifStrEmpty:self.traceInfo.wlmc];
    self.partNameLabel.text = tempStr;

    //set status button
    tempStr = getOrderTraceStatusById(self.traceInfo.puton_status);
    NSMutableAttributedString *statusAttr = [[NSMutableAttributedString alloc] initWithString:tempStr];
    NSRange titleRange = {0,[statusAttr length]};
    [statusAttr addAttribute:NSForegroundColorAttributeName value:ColorWithHex(@"#fc502a") range:titleRange];
    NSNumber *underLine = [NSNumber numberWithInteger:NSUnderlineStyleNone];
    BOOL bRefuse = [self.traceInfo.puton_status isEqualToString:@"4"];
    UIImage *imageIcon;
    if (!bRefuse) {
        self.statusButton.layer.borderWidth = 0.5f;
    }else {
        self.statusButton.layer.borderWidth = 0.0f;
        underLine = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
        imageIcon = ImageNamed(@"info_red_detail");
    }
    [statusAttr addAttribute:NSUnderlineStyleAttributeName value:underLine range:titleRange];
    [self.statusButton setAttributedTitle:statusAttr forState:UIControlStateNormal];
    [self.statusButton setImage:imageIcon forState:UIControlStateNormal];
    self.statusButton.enabled = bRefuse;

    tempStr = [Util defaultStr:kUnknown ifStrEmpty:self.traceInfo.puton_part_matno];
    tempStr = [NSString stringWithFormat:@"编号 : %@", tempStr];
    self.partNoLabel.text = tempStr;
    self.partNoLabel.adjustsFontSizeToFitWidth = YES;

    if (![Util isEmptyString:self.traceInfo.zzfld00002s] && isStatusDoaBack) {
        tempStr = [NSString stringWithFormat:@"条码 : %@", self.traceInfo. zzfld00002s];
        self.partCodeLabel.text = tempStr;
        self.partCodeLabel.adjustsFontSizeToFitWidth = YES;
        self.partCodeLabel.hidden = NO;
    }else {
        self.partCodeLabel.hidden = YES;
    }
}

- (void)statusButtonClicked:(id)sender
{
    if (nil != self.statusButtonClickedBlock) {
        self.statusButtonClickedBlock(self);
    }
}

-(CGFloat)fitHeight
{
    CGSize textSize = [self.partNameLabel sizeThatFits:CGSizeMake(ScreenWidth - 2 * kTableViewLeftPadding, MAXFLOAT)];
    return kOrderTraceCellOneLineDefaultHeight * 2 + MAX(textSize.height, kOrderTraceCellOneLineDefaultHeight) +  kDefaultSpaceUnit;
}

@end
