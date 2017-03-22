//
//  LeftAttrRightAttrCell.h
//  ServiceManager
//
//  Created by wangzhi on 15/7/20.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftAttrRightAttrCell : UITableViewCell
@property(nonatomic, strong)UILabel *leftAttrLabel;
@property(nonatomic, strong)UILabel *leftAttrValueLabel;
@property(nonatomic, strong)UILabel *rightAttrLabel;
@property(nonatomic, strong)UILabel *rightAttrValueLabel;

@property(nonatomic, assign)CGFloat leftAttrLabelWidth;
@property(nonatomic, assign)CGFloat rightAttrLabelWidth;

- (void)layoutCustomSubViews;

@end
