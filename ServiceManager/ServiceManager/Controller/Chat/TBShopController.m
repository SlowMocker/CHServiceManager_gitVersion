//
//  TBPublishViewController.m
//  WangPuDuo
//
//  Created by wangzhi on 15-4-9.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "TBShopController.h"

@interface TBShopController ()

@end

@implementation TBShopController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clearNavBarLeftView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isSelfViewNil) {
        //TODO: ADD CODE
    }
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
