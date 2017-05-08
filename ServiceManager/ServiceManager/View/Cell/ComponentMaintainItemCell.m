//
//  ComponentMaintainItemCell.m
//  ServiceManager
//
//  Created by will.wang on 15/9/11.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ComponentMaintainItemCell.h"

#define kOrderTraceCellOneLineDefaultHeight (34)

@interface ComponentMaintainItemCell()
@property(nonatomic, strong)UIView *partContentView;
@end

@implementation ComponentMaintainItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kColorWhite;
        self.contentView.backgroundColor = kColorWhite;
        self.topContentView = self.partContentView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (UIView*)partContentView
{
    if (nil == _partContentView) {
        _partContentView = [[UIView alloc]init];
        _partContentView.backgroundColor =kColorWhite;
        
        //subviews
        self.onPartTitleLabel = [self makeTextLabel:kColorDefaultBlue];
        self.onPartTitleLabel.text = @"换上件";
        self.onPartTitleLabel.font = SystemFont(13);
        [_partContentView addSubview:self.onPartTitleLabel];

        self.onPartCodeLabel = [self makeTextLabel:kColorDefaultOrange];
        [_partContentView addSubview:self.onPartCodeLabel];

        self.onPartStatusLabel = [self makeTextLabel:kColorDefaultRed];
        self.onPartStatusLabel.textAlignment = NSTextAlignmentCenter;
        self.onPartStatusLabel.font = SystemFont(13);
        self.onPartStatusLabel.layer.borderWidth = 0.5;
        self.onPartStatusLabel.layer.borderColor = self.onPartStatusLabel.textColor.CGColor;
        self.onPartStatusLabel.layer.cornerRadius = 2.0;
        [_partContentView addSubview:self.onPartStatusLabel];
        
        self.isSyncLabel = [self makeTextLabel:kColorDefaultGray];
        self.isSyncLabel.textAlignment = NSTextAlignmentCenter;
        self.isSyncLabel.font = SystemFont(13);
        self.isSyncLabel.layer.borderWidth = 0.5;
        self.isSyncLabel.layer.borderColor = self.isSyncLabel.textColor.CGColor;
        self.isSyncLabel.layer.cornerRadius = 2.0;
        self.isSyncLabel.text = @"未同步";
        [_partContentView addSubview:self.isSyncLabel];

        self.onPartNameLabel = [self makeTextLabel:kColorLightGray];
        self.onPartNameLabel.numberOfLines = 0;
        self.onPartNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_partContentView addSubview:self.onPartNameLabel];

        self.seprateLine = [[UIView alloc]init];
        self.seprateLine.backgroundColor = kColorLightGray;
        self.seprateLine.alpha = 0.5;
        [_partContentView addSubview:self.seprateLine];

        self.offPartTitleLabel = [self makeTextLabel:kColorDefaultBlue];
        self.offPartTitleLabel.text =  @"换下件";
        self.offPartTitleLabel.font = self.onPartTitleLabel.font;
        [_partContentView addSubview:self.offPartTitleLabel];

        self.offPartCodeLabel = [self makeTextLabel:kColorDefaultOrange];
        [_partContentView addSubview:self.offPartCodeLabel];

        self.offPartNameLabel = [self makeTextLabel:kColorDarkGray];
        self.offPartNameLabel.numberOfLines = 0;
        self.offPartNameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_partContentView addSubview:self.offPartNameLabel];
        
        //layout sub views
        [self.onPartTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_partContentView);
            make.left.equalTo(_partContentView).with.offset(kTableViewLeftPadding);
            make.height.equalTo(@(25));
            make.width.equalTo(@(50));
        }];
        [self.onPartCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.onPartTitleLabel.mas_right);
            make.centerY.equalTo(self.onPartTitleLabel);
            make.height.equalTo(self.onPartTitleLabel);
        }];
        [self.onPartStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.onPartCodeLabel.mas_right).with.offset(kDefaultSpaceUnit);
            make.width.greaterThanOrEqualTo(@(40));
            make.centerY.equalTo(self.onPartCodeLabel);
        }];
        [self.isSyncLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.onPartStatusLabel.mas_right).with.offset(kDefaultSpaceUnit);
            make.width.greaterThanOrEqualTo(@(40));
            make.centerY.equalTo(self.onPartCodeLabel);
        }];
        
        [self.onPartNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.onPartTitleLabel.mas_bottom);
            make.left.equalTo(self.onPartCodeLabel);
            make.right.equalTo(_partContentView).with.offset(-kTableViewLeftPadding);
        }];
        
        [self.seprateLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.onPartNameLabel.mas_bottom);
            make.left.equalTo(_partContentView).with.offset(kDefaultSpaceUnit);
            make.right.equalTo(_partContentView).with.offset(-kDefaultSpaceUnit);
            make.height.equalTo(@(0.5));
        }];
        
        [self.offPartTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.seprateLine.mas_bottom);
            make.left.equalTo(self.onPartTitleLabel);
            make.size.equalTo(self.onPartTitleLabel);
        }];
        [self.offPartCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.offPartTitleLabel.mas_right);
            make.centerY.equalTo(self.offPartTitleLabel);
            make.height.equalTo(self.offPartTitleLabel);
        }];
        [self.offPartNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.offPartTitleLabel.mas_bottom);
            make.left.equalTo(self.offPartCodeLabel);
            make.right.equalTo(_partContentView).with.offset(-kTableViewLeftPadding);
            make.bottom.equalTo(_partContentView).with.offset(-kDefaultSpaceUnit/2);
        }];
    }
    return _partContentView;
}

