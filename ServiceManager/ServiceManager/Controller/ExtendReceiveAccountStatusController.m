//
//  ExtendReceiveAccountStatusController.m
//  ServiceManager
//
//  Created by will.wang on 2017/2/21.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "ExtendReceiveAccountStatusController.h"
#import "ExtendServiceListViewController.h"

@implementation ExtendReceiveAccountStatusController

- (UIImageView*)statusImageView{
    if (nil == _statusImageView) {
        _statusImageView = [[UIImageView alloc]init];
        _statusLabelView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _statusImageView;
}

- (UILabel*)statusLabelView {
    if (nil == _statusLabelView) {
        _statusLabelView = [[UILabel alloc]init];
        _statusLabelView.textColor = kColorDefaultGray;
    }
    return _statusLabelView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.statusImageView];
    [self.view addSubview:self.statusLabelView];

    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).with.offset(-20);
        make.width.equalTo(@(80));
        make.height.equalTo(self.statusImageView.mas_width);
    }];
    [self.statusLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.statusImageView);
        make.top.equalTo(self.statusImageView.mas_bottom).with.offset(kDefaultSpaceUnit);
    }];
}

- (void)navBarLeftButtonClicked:(UIButton *)defaultLeftButton
{
    [MiscHelper popToLatestListViewController:self];
}

@end
