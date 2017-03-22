//
//  ThreeButtonCell.h
//  ServiceManager
//
//  Created by wangzhi on 15-5-26.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThreeButtonCell;

@protocol ThreeButtonCellDelegate <NSObject>
- (void)threeButtonCell:(ThreeButtonCell*)cell buttonClicked:(UIButton*)btn;
@end

@interface ThreeButtonCell : UITableViewCell
@property(nonatomic, strong)UIButton *button1;
@property(nonatomic, strong)UIButton *button2;
@property(nonatomic, strong)UIButton *button3;

@property(nonatomic, assign)id<ThreeButtonCellDelegate>delegate;

//textArray ITEM: 3 nsstring
- (ThreeButtonCell*)configureCellDatas:(NSArray*)textArray;

@end
