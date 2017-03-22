//
//  SupportResourceViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/03/2017.
//  Copyright © 2017 wangzhi. All rights reserved.
//

#import "SupportResourceViewController.h"

@implementation SupportResourceViewController

- (instancetype)init
{
    self = [super initWithRequest:kSupportResourceURL];
    self.showWaitingDialog = YES;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
