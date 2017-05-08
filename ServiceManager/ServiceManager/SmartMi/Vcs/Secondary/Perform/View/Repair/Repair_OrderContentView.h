//
//  Repair_OrderContentView.h
//  ServiceManager
//
//  Created by Wu on 17/3/29.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Repair_OrderContentView;
@protocol Repair_OrderContentViewDelegate <NSObject>
/**
 *  故障代码栏被点击
 */
- (void) repair_OrderContentView:(Repair_OrderContentView *)view didSelectedFaultBtn:(UIButton *)btn;

/**
 *  维修方式栏被点击
 */
- (void) repair_OrderContentView:(Repair_OrderContentView *)view didSelectedRepairTypeBtn:(UIButton *)btn;

/**
 *  技术支持按钮被点击
 */
- (void) repair_OrderContentView:(Repair_OrderContentView *)view didSelectedTecSupportBtn:(UIButton *)btn;

/**
 *  备件维护按钮被点击
 */
- (void) repair_OrderContentView:(Repair_OrderContentView *)view didSelectedPartBtn:(UIButton *)btn;

@end

@interface Repair_OrderContentView : UIView

@property (nonatomic , weak) id<Repair_OrderContentViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *faultReasonLabel;/**< 故障原因 label */
@property (strong, nonatomic) IBOutlet UILabel *repairTypeLabel;/**< 维修方式 label */

@end
