//
//  Repair_ProductConfirmationView.h
//  ServiceManager
//
//  Created by Wu on 17/3/29.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Repair_ProductConfirmationView;
@protocol Repair_ProductConfirmationViewDelegate <NSObject>
/**
 *  安装工单_产品确认_串号_扫描按钮点击
 */
- (void) repair_ProductConfirmationView:(Repair_ProductConfirmationView *)view didSelectedScanBtn:(UIButton *)btn;

/**
 *  安装工单_产品确认_整体按钮点击
 */
- (void) repair_ProductConfirmationView:(Repair_ProductConfirmationView *)view didSelectedMoreBtn:(UIButton *)btn;

/**
 *  安装工单_产品确认_保修类型_段选按钮点击
 */
- (void) repair_ProductConfirmationView:(Repair_ProductConfirmationView *)view didSelectedSegment:(UISegmentedControl *)segment;

@end

@interface Repair_ProductConfirmationView : UIView

@property (nonatomic , weak) id<Repair_ProductConfirmationViewDelegate> delegate;

@end
