//
//  Install_ProductConfirmationView.h
//  ServiceManager
//
//  Created by Wu on 17/3/29.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

// 高度 240 上间隔 15 下间隔 10

#import <UIKit/UIKit.h>

@class Install_ProductConfirmationView;
@protocol Install_ProductConfirmationViewDelegate <NSObject>
/**
 *  安装工单_产品确认_外机条码_扫描按钮点击
 */
- (void) install_ProductConfirmationView:(Install_ProductConfirmationView *)view didSelectedTopBtn:(UIButton *)btn;

/**
 *  安装工单_产品确认_内机条码_扫描按钮点击
 */
- (void) install_ProductConfirmationView:(Install_ProductConfirmationView *)view didSelectedBottomBtn:(UIButton *)btn;

/**
 *  安装工单_产品确认_整体按钮点击
 */
- (void) install_ProductConfirmationView:(Install_ProductConfirmationView *)view didSelectedMoreBtn:(UIButton *)btn;

/**
 *  安装工单_产品确认_整体按钮点击
 */
- (void) install_ProductConfirmationView:(Install_ProductConfirmationView *)view didSelectedQueryBtn:(UIButton *)btn;

@end

@interface Install_ProductConfirmationView : UIView

@property (nonatomic , weak) id<Install_ProductConfirmationViewDelegate> delegate;


@property (nonatomic , copy) NSString *outBarcode;/**< 外机条码 */
@property (nonatomic , copy) NSString *inBarcode;/**< 内机条码 */
@property (nonatomic , copy) NSString *scanOutBarcode;/**< 外机扫描条码 */
@property (nonatomic , copy) NSString *scanInBarcode;/**< 内机扫描条码 */


@property (nonatomic , copy) NSString *category;/**< 品类 */
@property (nonatomic , copy) NSString *queryResult;/**< 机型 */


@end
