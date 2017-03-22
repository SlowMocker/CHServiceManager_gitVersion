//
//  ComponentMaintainItemCell.h
//  ServiceManager
//
//  Created by will.wang on 15/9/11.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZSwipeCell.h"

/**
 * 备件维护中的列表项
 */

@interface ComponentMaintainItemCell : WZSwipeCell

@property(nonatomic, strong)UILabel *onPartTitleLabel;
@property(nonatomic, strong)UILabel *onPartCodeLabel;
@property(nonatomic, strong)UILabel *onPartStatusLabel;
@property(nonatomic, strong)UILabel *isSyncLabel; //是否同步到CRM
@property(nonatomic, strong)UILabel *onPartNameLabel;

@property(nonatomic, strong)UIView *seprateLine;

@property(nonatomic, strong)UILabel *offPartTitleLabel;
@property(nonatomic, strong)UILabel *offPartCodeLabel;
@property(nonatomic, strong)UILabel *offPartNameLabel;

@property(nonatomic, strong)PartMaintainContent *partInfo;

@end
