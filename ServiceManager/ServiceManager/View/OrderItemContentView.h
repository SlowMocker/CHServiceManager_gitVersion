//
//  OrderItemContentView.h
//  ServiceManager
//
//  Created by will.wang on 15/8/28.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"

/**
 *  only used for OrderTableViewCell
 *
 */

typedef NS_ENUM(NSInteger, kOrderItemContentViewLayoutType)
{
    kOrderItemContentViewLayoutType1 = 0x1,
    kOrderItemContentViewLayoutType2,
    kOrderItemContentViewLayoutType3,
    kOrderItemContentViewLayoutType4,    //用于技术工技术确认项
    kOrderItemContentViewLayoutType5,    //用于技术工已处理、新任务项、历史工单
    kOrderItemContentViewLayoutType6    //used for order
};

@interface OrderItemContentView : UIView
@property(nonatomic, assign)kOrderItemContentViewLayoutType layoutType;

//subviews
@property(nonatomic, strong)UILabel *orderIdLabel;
@property(nonatomic, strong)UILabel *contentLabel;
@property(nonatomic, strong)UILabel *addressLabel;
@property(nonatomic, strong)UIButton *label1Btn; //紧急
@property(nonatomic, strong)UIButton *label2Btn; //催单
@property(nonatomic, strong)UIButton *label3Btn; //装、修

//used in layout2
@property(nonatomic, strong)UILabel *executeNameLabel;

//used in layout3
@property(nonatomic, strong)UILabel *statusLabel; //status label
@property(nonatomic, strong)UILabel *dateLabel;   //date label

//used in layout4
@property(nonatomic, strong)TQStarRatingView *starView; //starView

+(CGFloat)getFitHeightByType:(kOrderItemContentViewLayoutType)layoutType;

//设置紧急和催单图标的显示与否, bPrior 紧急，bUrgent是否催单
- (void)showPrior:(BOOL)bPrior showUrgent:(BOOL)bUrgent;

//新->装 、 修->修
- (void)updateProductRepairTypeToViews:(NSString*)processType;

@end
