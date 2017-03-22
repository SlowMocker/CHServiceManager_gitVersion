//
//  RequestQrCodeView.m
//  ServiceManager
//
//  Created by will.wang on 2017/2/10.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "RequestQrCodeView.h"
#import <MBProgressHUD.h>
#import <UIImageView+AFNetworking.h>

#pragma mark -- RequestQrCodeData

@implementation RequestQrCodeData
@end

#pragma mark -- RequestQrCodeView

@interface RequestQrCodeView()
@property(nonatomic, strong)UIImageView *qrCodeImage;
@property(nonatomic, strong)MBProgressHUD *waitingDialog;
@property(nonatomic, strong)UIButton *retryButton;
@property(nonatomic, strong)UILabel *statusLabel;
@end

@implementation RequestQrCodeView

- (void)setViewBorderColor:(UIColor*)borderColor backgroundColor:(UIColor*)backgroundColor
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 3;
    self.backgroundColor = backgroundColor;
}

- (UIImageView*)qrCodeImage{
    if (nil == _qrCodeImage) {
        _qrCodeImage = [[UIImageView alloc]init];
        _qrCodeImage.backgroundColor = kColorWhite;
        [self addSubview:self.qrCodeImage];
        [_qrCodeImage addSingleTapEventWithTarget:self action:@selector(qrCodeImageClicked:)];
        [_qrCodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
        }];
    }
    return _qrCodeImage;
}

- (UIButton*)retryButton{
    if (nil == _retryButton) {
        _retryButton = [UIButton redButton:@"重试"];
        [_retryButton addTarget:self action:@selector(retryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_retryButton];

        [_retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 32));
            make.center.equalTo(self);
        }];
    }
    return _retryButton;
}

- (UILabel*)statusLabel{
    if (nil == _statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.font = SystemFont(14);
        _statusLabel.textColor = [UIColor grayColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.numberOfLines = 0;
        _statusLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:_statusLabel];

        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.retryButton.mas_bottom).with.offset(kDefaultSpaceUnit);
            make.centerX.equalTo(self.retryButton);
            make.left.equalTo(self);
            make.right.equalTo(self);
        }];
    }
    return _statusLabel;
}

- (void)qrCodeImageClicked:(id)sender
{
    [self startRequestQrCode];
}

- (void)retryButtonClicked:(id)sender
{
    [self startRequestQrCode];
}

- (void)hideAllCustomSubViews
{
    _qrCodeImage.hidden = YES;
    _retryButton.hidden = YES;
    _statusLabel.hidden = YES;

    [_waitingDialog hide:YES];
    [_waitingDialog removeFromSuperview];
    _waitingDialog = nil;
}

- (MBProgressHUD*)makeMBProgressHUD
{
    MBProgressHUD *waitingDialog = [[MBProgressHUD alloc] initWithView:self];
    waitingDialog.labelText = @"二维码获取中...";
    waitingDialog.color = kColorClear;
    waitingDialog.activityIndicatorColor = [UIColor lightGrayColor];
    waitingDialog.labelFont = SystemFont(14);
    waitingDialog.labelColor = [UIColor grayColor];
    
    return waitingDialog;
}

- (void)startRequestQrCode
{
    //1, show waiting dialog, hide others
    [self setViewBorderColor:[UIColor lightGrayColor] backgroundColor:kColorClear];
    [self hideAllCustomSubViews];
    self.waitingDialog = [self makeMBProgressHUD];
    [self addSubview:self.waitingDialog];
    [self.waitingDialog show:YES];

    //2, request
    if ([self.delegate respondsToSelector:@selector(asyncRequestQrCode:)]) {
        [self.delegate asyncRequestQrCode:self];
    }
}

- (void)setQrCodeData:(RequestQrCodeData*)data
{
    _qrCodeData = data;

    //hide waiting dialog
    [self hideAllCustomSubViews];

    if (![Util isEmptyString:data.qrCodeImageUrl]) {
        self.qrCodeImage.hidden = NO;
        [self.qrCodeImage setImageWithDownloadUrl:data.qrCodeImageUrl defaultImage:nil];
        [self setViewBorderColor:kColorDarkGray backgroundColor:kColorWhite];
    }else if (![Util isEmptyString:data.qrCode]) {
        CGFloat sideLength = CGRectGetWidth(self.bounds);
        sideLength = (sideLength > 0) ? sideLength : 200;
        //show qrcode imageview
        UIImage *qrImage = [QrCodeUtil generateQrCodeImage:data.qrCode sideLength:sideLength];
        self.qrCodeImage.hidden = NO;
        self.qrCodeImage.image = qrImage;
        [self setViewBorderColor:kColorDarkGray backgroundColor:kColorWhite];
    }else {
        //show retry button & status label
        self.retryButton.hidden = NO;
        self.statusLabel.hidden = NO;
        self.statusLabel.text = data.errMessage;
        [self setViewBorderColor:[UIColor lightGrayColor] backgroundColor:kColorClear];
    }
}

@end
