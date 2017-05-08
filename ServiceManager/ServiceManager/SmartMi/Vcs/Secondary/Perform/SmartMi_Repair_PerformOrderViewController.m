//
//  SmartMi_Repair_PerformOrderViewController.m
//  ServiceManager
//
//  Created by Wu on 17/3/29.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "SmartMi_Repair_PerformOrderViewController.h"

#import "Common_SignInView.h"
#import "Common_UserInfoView.h"
#import "Repair_ProductConfirmationView.h"
#import "Repair_OrderContentView.h"

@interface SmartMi_Repair_PerformOrderViewController ()<Common_SignInViewDelegate , Common_UserInfoViewDelegate ,  Repair_ProductConfirmationViewDelegate , Repair_OrderContentViewDelegate>

@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) Common_SignInView *common_SIView;/**< 上门签到 view */
@property (nonatomic , strong) Common_UserInfoView *common_UIView;/**< 用户信息 view */
@property (nonatomic , strong) Repair_ProductConfirmationView *repair_PCView;/**< 产品确认 view */
@property (nonatomic , strong) Repair_OrderContentView *repair_OCView;/**< 订单内容 view */
@property (nonatomic , strong) UIButton *submitBtn;/**< 提交按钮 */

@end

@implementation SmartMi_Repair_PerformOrderViewController

#pragma mark
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.scrollView];
    [self setNavBarRightButton:@"特殊完工" clicked:@selector(specialPerformButtonAction:)];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    
    [self.common_SIView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.height.mas_equalTo(155);
        make.width.equalTo(self.view).offset(-20);
    }];
    
    [self.common_UIView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.common_SIView.mas_bottom);
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.height.mas_equalTo(257);
        make.width.equalTo(self.view).offset(-20);
    }];
    
    [self.repair_PCView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.common_UIView.mas_bottom);
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.height.mas_equalTo(206);
        make.width.equalTo(self.view).offset(-20);
    }];
    
    [self.repair_OCView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.repair_PCView.mas_bottom);
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.height.mas_equalTo(414);
        make.width.equalTo(self.view).offset(-20);
    }];

    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.repair_OCView.mas_bottom).offset(25);
        make.left.equalTo(self.scrollView).offset(10);
        make.right.equalTo(self.scrollView).offset(-10);
        make.bottom.equalTo(self.scrollView).offset(-15); // 注意点
        make.height.mas_equalTo(50);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark event respose
- (void) submitBtnAction:(UIButton *)sender {
    NSLog(@"提交按钮被点击");
}

- (void) specialPerformButtonAction:(UIButton *)sender {
    
}

#pragma mark
#pragma mark Common_SignInViewDelegate

- (SmartMiRepairSignInInputParams *) common_SignInView:(Common_SignInView *)view needSupplementParam:(SmartMiRepairSignInInputParams *)param {
    param.objectId = self.smartMiOrderModel.objectId;
    param.repairManId = [self.user.userId description];
    return param;
}

#pragma mark
#pragma mark Common_UserInfoViewDelegate

- (void) common_UserInfoView:(Common_UserInfoView *)view didSelectedChooseAreaBtn:(UIButton *)btn {
    NSLog(@"用户信息_选择区域按钮被点击");
}

#pragma mark
#pragma mark Repair_ProductConfirmationViewDelegate
- (void) repair_ProductConfirmationView:(Repair_ProductConfirmationView *)view didSelectedScanBtn:(UIButton *)btn {
    NSLog(@"产品确认_扫描按钮被点击");
}

- (void) repair_ProductConfirmationView:(Repair_ProductConfirmationView *)view didSelectedMoreBtn:(UIButton *)btn {
    NSLog(@"产品确认_整体_更多选择按钮被点击");
}

- (void) repair_ProductConfirmationView:(Repair_ProductConfirmationView *)view didSelectedSegment:(UISegmentedControl *)segment {
    NSLog(@"产品确认_保修选择_段选被点击");
}

#pragma mark
#pragma mark Repair_OrderContentViewDelegate

- (void) repair_OrderContentView:(Repair_OrderContentView *)view didSelectedFaultBtn:(UIButton *)btn {
    NSLog(@"工单内容_故障代码按钮被点击");
}

- (void) repair_OrderContentView:(Repair_OrderContentView *)view didSelectedRepairTypeBtn:(UIButton *)btn {
    NSLog(@"工单内容_维修方式按钮被点击");
}

- (void) repair_OrderContentView:(Repair_OrderContentView *)view didSelectedTecSupportBtn:(UIButton *)btn {
    NSLog(@"工单内容_申请技术支持按钮被点击");
}

- (void) repair_OrderContentView:(Repair_OrderContentView *)view didSelectedPartBtn:(UIButton *)btn {
    NSLog(@"工单内容_备件维护按钮被点击");
}

#pragma mark
#pragma mark setters and getters

- (UIScrollView *) scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor colorWithRed:241./255 green:241./255 blue:241./255 alpha:1];
        _scrollView.scrollEnabled = YES;
        [_scrollView addSubview:self.common_SIView];
        [_scrollView addSubview:self.common_UIView];
        [_scrollView addSubview:self.repair_PCView];
        [_scrollView addSubview:self.repair_OCView];
        [_scrollView addSubview:self.submitBtn];
    }
    return _scrollView;
}

- (Common_SignInView *) common_SIView {
    if (_common_SIView == nil) {
        _common_SIView = [[[NSBundle mainBundle] loadNibNamed:@"Common_SignInView" owner:nil options:nil] lastObject];
        _common_SIView.delegate = self;
        _common_SIView.backgroundColor = [UIColor clearColor];
    }
    return _common_SIView;
}

- (Common_UserInfoView *) common_UIView {
    if (_common_UIView == nil) {
        _common_UIView = [[[NSBundle mainBundle] loadNibNamed:@"Common_UserInfoView" owner:nil options:nil] lastObject];
                _common_UIView.delegate = self;
        _common_UIView.backgroundColor = [UIColor clearColor];
    }
    return _common_UIView;
}

- (Repair_ProductConfirmationView *) repair_PCView {
    if (_repair_PCView == nil) {
        _repair_PCView = [[[NSBundle mainBundle] loadNibNamed:@"Repair_ProductConfirmationView" owner:nil options:nil] lastObject];
        _repair_PCView.delegate = self;
        _repair_PCView.backgroundColor = [UIColor clearColor];
    }
    return _repair_PCView;
}

- (Repair_OrderContentView *) repair_OCView {
    if (_repair_OCView == nil) {
        _repair_OCView = [[[NSBundle mainBundle] loadNibNamed:@"Repair_OrderContentView" owner:nil options:nil] lastObject];
        _repair_OCView.delegate = self;
        _repair_OCView.backgroundColor = [UIColor clearColor];
    }
    return _repair_OCView;
}

- (UIButton *) submitBtn {
    if (_submitBtn == nil) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn setBackgroundColor:[UIColor colorWithRed:251./255 green:71./255 blue:65./255 alpha:1] forState:UIControlStateNormal];
        [_submitBtn.layer setCornerRadius:3];
        [_submitBtn setTintColor:[UIColor whiteColor]];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    return _submitBtn;
}


@end
