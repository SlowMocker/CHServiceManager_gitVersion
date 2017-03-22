//
//  ExtendReceiveAccountQrCodeController.m
//  ServiceManager
//
//  Created by will.wang on 2017/2/21.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "ExtendReceiveAccountQrCodeController.h"
#import "RequestQrCodeView.h"
#import "ExtendReceiveAccountStatusController.h"
#import "ExtendServiceListViewController.h"

@interface ExtendReceiveAccountQrCodeController()<RequestQrCodeViewDelegate>
@property(nonatomic, strong)RequestQrCodeView *qrCodeView;
@property(nonatomic, strong)UILabel *contractNoLabel;
@property(nonatomic, strong)UILabel *amountLabel; //金额
@property(nonatomic, strong)UILabel *amountPrompt; //金额Label
@end

@implementation ExtendReceiveAccountQrCodeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"延保收款";
    [self addContentSubViews];
    [self requestCommentQrCode];
}

- (UILabel*)makeLabel:(UIFont*)font align:(NSTextAlignment)align
{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = kColorBlack;
    label.font = font;
    label.textAlignment = align;
    label.backgroundColor = kColorClear;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    return label;
}

- (void)addContentSubViews
{
    //top prompt label
    UILabel *promptLabel = [self makeLabel:SystemBoldFont(16) align:NSTextAlignmentLeft];
    promptLabel.text = @"中心区域显示出二维码时，请客户使用微信“扫一扫”，进行付款。";
    promptLabel.alpha = 0.8;
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@(kTableViewLeftPadding));
        make.right.equalTo(@(-kTableViewLeftPadding));
    }];
    
    //contract no
    _contractNoLabel = [self makeLabel:SystemFont(15) align:NSTextAlignmentCenter];
    _contractNoLabel.textColor = kColorDefaultOrange;
    [self.view addSubview:self.contractNoLabel];
    [self.contractNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(promptLabel.mas_bottom).with.offset(kDefaultSpaceUnit);
    }];
    
    //qrcode view
    _qrCodeView = [[RequestQrCodeView alloc]initWithFrame:CGRectMake(0, 0, 210, 210)];
    _qrCodeView.delegate = self;
    _qrCodeView.center = CGPointMake(self.view.center.x, self.view.center.y -32);
    [self.view addSubview:self.qrCodeView];

    //amount
    _amountLabel = [self makeLabel:SystemBoldFont(28) align:NSTextAlignmentCenter];
    _amountLabel.textColor = kColorDefaultRed;
    [self.view addSubview:self.amountLabel];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qrCodeView);
        make.bottom.equalTo(self.qrCodeView.mas_top).with.offset(-kDefaultSpaceUnit);
    }];

    //amount prompt
    _amountPrompt = [self makeLabel:SystemFont(13) align:NSTextAlignmentCenter];
    _amountPrompt.textColor = kColorLightGray;
    _amountPrompt.text = @"付款金额";
    [self.view addSubview:self.amountPrompt];
    [self.amountPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.amountLabel);
        make.bottom.equalTo(self.amountLabel.mas_top).with.offset(-kDefaultSpaceUnit/2);
    }];

    //notelabel
    UILabel *noteLabel = [self makeLabel:SystemFont(13) align:NSTextAlignmentLeft];
    noteLabel.text = @"备注：请主动向客户说明本次延保的产品、金额和年限等信息后，再邀请客户扫码。";
    [self.view addSubview:noteLabel];
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kTableViewLeftPadding));
        make.right.bottom.equalTo(@(-kTableViewLeftPadding));
    }];
}

- (void)requestCommentQrCode
{
    [self.qrCodeView startRequestQrCode];
}

#pragma mark - RequestQrCodeView

- (void)asyncRequestQrCode:(RequestQrCodeView*)view
{
    ExtendPayOrderInfoInputParams *input = [[ExtendPayOrderInfoInputParams alloc]init];
    input.tempNum = self.extendOrderTempNumber;

    [self.httpClient getExtendPayOrderInfo:input response:^(NSError *error, HttpResponseData *responseData) {
        ExtendOrderPaymentInfo *payment = [[ExtendOrderPaymentInfo alloc]initWithDictionary:responseData.resultData];
        [self handlePaymentResponse:error response:responseData paymentInfo:payment];
    }];
}

