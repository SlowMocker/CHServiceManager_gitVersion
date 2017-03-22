//
//  TwoTextLabelCell.h
//  ServiceManager
//
//  Created by will.wang on 1/7/16.
//  Copyright © 2016 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TwoTextLabelCellLayout)
{
    //不可用
    TwoTextLabelCellLayoutNone = 0x0,   //没有布局
    
    //label1居左，宽不超过CenterX, label2居右
    TwoTextLabelCellLayoutLeftRight,    //左右布局
    
    //label1居上，label2居下
    TwoTextLabelCellLayoutTopBottom,    //上下布局

    //label1铺满整个cell，label2不显示
    TwoTextLabelCellLayoutOneLabel      //单文本
};

@interface TwoTextLabelCell : UITableViewCell

- (instancetype)initWithLayoutType:(TwoTextLabelCellLayout)layout reuseIdentifier:(NSString *)reuseIdentifier;

@property(nonatomic, assign)TwoTextLabelCellLayout layoutType;

//当cell宽度不为屏宽时，请指定其宽度，从而精确计算高度
@property(nonatomic, assign)CGFloat estimatedCellWidth;

@property(nonatomic, strong)UILabel *label1;
@property(nonatomic, strong)UILabel *label2;

@end
