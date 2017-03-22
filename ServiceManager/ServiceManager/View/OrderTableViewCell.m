//
//  OrderTableViewCell.m
//  ServiceManager
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "OrderTableViewCell.h"

@interface OrderTableViewCell()
@end

@implementation OrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _topOrderContentView = [[OrderItemContentView alloc]init];
        self.topOrderContentView.backgroundColor = kColorWhite;
        [self.topOrderContentView addLineTo:kFrameLocationBottom];
        self.topContentView = self.topOrderContentView;
    }
    return self;
}

- (CGFloat)fitHeight
{
    return [OrderItemContentView getFitHeightByType:self.topOrderContentView.layoutType];
}

@end