- (void)handlePaymentResponse:(NSError*)error response:(HttpResponseData*)responseData paymentInfo:(ExtendOrderPaymentInfo*)payment
{
    kHttpReturnCode retCode = responseData.resultCode;

    do {
        BreakIf(error);
        if (kHttpReturnCodeSuccess == retCode) {
            [self showPaymentInfoToViews:payment];
        }else if(kHttpReturnCodePaymentSuccess == retCode){
            [self pushToWeixinPaymentResultViewController];
            [self postNotification:NotificationExtendOrderChanged];
        }else {
            break;
        }
        return;
    } while (FALSE);

    RequestQrCodeData *qrCodeData = [[RequestQrCodeData alloc]init];
    if (error) {
        qrCodeData.errCode = error.code;
        qrCodeData.errMessage = error.localizedDescription;
    }else {
        qrCodeData.errMessage = [Util getErrorDescritpion:responseData otherError:error];
        qrCodeData.errCode = responseData.resultCode;
    }
    self.amountLabel.hidden = YES;
    self.contractNoLabel.hidden = YES;
    
    self.amountPrompt.hidden = self.amountLabel.isHidden;
    self.qrCodeView.qrCodeData = qrCodeData;
}

- (void)showPaymentInfoToViews:(ExtendOrderPaymentInfo*)payment
{
    RequestQrCodeData *qrCodeData = [[RequestQrCodeData alloc]init];
    
    qrCodeData.errCode = (kHttpReturnCode)[payment.code integerValue];
    qrCodeData.errMessage = payment.msg;
    qrCodeData.qrCodeImageUrl = payment.url;
    self.contractNoLabel.text = payment.ext_po_number;
    self.contractNoLabel.hidden = NO;
    
    NSString *amountStr = payment.price;
    CGFloat amountVal = 0;
    if ([amountStr isPureInt] || [amountStr isPureFloat]) {
        amountVal = [amountStr floatValue];
        amountStr = [NSString stringWithFormat:@"%.2f", amountVal];
    }
    self.amountLabel.text = [NSString stringWithFormat:@"￥ %@", amountStr];
    self.amountLabel.hidden = NO;
    self.amountPrompt.hidden = self.amountLabel.isHidden;
    self.qrCodeView.qrCodeData = qrCodeData;
}

- (void)navBarLeftButtonClicked:(UIButton *)defaultLeftButton
{
    [MiscHelper popToLatestListViewController:self];
}

- (void)registerNotifications
{
    [super registerNotifications];
    [self doObserveNotification:NotificationNameReceivedAccount selector:@selector(handleNotificationNameReceivedAccount:)];
}

- (void)unregisterNotifications
{
    [super unregisterNotifications];
    [self undoObserveNotification:NotificationNameReceivedAccount];
}

- (void)handleNotificationNameReceivedAccount:(NSNotification*)notification
{
    if (self.navigationController.topViewController == self) {
        NSDictionary *userInfoDic = [notification userInfo];
        if ([userInfoDic isKindOfClass:[NSDictionary class]]) {
            NSString *isPay = [userInfoDic objForKey:@"isPay"];
            NSString *tempNum = [userInfoDic objForKey:@"tempNum"];
            
            if ([isPay isEqualToString:@"1"]
                && [tempNum isEqualToString:self.extendOrderTempNumber]) {
                [self pushToWeixinPaymentResultViewController];
            }
            [self postNotification:NotificationExtendOrderChanged];
        }
    }
}

- (void)pushToWeixinPaymentResultViewController
{
    ExtendReceiveAccountStatusController *vc = [[ExtendReceiveAccountStatusController alloc]init];
    vc.title = @"延保收款";
    vc.statusImageView.image = ImageNamed(@"circle_green_success");
    vc.statusLabelView.text = @"您已收款成功，请关闭本页面。";
    [self pushViewController:vc];
}

@end
