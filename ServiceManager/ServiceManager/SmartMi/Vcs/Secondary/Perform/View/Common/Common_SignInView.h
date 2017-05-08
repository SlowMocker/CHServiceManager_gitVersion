//
//  Common_SignInView.h
//  ServiceManager
//
//  Created by Wu on 17/3/30.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Common_SignInView;
@class SmartMiRepairSignInInputParams;
@protocol Common_SignInViewDelegate <NSObject>

/**
 *  补充签到参数
 *
 *  @note 只需要补充 订单号 和 维修工编号
 *
 *  @param param 待补充参数
 */
- (SmartMiRepairSignInInputParams *) common_SignInView:(Common_SignInView *)view needSupplementParam:(SmartMiRepairSignInInputParams *)param;

@end

@interface Common_SignInView : UIView

@property (nonatomic , weak) id<Common_SignInViewDelegate> delegate;

@property (nonatomic , copy , readonly) NSString *signInAddress;/**< 签到地址 */

@property (nonatomic , assign , readonly) BOOL needSignIn;/**< 是否需要签到 */

@end
