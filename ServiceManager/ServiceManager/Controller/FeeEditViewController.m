//
//  FeeEditViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/4/8.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "FeeEditViewController.h"

@interface FeeEditViewController ()

@end

@implementation FeeEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyBoard
{
    UNIMPLEMENTED;
}

#pragma mark - 添加或编辑一个智能销售单

- (void)editFeeOrder:(EditFeeOrderInputParams*)param
{
    [self dismissKeyBoard];

    [Util showWaitingDialog];
    [self.httpClient editFeeOrder:param response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];
        if (!error && (kHttpReturnCodeSuccess == responseData.resultCode)) {
            [self popViewController];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}


@end
