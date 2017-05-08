//
//  Common_UserInfoView.h
//  ServiceManager
//
//  Created by Wu on 17/4/12.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Common_UserInfoView;
@protocol Common_UserInfoViewDelegate <NSObject>

- (void) common_UserInfoView:(Common_UserInfoView *)view didSelectedChooseAreaBtn:(UIButton *)btn;

@end

@interface Common_UserInfoView : UIView

@property (nonatomic , weak) id<Common_UserInfoViewDelegate> delegate;

@property (nonatomic , copy) NSString *userName;/**< 用户名 */
@property (nonatomic , copy) NSString *detailAddress;/**< 详细地址 */
@property (nonatomic , copy) NSString *phoneNums;/**< 联系方式 */
@property (nonatomic , copy) NSString *address;/**< 地址 省市区街道 */

@property (nonatomic , copy) NSString *refPhoneNums;/**< 参考电话 */

@end
