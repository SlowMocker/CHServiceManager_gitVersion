//
//  LeftTextRightTextCell.h
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-5-6.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftTextRightTextModel : NSObject
@property(nonatomic, copy)NSString *leftText;
@property(nonatomic, copy)NSString *rightText;
@property(nonatomic, strong)UIColor *leftTextColor;
@property(nonatomic, strong)UIFont *rightTextFont;
@property(nonatomic, strong)UIColor *rightTextColor;
@property(nonatomic, strong)UIView *accessoryView;
@property(nonatomic, assign)NSInteger modelTag;
@end

@interface LeftTextRightTextCell : UITableViewCell
@property(nonatomic, strong)UILabel *leftTextLabel;
@property(nonatomic, strong)UILabel *rightTextLabel;

@property(nonatomic, assign)CGFloat leftTextLabelLeft;
@property(nonatomic, assign)CGFloat leftTextLabelWidth;

@property(nonatomic, strong)LeftTextRightTextModel *dataModel;

//Left aligned label on left and right aligned label on right
- (void)layoutCustomSubViews;

@end
