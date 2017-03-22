//
//  LetvSmartProductSellEditViewController.m
//  ServiceManager
//
//  Created by will.wang on 16/5/24.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "LetvSmartProductSellEditViewController.h"

@interface LetvSmartProductSellEditViewController ()

@end

@implementation LetvSmartProductSellEditViewController

#pragma mark - 添加或编辑一个智能销售单

- (void)editFeeOrder:(EditFeeOrderInputParams*)param
{
    [self dismissKeyBoard];
    
    LetvEditFeeOrderInputParams *input = [[LetvEditFeeOrderInputParams alloc]initWithEditFeeOrderInputParams:param];

    [Util showWaitingDialog];
    [self.httpClient letv_editFeeOrder:input response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error && (kHttpReturnCodeSuccess == responseData.resultCode)) {
            [self popViewController];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

@end
