//
//  ButtonTableViewCell.h
//  ServiceManager
//
//  Created by will.wang on 16/5/5.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  包含一个button的CELL，
 */
@interface ButtonTableViewCell : UITableViewCell
@property(nonatomic, strong)UIButton *button;

- (instancetype)initWithButtonEdge:(UIEdgeInsets)insets reuseIdentifier:(NSString *)reuseIdentifier;

@end