- (UILabel*)makeTextLabel:(UIColor*)textColor
{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = textColor;
    [label clearBackgroundColor];
    label.font = SystemFont(15);
    
    return label;
}

- (void)setPartInfo:(PartMaintainContent *)partInfo
{
    if (partInfo != _partInfo) {
        _partInfo = partInfo;
        [self setTraceInfoToViews];
        [self setMenuButtons];
    }
}

- (MenuButtonModel*)makeMenuButtonModel:(kComponentMaintainHandleType)handleType backgroundColor:(UIColor*)backgroundColor
{
    MenuButtonModel *model = [MenuButtonModel new];
    model.title = getComponentMaintainHandleTypeStrById(handleType);
    model.backgroundColor = backgroundColor;
    model.buttonTag = handleType;
    
    return model;
}

- (void)setMenuButtons
{
    NSMutableArray *menuBtnModelArray = [NSMutableArray new];
    MenuButtonModel *menuBtnModel;
    
    BOOL editable = [MiscHelper canEditPartMaintainContent:self.partInfo];

    if (editable) {
        menuBtnModel = [self makeMenuButtonModel:kComponentMaintainHandleTypeEdit backgroundColor:kColorDefaultGreen];
        [menuBtnModelArray addObject:menuBtnModel];

        menuBtnModel = [self makeMenuButtonModel:kComponentMaintainHandleTypeDelete backgroundColor:kColorDefaultRed];
        [menuBtnModelArray addObject:menuBtnModel];
    }else if ([self.partInfo.is_send_crm isEqualToString:@"1"]){
        //未同步的，可删除
        menuBtnModel = [self makeMenuButtonModel:kComponentMaintainHandleTypeDelete backgroundColor:kColorDefaultRed];
        [menuBtnModelArray addObject:menuBtnModel];
    }
    [self setRightButtonsWithModels:menuBtnModelArray];
}

- (void)setTraceInfoToViews
{
    self.onPartCodeLabel.text = self.partInfo.puton_part_matno;
    self.onPartStatusLabel.text = getDispatchPartStatusById(self.partInfo.puton_status);
    self.isSyncLabel.hidden = ![self.partInfo.is_send_crm isEqualToString:@"1"];
    self.onPartNameLabel.text = self.partInfo.part_text;

    self.offPartCodeLabel.text = self.partInfo.putoff_part_matno;
    self.offPartNameLabel.text = self.partInfo.putoff_part_text;
}

- (CGFloat)fitHeight{
    CGFloat fitWidth = ScreenWidth - kTableViewLeftPadding * 2 - 50;
    return 25 * 2 + kDefaultSpaceUnit/2 + [self.onPartNameLabel sizeThatFits:CGSizeMake(fitWidth, MAXFLOAT)].height + [self.offPartNameLabel sizeThatFits:CGSizeMake(fitWidth, MAXFLOAT)].height+ 2;
}

@end
