//
//  TextLabelCell.h
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-5-8.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

/*
 * 整个cell中就一个uilabelView,用于显示文本
 */

#import <UIKit/UIKit.h>

@interface TextLabelCell : UITableViewCell
@property(nonatomic, strong)UILabel *textContentLabel;
@end
