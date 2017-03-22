//
//  ExtendReceiveAccountStatusController.h
//  ServiceManager
//
//  Created by will.wang on 2017/2/21.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "ViewController.h"

/**
 * 收款后的状态显示
 */

@interface ExtendReceiveAccountStatusController : ViewController

//uiimage,
//1,'circle_red_err' for error,
//2,'circle_green_success' for success
@property(nonatomic,strong)UIImageView *statusImageView;

@property(nonatomic,strong)UILabel *statusLabelView;
@end
