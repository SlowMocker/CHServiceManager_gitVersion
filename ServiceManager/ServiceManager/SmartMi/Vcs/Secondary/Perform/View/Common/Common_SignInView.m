//
//  Common_SignInView.m
//  ServiceManager
//
//  Created by Wu on 17/3/30.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

/*
 
 1. 当 view 加载时开始定位
 2. 当初次定位失败时，label 显示"定位失败，再试一次"
 
 3. 如果定位失败无法签到
 4. 如果签到成功，再次定位，则显示重新签到
 
 */

#import "Common_SignInView.h"
#import "HttpClientManager+SmartMi.h"

@interface Common_SignInView()

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;/**< 定位地点显示 label */
@property (strong, nonatomic) IBOutlet UIButton *signInBtn;/**< 上门签到按钮 */
@property (nonatomic , assign) BOOL signInBtnEnable;/**< 签到按钮是否可以交互 */
@property (strong, nonatomic) IBOutlet UIButton *locationBtn;/**< 定位按钮 */
@property (nonatomic , assign) BOOL locationBtnEnable;/**< 定位按钮是否可以交互 */

@property (nonatomic , assign) BOOL hasSignIn;/**< 是否已经签到 */

@end

@implementation Common_SignInView
{
    CLLocationDegrees _longitude;/**< 经度 */
    CLLocationDegrees _latitude;/**< 纬度 */
}

- (void) awakeFromNib {
    [super awakeFromNib];
    self.signInBtnEnable = YES;
    _needSignIn = YES;
    [self locationOpration];
}

// 上门签到
- (IBAction)signInBtnAction:(id)sender {
    if ([self checkSignIn]) {
        [Util showToast:[self checkSignIn]];
    }
    else {
        SmartMiRepairSignInInputParams *input = [[SmartMiRepairSignInInputParams alloc]init];
        input.latitude = [NSString stringWithFormat:@"%f", _latitude];
        input.longitude = [NSString stringWithFormat:@"%f", _longitude];
        input.arriveAddress = [_signInAddress truncatingTailWhenLengthGreaterThan:30];
        input.posType = [NSString intStr:0];
        
        if ([self.delegate respondsToSelector:@selector(common_SignInView:needSupplementParam:)]) {
            input = [self.delegate common_SignInView:self needSupplementParam:input]; // 补全参数（订单号、维修工编号）
            
            [Util showWaitingDialog];
            [[HttpClientManager sharedInstance] smartMi_repairSignIn:input response:^(NSError *error, HttpResponseData *responseData) {
                [Util dismissWaitingDialog];
                
                _hasSignIn = (!error && kHttpReturnCodeSuccess == responseData.resultCode);
                if (_hasSignIn){
                    [sender setTitle:@"签到成功" forState:UIControlStateNormal];
                    _needSignIn = NO;
                    self.signInBtnEnable = NO;
                }
                else {
                    [Util showErrorToastIfError:responseData otherError:error];
                }
            }];
        }
        else {
            [Util showToast:@"请开发人员补全订单号和维修工编号"];
        }
    }
}

// 定位
- (IBAction)locationBtnAction:(id)sender {
    [self locationOpration];
}

#pragma mark
#pragma mark private methods
// 是否可以签到
- (NSString *) checkSignIn {
    NSString *cannotSignInReason = nil;
    
    if (!self.signInBtnEnable) {
        cannotSignInReason = @"当前无法再次签到";
    }
    else if (_latitude == 0 || _longitude == 0) {
        cannotSignInReason = @"请先定位您的位置";
    }
    
    return cannotSignInReason;
}

- (void) locationOpration {
    self.locationLabel.text = @"正在定位...";
    self.locationBtnEnable = NO;
    _needSignIn = YES;
    [MiscHelper locateCurrentAddressWithComplete:^(BMKReverseGeoCodeResult *location) {
        self.locationBtnEnable = YES;
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            if (location == nil) { // 定位失败（未签到、已签到）签到保持原状态
                self.locationLabel.text = @"定位失败，再试一次";
                _longitude = 0;
                _latitude = 0;
            }
            else { // 定位成功
                self.locationLabel.text = location.address;
                _longitude = location.location.longitude;
                _latitude = location.location.latitude;
                _signInAddress = [location.address copy];
                if (_hasSignIn) { // 已签到
                    [self.signInBtn setTitle:@"重新签到" forState:UIControlStateNormal];
                    self.signInBtnEnable = YES;
                }
            }
        });
    }];
}

#pragma mark
#pragma mark setters and getters
- (void) setSignInBtnEnable:(BOOL)signInBtnEnable {
    _signInBtnEnable = signInBtnEnable;
    if (_signInBtnEnable) {
        self.signInBtn.enabled = YES;
        self.signInBtn.alpha = 1;
    }
    else {
        self.signInBtn.enabled = NO;
        self.signInBtn.alpha = 0.7;
    }
}

- (void) setLocationBtnEnable:(BOOL)locationBtnEnable {
    _locationBtnEnable = locationBtnEnable;
    if (_locationBtnEnable) {
        self.locationBtn.enabled = YES;
    }
    else {
        self.locationBtn.enabled = NO;
    }
}

@end
