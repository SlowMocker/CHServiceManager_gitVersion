//
//  LabelEditCell.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-6.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  左边文本，中间编辑框，右边可用系统的accessoryView，默认用系统的分隔线
 *
 */
@interface LabelEditCell : UITableViewCell
@property(nonatomic, strong)UILabel *leftLabel;
@property(nonatomic, strong)UITextField *middleTextField;
@property(nonatomic, strong)UILabel *rightLabel;

+ (LabelEditCell*)makeLabelEditCell:(NSString*)title hint:(NSString*)hint keyBoardType:(UIKeyboardType)keyBoardType unit:(NSString *)unitString;
@end
