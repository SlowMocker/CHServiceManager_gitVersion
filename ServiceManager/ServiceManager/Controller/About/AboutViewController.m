//
//  AboutViewController.m
//  ServiceManager
//
//  Created by mac on 15/8/25.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *contentView;

@property(nonatomic, strong)UIImageView *iosQrCodeImageView;
@property(nonatomic, strong)UILabel *iosPlatformLabel;

@property(nonatomic, strong)UILabel *versionLabel;
@property(nonatomic, strong)UIImageView *mainImageView;
@property(nonatomic, strong)UILabel *contentLabel;
@property(nonatomic, strong)UIButton *contactButton;

@property(nonatomic, copy)NSString *qrcodeUrl;

@end

@implementation AboutViewController

- (NSString*)qrcodeUrl{
    if (nil == _qrcodeUrl) {
        _qrcodeUrl = [NSString stringWithFormat:@"%@%@",kServerBaseUrl, @"static/dl/app.html"];
    }
    return _qrcodeUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color1 = ColorWithHex(@"#307fdb");
    UIColor *color2 = kColorDefaultBlue;

    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(__bridge id)color1.CGColor
                     ,(__bridge id)color2.CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];

    [self makeContentSubviews];
    [self layoutContentSubviews];
    
    [self setDataToViews];
}

- (void)makeContentSubviews
{
    _scrollView = [UIScrollView new];
    [_scrollView clearBackgroundColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    _contentView = [UIView new];
    [_contentView clearBackgroundColor];
    [_scrollView addSubview:_contentView];
    
    _iosPlatformLabel = [UILabel new];
    [_iosPlatformLabel clearBackgroundColor];
    _iosPlatformLabel.font = SystemBoldFont(14);
    _iosPlatformLabel.textColor = kColorWhite;
    _iosPlatformLabel.textAlignment = NSTextAlignmentCenter;
    _iosPlatformLabel.text = @"客户端下载";
    [self.contentView addSubview:_iosPlatformLabel];

    _iosQrCodeImageView = [UIImageView new];
    [_iosQrCodeImageView clearBackgroundColor];
    _iosQrCodeImageView.contentMode = UIViewContentModeScaleToFill;
    _iosQrCodeImageView.layer.borderColor = kColorDefaultBlue.CGColor;
    _iosQrCodeImageView.layer.borderWidth = 4.0;
    [self.contentView addSubview:_iosQrCodeImageView];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(iosQrCodeImageViewLongPress:)];
    longPressGesture.minimumPressDuration = 2.0;
    [_iosQrCodeImageView addGestureRecognizer:longPressGesture];
    _iosQrCodeImageView.userInteractionEnabled = YES;

    _versionLabel = [UILabel new];
    [_versionLabel clearBackgroundColor];
    _versionLabel.font = SystemBoldFont(16);
    _versionLabel.textColor = kColorWhite;
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_versionLabel];
    
    _mainImageView = [UIImageView new];
    [_mainImageView clearBackgroundColor];
    _mainImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_mainImageView];
    
    _contentLabel = [UILabel new];
    [_contentLabel clearBackgroundColor];
    _contentLabel.font = SystemFont(16);
    _contentLabel.textColor = kColorWhite;
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
    _contactButton = [UIButton redButton:nil];
    _contactButton.titleLabel.font = SystemFont(16);
    [_contactButton addTarget:self action:@selector(contactButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_contactButton];
}

- (void)layoutContentSubviews
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, kDefaultSpaceUnit, 0, kDefaultSpaceUnit));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.iosQrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kDefaultSpaceUnit*2));
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@(200));
        make.height.equalTo(self.iosQrCodeImageView.mas_width);
    }];
    
    [self.iosPlatformLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iosQrCodeImageView);
        make.right.equalTo(self.iosQrCodeImageView);
        make.top.equalTo(self.iosQrCodeImageView.mas_bottom).with.offset(kDefaultSpaceUnit);
        make.height.equalTo(@(kButtonDefaultHeight));
    }];

    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iosPlatformLabel.mas_bottom).with.offset(kDefaultSpaceUnit);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.versionLabel.mas_bottom).with.offset(kDefaultSpaceUnit);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainImageView.mas_bottom).with.offset(kDefaultSpaceUnit);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];

    [self.contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(kDefaultSpaceUnit * 2);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@(kButtonDefaultHeight));
    }];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contactButton.mas_bottom).with.offset(kDefaultSpaceUnit);
    }];
}

- (void)setDataToViews
{
    NSString *tempStr;

    self.iosQrCodeImageView.image = ImageNamed(@"ios_download.png");
    self.iosQrCodeImageView.image = [QrCodeUtil generateQrCodeImage:self.qrcodeUrl sideLength:200];
    self.iosQrCodeImageView.backgroundColor = kColorWhite;
    self.versionLabel.text = [NSString stringWithFormat:@"版本号 : V%@", [NSString appVersion]];
    self.mainImageView.image = ImageNamed(@"logo-w556");
    self.contentLabel.text = @"\t售后管家是四川快益点电器服务连锁有限公司为其售后维修、服务等人员专门定制开发的应用程序，通过该应用实现公司管理者、流动服务人员在服务过程中的无缝连接，提高了派工效率、降低平均服务成本、加强了对流动服务人员的管理。";

    tempStr = [NSString stringWithFormat:@"联系我们 : %@", kServiceManager400Tel];
    [self.contactButton setTitle:tempStr forState:UIControlStateNormal];
}

- (void)contactButtonClicked:(id)sender
{
    [Util makePhoneCallWithNumber:kServiceManager400Tel];
}

- (void)iosQrCodeImageViewLongPress:(UILongPressGestureRecognizer*)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        NSString *scannedResult = [QrCodeUtil readQrCodeFromImage:self.iosQrCodeImageView.image];
        if ([Util isEmptyString:scannedResult]) {
            [Util showAlertView:nil message:@"未能识别出图中的二维码"];
        }else {
            [Util confirmAlertView:nil message:@"识别图中的二维码" confirmTitle:@"识别" confirmAction:^{
                NSURL *openUrl = [NSURL URLWithString:scannedResult];
                BOOL canOpen = [[UIApplication sharedApplication]canOpenURL:openUrl];
                if (canOpen) {
                    [[UIApplication sharedApplication]openURL:openUrl];
                }
            } cancelTitle:@"取消" cancelAction:nil];
        }
    }
}

@end
