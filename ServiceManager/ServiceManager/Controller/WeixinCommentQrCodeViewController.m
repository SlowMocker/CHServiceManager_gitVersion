//
//  WeixinCommentQrCodeViewController.m
//  ServiceManager
//
//  Created by will.wang on 2017/2/10.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "WeixinCommentQrCodeViewController.h"
#import "RequestQrCodeView.h"
#import "OrderListViewController.h"
#import "WeixinCommentResultViewController.h"
#import "HistoryOrderListViewController.h"

@interface WeixinCommentQrCodeViewController()<RequestQrCodeViewDelegate>
@property(nonatomic, strong)RequestQrCodeView *qrCodeView;
@end

@implementation WeixinCommentQrCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"客户点评";
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
    promptLabel.text = @"中心区域显示出二维码时，请客户使用微信“扫一扫”，进行完工确认和点评操作。";
    promptLabel.alpha = 0.8;
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@(kTableViewLeftPadding));
        make.right.equalTo(@(-kTableViewLeftPadding));
    }];
    
    //qrcode view
    _qrCodeView = [[RequestQrCodeView alloc]initWithFrame:CGRectMake(0, 0, 210, 210)];
    _qrCodeView.delegate = self;
    _qrCodeView.center = CGPointMake(self.view.center.x, self.view.center.y -32);
    [self.view addSubview:self.qrCodeView];
    
    //notelabel
    UILabel *noteLabel = [self makeLabel:SystemFont(13) align:NSTextAlignmentLeft];
    noteLabel.text = @"备注：请主动向客户说明本次维修的金额或其它信息后，再邀请客户扫码，以避免因客户不同意完工而造成工单被打回。如果被打回，您可以在处理完相应问题后，重新执行完工。";
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
    WeixinCommentQrCodeInputParams *input = [[WeixinCommentQrCodeInputParams alloc]init];
    input.objectId = self.orderId;

    [self.httpClient getWeixinCommentQrCode:input response:^(NSError *error, HttpResponseData *responseData) {
        [self handleWeixinCommentResponse:error response:responseData];
    }];
}

- (void)handleWeixinCommentResponse:(NSError*)error response:(HttpResponseData*)responseData
{
    RequestQrCodeData *qrCodeData = [[RequestQrCodeData alloc]init];
    kHttpReturnCode retCode = responseData.resultCode;
    
    do {
        BreakIf(error);
        if (kHttpReturnCodeSuccess == retCode) {
            qrCodeData.errCode = (kHttpReturnCode)[[responseData.resultData objForKey:@"code"]integerValue];
            qrCodeData.errMessage = [responseData.resultData objForKey:@"msg"];
            qrCodeData.qrCodeImageUrl = [responseData.resultData objForKey:@"url"];
        }else if (kHttpReturnCodeCommentSuccess == retCode){
            NSNumber *starLevel = [responseData.resultData objForKey:@"starLevel"];
            NSString *objectIdStr = [responseData.resultData objForKey:@"objectId"];
            if ([objectIdStr isEqualToString:self.orderId]) {
                CGFloat commentScore =  [starLevel floatValue]/5.0;
                [self pushToWeixinCommentResultViewController:commentScore];
                [self postNotification:NotificationOrderChanged];
            }
            return;
        }
    } while (FALSE);
    
    if (error) {
        qrCodeData.errCode = error.code;
        qrCodeData.errMessage = error.localizedDescription;
    }else {
        qrCodeData.errMessage = [Util getErrorDescritpion:responseData otherError:error];
        qrCodeData.errCode = responseData.resultCode;
    }
    self.qrCodeView.qrCodeData = qrCodeData;
}

- (void)navBarLeftButtonClicked:(UIButton *)defaultLeftButton
{
    [MiscHelper popToLatestListViewController:self];
}

- (void)registerNotifications
{
    [super registerNotifications];
    [self doObserveNotification:NotificationNameWeixinComment selector:@selector(handleNotificationNameWeixinComment:)];
}

- (void)unregisterNotifications
{
    [super unregisterNotifications];
    [self undoObserveNotification:NotificationNameWeixinComment];
}

- (void)handleNotificationNameWeixinComment:(NSNotification*)notification
{
    if (self.navigationController.topViewController == self) {
        NSDictionary *notiInfoDic = [notification userInfo];
        if ([notiInfoDic isKindOfClass:[NSDictionary class]]) {
            NSNumber *starLevel = [notiInfoDic objForKey:@"starLevel"];
            NSString *objectIdStr = [notiInfoDic objForKey:@"objectId"];
            if ([objectIdStr isEqualToString:self.orderId]) {
                CGFloat commentScore = [starLevel floatValue]/5.0;
                [self pushToWeixinCommentResultViewController:commentScore];
                [self postNotification:NotificationOrderChanged];
            }
        }
    }
}

- (void)pushToWeixinCommentResultViewController:(CGFloat)commentScore
{
    WeixinCommentResultViewController *vc = [[WeixinCommentResultViewController alloc]init];
    vc.commentScore = commentScore;
    [self pushViewController:vc];
}

@end
