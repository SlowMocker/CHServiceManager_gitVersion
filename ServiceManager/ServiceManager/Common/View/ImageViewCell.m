//
//  ImageViewCell.m
//  ServiceManager
//
//  Created by wangzhi on 15-5-26.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ImageViewCell.h"

@implementation ImageViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self resetDefaultPropertyValue];
        [self addCustomSubViews];
        [self layoutCustomSubViews];
    }
    return self;
}

- (void)resetDefaultPropertyValue
{
}

- (void)addCustomSubViews
{
    _picView = [[UIImageView alloc]init];
    [_picView clearBackgroundColor];
    [self.contentView addSubview:_picView];
}

- (void)layoutCustomSubViews
{
    [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
        make.edges.equalTo(self.contentView).with.insets(insets);
        make.width.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
    }];
}

@end
