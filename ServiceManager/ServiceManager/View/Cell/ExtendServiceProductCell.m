//
//  ExtendServiceProductCell.m
//  ServiceManager
//
//  Created by will.wang on 10/13/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "ExtendServiceProductCell.h"

@implementation ExtendServiceProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentLabel = [[UILabel alloc]init];
        [self.contentLabel clearBackgroundColor];
        self.contentLabel.font = SystemBoldFont(14);
        self.contentLabel.textColor = kColorBlack;
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:self.contentLabel];
        
        self.machineCodeLabel = [[UILabel alloc]init];
        [self.machineCodeLabel clearBackgroundColor];
        self.machineCodeLabel.font = SystemFont(14);
        self.machineCodeLabel.textColor = [UIColor grayColor];
        self.machineCodeLabel.numberOfLines = 0;
        self.machineCodeLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:self.machineCodeLabel];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(kDefaultSpaceUnit));
            make.left.equalTo(@(kDefaultSpaceUnit));
            make.right.equalTo(@(-kDefaultSpaceUnit));
        }];
        [self.machineCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom);
            make.left.equalTo(@(kDefaultSpaceUnit));
            make.right.equalTo(@(-kDefaultSpaceUnit));
            make.bottom.equalTo(@(-kDefaultSpaceUnit));
        }];
    }
    return self;
}

- (void)setProduct:(ExtendProductContent *)product
{
    if (_product != product) {
        _product = product;
        
        NSString *brandName = [MiscHelper extendProductBrandName:product];
        NSString *productName = [MiscHelper extendSubProductName:product forType:kExtendServiceTypeMutiple];
        NSString *modelName = [MiscHelper extendProductModelName:product];
        NSString *titleStr = [NSString jointStringWithSeparator:@" | " strings:brandName, productName, modelName, nil];
        self.contentLabel.text = titleStr;
        self.machineCodeLabel.text = product.zzfld00000b;
    }
}

- (CGFloat)fitHeight{
    CGFloat space = kDefaultSpaceUnit * 2;
    CGFloat textWidth = ScreenWidth - (kTableViewLeftPadding + kDefaultSpaceUnit)*2;
    CGFloat contentLabelHeight = [self.contentLabel sizeThatFits:CGSizeMake(textWidth, MAXFLOAT)].height;
    CGFloat machineCodeLabelHeight = [self.machineCodeLabel sizeThatFits:CGSizeMake(textWidth, MAXFLOAT)].height;
    return space + contentLabelHeight + machineCodeLabelHeight;
}

@end
