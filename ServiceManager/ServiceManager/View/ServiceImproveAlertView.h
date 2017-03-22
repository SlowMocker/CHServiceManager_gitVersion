//
//  ServiceImproveAlertView.h
//  ServiceManager
//
//  Created by will.wang on 15/9/14.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZSwipeCell.h"

@interface ServiceImproveAlertView : UIView
@property(nonatomic, strong)UIImageView *alertIcon;
@property(nonatomic, strong)UILabel *alertTitle;
@property(nonatomic, strong)UILabel *textLable1;
@property(nonatomic, strong)UILabel *textLable2;

- (instancetype)initWithDefault;
@end
