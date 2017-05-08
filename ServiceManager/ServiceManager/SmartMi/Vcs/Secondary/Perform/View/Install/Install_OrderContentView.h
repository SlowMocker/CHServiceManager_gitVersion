//
//  Install_OrderContentView.h
//  ServiceManager
//
//  Created by Wu on 17/3/29.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Install_OrderContentCell.h"

@class Install_OrderContentView;
@protocol Install_OrderContentViewDelegate <NSObject>

///**
// *  室外环境温度按钮被点击
// */
//- (void) install_OrderContentView:(Install_OrderContentView *)view didSelectedOutTempBtn:(UIButton *)btn;
//
///**
// *  室内进风温度按钮被点击
// */
//- (void) install_OrderContentView:(Install_OrderContentView *)view didSelectedInWindBtn:(UIButton *)btn;
//
///**
// *  室内出风温度按钮被点击
// */
//- (void) install_OrderContentView:(Install_OrderContentView *)view didSelectedOutWindBtn:(UIButton *)btn;

///**
// *  室内机照片栏被点击
// */
//- (void) install_OrderContentView:(Install_OrderContentView *)view didSelectedInPhotoIndexPath:(NSIndexPath *)indexPath;
//
//
///**
// *  用户手机 APP 照片栏被点击
// */
//- (void) install_OrderContentView:(Install_OrderContentView *)view didSelectedAPPPhoneIndexPath:(NSIndexPath *)indexPath;
//
//
///**
// *  室外机照片栏被点击
// */
//- (void) install_OrderContentView:(Install_OrderContentView *)view didSelectedOutPhotoIndexPath:(NSIndexPath *)indexPath;
//
///**
// *  用户和设备合照栏被点击
// */
//- (void) install_OrderContentView:(Install_OrderContentView *)view didSelectedUserPhotoIndexPath:(NSIndexPath *)indexPath;
//
/**
 *  处理措施栏被点击
 */
- (void) tableViewCell:(UITableViewCell *)cell didSelectedHandleIndexPath:(NSIndexPath *)indexPath;



@end
@class SmartMi_Install_PerformOrderViewController;
@interface Install_OrderContentView : UIView

@property (nonatomic , weak) id<Install_OrderContentViewDelegate> delegate;

@property (nonatomic , copy) NSString *runPressure;/**< 运行压力 */
@property (nonatomic , copy) NSString *useArea;/**< 使用面积 */
@property (nonatomic , copy) NSString *outWindTemp;/**< 室外机出风温度 */
@property (nonatomic , copy) NSString *inWindTemp;/**< 室内机出风温度 */
@property (nonatomic , copy) NSString *outTemp;/**< 室外环境温度 */


@property (nonatomic , copy) NSString *inMachinePic;/**< 室内机照片 */
@property (nonatomic , copy) NSString *userAppPic;/**< 用户app照片 */
@property (nonatomic , copy) NSString *outMachinePic;/**< 室外机照片 */
@property (nonatomic , copy) NSString *userMachinePic;/**< 用户跟机器合照 */

@property (nonatomic , copy) NSString *orderId;
@property (nonatomic , weak) SmartMi_Install_PerformOrderViewController *vc;

@end
