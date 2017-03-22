//
//  ButtonTableViewCell.m
//  ServiceManager
//
//  Created by will.wang on 16/5/5.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "ButtonTableViewCell.h"

@implementation ButtonTableViewCell

- (instancetype)initWithButtonEdge:(UIEdgeInsets)insets reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.button = [[UIButton alloc]init];
        [self.button setTitleColor:kColorBlack forState:UIControlStateNormal];
        self.button.titleLabel.font = SystemFont(15);
        [self.contentView addSubview:self.button];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(insets);
        }];
    }
    return self;
}

@end
